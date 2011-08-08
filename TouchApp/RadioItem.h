//
//  RadioItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface RadioItem : FeedItem

@property (nonatomic, copy) NSString* author;
@property (nonatomic, copy) NSString* summary;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* pubDate;
@property (nonatomic, copy) NSString* link;
@property (nonatomic, copy) NSString* episode_duration;

@end
