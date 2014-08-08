//
//  NewsManager.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHNewsFeedList.h"
#import "TCHNewsFeedItem.h"


@implementation TCHNewsFeedList

//overrides
- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
  return [[TCHNewsFeedItem alloc] initWithXMLElement:element andBaseURL:baseURL];
}

- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
  return [[TCHNewsFeedItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL {
  return @"http://www.touchmusic.org.uk/iphone.xml";
}

- (NSString *)cacheFilename {
  return @"touchNews";
}

@end
