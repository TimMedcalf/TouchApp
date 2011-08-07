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
- (void)updateSource;
- (void)updateImage:(NSInteger)index;
- (void)updateFailed;
@end

@interface FeedList : NSObject <FeedItemDelegate>

@property (nonatomic, assign) id<FeedListConsumerDelegate, NSObject> delegate;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSDate *lastRefresh;

- (void)refreshFeedForced:(BOOL)forced;
- (void)refreshFeed;
- (void)cancelRefresh;

- (void)startDownload;
- (void)cancelDownload;
- (void)parseResultWithData:(NSData *)xmlData;
- (void)mergeExistingWithItems:(NSArray *)newItems;

//overrides
- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL;
- (FeedItem *)initNewItemWithDictionary:dictionary;
- (void)dataUpdated;
- (NSString *)feedURL;
- (NSString *)cacheFilename;
@end
