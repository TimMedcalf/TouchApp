//
//  TCHRadioFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHRadioFeedList.h"
#import "TCHRadioFeedItem.h"


@implementation TCHRadioFeedList

//overrides

//- (NSInteger)refreshTimerCount
//{
//  return 3600;
//}

- (TCHBaseFeedItem *)newItemWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
  return [[TCHRadioFeedItem alloc]initWithRawXMLElement:element andBaseURL:baseURL];
}

- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
  return [[TCHRadioFeedItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL {
  return @"http://www.touchshop.org/touchradio/podcast.xml";
}

- (NSString *)cacheFilename {
  return @"touchRadio";
}

@end
