//
//  TCHCatalogueFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHCatalogueFeedList.h"
#import "TCHCatalogueFeedItem.h"


@implementation TCHCatalogueFeedList

//overrides

//- (NSInteger)refreshTimerCount
//{
//  return 3600;
//}

- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
  return [[TCHCatalogueFeedItem alloc] initWithXMLElement:element andBaseURL:baseURL];
}

- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
  return [[TCHCatalogueFeedItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL {
  return @"http://electric-window-7475.herokuapp.com/releases/publisher/Touch.xml";
}

- (NSString *)cacheFilename {
  return @"touchCatalogue";
}

@end
