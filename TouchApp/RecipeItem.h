//
//  RecipeItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RecipeItem : FeedItem

@property (nonatomic) NSString *recipeTitle;
@property (nonatomic) NSString *recipeExcerpt;
@property (nonatomic) NSString *recipeDescription;
@property (nonatomic) NSDate *recipePubDate;

@end
