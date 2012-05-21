//
//  FeedList.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"


@protocol FeedListConsumerDelegate
@optional
- (void)updateSource;
- (void)updateFailed;
- (void)updateProgressWithPercent:(CGFloat)percentComplete;
@end

@interface FeedList : NSObject

@property (nonatomic, assign) id<FeedListConsumerDelegate, NSObject> delegate;
@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSDate *lastRefresh;
@property (nonatomic, retain) NSString *xpathOverride;
@property (nonatomic, assign) BOOL rawMode;

//dirty hack to deal with the way we load touch recipe books...probably a better way of coping with this...
- (id)initWithoutLoading;
- (void)continueLoading;

- (void)refreshFeedForced:(BOOL)forced;
- (void)refreshFeed;
- (void)cancelRefresh;

//overrides
- (NSInteger)refreshTimerCount;
- (FeedItem *)newItemWithXMLDictionary:(NSDictionary *)itemDict andBaseURL:(NSURL *)baseURL;
- (FeedItem *)newItemWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL; 
- (FeedItem *)newItemWithDictionary:(NSDictionary *)dictionary;

- (NSString *)feedURL;
- (NSString *)cacheFilename;

- (void)dataUpdated;
@end
