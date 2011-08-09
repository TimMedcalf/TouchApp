//
//  FeedList.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedList.h"
#import "CXMLDocument.h"
#import "FeedItem.h"
#import "AppManager.h"

//number of seconds to wait before news refreshes
//NSInteger refreshTimer = 43200; //twelve hours
NSInteger refreshTimer = 3600; //1 hour
//NSInteger refreshTimer = 0; //immediate

NSString *const Key_FeedList_LastRefresh = @"lastRefresh";
NSString *const Key_FeedList_ETag = @"etag";
NSString *const Key_FeedList_FeedItems = @"FeedItems";


@interface FeedList ()
//RSS Feed Updating
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *rssConnection;
@property (nonatomic, retain) NSString *feed;
@property (nonatomic, retain) NSString *cacheFile;
@property (nonatomic, retain) NSString *eTag;

- (void)saveItems;
- (void)loadItems;
- (NSDictionary *)saveItemsToDictionary;
- (void)loadItemsFromDictionary:(NSDictionary *)dict;
@end

@implementation FeedList

@synthesize delegate = _delegate;
@synthesize lastRefresh = _lastRefresh;
@synthesize items = _items;
@synthesize activeDownload = _activeDownload;
@synthesize rssConnection = _rssConnection;
@synthesize feed = _feed;
@synthesize cacheFile = _cacheFile;
@synthesize eTag = _eTag;
@synthesize xpathOverride = _xpathOverride;

#pragma mark lifecycle
- (id)init
{
  //NSLog(@"list alloc");
  if ((self = [super init]))
  {
    self.lastRefresh = [NSDate distantPast];
    self.items = [NSMutableArray array];
    self.feed = [self feedURL];
    NSString *tmpCacheFile = [[[self cacheFilename] lastPathComponent] stringByDeletingPathExtension];
    self.cacheFile = [[AppManager instance].cacheFolder stringByAppendingPathComponent:[tmpCacheFile stringByAppendingPathExtension:@"plist"]];
    [self loadItems];
  }
  return self;
}

-(void) dealloc
{
  //NSLog(@"list dealloc");
  if (self.activeDownload) [self cancelDownload];
  [_feed release];
  [_lastRefresh release];
  [_items release];
  [_activeDownload release];
  [_rssConnection release];
  [_cacheFile release];
  [_eTag release];
  [_xpathOverride release];
  [super dealloc];
}

#pragma mark load/save
- (void)saveItems
{
  [[self saveItemsToDictionary] writeToFile:self.cacheFile atomically:YES];
}

- (void)loadItems;
{
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheFile])
  {
    NSDictionary *loadDictionary = [[NSDictionary alloc]  initWithContentsOfFile:self.cacheFile];
    [self loadItemsFromDictionary:loadDictionary];
    [loadDictionary release]; loadDictionary = nil;
  }
}

- (NSDictionary *)saveItemsToDictionary
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
  [dict setObject:self.lastRefresh forKey:Key_FeedList_LastRefresh];
  if (self.eTag) [dict setObject:self.eTag forKey:Key_FeedList_ETag];
  
  NSMutableArray *itemsDicts = [NSMutableArray arrayWithCapacity:[self.items count]];
  for (FeedItem *item in self.items)
  {
    [itemsDicts addObject:[item dictionaryRepresentation]];
  }
  [dict setObject:itemsDicts forKey:Key_FeedList_FeedItems];
  return dict;
}

- (void)loadItemsFromDictionary:(NSDictionary *)dict
{
  [self.items removeAllObjects];
  self.lastRefresh = [dict objectForKey:Key_FeedList_LastRefresh];
  self.eTag = [dict objectForKey:Key_FeedList_ETag];
  NSArray *itemsArray = [dict objectForKey:Key_FeedList_FeedItems];
  for (NSDictionary *itemDict in itemsArray)
  {
    FeedItem *item =[self initNewItemWithDictionary:itemDict];
    item.delegate = self;
    [self.items addObject:item];
    [item release]; item = nil;
  }
  [self dataUpdated];
  if (self.delegate) [self.delegate updateSource];
}


#pragma mark RSS Feed
- (void)refreshFeed
{
  if (!self.activeDownload) [self refreshFeedForced:NO];
}

- (void)refreshFeedForced:(BOOL)forced;
{
  if (([self.items count] == 0) || ([[NSDate date] timeIntervalSinceDate:self.lastRefresh] > refreshTimer) || forced)
  {
    [self startDownload];
  }
}

- (void)cancelRefresh
{
  if (self.activeDownload) [self cancelDownload];
//  for (FeedItem *item in self.items)
//  {
//    if (item.lazyImage)
//    {
//      [item.lazyImage cancelImageDownload];
//    }
//  }
}

- (void)startDownload
{
  [[UIApplication sharedApplication] tjm_pushNetworkActivity];
  self.activeDownload = [NSMutableData data];
  // alloc+init and start an NSURLConnection; release on completion/failure
  NSMutableURLRequest *tmpRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.feed]];
  if (self.eTag) 
  {
    [tmpRequest addValue:self.eTag forHTTPHeaderField:@"If-None-Match"]; 
  }
  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                           tmpRequest delegate:self];
  [tmpRequest release];
  self.rssConnection = conn;
  [conn release];
}

- (void)cancelDownload
{
  [self.rssConnection cancel];
  self.rssConnection = nil;
  self.activeDownload = nil;
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
}

