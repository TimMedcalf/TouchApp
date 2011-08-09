//
//  RadioItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RadioItem : FeedItem

@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *titleLabel;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSDate   *pubDate;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *episode_duration;

@end
