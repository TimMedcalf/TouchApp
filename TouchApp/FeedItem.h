//
//  FeedItem.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedItem;

@interface FeedItem : NSObject
@property (weak, nonatomic) NSURL *imageURL;
@property (nonatomic, assign) BOOL updateFlag;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL;
- (id)initWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL;
- (NSMutableDictionary *)dictionaryRepresentation;
- (NSComparisonResult)compare:(FeedItem *)item;
- (NSString *)htmlForWebView;


@end
