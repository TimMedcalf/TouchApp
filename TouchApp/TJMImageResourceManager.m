//
//  TJMImageResourceManager.m
//  TouchApp
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMImageResourceManager.h"
#import "TCHAppManager.h"
#import "TJMImageResource.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const ResourceManifestFile = @"TJMImageResourceManifest.plist";
#pragma clang diagnostic pop

NSInteger TwoMonths = -5184000;


@interface TJMImageResourceManager ()

- (void)loadFromFile;
- (void)saveToFile;

@end


@implementation TJMImageResourceManager

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialization code here.
      [self loadFromFile];
    }
    return self;
}

+ (instancetype)sharedInstance {
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (void)loadFromFile {
  self.imageResourceDict = nil;
  NSArray *tmpArray = [[NSArray alloc] initWithContentsOfFile:[[TCHAppManager sharedInstance].cacheFolder stringByAppendingPathComponent:ResourceManifestFile]];
  if (tmpArray) {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:tmpArray.count];
    for (NSDictionary  *itemDict in tmpArray) {
      TJMImageResource *tmpImage = [[TJMImageResource alloc] initWithDictionary:itemDict];
      tmpDict[(tmpImage.imageURL).absoluteString] = tmpImage;
    }
    self.imageResourceDict = tmpDict;
  } else {
    self.imageResourceDict = [NSMutableDictionary dictionaryWithCapacity:10];
  }
}

- (void)save {
  [self saveToFile];
}

- (void)saveToFile {
  NSMutableArray *saveArray = [[NSMutableArray alloc] initWithCapacity:(self.imageResourceDict).count];
  
  for (NSString *imageKey in self.imageResourceDict) {
    NSLog(@"Save %@",imageKey);
    TJMImageResource *tmpRes = (self.imageResourceDict)[imageKey];
    if ((tmpRes.lastAccessed).timeIntervalSinceNow > TwoMonths) {
      //if the interval is greater than negative 2 months then they've used it in the last two months - add it to the save list
      [saveArray addObject:[tmpRes dictionaryRepresentation]];
    } else {
      [tmpRes clearCachedFiles];
    }
  }
  [saveArray writeToFile:[[TCHAppManager sharedInstance].cacheFolder stringByAppendingPathComponent:ResourceManifestFile] atomically:YES];
}

- (TJMImageResource *)resourceForURL:(NSURL *)imageURL {
  //find the resource from the URL
  //DDLogDebug(@"Number of image resources %lu", (unsigned long)[self.imageResourceDict count]);
  TJMImageResource *resource = nil;
  if (imageURL) {
    resource = (self.imageResourceDict)[imageURL.absoluteString];
    //did we get one?
    if (!resource) {
      resource = [[TJMImageResource alloc] initWithURL:imageURL];
      (self.imageResourceDict)[(resource.imageURL).absoluteString] = resource;
      //[self saveToFile];
    }
  }

  return resource;
}

@end
