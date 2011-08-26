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


@end
