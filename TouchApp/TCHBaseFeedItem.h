//
//  TCHBaseFeedItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDXMLElement;

@interface TCHBaseFeedItem : NSObject
@property (strong, nonatomic) NSURL *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL;
- (NSDictionary *)dictionaryRepresentation;
- (NSComparisonResult)compare:(TCHBaseFeedItem *)item;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *htmlForWebView;


@end
