//
//  TCHRecipeCategoryFeedItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedItem.h"


@interface TCHRecipeCategoryFeedItem : TCHBaseFeedItem

@property (strong, nonatomic) NSNumber *recipeId;
@property (copy, nonatomic) NSString *recipeTitle;

@end
