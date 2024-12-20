/*
 File: ImageScrollView.m
 Abstract: Centers image within the scroll view and configures image sizing and display.
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

#import "TCHImageScrollView.h"


@implementation TCHImageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

#pragma mark - Override layoutSubviews to center content
- (void)layoutSubviews  {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    imageView.frame = frameToCenter;
    DDLogDebug(@"[%@ %@] Frame = %f %f", [self class], NSStringFromSelector(_cmd), imageView.frame.size.width, imageView.frame.size.height);
}

#pragma mark - UIScrollView delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

#pragma mark - Configure scrollView to display new image (tiled or not)
- (void)displayImage:(TCHImageFeedItem *)image {
    // clear the previous imageView
    [imageView removeFromSuperview];
    imageView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    imageView = [[TJMImageResourceView alloc] initWithImageItem:image];// forSize:self.bounds.size];
    [self addSubview:imageView];
    
    //TJM Investigate this line,
    self.contentSize = (imageView.image).size;
    DDLogDebug(@"Image content size width=%f height=%f", self.contentSize.width, self.contentSize.height);
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = imageView.bounds.size;
    
    // calculate min/max zoom scale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    //         TJM was 3
    //CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    CGFloat maxScale = 5 / [UIScreen mainScreen].scale;
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

#pragma mark - Methods called during rotation to preserve the zoomScale and the visible portion of the image
// returns the center point, in image coordinate space, to try to restore after rotation.
- (CGPoint)pointToCenterAfterRotation {
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:imageView];
}

// returns the zoom scale to attempt to restore after rotation.
- (CGFloat)scaleToRestoreAfterRotation {
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset {
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoom scale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale {
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake((CGFloat) (boundsCenter.x - self.bounds.size.width / 2.0),
            (CGFloat) (boundsCenter.y - self.bounds.size.height / 2.0));
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}

- (void)toggleBars {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TJMPhotoViewToggleBars" object:nil];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	
	if (touch.tapCount == 1) {
		[self performSelector:@selector(toggleBars) withObject:nil afterDelay:.2];
	} else if (touch.tapCount == 2) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleBars) object:nil];
		//[self zoomRectWithCenter:[[touches anyObject] locationInView:self]];
	}
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    DDLogDebug(@"Scale %f",scrollView.zoomScale);
    //resize the loading spinner to account for any scaling done on the view
    imageView.spinner.transform = CGAffineTransformMakeScale(1/scrollView.zoomScale, 1/scrollView.zoomScale);
}

@end
