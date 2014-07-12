//
//  TCHRadioFeedItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedItem.h"

extern NSString *const Key_Radio_Author;
extern NSString *const Key_Radio_Title;
extern NSString *const Key_Radio_Summary;
extern NSString *const Key_Radio_SubTitle;
extern NSString *const Key_Radio_PubDate;
extern NSString *const Key_Radio_Link;
extern NSString *const Key_Radio_Duration;
extern NSString *const Key_Radio_TitleLabel;
extern NSString *const Key_ImageOverride;

@interface TCHRadioFeedItem : TCHBaseFeedItem

@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *titleLabel;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *episode_duration;
@property (strong, nonatomic) NSDate *pubDate;

@end
