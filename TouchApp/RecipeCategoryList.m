//
//  RecipeCategoryList.m
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeCategoryList.h"
#import "RecipeCategoryItem.h"

@implementation RecipeCategoryList

//overrides
- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[RecipeCategoryItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[RecipeCategoryItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
  return @"http://www.touchmusic.org.uk/recipebook/categories.xml";
}

- (NSString *)cacheFilename
{
  return @"touchRecipeCategories";
}

- (void)dataUpdated
{
  NSMutableArray *delete = [NSMutableArray array];
  for (RecipeCategoryItem *item in self.items)
  {
    if (([item.recipeTitle isEqualToString:@"left"]) || ([item.recipeTitle isEqualToString:@"right"]))
      [delete addObject:item];
  }
  [self.items removeObjectsInArray:delete];
}


@end
