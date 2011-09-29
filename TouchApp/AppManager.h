//
//  AppManager.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsList.h"
#import "ImageList.h"
#import "CatalogueList.h"
#import "RadioList.h"
#import "RecipeCategoryList.h"


@interface AppManager : NSObject

SINGLETON_INTERFACE_FOR(AppManager)

@property (nonatomic, retain) NSString *cacheFolder;

- (NewsList *)newsList;
- (ImageList *)imageList;
- (CatalogueList *)catalogueList;
- (RadioList *)radioList;
- (RecipeCategoryList *)recipeList;

- (void)cancelUpdates;
- (void)refreshAllFeeds;

@end
