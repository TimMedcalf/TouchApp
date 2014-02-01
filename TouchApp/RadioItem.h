//
//  RadioItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"


@interface RadioItem : FeedItem

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *titleLabel;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSDate   *pubDate;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *episode_duration;

@end
