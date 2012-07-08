//
//  RecipeItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RecipeItem : FeedItem

@property (weak, nonatomic) NSString *recipeTitle;
@property (weak, nonatomic) NSString *recipeExcerpt;
@property (weak, nonatomic) NSString *recipeDescription;
@property (weak, nonatomic) NSDate *recipePubDate;

@end
