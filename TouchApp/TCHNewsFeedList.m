//
//  NewsManager.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//


#import "TCHNewsFeedList.h"
#import "TCHNewsFeedItem.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
//NSString *const kNewsFeedURLString = @"http://www.touchshop.org/touch/iphone.xml";
NSString *const kNewsFeedURLString = @"http://www.touchmusic.org.uk/iphone.xml";
//NSString *const kNewsFeedURLString = @"http://touch33.net/news/feed";

NSString *const kNewsCacheFileName = @"touchNews";
#pragma clang diagnostic pop

@implementation TCHNewsFeedList

//overrides
- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    
    return [[TCHNewsFeedItem alloc] initWithXMLElement:element andBaseURL:baseURL];
}


- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
    
    return [[TCHNewsFeedItem alloc] initWithDictionary:dictionary];
}


- (NSString *)feedURL {
    
    return kNewsFeedURLString;
}


- (NSString *)cacheFilename {
    
    return kNewsCacheFileName;
}


@end
