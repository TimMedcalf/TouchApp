//
//  UIImage-Expanded.m
//  Preso
//
//  Created by Tim Medcalf on 08/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJM_UIImage.h"
#import "AppManager.h"

@implementation UIImage (TJM_UIImage)

//+(UIImage *)imageThumbnailWithFile:(NSString *)imageFile ofSize:(CGSize)size cached:(BOOL)cached
//{
//  //work out what the cached thumbname one would be
//  //first get the attibutes of the bundled file
//
//  NSString* file = [name stringByDeletingPathExtension];
//  NSString* extension = [name pathExtension];
//  NSError *error;    
//  NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSBundle mainBundle] pathForResource:file ofType:extension] error:&[error)];
//  
//}

+(UIImage *)imageThumbnailWithFile:(NSString *)imageFile ofSize:(CGSize)size
{
  return [UIImage imageThumbnailWithImage:[UIImage imageWithContentsOfFile:imageFile] ofSize:size];
}

+(UIImage *)imageThumbnailWithImage:(UIImage *)image ofSize:(CGSize)size
{
  //first lets work out the aspect ratio of the image required
  CGFloat desiredRatio = size.width / size.height;
  
  //the thumbnail will stretch either all of the height or the width
  CGFloat originalRatio = image.size.width / image.size.height;
  
  //if original ratio is bigger than the desired ratio then the height will be the value thats maxed.
  CGFloat initialHeight = image.size.height;
  CGFloat initialWidth = image.size.width;
  if (originalRatio > desiredRatio)
  {
    initialHeight = image.size.height;
    initialWidth = image.size.height * desiredRatio;
  }
  else if (originalRatio < desiredRatio)
  {
    initialWidth = image.size.width;
    initialHeight = image.size.width / desiredRatio;
  }
  //okay...now we've got a the size of a rect that fits inside the original image, 
  //but is the same aspect ratio of the desied thumbnail
  //so now we need to take a copy of that part of the image
  UIImage *tmpImage;
  //specify a nice rect using that size and positioning it in the middle of the image
  CGRect thumbRect = CGRectMake(((image.size.width - initialWidth) / 2)*image.scale, ((image.size.height - initialHeight) / 2)*image.scale, initialWidth*image.scale, initialHeight*image.scale);
  //NSLog(@"thumbrect x=%f y=%f w=%f h=%f",thumbRect.origin.x, thumbRect.origin.y, thumbRect.size.width,thumbRect.size.height);
  //create a copy of the image that is just that rect.
  CGImageRef thumbImage = CGImageCreateWithImageInRect(image.CGImage, thumbRect);
  //NSLog(@"image w=%f h=%f",image.size.width,image.size.height);
  //NSLog(@"image w=%ld h=%ld",CGImageGetWidth(image.CGImage),CGImageGetHeight(image.CGImage));
  tmpImage = [UIImage imageWithCGImage:thumbImage];
  //NSLog(@"w=%f h=%f",tmpImage.size.width,tmpImage.size.height);
  CGImageRelease(thumbImage);
  
  // begin an image context that will essentially "hold" our new image
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height),YES,0.0);
  // now redraw our image in a smaller rectangle.
  [tmpImage drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
  //[tmpImage release];
  // make a "copy" of the image from the current context
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}


+(UIImage *)imageWithCircularMask:(UIImage*)image
{
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  UIGraphicsBeginImageContext(image.size);
  UIBezierPath * path;
  path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,image.size.width, image.size.height)];
  
  [path setLineWidth:0];
  
  [[UIColor blackColor] set];
  [path fill];
  UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  CGImageRef maskImageRef = [maskImage CGImage];
  
  // create a bitmap graphics context the size of the image
  CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
  CGColorSpaceRelease(colorSpace);
  
  
  if (mainViewContentContext==NULL)
    return NULL;
  
  CGFloat ratio = 0;
  
  ratio = maskImage.size.width/ image.size.width;
  
  if(ratio * image.size.height < maskImage.size.height) {
    ratio = maskImage.size.height/ image.size.height;
  } 
  
  CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
  CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
  
  
  CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
  CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
  
  
  // Create CGImageRef of the main view bitmap content, and then
  // release that bitmap context
  CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
  CGContextRelease(mainViewContentContext);
  
  UIImage *theImage = [UIImage imageWithCGImage:newImage];
  
  CGImageRelease(newImage);
  
  // return the image
  return theImage;
}

+(UIImage *)imageWithCircularMask:(UIImage *)image ofDiameter:(NSInteger)diameter
{
  return [UIImage imageWithCircularMask:[UIImage imageThumbnailWithImage:image ofSize:CGSizeMake(diameter,diameter)]];
}

-(CGFloat) imageHeightForWidth:(CGFloat)width
{
  //CGFloat aspect = self.size.width / self.size.height;
  return width / (self.size.width / self.size.height);
}

+(UIImage *)imageNamed:(NSString *)name withDefault:(NSString *)defaultName
{
  UIImage *image = [UIImage imageNamed:name];
  if (!image)
    return [UIImage imageNamed:defaultName];
  else
    return image;
  
//  if ([name length] == 0) return [UIImage imageNamed:defaultName];
//  //first check if the image is in the cachefolder
//  NSString *filePath = [[AppManager instance].cacheFolder stringByAppendingPathComponent:name];
//  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//  {
//    return [UIImage imageWithContentsOfFile:filePath];
//  }
//  //if its not there, check the bundle
//  NSString* file = [name stringByDeletingPathExtension];
//  NSString* extension = [name pathExtension];
//  if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:file ofType:extension]])
//  {
//    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:extension]];
//  }
//  return [UIImage imageNamed:defaultName];
}



@end
