//
//  ViewWebsiteViewController.m
//  Habitat Fitted Kitchens
//
//  Created by Tim Medcalf on 01/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHWebsiteViewController.h"
#import "UIApplication+TJMNetworkActivity.h"


@interface TCHWebsiteViewController ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSTimer *barTimer;
@property (nonatomic, strong) NSTimer *barTapTimer;

@property (nonatomic, copy) NSString *HTMLString; //load from a string

@property (nonatomic, assign) BOOL openLinksInNewView;

- (void)singleTapGesture:(UITapGestureRecognizer *)tapGesture;

@end


@implementation TCHWebsiteViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.webView.backgroundColor = [UIColor whiteColor];

  //remove shadow when scrolling the background of the webview
  for (UIView *subView in (self.webView).subviews) {
    if ([subView isKindOfClass:[UIScrollView class]]) {
      for (UIView *shadowView in subView.subviews) {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
          [shadowView setHidden:YES];
        }
      }
    }
  }  
  
  self.webView.delegate = self;

  [self.webView setOpaque:NO];
  self.webView.scalesPageToFit = YES;
	self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  
  //single tap gesture to toggle navigation bar display
  UITapGestureRecognizer *sgltapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
  sgltapGesture.delegate = self;
  [self.webView addGestureRecognizer:sgltapGesture];
  
  self.navigationItem.title = @"";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",@"Back")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
  
  self.navigationItem.backBarButtonItem = backButton;   // Affect child view controller’s back button.
  
  if (!self.openLinksInNewView) {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            @[[UIImage imageNamed:@"Arrow-Left.png"],
                                             [UIImage imageNamed:@"Arrow-Right.png"]]];
    
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 70, 30);
    //segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; iOS7Change
    segmentedControl.momentary = YES;
    
    //defaultTintColor = [segmentedControl.tintColor retain];    // keep track of this for later
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    self.segmentControl = segmentedControl;
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    [self.segmentControl setEnabled:NO forSegmentAtIndex:0];
    [self.segmentControl setEnabled:NO forSegmentAtIndex:1];
  }
}

- (void)dealloc {
    self.webView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  //self.navigationController.toolbarHidden = NO;
  [self.navigationController setToolbarHidden:YES animated:YES];
  self.webView.delegate = self;
  if (self.HTMLString) {
    //set the baeURL to be local the for CSS loading...
    NSString *path = [NSBundle mainBundle].bundlePath;
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.segmentControl.hidden = YES;
    [self.webView loadHTMLString:self.HTMLString baseURL:baseURL];
  } else {
    DDLogDebug(@"Loading URL");
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.initialURL]]];
  }
}

- (void)segmentAction:(id)sender {
  if ([sender selectedSegmentIndex] == 0) {
    [self.webView goBack];
    return;
  }
  if ([sender selectedSegmentIndex] == 1) {
    [self.webView goForward];
    return;
  }
  
}

- (void)timerBarHideMethod:(NSTimer *)theTimer {
  if (!self.dontHideNavigationBar) {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  }
}

- (void)timerBarToggleMethod:(NSTimer *)theTimer {
  if (!self.dontHideNavigationBar) {
    [self.barTimer invalidate];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    if (!self.navigationController.navigationBarHidden) {
      self.barTimer = [NSTimer scheduledTimerWithTimeInterval:5.00 target:self selector:@selector(timerBarHideMethod:) userInfo:nil repeats:NO];
    }
  }
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
   return (!self.HTMLString);
}

#pragma mark Gestures
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tapGesture {
  self.barTapTimer = [NSTimer scheduledTimerWithTimeInterval:0.30 target:self selector:@selector(timerBarToggleMethod:) userInfo:nil repeats:NO];
}

#pragma mark UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  DDLogDebug(@"Should Load");
  [self.barTapTimer invalidate];
  if ((navigationType == UIWebViewNavigationTypeLinkClicked ) & self.openLinksInNewView) {
    TCHWebsiteViewController *newWeb = [[[self class] alloc] initWithNibName:@"TCHWebsiteViewController" bundle:nil];
    newWeb.initialURL = (request.URL).absoluteString;
    newWeb.dontHideNavigationBar = YES;
    [self.navigationController pushViewController:newWeb animated:YES];
    return NO;
  }
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  // starting the load, show the activity indicator in the status bar
  [[UIApplication sharedApplication] tjm_pushNetworkActivity];
  if (!self.openLinksInNewView) {
    self.navigationItem.rightBarButtonItem.enabled = self.webView.canGoBack;
    [self.segmentControl setEnabled:self.webView.canGoBack forSegmentAtIndex:0];
    [self.segmentControl setEnabled:self.webView.canGoForward forSegmentAtIndex:1];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // finished loading, hide the activity indicator in the status bar
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  if (!self.dontHideNavigationBar) {
    self.barTimer = [NSTimer scheduledTimerWithTimeInterval:5.00 target:self selector:@selector(timerBarHideMethod:) userInfo:nil repeats:NO];
  }
  
  if (!self.openLinksInNewView) {
    [self.segmentControl setEnabled:self.webView.canGoBack forSegmentAtIndex:0];
    [self.segmentControl setEnabled:self.webView.canGoForward forSegmentAtIndex:1];
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  if (error.code != -999) {
    // load error, hide the activity indicator in the status bar
    if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error - website not found.",@"Error - website not found.")
                                                        message:NSLocalizedString(@"Please check that you are connected to the internet.",@"Please check that you are connected to the internet.")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
      [alert show];
      return;
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  if ( self.webView.loading ) {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
  }
  self.webView.delegate = nil;    // disconnect the delegate as the webView is hidden
  [self.barTimer invalidate];
}

@end
