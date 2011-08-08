//
//  RadioItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

NSString *const Key_Radio_Author = @"";
NSString *const Key_Radio_Summary = @"";
NSString *const Key_Radio_SubTitle = @"";
NSString *const Key_Radio_PubDate = @"";
NSString *const Key_Radio_Link = @"";
NSString *const Key_Radio_Duration = @"";

#import "RadioItem.h"

@implementation RadioItem

@synthesize author = _author;
@synthesize summary = _summary;
@synthesize subtitle = _subtitle;
@synthesize pubDate = _pubDate;
@synthesize link =_link;
@synthesize episode_duration = _episode_duration;
@end
