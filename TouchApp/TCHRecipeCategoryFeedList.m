//
//  TCHRecipeCategoryFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHRecipeCategoryFeedList.h"
#import "TCHRecipeCategoryFeedItem.h"


@implementation TCHRecipeCategoryFeedList

//overrides
- (TCHBaseFeedItem *)newItemWithXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
  return [[TCHRecipeCategoryFeedItem alloc] initWithXMLElement:element andBaseURL:baseURL];
}

- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
  return [[TCHRecipeCategoryFeedItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL {
  return @"http://www.touchmusic.org.uk/recipebook/categories.xml";
}

- (NSString *)cacheFilename {
  return @"touchRecipeCategories";
}

// what is this for?
- (void)dataUpdated {
  [super dataUpdated];
  NSMutableArray *delete = [NSMutableArray array];
  for (TCHRecipeCategoryFeedItem *item in self.itemArray) {
      if (([item.recipeTitle isEqualToString:@"left"]) || ([item.recipeTitle isEqualToString:@"right"]))
          [delete addObject:item];
  }
  [self removeItemsInArray:delete];
}

@end
