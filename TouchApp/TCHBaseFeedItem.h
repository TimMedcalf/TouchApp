//
//  TCHBaseFeedItem.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@class TCHBaseFeedItem;


@interface TCHBaseFeedItem : NSObject
@property (strong, nonatomic) NSURL *imageURL;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL;
- (NSMutableDictionary *)dictionaryRepresentation;
- (NSComparisonResult)compare:(TCHBaseFeedItem *)item;
- (NSString *)htmlForWebView;

@end
