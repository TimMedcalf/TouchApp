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

- (void) dealloc
{
  [_recipeId release];
  [_recipeTitle release];
  [super dealloc];
}

#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.recipeId = [dict objectForKey:Key_RCat_Id];
  self.recipeTitle = [dict objectForKey:Key_RCat_Title];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{ 
  self.recipeId = [dict objectForKey:Key_RCat_Id];
  self.recipeTitle = [dict objectForKey:Key_RCat_Title];
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.recipeId) [dict setObject:self.recipeId forKey:Key_RCat_Id];
  if (self.recipeTitle) [dict setObject:self.recipeTitle forKey:Key_RCat_Title];
}

- (NSComparisonResult)compare:(RecipeCategoryItem *)item
{
  //compare in reverse so that we get the newest at the top.
  return [self.recipeTitle compare:item.recipeTitle];
}

@end
