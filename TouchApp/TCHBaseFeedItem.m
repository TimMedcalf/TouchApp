//
//  TCHBaseFeedItem.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedItem.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const FeedItem_ImageURLKey = @"imageURL";
#pragma clang diagnostic pop


@implementation TCHBaseFeedItem

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.imageURL = [NSURL URLWithString:dict[FeedItem_ImageURLKey]];
    }
    return self;
}

- (instancetype)initWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    self = [super init];
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //TODO - what is this for?
    if (self.imageURL) dict[FeedItem_ImageURLKey] = [self.imageURL absoluteString];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSComparisonResult)compare:(TCHBaseFeedItem *)item {
    //override in subclass if possible
    return NSOrderedSame;
}

- (NSString *)htmlForWebView {
    //override in subclass if you want HTML content linked to this item
    return nil;
}

@end
