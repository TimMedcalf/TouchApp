//
//  AppManager.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "AppManager.h"
#import "NewsList.h"

NSString *const LMSUCache = @"TouchCache";

@interface AppManager ()
@property (nonatomic, retain) NewsList *internalNewsList;
@property (nonatomic, retain) ImageList *internalImageList;
@property (nonatomic, retain) CatalogueList *internalCatalogueList;
@property (nonatomic, retain) RadioList *internalRadioList;
@property (nonatomic, retain) RecipeCategoryList *internalRecipeList;
@end

@implementation AppManager

SINGLETON_IMPLEMENTATION_FOR(AppManager)

@synthesize cacheFolder = _cacheFolder;

@synthesize internalNewsList = _internalNewsList;
@synthesize internalImageList = _internalImageList;
@synthesize internalCatalogueList = _internalCatalogueList;
@synthesize internalRadioList = _internalRadioList;
@synthesize internalRecipeList = _internalRecipeList;

- (id)init
{
  if ((self = [super init]))
  {    
    NSError *error;
    self.cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LMSUCache];
    if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheFolder withIntermediateDirectories:YES attributes:nil error:&error])
    {
      NSLog(@"Error creating caches subfolder : %@",error);
    }
  }
  return self;
}

- (NewsList *)newsList
{
  if (!self.internalNewsList)
  {
    NewsList *tmpNewsList = [[NewsList alloc] init];
    self.internalNewsList = tmpNewsList;
    [tmpNewsList release];
  }
  return self.internalNewsList;
}

- (ImageList *)imageList
{
  if (!self.internalImageList)
  {
    ImageList *tmpImageList = [[ImageList alloc] init];
    self.internalImageList = tmpImageList;
    tmpImageList.xpathOverride = @"//photo";
    tmpImageList.rawMode = YES;

    [tmpImageList release];
  }
  return self.internalImageList;
}

- (CatalogueList *)catalogueList
{
  if (!self.internalCatalogueList)
  {
    CatalogueList *tmpList = [[CatalogueList alloc] init];
    tmpList.xpathOverride = @"//release";
    self.internalCatalogueList = tmpList;
    [tmpList release];
  }
  return self.internalCatalogueList;
}

- (RadioList *)radioList
{
  if (!self.internalRadioList)
  {
    RadioList *tmpList = [[RadioList alloc] init];
    self.internalRadioList = tmpList;
    [tmpList release];
  }
  return self.internalRadioList;
}

- (RecipeCategoryList *)recipeList
{
  if (!self.internalRecipeList)
  {
    RecipeCategoryList *tmpList = [[RecipeCategoryList alloc] init];
    tmpList.xpathOverride = @"//category";
    self.internalRecipeList = tmpList;
    [tmpList release];
  }
  return self.internalRecipeList;
}

- (void)cancelUpdates
{
  [self.internalCatalogueList cancelRefresh];
  [self.internalRadioList cancelRefresh];
  [self.internalNewsList cancelRefresh];
  [self.internalImageList cancelRefresh];
  [self.internalRecipeList cancelRefresh];
}
- (void)refreshAllFeeds
{
  // if nothing has been loaded before (so there'd be no items in news)
  // then just refresh the news and super expensive catalogue
  // the others can wait till the user taps on them
  // but if it's been loaded before, just refresh them all...
  if ([[self newsList].items count] == 0)
  {
    [[self newsList] refreshFeed];
    [[self catalogueList] refreshFeed];
  }
  else
  {
    [[self newsList] refreshFeed];
    [[self catalogueList] refreshFeed];
    [[self radioList] refreshFeed];
    [[self imageList] refreshFeed];
    [[self recipeList] refreshFeed];
  }
}

- (void) dealloc
{
  [_cacheFolder release];
  [_internalNewsList release];
  [_internalImageList release];
  [_internalCatalogueList release];
  [_internalRadioList release];
  [_internalRecipeList release];
  [super dealloc];
}
@end
