//
//  RadioItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"


@interface RadioItem : FeedItem

@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *titleLabel;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *episode_duration;
@property (strong, nonatomic) NSDate *pubDate;

@end
