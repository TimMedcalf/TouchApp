//
//  RecipeItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"


@interface RecipeItem : FeedItem

@property (strong, nonatomic) NSString *recipeTitle;
@property (strong, nonatomic) NSString *recipeExcerpt;
@property (strong, nonatomic) NSString *recipeDescription;
@property (strong, nonatomic) NSDate *recipePubDate;

@end
