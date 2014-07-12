//
//  TCHNewsFeedItem.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCHBaseFeedItem.h"


@interface TCHNewsFeedItem : TCHBaseFeedItem

@property (copy, nonatomic) NSString *pubDate;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *description;

@end
