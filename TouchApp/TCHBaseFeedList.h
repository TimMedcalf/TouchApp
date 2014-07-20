//
//  TCHBaseFeedList.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"

@class TCHBaseFeedItem, CXMLElement;

@protocol FeedListConsumerDelegate

@optional
- (void)updateSource;
- (void)updateFailed;
- (void)updateProgressWithPercent:(CGFloat)percentComplete;

@end


@interface TCHBaseFeedList : NSObject

@property (weak, nonatomic) id<FeedListConsumerDelegate, NSObject> delegate;
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) NSDate *lastRefresh;
@property (copy, nonatomic) NSString *xpathOverride;

//dirty hack to deal with the way we load touch recipe books...probably a better way of coping with this...
- (id)initWithoutLoading;
- (void)continueLoading;

- (void)refreshFeedForced:(BOOL)forced;
- (void)refreshFeed;
- (void)cancelRefresh;

- (NSUInteger)itemCount;
- (id)itemAtIndex:(NSUInteger)index;
- (void)removeItemsInArray:(NSArray *)itemsArray;
- (NSArray *)itemArray;

//overrides
- (NSInteger)refreshTimerCount;
- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL;
- (TCHBaseFeedItem *)newItemWithDictionary:(NSDictionary *)dictionary;

- (NSString *)feedURL;
- (NSString *)cacheFilename;

- (void)dataUpdated;

@end
