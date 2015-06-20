//
//  TJMImageResource.m
//  TouchApp
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//
#import "TJMImageResource.h"
#import "AppManager.h"
#import "UIApplication+TJMNetworkActivity.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const TJMImageResourceImageNeedsUpdating = @"TJMImageResourceImageNeedsUpdating";
NSString *const Key_TJMImageResource_imageURL = @"imageURL";
NSString *const Key_TJMImageResource_lastModified = @"lastModified";
NSString *const Key_TJMImageResource_eTag = @"etag";
NSString *const Key_TJMImageResource_localFileName = @"localFileName";
NSString *const Key_TJMImageResource_localFileExtension = @"localFileExtension";
NSString *const Key_TJMImageResource_lastChecked = @"lastChecked";
NSString *const Key_TJMImageResource_lastAccessed = @"lastAccessed";
NSString *const Key_TJMImageResource_thumbnailPath = @"thumbnailPath";
#pragma clang diagnostic pop


@interface TJMImageResource () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSString *lastModified;
@property (strong, nonatomic) NSString *etag;
@property (strong, nonatomic) NSString *localFileName;
@property (strong, nonatomic) NSString *localFileExtension;
@property (strong, nonatomic) NSDate   *lastChecked;
@property (strong, nonatomic) NSString *thumbnailPath;
@property (strong, nonatomic) NSMutableData *activeDownload;
@property (strong, nonatomic) NSURLConnection *activeConnection;

- (void)startDownload;
//- (void)cancelDownload;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *fullPathForLocalBaseImage;

@end


@implementation TJMImageResource

#pragma mark lifecycle
- (instancetype)initWithURL:(NSURL *)imageURL {
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
        //this is a new file...we need to come up with a filename;
        self.localFileExtension = [[[self.imageURL absoluteString] lastPathComponent] pathExtension];
        CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef string = CFUUIDCreateString(kCFAllocatorDefault, theUUID);
        CFRelease(theUUID);
        self.localFileName = (__bridge NSString *)string;
        CFRelease(string);
        self.lastChecked = [NSDate distantPast];

        self.lastAccessed = [NSDate distantPast];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSString *tmpURLString = dict[Key_TJMImageResource_imageURL];
        if (tmpURLString) {
            NSURL *tmpURL = [[NSURL alloc] initWithString:tmpURLString];
            self.imageURL = tmpURL;
        }
        self.lastModified = dict[Key_TJMImageResource_lastModified];
        //NSLog(@"LM! = %@",self.lastModified);
        self.etag = dict[Key_TJMImageResource_eTag];
        //NSLog(@"Etag! = %@",self.etag);
        self.localFileName = dict[Key_TJMImageResource_localFileName];
        self.localFileExtension = dict[Key_TJMImageResource_localFileExtension];
        self.lastChecked = dict[Key_TJMImageResource_lastChecked];
        self.lastAccessed = dict[Key_TJMImageResource_lastAccessed];
        if (!self.lastAccessed) self.lastAccessed = [NSDate distantPast];
        self.thumbnailPath = dict[Key_TJMImageResource_thumbnailPath];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:7];
    if (self.imageURL) dict[Key_TJMImageResource_imageURL] = [self.imageURL absoluteString];
    if (self.lastModified) dict[Key_TJMImageResource_lastModified] = self.lastModified;
    if (self.etag) dict[Key_TJMImageResource_eTag] = self.etag;
    if (self.localFileName) dict[Key_TJMImageResource_localFileName] = self.localFileName;
    if (self.localFileExtension) dict[Key_TJMImageResource_localFileExtension] = self.localFileExtension;
    if (self.lastChecked) dict[Key_TJMImageResource_lastChecked] = self.lastChecked;
    if (self.lastAccessed) dict[Key_TJMImageResource_lastAccessed] = self.lastAccessed;
    if (self.thumbnailPath) dict[Key_TJMImageResource_thumbnailPath] = self.thumbnailPath;
    return dict;
}

#pragma mark image resourcing
- (UIImage *)getImage {
    //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if ([self imageIsDownloaded]) {
        self.lastAccessed = nil;
        self.lastAccessed = [NSDate date];
        UIImage *tmpImage = [UIImage imageWithContentsOfFile:[self fullPathForLocalBaseImage]];
        return tmpImage ?: [UIImage imageNamed:@"placeholder.png"];
    } else {
        [self cacheImage];
        return [UIImage imageNamed:@"placeholder.png"];
    }
}

- (void)clearCachedFiles {
    [[NSFileManager defaultManager] removeItemAtPath:self.thumbnailPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self fullPathForLocalBaseImage] error:nil];
}

#pragma mark helpers
- (NSString *)fullPathForLocalBaseImage {
    NSString *filename = [self.localFileName stringByAppendingPathExtension:self.localFileExtension];
    return [[AppManager  sharedInstance].cacheFolder stringByAppendingPathComponent:filename];
}

- (BOOL)imageIsDownloaded {
    return (([[NSFileManager defaultManager] fileExistsAtPath:[self fullPathForLocalBaseImage]]) &&
            ([self.lastChecked timeIntervalSinceNow] > -(3600 *24 *30)) &&
            (!self.activeDownload));
}

#pragma mark downloads
- (void)cacheImage {
    if ((![self imageIsDownloaded]) && (!self.activeDownload))
        [self startDownload];
}

- (void)startDownload {
    //kick off the download process
    [[UIApplication sharedApplication] tjm_pushNetworkActivity];
    self.activeDownload = [NSMutableData data];
    NSMutableURLRequest *tmpRequest = [[NSMutableURLRequest alloc] initWithURL:self.imageURL];
    if (self.lastModified) [tmpRequest addValue:self.lastModified forHTTPHeaderField:@"If-Modified-Since"];
    if (self.etag) [tmpRequest addValue:self.etag forHTTPHeaderField:@"If-None-Match"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:tmpRequest delegate:self];
    self.activeConnection = conn;
}

//- (void)cancelDownload {
//  [self.activeConnection cancel];
//  self.activeConnection = nil;
//  self.activeDownload = nil;
//  [[UIApplication sharedApplication] tjm_popNetworkActivity];
//}

#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //store the etag and lastModified strings if they're present
    //NSLog(@"%@",[(NSHTTPURLResponse *)response allHeaderFields]);
    self.etag = [(NSHTTPURLResponse *)response allHeaderFields][@"Etag"];
    self.lastModified = [(NSHTTPURLResponse *)response allHeaderFields][@"Last-Modified"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    // Release the connection now that it's finished
    self.activeConnection = nil;
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"[%@ %@] size of download %ul", [self class], NSStringFromSelector(_cmd), [self.activeDownload length]);
    if ((self.activeDownload) && ([self.activeDownload length] > 0)) {
        if (![self.activeDownload writeToFile:[self fullPathForLocalBaseImage] atomically:YES]) {
            NSLog(@"Error: Couldn't write file '%@' to cache.", [self fullPathForLocalBaseImage]);
        }
    }
    self.activeDownload = nil;

    // Release the connection now that it's finished
    self.activeConnection = nil;
    self.lastChecked = [NSDate date];
    [[UIApplication sharedApplication] tjm_popNetworkActivity];

    // call our delegate and tell it that our icon is ready for display
    [[NSNotificationCenter defaultCenter] postNotificationName:TJMImageResourceImageNeedsUpdating object:self];
}

@end
