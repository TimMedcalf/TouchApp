//
//  RadioItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RadioItem : FeedItem

@property (nonatomic) NSString *author;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *titleLabel;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSDate   *pubDate;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *episode_duration;

@end
