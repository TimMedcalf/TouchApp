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


NSString *const Key_FeedItems = @"FeedItems";
NSString *const Key_LastRefresh = @"lastRefresh";
NSString *const Key_Feed_Etag = @"etag";
NSString *const Key_Feed_LastUpdated = @"lastupdated";
NSString *const Key_Feed_BaseURL = @"baseURL";

@interface FeedList ()
//RSS Feed Updating
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *rssConnection;
@property (nonatomic, retain) NSString *feed;
@property (nonatomic, retain) NSString *cacheFile;
@property (nonatomic, retain) NSString *etag;
@property (nonatomic, retain) NSString *lastUpdated;
@property (nonatomic, assign) NSInteger totalBytes;
@property (nonatomic, assign) NSInteger bytesDownloaded;


- (void)startDownload;
- (void)cancelDownload;
- (void)parseResultWithData:(NSData *)xmlData;

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
@synthesize etag = _etag;
@synthesize lastUpdated = _lastUpdated;
@synthesize baseURL = _baseURL;
@synthesize xpathOverride = _xpathOverride;
@synthesize rawMode = _rawMode;
@synthesize totalBytes = _totalBytes;
@synthesize bytesDownloaded = _bytesDownloaded;

#pragma mark lifecycle
- (id)init
{
  //NSLog(@"list alloc");
  if ((self = [super init]))
  {
    self.lastRefresh = [NSDate distantPast];
    self.items = [NSMutableArray array];
    self.feed = [self feedURL];
    self.cacheFile = [[AppManager instance].cacheFolder stringByAppendingPathComponent:[[self cacheFilename] stringByAppendingPathExtension:@"plist"]];
    [self loadItems];
  }
  return self;
}

- (id)initWithoutLoading
{
  //NSLog(@"list alloc");
  if ((self = [super init]))
  {
    self.lastRefresh = [NSDate distantPast];
    self.items = [NSMutableArray array];
  }
  return self;
}

- (void)continueLoading
{
  self.feed = [self feedURL];
  self.cacheFile = [[AppManager instance].cacheFolder stringByAppendingPathComponent:[[self cacheFilename] stringByAppendingPathExtension:@"plist"]];
  [self loadItems];
}


/*
- (id)initWithFeed:(NSString *)feed andFile:(NSString *)file;
{
  //NSLog(@"list alloc");
  if ((self = [super init]))
  {
    self.lastRefresh = [NSDate distantPast];
    self.items = [NSMutableArray arrayWithCapacity:20];
    self.feed = feed;
    self.cacheFile = file;
    [self loadItems];
  }
  return self;
}
 */

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
  [_etag release];
  [_lastUpdated release];
  [_baseURL release];
  [_xpathOverride release];
  [super dealloc];
}

#pragma mark load/save
- (void)saveItems
{
  //NSLog(@"Save");
  //NSArray *folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  //NSString *file = [[folders lastObject] stringByAppendingPathComponent:[self.cacheFile stringByAppendingPathExtension:@"plist"]];
  //NSString *file = [[AppManager instance].cacheFolder stringByAppendingPathComponent:[self.cacheFile stringByAppendingPathExtension:@"plist"]];
  [[self saveItemsToDictionary] writeToFile:self.cacheFile atomically:YES];
}

- (void)loadItems;
{
  //NSLog(@"Load");
  //NSArray *folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  //NSString *file = [[folders lastObject] stringByAppendingPathComponent:[self.cacheFile stringByAppendingPathExtension:@"plist"]];
   // NSString *file = [[AppManager instance].cacheFolder stringByAppendingPathComponent:[self.cacheFile stringByAppendingPathExtension:@"plist"]];
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheFile])
  {
    NSDictionary *loadDictionary = [[NSDictionary alloc]  initWithContentsOfFile:self.cacheFile];
    [self loadItemsFromDictionary:loadDictionary];
    [loadDictionary release]; loadDictionary = nil;
  }
}

- (NSDictionary *)saveItemsToDictionary
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
  [dict setObject:self.lastRefresh forKey:Key_LastRefresh];
  if (self.etag) [dict setObject:self.etag forKey:Key_Feed_Etag];
  if (self.lastUpdated) [dict setObject:self.lastUpdated forKey:Key_Feed_LastUpdated];
  if (self.baseURL) [dict setObject:[self.baseURL absoluteString] forKey:Key_Feed_BaseURL];
  NSMutableArray *itemsDicts = [NSMutableArray arrayWithCapacity:[self.items count]];
  for (FeedItem *item in self.items)
  {
    [itemsDicts addObject:[item dictionaryRepresentation]];
  }
  [dict setObject:itemsDicts forKey:Key_FeedItems];
  return dict;
}

- (void)loadItemsFromDictionary:(NSDictionary *)dict
{
  [self.items removeAllObjects];
  self.lastRefresh = [dict objectForKey:Key_LastRefresh];
  self.etag = [dict objectForKey:Key_Feed_Etag];
  self.lastUpdated = [dict objectForKey:Key_Feed_LastUpdated];
  NSString *tmpURLString = [dict objectForKey:Key_Feed_BaseURL];
  if (tmpURLString)
  {
    NSURL *tmpURL = [[NSURL alloc] initWithString:tmpURLString];
    self.baseURL = tmpURL;
    [tmpURL release];
  }
  NSArray *itemsArray = [dict objectForKey:Key_FeedItems];
  for (NSDictionary *itemDict in itemsArray)
  {
    FeedItem *item =[self initNewItemWithDictionary:itemDict];
    [self.items addObject:item];
    [item release]; item = nil;
  }
  [self dataUpdated];
  if (self.delegate) [self.delegate updateSource];
}


#pragma mark RSS Feed
- (void)refreshFeed
{
  [self refreshFeedForced:NO];
}

