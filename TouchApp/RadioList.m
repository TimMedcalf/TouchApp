//
//  RadioList.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RadioList.h"
#import "RadioItem.h"

@implementation RadioList

//overrides
- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[RadioItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[RadioItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
  return @"http://www.touchshop.org/touchradio/podcast.xml";
}

- (NSString *)cacheFilename
{
  return @"touchRadio";
}

//- (NSInteger)refreshTimerCount
//{
//  return 3600;
//}


@end
