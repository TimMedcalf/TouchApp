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

//- (NSInteger)refreshTimerCount
//{
//  return 3600;
//}

- (FeedItem *)newItemWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
  return [[RadioItem alloc]initWithRawXMLElement:element andBaseURL:baseURL];
}

- (FeedItem *)newItemWithDictionary:dictionary {
  return [[RadioItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL {
  return @"http://www.touchshop.org/touchradio/podcast.xml";
}

- (NSString *)cacheFilename {
  return @"touchRadio";
}

@end
