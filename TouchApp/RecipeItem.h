//
//  RecipeItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RecipeItem : FeedItem

@property (nonatomic, retain) NSString *recipeTitle;
@property (nonatomic, retain) NSString *recipeExcerpt;
@property (nonatomic, retain) NSString *recipeDescription;
@property (nonatomic, retain) NSDate *recipePubDate;

@end
