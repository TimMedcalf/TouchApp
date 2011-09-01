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

#import "PhotoViewController.h"
#import "ImageScrollView.h"
#import "ImageList.h"
#import "ImageItem.h"
#import "TJMImageResourceManager.h"

@interface PhotoViewController ()

//methods to force view dimensions to landscape
//useful because we know we're in landscape but the device
//won't have updated some stuff by the time we need it.
- (CGRect)forceRectLandscape:(CGRect)rect;
- (CGSize)forceSizeLandscape:(CGSize)size;
@end

@implementation PhotoViewController

@synthesize imageList = _imageList;
@synthesize initialIndex = initialIndex;
@synthesize pagingScrollView = _pagingScrollView;

#pragma mark -
#pragma mark View loading and unloading

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
  }
  self.hidesBottomBarWhenPushed = YES;
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  //[super viewWillAppear:NO];
  //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePhoto)] autorelease]; 
	
	self.view.backgroundColor = [UIColor blackColor];
  self.hidesBottomBarWhenPushed = YES;
  self.navigationController.navigationBar.tintColor = nil;
  self.navigationController.navigationBar.barStyle  = UIBarStyleBlack;
  self.navigationController.navigationBar.translucent = YES;
  //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
  
	self.wantsFullScreenLayout = YES;
	
  //self.pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  self.pagingScrollView.delegate=self;
  self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
  self.pagingScrollView.multipleTouchEnabled=YES;
  self.pagingScrollView.scrollEnabled=YES;
  self.pagingScrollView.directionalLockEnabled=YES;
  self.pagingScrollView.canCancelContentTouches=YES;
  self.pagingScrollView.delaysContentTouches=YES;
  self.pagingScrollView.clipsToBounds=YES;
  self.pagingScrollView.alwaysBounceHorizontal=YES;
  self.pagingScrollView.bounces=YES;
  self.pagingScrollView.pagingEnabled=YES;
  self.pagingScrollView.showsVerticalScrollIndicator=NO;
  self.pagingScrollView.showsHorizontalScrollIndicator=NO;
  self.pagingScrollView.backgroundColor = self.view.backgroundColor;
  self.pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
  recycledPages = [[NSMutableSet alloc] init];
  visiblePages  = [[NSMutableSet alloc] init];
  [self tilePages];
}

- (void)savePhoto {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                initWithTitle:nil
                                delegate:self 
                                cancelButtonTitle:@"Cancel" 
                                destructiveButtonTitle:@"Save to Camera Roll" 
                                otherButtonTitles:nil]; 
  [actionSheet showInView:self.view]; 
  [actionSheet release]; 
	
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [actionSheet cancelButtonIndex]) { 
    //UIImage *image = current.image;
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
  } 
}



- (void)viewDidUnload
{
  [super viewDidUnload];
  [_pagingScrollView release];
  _pagingScrollView = nil;
  [recycledPages release];
  recycledPages = nil;
  [visiblePages release];
  visiblePages = nil;
}

- (void)dealloc
{
  [_pagingScrollView release];
  [_imageList release];
  [super dealloc];
}


#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);
    
    // Recycle no-longer-visible pages 
    for (ImageScrollView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [self.pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }  
}

- (ImageScrollView *)dequeueRecycledPage
{
    ImageScrollView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (ImageScrollView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(ImageScrollView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    
    [page displayImage:[self imageAtIndex:index]];
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

#pragma mark -
#pragma mark View controller rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = self.pagingScrollView.contentOffset.x;
    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // recalculate contentSize based on current orientation
    self.pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    // adjust frames and configuration of each visible page
    for (ImageScrollView *page in visiblePages) {
        CGPoint restorePoint = [page pointToCenterAfterRotation];
        CGFloat restoreScale = [page scaleToRestoreAfterRotation];
        page.frame = [self frameForPageAtIndex:page.index];
        [page setMaxMinZoomScalesForCurrentBounds];
        [page restoreCenterPoint:restorePoint scale:restoreScale];
        
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    self.pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}

#pragma mark -
#pragma mark  Frame calculations
//#define PADDING  10
#define PADDING  0


- (CGRect)frameForPageAtIndex:(NSUInteger)index {
  CGRect pageFrame = [self forceRectLandscape:self.pagingScrollView.bounds];
  pageFrame.size.width -= (2 * PADDING);
  pageFrame.origin.x = (pageFrame.size.width * index) + PADDING;
  //
  pageFrame.origin.y = 0;
  //
  //NSLog(@"frameForPageAtIndex x=%f y=%f width=%f height=%f",pageFrame.origin.x, pageFrame.origin.y,pageFrame.size.width, pageFrame.size.height);
  return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
  CGRect bounds = [self forceRectLandscape:self.pagingScrollView.bounds];
  //NSLog(@"content size width=%f height=%f",bounds.size.width, bounds.size.height);
  return CGSizeMake(bounds.size.width * [self imageCount], bounds.size.height);
}


#pragma mark -
#pragma mark Image wrangling


- (ImageItem *)imageAtIndex:(NSUInteger)index {
  return [self.imageList.items objectAtIndex:index];
}


- (NSUInteger)imageCount {
  return [self.imageList.items count];
}

- (CGRect)forceRectLandscape:(CGRect)rect
{
  CGFloat width = MAX(rect.size.width, rect.size.height);
  CGFloat height = MIN(rect.size.width, rect.size.height);
  return CGRectMake(rect.origin.x, rect.origin.y,width,height);
}

- (CGSize)forceSizeLandscape:(CGSize)size
{
  CGFloat width = MAX(size.width, size.height);
  CGFloat height = MIN(size.width, size.height);
  return CGSizeMake(width, height);
}



@end
