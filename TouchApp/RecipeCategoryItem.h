//
//  RecipeCategoryItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RecipeCategoryItem : FeedItem

@property (nonatomic,retain) NSNumber *recipeId;
@property (nonatomic, retain) NSString *recipeTitle;

@end
