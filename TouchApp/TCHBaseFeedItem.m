//
//  TCHBaseFeedItem.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedItem.h"

NSString *const FeedItem_ImageURLKey = @"imageURL";


@interface TCHBaseFeedItem ()

//things to override
- (void)processSavedDictionary:(NSDictionary *)dict;
- (void)processXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL;
@end


@implementation TCHBaseFeedItem

- (id)initWithDictionary:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    self.imageURL = [NSURL URLWithString:dict[FeedItem_ImageURLKey]];
      [self processSavedDictionary:dict];
  }
  return self;
}

- (id)initWithXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
  self = [super init];
  if (self) {
      [self processXMLElement:element andBaseURL:baseURL];
  }
  return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    //TODO - what is this for?
    if (self.imageURL) dict[FeedItem_ImageURLKey] = [self.imageURL absoluteString];

    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark subclass overrides
- (void)processSavedDictionary:(NSDictionary *)dict {
  //override in subclass
}

- (void)processXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
  //override in subclass
}


- (NSComparisonResult)compare:(TCHBaseFeedItem *)item {
    //override in subclass
    return NSOrderedSame;
}

- (NSString *)htmlForWebView {
    //override in subclass
    return nil;
}

@end
