//
//  AppManager.h
//  TouchApp
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDSingleton.h"

@class TCHNewsFeedList, TCHImageFeedList, TCHCatalogueFeedList, TCHRadioFeedList, TCHRecipeCategoryFeedList;


@interface AppManager : NSObject

@property (strong, nonatomic) NSString *cacheFolder;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) TCHNewsFeedList *newsList;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) TCHImageFeedList *imageList;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) TCHCatalogueFeedList *catalogueList;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) TCHRadioFeedList *radioList;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) TCHRecipeCategoryFeedList *recipeList;

- (void)cancelUpdates;
- (void)refreshAllFeeds;

+ (instancetype)sharedInstance;

@end
