//
//  RecipeCategoryItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeCategoryItem.h"

NSString *const Key_RCat_Id = @"id";
NSString *const Key_RCat_Title = @"title";

@implementation RecipeCategoryItem

@synthesize recipeId = _recipeId;
@synthesize recipeTitle = _recipeTitle;


#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.recipeId = dict[Key_RCat_Id];
  self.recipeTitle = dict[Key_RCat_Title];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{ 
  self.recipeId = dict[Key_RCat_Id];
  self.recipeTitle = dict[Key_RCat_Title];
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.recipeId) dict[Key_RCat_Id] = self.recipeId;
  if (self.recipeTitle) dict[Key_RCat_Title] = self.recipeTitle;
}

- (NSComparisonResult)compare:(RecipeCategoryItem *)item
{
  //compare in reverse so that we get the newest at the top.
  return [self.recipeTitle compare:item.recipeTitle];
}

- (NSInteger)refreshTimerCount
{
  return 3600;
}

@end
