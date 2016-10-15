//
//  AppManager.m
//  TouchApp
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHAppManager.h"
#import "TCHBaseFeedList.h"
#import "TCHNewsFeedList.h"
#import "TCHImageFeedList.h"
#import "TCHCatalogueFeedList.h"
#import "TCHRadioFeedList.h"
#import "TCHRecipeCategoryFeedList.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const LMSUCache = @"TouchCache";
#pragma clang diagnostic pop


@interface TCHAppManager ()

@property (strong, nonatomic) TCHNewsFeedList *internalNewsList;
@property (strong, nonatomic) TCHImageFeedList *internalImageList;
@property (strong, nonatomic) TCHCatalogueFeedList *internalCatalogueList;
@property (strong, nonatomic) TCHRadioFeedList *internalRadioList;
@property (strong, nonatomic) TCHRecipeCategoryFeedList *internalRecipeList;

@end


@implementation TCHAppManager

- (instancetype)init {
    if ((self = [super init])) {
        NSError *error;
        _cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:LMSUCache];
        if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
            DDLogError(@"Error creating caches subfolder : %@", error);
        }
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (TCHNewsFeedList *)newsList {
    if (!self.internalNewsList) {
        TCHNewsFeedList *tmpNewsList = [[TCHNewsFeedList alloc] init];
        self.internalNewsList = tmpNewsList;
    }
    return self.internalNewsList;
}

- (TCHImageFeedList *)imageList {
    if (!self.internalImageList) {
        TCHImageFeedList *tmpImageList = [[TCHImageFeedList alloc] init];
        self.internalImageList = tmpImageList;
        tmpImageList.xpathOverride = @"//photo";
    }
    
    return self.internalImageList;
}

- (TCHCatalogueFeedList *)catalogueList {
    if (!self.internalCatalogueList) {
        TCHCatalogueFeedList *tmpList = [[TCHCatalogueFeedList alloc] init];
        tmpList.xpathOverride = @"//release";
        self.internalCatalogueList = tmpList;
    }
    
    return self.internalCatalogueList;
}

- (TCHRadioFeedList *)radioList {
    if (!self.internalRadioList) {
        TCHRadioFeedList *tmpList = [[TCHRadioFeedList alloc] init];
        self.internalRadioList = tmpList;
    }
    return self.internalRadioList;
}

- (TCHRecipeCategoryFeedList *)recipeList {
    if (!self.internalRecipeList) {
        TCHRecipeCategoryFeedList *tmpList = [[TCHRecipeCategoryFeedList alloc] init];
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
    
    if ((self.newsList).itemCount == 0) {
        [self.newsList refreshFeed];
        [self.catalogueList refreshFeed];
    } else {
        [self.newsList refreshFeed];
        [self.catalogueList refreshFeed];
        [self.radioList refreshFeed];
        [self.imageList refreshFeed];
        [self.recipeList refreshFeed];
    }
}

@end
