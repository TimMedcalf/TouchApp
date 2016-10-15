//
//  TCHBaseFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedList.h"
#import "TCHBaseFeedItem.h"
#import "TCHAppManager.h"
#import "UIApplication+TJMNetworkActivity.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const Key_FeedItems = @"FeedItems";
NSString *const Key_LastRefresh = @"lastRefresh";
NSString *const Key_Feed_ETag = @"etag";
NSString *const Key_Feed_LastUpdated = @"lastupdated";
NSString *const Key_Feed_BaseURL = @"baseURL";
#pragma clang diagnostic pop

@interface TCHBaseFeedList () <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

//RSS Feed Updating
//@property (strong, nonatomic) NSMutableData *activeDownload;
//@property (strong, nonatomic) NSURLConnection *rssConnection;

@property (strong, nonatomic) NSURLSessionDownloadTask *activeDownloadTask;
@property (strong, nonatomic) NSURLSession *urlSession;
@property (strong, nonatomic) NSString *feed;
@property (strong, nonatomic) NSString *cacheFile;
@property (strong, nonatomic) NSString *etag;
@property (strong, nonatomic) NSString *lastUpdated;
@property (assign, nonatomic) long long int totalBytes;
@property (assign, nonatomic) NSInteger bytesDownloaded;
@property (strong, nonatomic) NSMutableArray *items;

- (void)startDownload;
- (void)cancelDownload;
- (void)parseResultWithData:(NSData *)xmlData;
- (void)saveItems;
- (void)loadItems;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *saveItemsToDictionary;
- (void)loadItemsFromDictionary:(NSDictionary *)dict;

@end


@implementation TCHBaseFeedList

#pragma mark lifecycle
- (instancetype)init {
    self = [self initWithoutLoading];
    if (self) {
        _feed = self.feedURL;
        _cacheFile = [[TCHAppManager sharedInstance].cacheFolder stringByAppendingPathComponent:[self.cacheFilename stringByAppendingPathExtension:@"plist"]];
        [self loadItems];
    }
    return self;
}

- (instancetype)initWithoutLoading {
    if ((self = [super init])) {
        _lastRefresh = [NSDate distantPast];
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)continueLoading {
    self.feed = self.feedURL;
    self.cacheFile = [[TCHAppManager sharedInstance].cacheFolder stringByAppendingPathComponent:[self.cacheFilename stringByAppendingPathExtension:@"plist"]];
    [self loadItems];
}

- (void)dealloc {
    DDLogDebug(@"list dealloc");
    [self.urlSession invalidateAndCancel];
    self.urlSession = nil;
}

#pragma mark load/save
- (void)saveItems {
    [self.saveItemsToDictionary writeToFile:self.cacheFile atomically:YES];
}

- (void)loadItems {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheFile]) {
        [self loadItemsFromDictionary:[[NSDictionary alloc]  initWithContentsOfFile:self.cacheFile]];
    }
}

- (NSDictionary *)saveItemsToDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    dict[Key_LastRefresh] = self.lastRefresh;
    if (self.etag) dict[Key_Feed_ETag] = self.etag;
    if (self.lastUpdated) dict[Key_Feed_LastUpdated] = self.lastUpdated;
    if (self.baseURL) dict[Key_Feed_BaseURL] = (self.baseURL).absoluteString;
    NSMutableArray *itemsDicts = [NSMutableArray arrayWithCapacity:(self.items).count];
    for (TCHBaseFeedItem *item in self.items) {
        [itemsDicts addObject:[item dictionaryRepresentation]];
    }
    dict[Key_FeedItems] = itemsDicts;
    return dict;
}

- (void)loadItemsFromDictionary:(NSDictionary *)dict {
    [self.items removeAllObjects];
    self.lastRefresh = dict[Key_LastRefresh];
    self.etag = dict[Key_Feed_ETag];
    self.lastUpdated = dict[Key_Feed_LastUpdated];
    NSString *tmpURLString = dict[Key_Feed_BaseURL];
    if (tmpURLString) {
        NSURL *tmpURL = [[NSURL alloc] initWithString:tmpURLString];
        self.baseURL = tmpURL;
    }
    NSArray *itemsArray = dict[Key_FeedItems];
    for (NSDictionary *itemDict in itemsArray) {
        [self.items addObject:[self newItemWithDictionary:itemDict]];
    }
    [self dataUpdated];
    if (self.delegate) [self.delegate updateSource];
}

#pragma mark RSS Feed
- (void)refreshFeed {
    [self refreshFeedForced:NO];
}

- (void)refreshFeedForced:(BOOL)forced {
    
    if (((self.items).count == 0) ||
        ([[NSDate date] timeIntervalSinceDate:self.lastRefresh] > self.refreshTimerCount) || forced) {
        [self startDownload];
    }
}

- (void)cancelRefresh {

    [self.urlSession invalidateAndCancel];
    self.urlSession = nil;
}


