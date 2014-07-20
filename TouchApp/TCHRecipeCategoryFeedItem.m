//
//  TCHRecipeCategoryFeedItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHRecipeCategoryFeedItem.h"

NSString *const Key_RCat_Id = @"id";
NSString *const Key_RCat_Title = @"title";


@implementation TCHRecipeCategoryFeedItem

#pragma mark overrides from FeedItem

//- (NSInteger)refreshTimerCount
//{
//  return 3600;
//}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.recipeId = dict[Key_RCat_Id];
        self.recipeTitle = dict[Key_RCat_Title];
    }
    return self;
}



- (instancetype)initWithXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
    self = [super initWithXMLElement:element andBaseURL:baseURL];
    if (self) {
        NSString *numString = [[element nodeForXPath:Key_RCat_Id error:nil] stringValue];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.recipeId = [f numberFromString:numString];
        self.recipeTitle = [[element nodeForXPath:Key_RCat_Title error:nil] stringValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    if (self.recipeId) dict[Key_RCat_Id] = self.recipeId;
    if (self.recipeTitle) dict[Key_RCat_Title] = self.recipeTitle;
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSComparisonResult)compare:(TCHBaseFeedItem *)item {
  //compare in reverse so that we get the newest at the top.
  return [self.recipeTitle compare:((TCHRecipeCategoryFeedItem *)item).recipeTitle];
}

@end
