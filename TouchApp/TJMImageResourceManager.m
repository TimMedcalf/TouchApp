//
//  TJMImageResourceManager.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMImageResourceManager.h"
#import "TJMImageResource.h"
#import "AppManager.h"

NSString *const ResourceManifestFile = @"TJMImageResourceManifest.plist";

NSInteger TwoMonths = -5184000;

@interface TJMImageResourceManager ()
- (void)loadFromFile;
- (void)saveToFile;
@end

@implementation TJMImageResourceManager

SINGLETON_IMPLEMENTATION_FOR(TJMImageResourceManager)

@synthesize imageResourceDict = _imageResourceDict;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
      [self loadFromFile];
    }
    return self;
}

- (void)dealloc
{
  [_imageResourceDict release];
  [super dealloc];
}

- (void)loadFromFile
{
  self.imageResourceDict = nil;
  NSArray *tmpArray = [[NSArray alloc] initWithContentsOfFile:[[AppManager instance].cacheFolder stringByAppendingPathComponent:ResourceManifestFile]];
  if (tmpArray)
  {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:[tmpArray count]];
    for (NSDictionary  *itemDict in tmpArray)
    {
      TJMImageResource *tmpImage = [[TJMImageResource alloc] initWithDictionary:itemDict];
      [tmpDict setObject:tmpImage forKey:[tmpImage.imageURL absoluteString]];
      [tmpImage release];
    }
    [tmpArray release];
    self.imageResourceDict = tmpDict;
    [tmpDict release];
  }
  else
  {
    self.imageResourceDict = [NSMutableDictionary dictionaryWithCapacity:10];
  }
}

- (void)save
{
  [self saveToFile];
}

- (void)saveToFile
{
  NSMutableArray *saveArray = [[NSMutableArray alloc] initWithCapacity:[self.imageResourceDict count]];
  
  for (NSString *imageKey in self.imageResourceDict)
  {
    //NSLog(@"Save %@",imageKey);
    TJMImageResource *tmpRes = [self.imageResourceDict objectForKey:imageKey];
    if ([tmpRes.lastAccessed timeIntervalSinceNow] > TwoMonths)
      //if the interval is greater than negative 2 months then they've used it in the last threee months - add it to the save list
      [saveArray addObject:[tmpRes dictionaryRepresentation]];
    else
      [tmpRes clearCachedFiles];
  }
  //now sort the array based on the last access date
//  if ([intermArray count] > 2)
//  {
//    NSLog(@"Trimming the amount of cached files...");
//    //sort the array by lastAccessed date - reverse order
//    [intermArray sortWithOptions: 0 usingComparator: ^(id inObj1, id inObj2) {
//      NSLog(@"Sorting...");
//      TJMImageResource *res1 = (TJMImageResource *)inObj1;
//      TJMImageResource *res2 = (TJMImageResource *)inObj2;
//      return [res1.lastAccessed compare: res2.lastAccessed];
//    }];
//    NSLog(@"Trimming...");
//    for (int i = 0; i < [intermArray count] - 2; i++)
//    {
//      TJMImageResource *tmpRes = [intermArray objectAtIndex:i];
//      [tmpRes clearCachedFiles];
//    }
//    [intermArray removeObjectsInRange:NSMakeRange(0, [intermArray count] - 2)];
//  }
  NSLog(@"Saving %i **********", [saveArray count]);
//  NSMutableArray *saveArray = [[NSMutableArray alloc] initWithCapacity:[intermArray count]];
//  for (TJMImageResource *image in intermArray)
//  {
//    [saveArray addObject:[image dictionaryRepresentation]];
//  }
//  [intermArray release];  
  [saveArray writeToFile:[[AppManager instance].cacheFolder stringByAppendingPathComponent:ResourceManifestFile] atomically:YES];
  [saveArray release];
}

- (TJMImageResource *)resourceForURL:(NSURL *)imageURL
{
  //find the resource from the URL
  //NSLog(@"Number of image resources %i", [self.imageResourceDict count]);
  TJMImageResource *resource = [self.imageResourceDict objectForKey:[imageURL absoluteString]];
  //did we get one?
  if (!resource)
  {
    resource = [[[TJMImageResource alloc] initWithURL:imageURL] autorelease];
    [self.imageResourceDict setObject:resource forKey:[resource.imageURL absoluteString]];
    //[self saveToFile];
  }

  return resource;
}

@end
