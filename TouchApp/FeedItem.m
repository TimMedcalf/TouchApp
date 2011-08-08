//
//  FeedItem.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 25/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"
#import "TJMLazyImage.h"

NSString *const FeedItem_ImageLinkKey = @"imageLink";
NSString *const FeedItem_CachedImageNameKey = @"cachedImageName";
NSString *const FeedItem_BaseURLKey = @"baseURL";

@interface FeedItem ()
//things to override
- (void)procesSavedDictionary:(NSDictionary *)dict;
- (void)processXMLDictionary:(NSDictionary *)dict;
- (void)populateDictionary:(NSMutableDictionary *)dict;
@end

@implementation FeedItem

@synthesize delegate = _delegate;
@synthesize imageLink = _imageLink;
@synthesize cachedImageName = _cachedImageName;
@synthesize lazyImage = _lazyImage;
@synthesize baseURL = _baseURL;

@synthesize updateFlag = _updateFlag;


- (id)initWithDictionary:(NSDictionary *)dict
{
  self = [super init];
  if (self)
  {
    self.cachedImageName = [dict objectForKey:FeedItem_CachedImageNameKey];
    self.imageLink = [dict objectForKey:FeedItem_ImageLinkKey];
    self.baseURL = [dict objectForKey:FeedItem_BaseURLKey];
    [self procesSavedDictionary:dict];
  }
  return self;
}

- (id)initWithXMLDictionary:(NSDictionary *)dict andBaseURL:(NSString *)baseURL
{
  self = [super init];
  if (self)
  {
    self.baseURL = baseURL;
    [self processXMLDictionary:dict];
  }
  return self;
}

- (NSMutableDictionary *)dictionaryRepresentation
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
  if (self.imageLink) [dict setObject:self.imageLink forKey:FeedItem_ImageLinkKey];
  if (self.cachedImageName) [dict setObject:self.cachedImageName forKey:FeedItem_CachedImageNameKey];
  if (self.baseURL) [dict setObject:self.baseURL forKey:FeedItem_BaseURLKey];
  [self populateDictionary:dict];
  return dict;
}

- (void)setImageLink:(NSString *)link
{
  self.lazyImage = nil;
  if ([link length] > 0)
  {
    _imageLink = [link retain];
    if (!self.cachedImageName)
    {
      NSString *extension = [[link lastPathComponent] pathExtension];
      CFUUIDRef theUUID = CFUUIDCreate(NULL);
      CFStringRef string = CFUUIDCreateString(NULL, theUUID);
      CFRelease(theUUID);
      self.cachedImageName = [(NSString *)string autorelease];
      self.cachedImageName = [self.cachedImageName stringByAppendingPathExtension:extension];
    }
    TJMLazyImage *tmpLazy = [[TJMLazyImage alloc] initWithURL:self.imageLink andCacheFilename:self.cachedImageName];
    self.lazyImage = tmpLazy;
    [tmpLazy release]; tmpLazy = nil;
    self.lazyImage.delegate = self;
  }
}

- (void)dealloc
{
  //NSLog(@"FeedItem [%@ %@]", [self class], NSStringFromSelector(_cmd));
  //NSLog(@"Cancelling iomage download");
  self.lazyImage.delegate = nil;
  [self.lazyImage cancelImageDownload];
  [_lazyImage release];
  [_imageLink release];
  [_cachedImageName release];
  [_baseURL release];
  [super dealloc];
}

#pragma mark TJMLazyImage delegate
- (void)imageUpdated
{
  if (self.delegate) [self.delegate imageUpdated:self];
}

#pragma mark sublclass overrides
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  //override in subclass
}

- (void)processXMLDictionary:(NSDictionary *)dict
{
  //override in subclass
}

- (void)populateDictionary:(NSMutableDictionary *)dict;
{
  //override in subclass
}

- (BOOL)isEqualToItem:(FeedItem *)otherFeedItem
{
  //override in subclass
  return ([self.imageLink isEqualToString:otherFeedItem.imageLink]);
}

- (NSComparisonResult)compare:(FeedItem *)item
{
  //override in subclass if you want something different
  return NSOrderedSame;
}

- (NSString *)htmlForWebView
{
  //override in subclass
  return @"override htmlForWebView!";
}

@end
