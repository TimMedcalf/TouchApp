//
//  FeedItem.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"


NSString *const FeedItem_ImageURLKey = @"imageURL";

@interface FeedItem ()

//things to override
- (void)procesSavedDictionary:(NSDictionary *)dict;
- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL;
- (void)processRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL; 
- (void)populateDictionary:(NSMutableDictionary *)dict;
@end

@implementation FeedItem

@synthesize imageURL = _imageURL;

@synthesize updateFlag = _updateFlag;


- (id)initWithDictionary:(NSDictionary *)dict
{
  self = [super init];
  if (self)
  {
    self.imageURL = [NSURL URLWithString:dict[FeedItem_ImageURLKey]];
    [self procesSavedDictionary:dict];
  }
  return self;
}

- (id)initWithXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{
  self = [super init];
  if (self)
  {
    [self processXMLDictionary:dict andBaseURL:baseURL];
  }
  return self;
}

- (id)initWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL
{
  self = [super init];
  if (self)
  {
    [self processRawXMLElement:element andBaseURL:baseURL];
  }
  return self;
}


- (NSMutableDictionary *)dictionaryRepresentation
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
  if (self.imageURL) dict[FeedItem_ImageURLKey] = [self.imageURL absoluteString];
  [self populateDictionary:dict];
  return dict;
}




#pragma mark sublclass overrides



- (void)procesSavedDictionary:(NSDictionary *)dict
{
  //override in subclass
  NSLog(@"Processing Saved Dictionary! This should be overridden!");
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{
  //override in subclass
  NSLog(@"Processing XML Dictionary! This should be overridden!");
}

- (void)processRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL
{
  //override in subclass
  NSLog(@"Processing XML Raw Element! This should be overridden!");
}

- (void)populateDictionary:(NSMutableDictionary *)dict;
{
  //override in subclass
  NSLog(@"Populating dictionary! This should be overridden!");
  
}

- (NSComparisonResult)compare:(FeedItem *)item
{
  //override in subclass
  return 0;
}

- (NSString *)htmlForWebView
{
  NSLog(@"should override htmlForWebView!");
  return @"should override htmlForWebView!";
}

@end
