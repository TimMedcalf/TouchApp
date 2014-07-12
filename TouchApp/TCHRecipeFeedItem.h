//
//  TCHRecipeFeedItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedItem.h"


@interface TCHRecipeFeedItem : TCHBaseFeedItem

@property (copy, nonatomic) NSString *recipeTitle;
@property (copy, nonatomic) NSString *recipeExcerpt;
@property (copy, nonatomic) NSString *recipeDescription;
@property (strong, nonatomic) NSDate *recipePubDate;

@end
