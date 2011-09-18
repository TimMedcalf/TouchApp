//
//  ViewFittedKitchensWebsiteViewController.h
//  Habitat Fitted Kitchens
//
//  Created by Tim Medcalf on 01/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebsiteViewController.h"
#import "RadioItem.h"

@interface NewRadioItemViewController : WebsiteViewController

@property (nonatomic, retain) RadioItem *item;

- (void)pause;
- (void)play;
- (void)togglePlayPauseInWebView;

@end
