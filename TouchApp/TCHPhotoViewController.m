/*
 File: PhotoViewController.m
 Abstract: Configures and displays the paging scroll view and handles tiling and page configuration.
 Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

/*
 
 NOTE: MODIFIED BY TIM MEDCALF, tim@kadixi.com
 
 */

#import "TCHPhotoViewController.h"
#import "TCHImageScrollView.h"
#import "TJMImageResourceManager.h"
#import "TJMImageResource.h"


@interface TCHPhotoViewController ()
{
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int           firstVisiblePageIndexBeforeRotation;
    CGFloat       percentScrolledIntoFirstVisiblePage;
}

@property (nonatomic, strong) UIPopoverPresentationController *activityPopover;
@property (nonatomic, strong) UIBarButtonItem *shareItem;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger centerPhotoIndex;
- (void)setViewState;
- (void)skipToPage:(NSUInteger)page;
- (CGPoint)offsetForPageAtIndex:(NSUInteger)index;
@property (NS_NONATOMIC_IOSONLY, readonly) CGRect frameForPagingScrollView;

@end


@implementation TCHPhotoViewController

#pragma - mark View loading and unloading

- (instancetype)init {
    self = [super init];
    if (self) {
        _initialIndex = 0;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)loadView  {
    //self.wantsFullScreenLayout = YES; iOS7Change
    UIView *tmpView = [[UIView alloc] initWithFrame:self.frameForPagingScrollView];
    self.view = tmpView;
    
    // Step 1: make the outer paging scroll view
    CGRect pagingScrollViewFrame = self.frameForPagingScrollView;
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.backgroundColor = [UIColor whiteColor];
    self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView;
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.pagingScrollView.multipleTouchEnabled = YES;
    self.pagingScrollView.scrollEnabled = YES;
    self.pagingScrollView.directionalLockEnabled = YES;
    self.pagingScrollView.canCancelContentTouches = YES;
    self.pagingScrollView.delaysContentTouches = YES;
    self.pagingScrollView.clipsToBounds = YES;
    self.pagingScrollView.alwaysBounceHorizontal = YES;
    self.pagingScrollView.bounces = YES;
    self.pagingScrollView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_pagingScrollView];
    
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
    
    UINavigationBar *tmpBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.customNavigationBar = tmpBar;
    self.customNavigationBar.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    
    UINavigationItem *tmpItem = [[UINavigationItem alloc] initWithTitle:@""];
    self.customNavigationItem = tmpItem;
    (self.customNavigationBar).items = @[self.customNavigationItem];
    
    [self.view addSubview:self.customNavigationBar];
    self.customNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"702-share-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(savePhoto)];
    self.shareItem = self.customNavigationItem.rightBarButtonItem;
    self.customNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"765-arrow-left-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.customNavigationBar.tintColor = [UIColor whiteColor];
    self.customNavigationBar.barStyle = UIBarStyleBlack;
    //self.customNavigationBar.barTintColor = [UIColor redColor];
    self.customNavigationBar.translucent = YES;
    self.customNavigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleBarsNotification:) name:@"TJMPhotoViewToggleBars" object:nil];
}


- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationNone;
}

- (void)savePhoto {
    //Create an activity view controller with the profile as its activity item. APLProfile conforms to the UIActivityItemSource protocol.
    //first up, go the direct route - will be better to do it with a profile i think...but for now...
    TCHImageFeedItem *img = [self.imageList itemAtIndex:(NSUInteger)self.centerPhotoIndex];
    TJMImageResource *tmpRes = [[TJMImageResourceManager sharedInstance] resourceForURL:img.imageURL];
    UIImage *image = tmpRes.image;
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard,UIActivityTypePrint];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        //iPhone, present activity view controller as is.
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else
    {
        
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:activityViewController animated: YES completion: nil];
        
        // Get the popover presentation controller and configure it.
        self.activityPopover = [activityViewController popoverPresentationController];
        self.activityPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.activityPopover.barButtonItem = self.shareItem;
    }
}

- (void)setViewState {
    if ((self.imageList).itemCount > 1) {
        self.customNavigationItem.title = [NSString stringWithFormat:@"%i of %lu", (int)self.centerPhotoIndex+1, (unsigned long)(self.imageList).itemCount];
    } else {
        self.title = @"";
    }
    if ((self.pagingScrollView).tracking) {
        self.customNavigationBar.hidden = YES;
        //self.pagingScrollView.backgroundColor = [UIColor blackColor];
    }
}

- (void)toggleBarsNotification:(NSNotification *)notification {
    self.customNavigationBar.hidden = !self.customNavigationBar.hidden;
    //self.pagingScrollView.backgroundColor = (self.customNavigationBar.hidden) ? [UIColor blackColor] : [UIColor whiteColor];
}

- (void)goBack {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.customNavigationBar.hidden = YES;        //self.pagingScrollView.backgroundColor = [UIColor blackColor];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.delegate dismissPhotoView:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogDebug(@"ViewDidLoad - %@", NSStringFromCGRect(self.view.frame));
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewDidAppear:animated];
    self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView;
    //we use out own nav bar...
    [self tilePages];
    [self skipToPage:self.initialIndex];
}

