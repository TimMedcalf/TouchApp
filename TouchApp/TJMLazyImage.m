//
//  TJMLazyImage.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 06/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMLazyImage.h"
#import "TJM_UIImage.h"
#import "AppManager.h"

@interface TJMLazyImage ()
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) NSString *cachePathAndFilename;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic, retain) UIImage *thumbnail;
- (void)cacheImage;
- (void)startDownload;
- (void)cancelDownload;
@end


@implementation TJMLazyImage

@synthesize imageURL = _imageURL;
@synthesize cachePathAndFilename = _cachePathAndFilename;
@synthesize delegate = _delegate;
@synthesize activeDownload = _activeDownload;
@synthesize imageConnection = _imageConnection;
@synthesize thumbnail = _thumbnail;

#pragma mark lifecycle
- (id)initWithURL:(NSString *)imageURL andCacheFilename:(NSString *)cacheFilename
{
  if ((self = [super init]))
  {
    self.imageURL = [NSURL URLWithString:imageURL];
    //NSArray *folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    self.cachePathAndFilename = [[AppManager instance].cacheFolder stringByAppendingPathComponent:cacheFilename];
  }
  return self;
}

- (void)dealloc
{
  //NSLog(@"[%@ %@] %@", [self class], NSStringFromSelector(_cmd), self.cachePathAndFilename);
  [self cancelDownload];
  [_imageURL release];
  [_cachePathAndFilename release];
  [_thumbnail release];
  [_activeDownload release];
  [_imageConnection release];
  [super dealloc];
}

#pragma mark external facing

- (void)cancelImageDownload
{
  [self cancelDownload];
}

- (UIImage *)getImage
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  if (self.imageCached)
  {
    return [UIImage imageWithContentsOfFile:self.cachePathAndFilename];
  }
  else
  {
    [self cacheImage];
    return [UIImage imageNamed:@"placeholder.png"];
  }
}

#pragma mark external facing
- (UIImage *)getImageThumbnailOfSize:(CGSize)size;
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  if (self.imageCached)
  {
    if ((!self.thumbnail) || (self.thumbnail.size.width != size.width) || (self.thumbnail.size.height != size.height))
    {
      self.thumbnail = nil;
      NSString *file = [self.cachePathAndFilename stringByDeletingPathExtension];
      //note, thumbnails will always be saved as PNG
      NSString *thumbnailPath = [NSString stringWithFormat:@"%@%f%f.png",file,size.width,size.height];

      //does the thumbnail already exist?
      self.thumbnail = [UIImage imageWithContentsOfFile:thumbnailPath];
      if (!self.thumbnail)
      {
        //NSLog(@"Creating thumbnail");
        //NSLog(@"Creating thumbnail %@",thumbnailPath);
        //nope...create it, then return it
        self.thumbnail  = [UIImage imageThumbnailWithFile:self.cachePathAndFilename ofSize:size];
        //NSLog(@"thumbnail size width=%f height=%f",thumbnailImage.size.width,thumbnailImage.size.height);
        if ([UIScreen mainScreen].scale > 1) thumbnailPath = [NSString stringWithFormat:@"%@%f%f@2x.png",file, size.width,size.height];
        //NSLog(@"Creating thumbnail %@",thumbnailPath);
        [UIImagePNGRepresentation(self.thumbnail) writeToFile:thumbnailPath atomically:YES];
      }
    }
    return self.thumbnail;
  }
  else
  {
    [self cacheImage];
    return [UIImage imageThumbnailWithImage:[UIImage imageNamed:@"placeholder.png"] ofSize:size];
  }
}

#pragma mark helpers
- (BOOL)imageCached
{
  return [[NSFileManager defaultManager] fileExistsAtPath:self.cachePathAndFilename];
}

- (void)cacheImage
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  //first check whether we actually need to...is is already downloaded?
  if (![self imageCached]) [self startDownload];
}

#pragma mark lazyloader
- (void)startDownload
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  [[UIApplication sharedApplication] tjm_pushNetworkActivity];
  self.activeDownload = [NSMutableData data];
  NSMutableURLRequest *tmpRequest = [[NSMutableURLRequest alloc] initWithURL:self.imageURL];
  //[tmpRequest addValue:@"Sat, 30 Jul 2011 01:01:50 GMT" forHTTPHeaderField:@"If-Modified-Since"];
  
  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                           tmpRequest delegate:self];
  [tmpRequest release];
  self.imageConnection = conn;
  [conn release];
}

- (void)cancelDownload
{ 
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  if (self.activeDownload)
  {
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
  }
}

#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  // Clear the activeDownload property to allow later attempts
  self.activeDownload = nil;
  
  // Release the connection now that it's finished
  self.imageConnection = nil;
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  //NSLog(@"%i",[self.activeDownload length]);
  if (self.activeDownload)
  {
    if (![self.activeDownload writeToFile:self.cachePathAndFilename atomically:YES])
    {
      NSLog(@"Error: Couldn't write file '%@' to cache.", self.cachePathAndFilename);
    }
  }
  self.activeDownload = nil;
  
  // Release the connection now that it's finished
  self.imageConnection = nil;
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  
  // call our delegate and tell it that our icon is ready for display
  if (self.delegate) [self.delegate imageUpdated];
}











@end
