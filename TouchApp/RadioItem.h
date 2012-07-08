//
//  RadioItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RadioItem : FeedItem

@property (weak, nonatomic) NSString *author;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *titleLabel;
@property (weak, nonatomic) NSString *summary;
@property (weak, nonatomic) NSString *subtitle;
@property (weak, nonatomic) NSDate   *pubDate;
@property (weak, nonatomic) NSString *link;
@property (weak, nonatomic) NSString *episode_duration;

@end
