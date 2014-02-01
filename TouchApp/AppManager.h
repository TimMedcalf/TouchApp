//
//  AppManager.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDSingleton.h"

@class NewsList, ImageList, CatalogueList, RadioList,RecipeCategoryList;


@interface AppManager : NSObject

@property (strong, nonatomic) NSString *cacheFolder;

- (NewsList *)newsList;
- (ImageList *)imageList;
- (CatalogueList *)catalogueList;
- (RadioList *)radioList;
- (RecipeCategoryList *)recipeList;

- (void)cancelUpdates;
- (void)refreshAllFeeds;

+ (instancetype)sharedInstance;

@end