- (void)refreshFeedForced:(BOOL)forced;
{
  if (!self.activeDownload)
  {
    if (([self.items count] == 0) || ([[NSDate date] timeIntervalSinceDate:self.lastRefresh] > [self refreshTimerCount]) || forced)
    {
      [self startDownload];
    }
  }
}

- (void)cancelRefresh
{
  if (self.activeDownload) [self cancelDownload];
}

- (void)startDownload
{
  [[UIApplication sharedApplication] tjm_pushNetworkActivity];
  self.activeDownload = [NSMutableData data];
  // alloc+init and start an NSURLConnection; release on completion/failure
  //NSLog(@"%@", self.feed);
  NSMutableURLRequest *tmpRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.feed] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
  if (self.etag) 
  {
    //NSLog(@"Adding If-None-Match Header");
    [tmpRequest addValue:self.etag forHTTPHeaderField:@"If-None-Match"];
  }
  if (self.lastUpdated) 
  {
    //NSLog(@"Adding If-Modified-Since Header");
    [tmpRequest addValue:self.lastUpdated forHTTPHeaderField:@"If-Modified-Since"];
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
  self.etag = nil;
  self.lastUpdated = nil;
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
}

#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  self.bytesDownloaded += [data length];
  [self.activeDownload appendData:data];
  //NSLog(@"Downloaded %d", [data length]);
  if ([self.delegate respondsToSelector:@selector(updateProgressWithPercent:)])
  {
    //NSLog(@"Updating progress");
    [self.delegate updateProgressWithPercent:(CGFloat)self.bytesDownloaded / self.totalBytes];
  }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  //NSLog(@"%@",[(NSHTTPURLResponse *)response allHeaderFields]);
  
  //store the etag
  self.etag = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Etag"];
  //NSLog(@"Etag=%@",self.etag);
  
  //last modified date - keep it as a string to easily match the server's format.
  self.lastUpdated = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Last-Modified"];
  //NSLog(@"Last Modified Date : %@", self.lastUpdated);
  
  // lets keep track of how big we are...and how much we've downloaded  
  self.totalBytes = [response expectedContentLength];
  self.bytesDownloaded = 0;

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

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  NSLog(@"Challenge!");
  //[[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"creode" password:@"creode" persistence:NSURLCredentialPersistenceForSession] forAuthenticationChallenge:challenge];  
}

- (void)parseResultWithData:(NSData *)xmlData
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  //NSLog(@"%@",[NSString stringWithUTF8String:[xmlData bytes]]);
  
  // Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
  // object that actually grabs and processes the RSS data
  if ([xmlData length] > 0)
  {
    NSLog(@"Parsing XML %u bytes from feed %@",[xmlData length], self.feed);
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithData:self.activeDownload options:0 error:nil];

    // Create a new Array object to be used with the looping of the results from the rssParser
    self.baseURL = nil;
  
    NSString *baseURL = [[[rssParser rootElement] attributeForName:@"xml:base"] stringValue];
    if (baseURL)
    {
      NSURL *tmpURL = [[NSURL alloc] initWithString:[[[rssParser rootElement] attributeForName:@"xml:base"] stringValue]];
      self.baseURL = tmpURL;
      [tmpURL release];
    }
    
    NSString *xpath;
    
    if (self.xpathOverride)
      xpath = self.xpathOverride;
    else
      xpath = @"//item";
    
    NSArray *resultNodes = [rssParser nodesForXPath:xpath error:nil];

    // Loop through the resultNodes to access each items' actual data
    NSMutableArray *newFeedItems = [[NSMutableArray alloc] initWithCapacity:[resultNodes count]];
    
    for (CXMLElement *resultElement in resultNodes)
    { 
      if (self.rawMode)
      {
        FeedItem *newFeedItem = [self initNewItemWithRawXMLElement:resultElement andBaseURL:self.baseURL];
        [newFeedItems addObject:newFeedItem];
        [newFeedItem release]; newFeedItem = nil;
      }
      else
      {

        NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
        for(int counter = 0; counter < [resultElement childCount]; counter++)
        {
          [itemDict setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
        FeedItem *newFeedItem = [self initNewItemWithXMLDictionary:itemDict andBaseURL:self.baseURL];
        [itemDict release]; itemDict= nil;
        [newFeedItems addObject:newFeedItem];
        [newFeedItem release]; newFeedItem = nil;
      }
    }
    [rssParser release]; rssParser = nil;
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:newFeedItems];
    //nearly done, just need to make sure the items are sorted correctly
    //descending pubDate order would probably be best
    [self.items sortUsingComparator: ^(id obj1, id obj2) {
      FeedItem *item1 = (FeedItem *)obj1;
      FeedItem *item2 = (FeedItem *)obj2;
      return [item1 compare:item2];
    }];
    [newFeedItems release]; newFeedItems = nil;
  }
  else
  {
    NSLog(@"0 updated bytes from feed %@",self.feed);
  }
}

//overrides
- (FeedItem *)initNewItemWithXMLDictionary:(NSDictionary *)itemDict andBaseURL:(NSURL *)baseURL
{
  return [[FeedItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL
{
  return [[FeedItem alloc]initWithRawXMLElement:element andBaseURL:baseURL];  
}

- (FeedItem *)initNewItemWithDictionary:(NSDictionary *)dictionary
{
  return [[FeedItem alloc] initWithDictionary:dictionary];
}

- (NSInteger)refreshTimerCount
{
  //number of seconds to wait before feed refreshes - override for different time
  return 25200; // 7 hours - read it in the morning, and see if there's anything new at the end of the day!

}

- (void)dataUpdated
{
  //do nothing...
}

- (NSString *)feedURL
{
  return nil;
}

- (NSString *)cacheFilename
{
  return nil;
}

@end
