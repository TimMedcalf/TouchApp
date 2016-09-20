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
    //    if (self.activeDownload) {
    //        [self cancelDownload];
    //    }
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
    //    if (!self.activeDownload) {
    if (((self.items).count == 0) ||
        ([[NSDate date] timeIntervalSinceDate:self.lastRefresh] > self.refreshTimerCount) ||
        forced) {
        [self startDownload];
    }
    //    }
}

- (void)cancelRefresh {
    //    if (self.activeDownload) [self cancelDownload];
}


- (void)startDownload {
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
    
    NSURLSessionDownloadTask *downloadTask = [self.urlSession downloadTaskWithRequest:tmpRequest];
//                                                                    completionHandler:
//                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
//                                                  
//                                                  if (error) {
//                                                      // Clear the activeDownload property to allow later attempts
//                                                      //            self.activeDownload = nil;
//                                                      // Release the connection now that it's finished
//                                                      
//                                                      //self.rssConnection = nil;
//                                                      [self.urlSession invalidateAndCancel];
//                                                      self.urlSession = nil;
//                                                      
//                                                      
//                                                      if (self.delegate) [self.delegate updateFailed];
//                                                  } else {
//                                                      
//                                                      NSData *data = [NSData dataWithContentsOfURL:location];
//                                                      if (data) {
//                                                          //download size check
//                                                          //                DDLogDebug(@"Download: %@, %lu", self.feedURL, (unsigned long)[self.activeDownload length]);
//                                                          
//                                                          [self parseResultWithData:data];
//                                                          //then update the lastRefresh property
//                                                          self.lastRefresh = [NSDate date];
//                                                          //done...lets save the date
//                                                          [self saveItems];
//                                                          [self dataUpdated];
//                                                          //tell delegate we've updated...
//                                                          if (self.delegate) [self.delegate updateSource];
//                                                      }
//                                                      //            self.activeDownload = nil;
//                                                      
//                                                      // Release the connection now that it's finished
//                                                      //self.rssConnection = nil;
//                                                      [self.urlSession invalidateAndCancel];
//                                                      self.urlSession = nil;
//                                                  }
//                                                  
//                                                  // call our delegate and tell it that our icon is ready for display
//                                                  //[delegate appImageDidLoad:self.indexPathInTableView];
//                                                  
//                                                  [[UIApplication sharedApplication] tjm_popNetworkActivity];
//                                              }];
    [downloadTask resume];
}


- (void)cancelDownload {
    
    [self.urlSession invalidateAndCancel];
    self.urlSession = nil;
    //    self.activeDownload = nil;
    self.etag = nil;
    self.lastUpdated = nil;
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
}


#pragma mark Download support (NSURLSessionDataDelegate)

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    DDLogDebug(@"%@",[(NSHTTPURLResponse *)response allHeaderFields]);
    
    //store the etag
    self.etag = ((NSHTTPURLResponse *)response).allHeaderFields[@"Etag"];
    DDLogDebug(@"Etag=%@",self.etag);
    
    //last modified date - keep it as a string to easily match the server's format.
    self.lastUpdated = ((NSHTTPURLResponse *)response).allHeaderFields[@"Last-Modified"];
    DDLogDebug(@"Last Modified Date : %@", self.lastUpdated);
    
    // lets keep track of how big we are...and how much we've downloaded
    self.totalBytes = response.expectedContentLength;
    self.bytesDownloaded = 0;
    //TEST THIS
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    self.bytesDownloaded += data.length;
    //    [self.activeDownload appendData:data];
    DDLogDebug(@"Downloaded %lu", (unsigned long)[data length]);
    if ([self.delegate respondsToSelector:@selector(updateProgressWithPercent:)]) {
        DDLogDebug(@"Updating progress");
        [self.delegate updateProgressWithPercent:(CGFloat)self.bytesDownloaded / self.totalBytes];
    }
}

//URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend
//URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesWritten:totalBytesExpectedToWrite
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    DDLogDebug(@"URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesWritten:totalBytesExpectedToWrite");
}



#pragma mark Download support (NSURLSessionTaskDelegate)


//- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//
//    if (error) {
//    // Clear the activeDownload property to allow later attempts
//        self.activeDownload = nil;
//        // Release the connection now that it's finished
//
//        //self.rssConnection = nil;
//        [self.urlSession invalidateAndCancel];
//        self.urlSession = nil;
//
//
//        if (self.delegate) [self.delegate updateFailed];
//    } else {
//
//        if (self.activeDownload) {
//            //download size check
//            DDLogDebug(@"Download: %@, %lu", self.feedURL, (unsigned long)[self.activeDownload length]);
//
//            [self parseResultWithData:self.activeDownload];
//            //then update the lastRefresh property
//            self.lastRefresh = [NSDate date];
//            //done...lets save the date
//            [self saveItems];
//            [self dataUpdated];
//            //tell delegate we've updated...
//            if (self.delegate) [self.delegate updateSource];
//        }
//        self.activeDownload = nil;
//
//        // Release the connection now that it's finished
//        //self.rssConnection = nil;
//        [self.urlSession invalidateAndCancel];
//        self.urlSession = nil;
//    }
//
//    // call our delegate and tell it that our icon is ready for display
//    //[delegate appImageDidLoad:self.indexPathInTableView];
//
//    [[UIApplication sharedApplication] tjm_popNetworkActivity];
//}



- (void)parseResultWithData:(NSData *)xmlData {
    DDLogDebug(@"%@",[NSString stringWithUTF8String:[xmlData bytes]]);
    
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
