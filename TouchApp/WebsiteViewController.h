//
//  ViewFittedKitchensWebsiteViewController.h
//  Habitat Fitted Kitchens
//
//  Created by Tim Medcalf on 01/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebsiteViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;
//load from a url
@property (nonatomic, retain) NSString *initialURL;
//load from a string
@property (nonatomic, retain) NSString *HTMLString;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, assign) BOOL openLinksInNewView;
@property (nonatomic, assign) BOOL dontHideNavigationBar;
@property (nonatomic, retain) NSString *pageTitle;
  
@end
