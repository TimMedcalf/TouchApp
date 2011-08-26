//
//  RadioItemViewController.h
//  Touch320
//
//  Created by Dave Knapik on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJMAudioCenter.h"
#import "RadioItem.h"

@interface RadioItemViewController : UIViewController <TJMAudioCenterDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *radioItemView;

@property (nonatomic, retain) RadioItem *item;

- (CGRect)resizeLabelFrame:(UILabel*)label forText:(NSString*)text;

- (void)pause;
- (void)play;
- (void)showPlaying;
- (void)showPaused;
- (void)showLoading;
- (void)showStopped;

@end
