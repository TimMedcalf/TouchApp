//
//  TCHBaseFeedItem.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CXMLElement;

@interface TCHBaseFeedItem : NSObject
@property (strong, nonatomic) NSURL *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL;
- (NSDictionary *)dictionaryRepresentation;
- (NSComparisonResult)compare:(TCHBaseFeedItem *)item;
- (NSString *)htmlForWebView;


@end
