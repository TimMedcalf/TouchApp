//
//  AppManager.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDSingleton.h"

@class TCHNewsFeedList, TCHImageFeedList, TCHCatalogueFeedList, TCHRadioFeedList, TCHRecipeCategoryFeedList;


@interface AppManager : NSObject

@property (strong, nonatomic) NSString *cacheFolder;

- (TCHNewsFeedList *)newsList;
- (TCHImageFeedList *)imageList;
- (TCHCatalogueFeedList *)catalogueList;
- (TCHRadioFeedList *)radioList;
- (TCHRecipeCategoryFeedList *)recipeList;

- (void)cancelUpdates;
- (void)refreshAllFeeds;

+ (instancetype)sharedInstance;

@end
