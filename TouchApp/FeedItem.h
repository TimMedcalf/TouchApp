//
//  FeedItem.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMLazyImage.h"
#import <Foundation/Foundation.h>

@class FeedItem;

@protocol FeedItemDelegate
-(void)imageUpdated:(FeedItem *)item;
@end

@interface FeedItem : NSObject <TJMLazyImageDelegate>

@property (nonatomic, retain) NSString *imageLink;
@property (nonatomic, retain) NSString *cachedImageName;
@property (nonatomic, retain) TJMLazyImage *lazyImage;
@property (nonatomic, retain) NSString *baseURL;

@property (nonatomic, assign) id<FeedItemDelegate, NSObject> delegate;
@property (nonatomic, assign) BOOL updateFlag;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithXMLDictionary:(NSDictionary *)dict andBaseURL:(NSString *)baseURL;
- (NSMutableDictionary *)dictionaryRepresentation;
- (BOOL)isEqualToItem:(FeedItem *)otherFeedItem;
- (NSComparisonResult)compare:(FeedItem *)item;

@end
