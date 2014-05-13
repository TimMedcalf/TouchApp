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
- (FeedItem *)newItemWithXMLDictionary:itemDict andBaseURL:baseURL {
  return [[RecipeCategoryItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)newItemWithDictionary:dictionary {
  return [[RecipeCategoryItem alloc]initWithDictionary:dictionary];
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
    for (RecipeCategoryItem *item in self.itemArray) {
        if (([item.recipeTitle isEqualToString:@"left"]) || ([item.recipeTitle isEqualToString:@"right"]))
            [delete addObject:item];
    }
    [self removeItemsInArray:delete];
}

@end
