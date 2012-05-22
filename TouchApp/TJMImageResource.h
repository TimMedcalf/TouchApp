//
//  TJMImageResource.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TJMImageResourceImageNeedsUpdating;


@interface TJMImageResource : NSObject

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSDate *lastAccessed;

- (id)initWithURL:(NSURL *)imageURL;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

- (void)clearCachedFiles;

- (BOOL)imageIsDownloaded;
- (void)cacheImage;
- (UIImage *)getImage;
- (UIImage *)getImageWithPreferredPlaceholder:(TJMImageResource *)placeholder;
- (UIImage *)getImageThumbnailOfSize:(CGSize)size;

@end
