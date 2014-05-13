//
//  UIImage-Expanded.h
//
//  Created by Tim Medcalf on 08/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (TJM_UIImage)

+ (UIImage *)imageThumbnailWithFile:(NSString *)imageFile ofSize:(CGSize)size;
+ (UIImage *)imageThumbnailWithImage:(UIImage *)image ofSize:(CGSize)size;
+ (UIImage *)imageWithCircularMask:(UIImage *)image;
+ (UIImage *)imageWithCircularMask:(UIImage *)image ofDiameter:(NSInteger)diameter;
- (CGFloat)imageHeightForWidth:(CGFloat)width;
+ (UIImage *)imageNamed:(NSString *)name withDefault:(NSString *)defaultName;

@end
