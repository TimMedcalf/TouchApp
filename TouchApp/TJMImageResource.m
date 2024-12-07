//
//  TJMImageResource.m
//  TouchApp
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//
#import "TJMImageResource.h"
#import "TCHAppManager.h"
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


@interface TJMImageResource () <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (strong, nonatomic) NSString *lastModified;
@property (strong, nonatomic) NSString *etag;
@property (strong, nonatomic) NSString *localFileName;
@property (strong, nonatomic) NSString *localFileExtension;
@property (strong, nonatomic) NSDate   *lastChecked;
@property (strong, nonatomic) NSString *thumbnailPath;

//@property (strong, nonatomic) NSMutableData *activeDownload;
//@property (strong, nonatomic) NSURLConnection *activeConnection;
@property (strong, nonatomic) NSURLSessionDownloadTask *activeDownloadTask;
@property (strong, nonatomic) NSURLSession *urlSession;

- (void)startDownload;
//- (void)cancelDownload;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *fullPathForLocalBaseImage;

@end


@implementation TJMImageResource

#pragma mark lifecycle
- (instancetype)initWithURL:(NSURL *)imageURL {
    self = [super init];
    if (self) {
        _imageURL = imageURL;
        //this is a new file...we need to come up with a filename;
        _localFileExtension = (self.imageURL).absoluteString.lastPathComponent.pathExtension;
        CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef string = CFUUIDCreateString(kCFAllocatorDefault, theUUID);
        CFRelease(theUUID);
        _localFileName = (__bridge NSString *)string;
        CFRelease(string);
        _lastChecked = [NSDate distantPast];

        _lastAccessed = [NSDate distantPast];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSString *tmpURLString = dict[Key_TJMImageResource_imageURL];
        if (tmpURLString) {
            NSURL *tmpURL = [[NSURL alloc] initWithString:tmpURLString];
            _imageURL = tmpURL;
        }
        _lastModified = dict[Key_TJMImageResource_lastModified];
//        DDLogDebug(@"LM! = %@",self.lastModified);
        _etag = dict[Key_TJMImageResource_eTag];
//        DDLogDebug(@"Etag! = %@",self.etag);
        _localFileName = dict[Key_TJMImageResource_localFileName];
        _localFileExtension = dict[Key_TJMImageResource_localFileExtension];
        _lastChecked = dict[Key_TJMImageResource_lastChecked];
        _lastAccessed = dict[Key_TJMImageResource_lastAccessed];
        if (!_lastAccessed) _lastAccessed = [NSDate distantPast];
        _thumbnailPath = dict[Key_TJMImageResource_thumbnailPath];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:7];
    if (self.imageURL) dict[Key_TJMImageResource_imageURL] = (self.imageURL).absoluteString;
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
- (UIImage *)image {
    //DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if (self.imageIsDownloaded) {
        self.lastAccessed = nil;
        self.lastAccessed = [NSDate date];
        UIImage *tmpImage = [UIImage imageWithContentsOfFile:self.fullPathForLocalBaseImage];
        return tmpImage ?: [UIImage imageNamed:@"placeholder.png"];
    } else {
        [self cacheImage];
        return [UIImage imageNamed:@"placeholder.png"];
    }
}

- (void)clearCachedFiles {
    [[NSFileManager defaultManager] removeItemAtPath:self.thumbnailPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.fullPathForLocalBaseImage error:nil];
}

#pragma mark helpers
- (NSString *)fullPathForLocalBaseImage {
    NSString *filename = [self.localFileName stringByAppendingPathExtension:self.localFileExtension];
    return [[TCHAppManager  sharedInstance].cacheFolder stringByAppendingPathComponent:filename];
}

- (BOOL)imageIsDownloaded {
    return (([[NSFileManager defaultManager] fileExistsAtPath:self.fullPathForLocalBaseImage]) &&
            ((self.lastChecked).timeIntervalSinceNow > -(3600 *24 *30)) &&
            (!self.activeDownloadTask));
}

#pragma mark downloads
- (void)cacheImage {
    if ((!self.imageIsDownloaded) && (!self.activeDownloadTask))
        [self startDownload];
}

- (void)startDownload {
    
    if (self.activeDownloadTask) {
        return;
    }
    
    [[UIApplication sharedApplication] tjm_pushNetworkActivity];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSMutableURLRequest *tmpRequest = [[NSMutableURLRequest alloc] initWithURL:self.imageURL];
    
    if (self.etag) {
        [tmpRequest addValue:self.etag forHTTPHeaderField:@"If-None-Match"];
    }
    if (self.lastModified) {
        [tmpRequest addValue:self.lastModified forHTTPHeaderField:@"If-Modified-Since"];
    }
    
    self.activeDownloadTask = [self.urlSession downloadTaskWithRequest:tmpRequest];
    
    [self.activeDownloadTask resume];

}


#pragma mark Download support (NSURLConnectionDelegate)

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    self.activeDownloadTask = nil;
    [[UIApplication sharedApplication] tjm_popNetworkActivity];

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //DDLogDebug(@"[%@ %@] didFinish",[self class], NSStringFromSelector(_cmd));
    
    //load the data
    NSData *downloadedData = [NSData dataWithContentsOfURL:location];
    //write it to the permananent place
    if (![downloadedData writeToFile:self.fullPathForLocalBaseImage atomically:YES]) {
        //DDLogError(@"Error: Couldn't write file '%@' to cache.", self.fullPathForLocalBaseImage);
    }
    
    self.lastChecked = [NSDate date];
    
    //extract the infos
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)downloadTask.response;
    //DDLogDebug(@"%@",[response allHeaderFields]);
    self.etag = response.allHeaderFields[@"Etag"];
    self.lastModified = response.allHeaderFields[@"Last-Modified"];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //tell delegate we've updated...
        // call our delegate and tell it that our icon is ready for display
        [[NSNotificationCenter defaultCenter] postNotificationName:TJMImageResourceImageNeedsUpdating object:self];
    });
}

@end
