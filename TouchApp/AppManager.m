//
//  AppManager.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "AppManager.h"
#import "FeedList.h"
#import "NewsList.h"
#import "ImageList.h"
#import "CatalogueList.h"
#import "RadioList.h"
#import "RecipeCategoryList.h"

NSString *const LMSUCache = @"TouchCache";


@interface AppManager ()

@property (strong, nonatomic) NewsList *internalNewsList;
@property (strong, nonatomic) ImageList *internalImageList;
@property (strong, nonatomic) CatalogueList *internalCatalogueList;
@property (strong, nonatomic) RadioList *internalRadioList;
@property (strong, nonatomic) RecipeCategoryList *internalRecipeList;

@end


@implementation AppManager

- (id)init {
  if ((self = [super init])) {
    NSError *error;
    self.cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:LMSUCache];    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
      NSLog(@"Error creating caches subfolder : %@", error);
    }
  }
  
  return self;
}

+ (instancetype)sharedInstance {
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (NewsList *)newsList {
  if (!self.internalNewsList) {
    NewsList *tmpNewsList = [[NewsList alloc] init];
    tmpNewsList.rawMode = YES;
    self.internalNewsList = tmpNewsList;
  }
  return self.internalNewsList;
}

- (ImageList *)imageList {
  if (!self.internalImageList) {
    ImageList *tmpImageList = [[ImageList alloc] init];
    self.internalImageList = tmpImageList;
    tmpImageList.xpathOverride = @"//photo";
    tmpImageList.rawMode = YES;

  }
  
  return self.internalImageList;
}

- (CatalogueList *)catalogueList {
  if (!self.internalCatalogueList) {
    CatalogueList *tmpList = [[CatalogueList alloc] init];
    tmpList.xpathOverride = @"//release";
    tmpList.rawMode = YES;
    self.internalCatalogueList = tmpList;
  }
  
  return self.internalCatalogueList;
}

- (RadioList *)radioList {
  if (!self.internalRadioList) {
    RadioList *tmpList = [[RadioList alloc] init];
    tmpList.rawMode = YES;
    self.internalRadioList = tmpList;
  }
  return self.internalRadioList;
}

- (RecipeCategoryList *)recipeList {
  if (!self.internalRecipeList) {
    RecipeCategoryList *tmpList = [[RecipeCategoryList alloc] init];
    tmpList.xpathOverride = @"//category";
    self.internalRecipeList = tmpList;
  }
  
  return self.internalRecipeList;
}

- (void)cancelUpdates {
  [self.internalCatalogueList cancelRefresh];
  [self.internalRadioList cancelRefresh];
  [self.internalNewsList cancelRefresh];
  [self.internalImageList cancelRefresh];
  [self.internalRecipeList cancelRefresh];
}

- (void)refreshAllFeeds {
  // if nothing has been loaded before (so there'd be no items in news)
  // then just refresh the news and super expensive catalogue
  // the others can wait till the user taps on them
  // but if it's been loaded before, just refresh them all...
  if ([self.newsList itemCount] == 0) {
    [[self newsList] refreshFeed];
    [[self catalogueList] refreshFeed];
  } else {
    [[self newsList] refreshFeed];
    [[self catalogueList] refreshFeed];
    [[self radioList] refreshFeed];
    [[self imageList] refreshFeed];
    [[self recipeList] refreshFeed];
  }
}

@end
