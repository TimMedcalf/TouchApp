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
- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL;
- (void)processRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL; 
- (void)populateDictionary:(NSMutableDictionary *)dict;

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
    [self processRawXMLElement:element andBaseURL:baseURL];
  }
  return self;
}


- (NSMutableDictionary *)dictionaryRepresentation {
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
  if (self.imageURL) dict[FeedItem_ImageURLKey] = [self.imageURL absoluteString];
  [self populateDictionary:dict];
  return dict;
}

#pragma mark sublclass overrides
- (void)processSavedDictionary:(NSDictionary *)dict {
  //override in subclass
  NSLog(@"Processing Saved Dictionary! This should be overridden!");
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL {
  //override in subclass
  NSLog(@"Processing XML Dictionary! This should be overridden!");
}

- (void)processRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
  //override in subclass
  NSLog(@"Processing XML Raw Element! This should be overridden!");
}

- (void)populateDictionary:(NSMutableDictionary *)dict {
  //override in subclass
  NSLog(@"Populating dictionary! This should be overridden!");
}

- (NSComparisonResult)compare:(TCHBaseFeedItem *)item {
  //override in subclass
  return NSOrderedSame;
}

- (NSString *)htmlForWebView {
  NSLog(@"should override htmlForWebView!");
  return @"should override htmlForWebView!";
}

@end