#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [self.activeDownload appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  self.eTag = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Etag"];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  // Clear the activeDownload property to allow later attempts
  self.activeDownload = nil;
  // Release the connection now that it's finished
  self.rssConnection = nil;
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  if (self.delegate) [self.delegate updateFailed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{  
  if (self.activeDownload)
  {
    [self parseResultWithData:self.activeDownload];
    //then update the lastRefresh property
    self.lastRefresh = [NSDate date];
    //done...lets save the date
    [self saveItems];
    [self dataUpdated];
    //tell delegate we've updated...
    if (self.delegate) [self.delegate updateSource];
  }
  self.activeDownload = nil;
  
  // Release the connection now that it's finished
  self.rssConnection = nil;
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  
  // call our delegate and tell it that our icon is ready for display
  //[delegate appImageDidLoad:self.indexPathInTableView];
}

//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//  //NSLog(@"Challenge!");
//  [[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"creode" password:@"creode" persistence:NSURLCredentialPersistenceForSession] forAuthenticationChallenge:challenge];  
//}

- (void)parseResultWithData:(NSData *)xmlData
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  if ([xmlData length] > 0)
  {
    
    // Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
    // object that actually grabs and processes the RSS data
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithData:self.activeDownload options:0 error:nil];

    // Create a new Array object to be used with the looping of the results from the rssParser
    NSString *baseURL = [[[rssParser rootElement] attributeForName:@"xml:base"] stringValue];

    NSString *tmpXPath = @"//";
    
    if (self.xpathOverride)
      tmpXPath = [tmpXPath stringByAppendingString:self.xpathOverride];
    else
      tmpXPath = [tmpXPath stringByAppendingString:@"item"];
    
    NSArray *resultNodes = [rssParser nodesForXPath:tmpXPath error:nil];

    // Loop through the resultNodes to access each items' actual data
    NSMutableArray *newFeedItems = [[NSMutableArray alloc] initWithCapacity:[resultNodes count]];
    for (CXMLElement *resultElement in resultNodes)
    { 
      NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
      for(int counter = 0; counter < [resultElement childCount]; counter++)
      {
        [itemDict setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
      }
      FeedItem *newFeedItem = [self initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL];
      [itemDict release]; itemDict= nil;
      newFeedItem.delegate = self;
      [newFeedItems addObject:newFeedItem];
      [newFeedItem release]; newFeedItem = nil;
    }
    [rssParser release]; rssParser = nil;
    [self mergeExistingWithItems:newFeedItems];
    [newFeedItems release]; newFeedItems = nil;
  }
}

- (void)mergeExistingWithItems:(NSArray *)newItems
{
  //NSLog(@"MERGING");
  //NSLog(@"Existing Count = %d",[self.items count]);
  //NSLog(@"Feed Count = %d",[newItems count]);  
  //okay, first, we need to put a marker on each FeedItem to make sure we still want it...is it still there?
  if (![self clearAllOnRefresh])
  {
    for (FeedItem *existingItem in self.items)
    {
      existingItem.updateFlag = NO;
    }
  } 
  else
  {
    [self.items removeAllObjects];  
  }
  //now loop thru the new items and see if it exists in the current list
  for (FeedItem *newItem in newItems)
  {
    //loop thru existing
    BOOL found = NO;
    for (FeedItem *existingItem in self.items)
    {
      //lets see if we found the item already there.
      //compare pubdate and title
      if ([existingItem isEqualToItem:newItem])
      {
        //yes, its the same
        existingItem.updateFlag = YES;
        existingItem.baseURL = newItem.baseURL;
        //NSLog(@"found YES");
        found = YES;
        break;
      }
    }
    //if we aint found it, we need to add it to the currentList
    if (!found)
    {
      [self.items addObject:newItem];
      newItem.updateFlag = YES;
    }
  }
  //okay, we've gone through the existing items, 
  //anything that hasn't got updateflag set needs to be deleted
  NSMutableArray *itemsToDelete = [[NSMutableArray alloc] initWithCapacity:[self.items count]];
  for (FeedItem *item in self.items)
  {
    if (!item.updateFlag) [itemsToDelete addObject:item];
  }
  //removed the deleted items from the original array
  [self.items removeObjectsInArray:itemsToDelete];
  [itemsToDelete release]; itemsToDelete = nil;
  //nearly done, just need to make sure the items are sorted correctly
  //descending pubDate order would probably be best
  [self.items sortUsingComparator: ^(id obj1, id obj2) {
    FeedItem *item1 = (FeedItem *)obj1;
    FeedItem *item2 = (FeedItem *)obj2;
    return [item1 compare:item2];
  }];
}

- (void)imageUpdated:(FeedItem *)item
{
  if (self.delegate)
  {
    NSInteger index = [self.items indexOfObject:item];
    if ((index >= 0) && (index < [self.items count]))
      [self.delegate updateImage:index];
  }
}

//overrides
- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[FeedItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[FeedItem alloc] initWithDictionary:dictionary];
}

- (void)dataUpdated
{
  //do nothing...
}

- (NSString *)feedURL;
{
  //override in subclass to return feed address
  return nil;
}
- (NSString *)cacheFilename;
{
  //override in subclass to return filename to save the data to - no path necessary
  return nil;
}

- (BOOL) clearAllOnRefresh
{
  return NO;
}


@end
