//
//  TJMLazyImage.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 06/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TJMLazyImageDelegate
- (void)imageUpdated;
@end

@interface TJMLazyImage : NSObject
- (id)initWithURL:(NSString *)imageURL andCacheFilename:(NSString *)cacheFilename;
- (void)cancelImageDownload;
- (UIImage *)getImage;
- (UIImage *)getImageThumbnailOfSize:(CGSize)size;
- (BOOL)imageCached;

@property (nonatomic, assign) id<TJMLazyImageDelegate, NSObject> delegate;

@end
