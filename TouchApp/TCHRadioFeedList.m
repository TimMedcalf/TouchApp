//
//  TCHRadioFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHRadioFeedList.h"
#import "TCHRadioFeedItem.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
//OLD NSString *const kRadioFeedURLString = @"http://www.touchshop.org/touchradio/podcast.xml";
// MIKE PREFERRED BUT NOT NSString *const kRadioFeedURLString = @"http://touchradio.org.uk/episodes/feed";
NSString *const kRadioFeedURLString = @"http://touchradio.org.uk/category/episodes/feed";
NSString *const kRadioCacheFileName = @"touchRadio";
#pragma clang diagnostic pop


@implementation TCHRadioFeedList

//overrides

- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    
    return [[TCHRadioFeedItem alloc] initWithXMLElement:element andBaseURL:baseURL];
}


- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
    
    return [[TCHRadioFeedItem alloc]initWithDictionary:dictionary];
}


- (NSString *)feedURL {
    
    return kRadioFeedURLString;
}


- (NSString *)cacheFilename {
    
    return kRadioCacheFileName;
}

@end