- (void)startDownload {
    
    if (self.activeDownloadTask) {
        return;
    }
    
    [[UIApplication sharedApplication] tjm_pushNetworkActivity];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSMutableURLRequest *tmpRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.feed]];
    if (self.etag) {
        [tmpRequest addValue:self.etag forHTTPHeaderField:@"If-None-Match"];
    }
    if (self.lastUpdated) {
        [tmpRequest addValue:self.lastUpdated forHTTPHeaderField:@"If-Modified-Since"];
    }
    
    self.activeDownloadTask = [self.urlSession downloadTaskWithRequest:tmpRequest];

    [self.activeDownloadTask resume];
}


- (void)cancelDownload {
    
    self.activeDownloadTask = nil;
    [self.urlSession invalidateAndCancel];
    self.urlSession = nil;
    self.etag = nil;
    self.lastUpdated = nil;
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
}


#pragma mark Download support (NSURLSessionDataDelegate)



- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    DDLogDebug(@"didFinish");
    self.activeDownloadTask = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    DDLogDebug(@"[%@ %@] Updating progress",[self class], NSStringFromSelector(_cmd));
    
    if ([self.delegate respondsToSelector:@selector(updateProgressWithPercent:)]) {
        [self.delegate updateProgressWithPercent:totalBytesWritten / totalBytesExpectedToWrite];
    }
    self.activeDownloadTask = nil;
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    
    DDLogDebug(@"[%@ %@] didFinish",[self class], NSStringFromSelector(_cmd));
    
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
    
    [self parseResultWithData:[NSData dataWithContentsOfURL:location]];
    self.lastRefresh = [NSDate date];
    //done...lets save the date
    [self saveItems];
    [self dataUpdated];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //tell delegate we've updated...
        [self.delegate updateSource];
    });
}



- (void)parseResultWithData:(NSData *)xmlData {
    //DDLogDebug(@"%@",[NSString stringWithUTF8String:[xmlData bytes]]);
    
    // Create a new rssParser object (DDXMLDocument), this is the object that actually grabs and processes the RSS data
    if (xmlData.length > 0) {
        DDLogDebug(@"Parsing XML %lu bytes from feed %@",(unsigned long)[xmlData length], self.feed);
        DDXMLDocument *rssParser = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        
        
        // Create a new Array object to be used with the looping of the results from the rssParser
        self.baseURL = nil;
        
        NSString *baseURL = [[rssParser rootElement] attributeForName:@"xml:base"].stringValue;
        if (baseURL) {
            NSURL *tmpURL = [[NSURL alloc] initWithString:[[rssParser rootElement] attributeForName:@"xml:base"].stringValue];
            self.baseURL = tmpURL;
        }
        
        NSString *xpath;
        
        if (self.xpathOverride) {
            xpath = self.xpathOverride;
        } else {
            xpath = @"//item";
        }
        
        NSArray *resultNodes = [rssParser nodesForXPath:xpath error:nil];
        
        // Loop through the resultNodes to access each items' actual data
        NSMutableArray *newFeedItems = [[NSMutableArray alloc] initWithCapacity:resultNodes.count];
        
        for (DDXMLElement *resultElement in resultNodes) {
            [newFeedItems addObject:[self newItemWithXMLElement:resultElement andBaseURL:self.baseURL]];
        }
        //rssParser = nil;
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:newFeedItems];
        //nearly done, just need to make sure the items are sorted correctly
        //descending pubDate order would probably be best
        [self.items sortUsingComparator: ^(id obj1, id obj2) {
            TCHBaseFeedItem *item1 = (TCHBaseFeedItem *)obj1;
            TCHBaseFeedItem *item2 = (TCHBaseFeedItem *)obj2;
            return [item1 compare:item2];
        }];
        //newFeedItems = nil;
    } else {
        DDLogDebug(@"0 updated bytes from %@",self.feed);
    }
}

- (NSUInteger)itemCount {
    return (self.items).count;
}

- (id)itemAtIndex:(NSUInteger)index {
    return (index < (self.items).count) ? self.items[index] : nil;
}

- (void)removeItemsInArray:(NSArray *)itemsArray {
    [self.items removeObjectsInArray:itemsArray];
}

- (NSArray *)itemArray {
    return [NSArray arrayWithArray:self.items];
}

# pragma mark - Override these

- (NSInteger)refreshTimerCount {
    //number of seconds to wait before feed refreshes - override for different time
    //return 25200; // 7 hours - read it in the morning, and see if there's anything new at the end of the day!
    
    // refresh feed every 30 minutes
    return 1800;
}

- (void)dataUpdated {
    //do nothing...
}

- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    //override in subclass
    NSAssert(NO,@"TCHBaseFeedList subclasses must override newItemWithXMLElement:andBaseURL: without calling super.");
    return nil;
}

- (TCHBaseFeedItem *)newItemWithDictionary:(NSDictionary *)dictionary {
    NSAssert(NO,@"TCHBaseFeedList subclasses must override newItemWithDictionary: without calling super.");
    return nil;
}

- (NSString *)feedURL {
    //override in subclass
    NSAssert(NO,@"TCHBaseFeedList subclasses must override feedURL without calling super.");
    return nil;
}

- (NSString *)cacheFilename {
    //override in subclass
    NSAssert(NO,@"TCHBaseFeedList subclasses must override cacheFilename without calling super.");
    return nil;
}

@end