- (void)dealloc {
    self.pagingScrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Tiling and page configuration
- (void)tilePages  {
    // Calculate which pages are visible
    CGRect visibleBounds = self.pagingScrollView.bounds;
    NSUInteger firstNeededPageIndex = (NSUInteger)floor(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    NSUInteger lastNeededPageIndex  = (NSUInteger)floor((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, (NSUInteger)0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);
    
    // Recycle no-longer-visible pages
    for (TCHImageScrollView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (NSUInteger index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            TCHImageScrollView *page = self.dequeueRecycledPage;
            if (page == nil) {
                page = [[TCHImageScrollView alloc] init];
            }
            [self configurePage:page forIndex:index];
            [self.pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }
}

- (TCHImageScrollView *)dequeueRecycledPage {
    TCHImageScrollView *page = [recycledPages anyObject];
    if (page) {
        //ARC
        //[[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (TCHImageScrollView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(TCHImageScrollView *)page forIndex:(NSUInteger)index {
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    [page displayImage:[self imageAtIndex:index]];
}

#pragma mark - ScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
    [self setViewState];
}

#pragma mark - View controller rotation methods

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskAllButUpsideDown;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
//    // place to calculate the content offset that we will need in the new orientation
//    CGFloat offset = self.pagingScrollView.contentOffset.x;
//    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
//    
//    if (offset >= 0) {
//        firstVisiblePageIndexBeforeRotation = (int)floor(offset / pageWidth);
//        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
//    } else {
//        firstVisiblePageIndexBeforeRotation = 0;
//        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
//    }
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = self.pagingScrollView.contentOffset.x;
    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = (int)floor(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // recalculate contentSize based on current orientation
    self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView;
    
    // adjust frames and configuration of each visible page
    for (TCHImageScrollView *page in visiblePages) {
        CGPoint restorePoint = page.pointToCenterAfterRotation;
        CGFloat restoreScale = page.scaleToRestoreAfterRotation;
        page.frame = [self frameForPageAtIndex:page.index];
        [page setMaxMinZoomScalesForCurrentBounds];
        [page restoreCenterPoint:restorePoint scale:restoreScale];
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    self.pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
    
    
    CGRect barFrame = self.customNavigationBar.frame;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        barFrame.size.height = 32;
        [UIView animateWithDuration:duration animations:^(void){
            self.customNavigationBar.frame = barFrame;
        }];
    } else {
        barFrame.size.height = 44;
        [UIView animateWithDuration:duration animations:^(void){
            self.customNavigationBar.frame = barFrame;
        }];
    }
}


//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    __weak __typeof__(self) weakSelf = self;
//    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        [weakSelf.delegate updateGalleryRotation];
//    }];
//}

#pragma mark -
#pragma mark  Frame calculations
//#define PADDING  10
#define PADDING  0

- (CGRect)frameForPagingScrollView {
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = self.view.bounds;
    DDLogDebug(@"frameForPageAtIndex = %@",NSStringFromCGRect(bounds));
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
    
}

- (CGSize)contentSizeForPagingScrollView {
    
    CGRect bounds = self.view.bounds;
    
    DDLogDebug(@"contentSizeForPagingScrollView = %@",NSStringFromCGRect(bounds));
    return CGSizeMake(bounds.size.width * self.imageCount, bounds.size.height);
}

#pragma mark - Image wrangling
- (TCHImageFeedItem *)imageAtIndex:(NSUInteger)index {
    
    //try to ensure the thumbnails we need are going to be there
    TCHImageFeedItem *item = [self.imageList itemAtIndex:index];
    [[[TJMImageResourceManager sharedInstance] resourceForURL:item.thumbnailURL]cacheImage];
    
    //try to ensure the thumbnails we need are going to be there
    if (index < self.imageCount -1) {
        item = [self.imageList itemAtIndex:index+1];
        [[[TJMImageResourceManager sharedInstance] resourceForURL:item.thumbnailURL]cacheImage];
    }
    
    //try to ensure the thumbnails we need are going to be there
    if (index > 0) {
        item = [self.imageList itemAtIndex:index-1];
        [[[TJMImageResourceManager sharedInstance] resourceForURL:item.thumbnailURL]cacheImage];
    }
    return [self.imageList itemAtIndex:index];
}

- (NSUInteger)imageCount {
    return (self.imageList).itemCount;
}

- (NSInteger)centerPhotoIndex {
    CGFloat pageWidth = self.pagingScrollView.frame.size.width;
    return (int)floor((self.pagingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)skipToPage:(NSUInteger)page {
    [self.pagingScrollView setContentOffset:[self offsetForPageAtIndex:page] animated:NO];
}

- (CGPoint)offsetForPageAtIndex:(NSUInteger)index {
    CGPoint offset;
    offset.x = (self.pagingScrollView.frame.size.width * index);
    offset.y = 0;
    return offset;
}

@end
