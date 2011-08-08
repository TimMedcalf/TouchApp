//
//  ViewWebsiteViewController.m
//  Habitat Fitted Kitchens
//
//  Created by Tim Medcalf on 01/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "WebsiteViewController.h"
#import "UIApplication+TJMNetworkActivity.h"


@interface WebsiteViewController ()
@property (nonatomic, retain) NSTimer *barTimer;
@property (nonatomic, retain) NSTimer *barTapTimer;
- (void)singleTapGesture:(UITapGestureRecognizer *)tapGesture;
- (void)navBackButtonTouched:(id)sender;
- (void)navForwarButtonTouched:(id)sender;
@end

@implementation WebsiteViewController

@synthesize webView = _webView;
@synthesize barTimer = _barTimer;
@synthesize barTapTimer = _barTapTimer;
@synthesize segmentControl = _segmentControl;
@synthesize initialURL = _initialURL;
@synthesize HTMLString = _HTMLString;
@synthesize openLinksInNewView = _openLinksInNewView;
@synthesize dontHideNavigationBar = _dontHideNavigationBar;
@synthesize baseURL = _baseURL;
@synthesize pageTitle = _pageTitle;
@synthesize freshersMode = _fresherMode;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
//  if (self.openLinksInNewView)
//  {
//    UIView *tableBackground;
//    if (self.freshersMode)
//      tableBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Freshers-Guide-Background.jpg"]];
//    else
//      tableBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_background_notoolbar.jpg"]];
//      
//    [self.view insertSubview:tableBackground atIndex:0];
//    [tableBackground release]; tableBackground = nil;
//    self.webView.backgroundColor = [UIColor clearColor];
//  }
//  else
//  {
//    self.webView.backgroundColor = [UIColor blackColor];
//  }
  self.webView.backgroundColor = [UIColor whiteColor];
  
  self.webView.delegate = self;

  [self.webView setOpaque:NO];
  self.webView.scalesPageToFit = YES;
	self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  
  //single tap gesture to toggle navigation bar display
  UITapGestureRecognizer *sgltapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
  sgltapGesture.delegate = self;
  [self.webView addGestureRecognizer:sgltapGesture];
  [sgltapGesture release]; sgltapGesture = nil;
  
  self.navigationItem.title = @"";
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
  
  self.navigationItem.backBarButtonItem = backButton;   // Affect child view controller’s back button.
  [backButton release];  
  
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                          [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"Arrow-Left.png"],
                                           [UIImage imageNamed:@"Arrow-Right.png"],
                                           nil]];
  
  [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
  segmentedControl.frame = CGRectMake(0, 0, 70, 30);
  segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  segmentedControl.momentary = YES;
  
  //defaultTintColor = [segmentedControl.tintColor retain];    // keep track of this for later
  
  UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
  self.segmentControl = segmentedControl;
  self.navigationItem.rightBarButtonItem = segmentBarItem;
  [segmentBarItem release];
  [segmentedControl release];
  [self.segmentControl setEnabled:NO forSegmentAtIndex:0];
  [self.segmentControl setEnabled:NO forSegmentAtIndex:1];
}

-(void)viewWillAppear:(BOOL)animated
{
  //self.navigationController.toolbarHidden = NO;
  [self.navigationController setToolbarHidden:YES animated:YES];
  self.webView.delegate = self;
  if (self.HTMLString){
    //set the baeURL to be local the for CSS loading...
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.segmentControl.hidden = YES;
    [self.webView loadHTMLString:self.HTMLString baseURL:baseURL];
  }
  else
  {
   // NSLog(@"Loading URL");
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.initialURL]]];
  }
}

- (void)segmentAction:(id)sender
{
  if ([sender selectedSegmentIndex] == 0)
  {
    [self.webView goBack];
    return;
  }
  if ([sender selectedSegmentIndex] == 1)
  {
    [self.webView goForward];
    return;
  }
  
}

-(void) timerBarHideMethod:(NSTimer *)theTimer
{
  if (!self.dontHideNavigationBar)
  {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  }
}

-(void) timerBarToggleMethod:(NSTimer *)theTimer
{
  if (!self.dontHideNavigationBar)
  {
    [self.barTimer invalidate];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    if (!self.navigationController.navigationBarHidden)
    {
      self.barTimer = [NSTimer scheduledTimerWithTimeInterval:5.00 target:self selector:@selector(timerBarHideMethod:) userInfo:nil repeats: NO];
    }
  }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Overriden to allow any orientation.
  return (!self.HTMLString);
}

#pragma mark button events
- (void)navBackButtonTouched:(id)sender
{
  [self.webView goBack];
}
- (void)navForwarButtonTouched:(id)sender
{
  [self.webView goForward];
}
  
#pragma mark Gestures
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  return YES;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tapGesture
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  //NSLog(@"tap");
  self.barTapTimer = [NSTimer scheduledTimerWithTimeInterval:0.30 target:self selector:@selector(timerBarToggleMethod:) userInfo:nil repeats: NO];
}


#pragma mark UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  //NSLog(@"Should Load");
  [self.barTapTimer invalidate];
  if ((navigationType == UIWebViewNavigationTypeLinkClicked ) & self.openLinksInNewView) 
  {
    WebsiteViewController *newWeb = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
    newWeb.initialURL = [request.URL absoluteString];
    [self.navigationController pushViewController:newWeb animated:YES];
    [newWeb release]; newWeb=nil;
    return NO;
  }
  return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
  // starting the load, show the activity indicator in the status bar
  [[UIApplication sharedApplication] tjm_pushNetworkActivity];
  self.navigationItem.rightBarButtonItem.enabled = self.webView.canGoBack;
  [self.segmentControl setEnabled:self.webView.canGoBack forSegmentAtIndex:0];
  [self.segmentControl setEnabled:self.webView.canGoForward forSegmentAtIndex:1];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  // finished loading, hide the activity indicator in the status bar
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  //self.navigationItem.rightBarButtonItem.enabled = self.webView.canGoBack;
  if (!self.dontHideNavigationBar)
  {
    self.barTimer = [NSTimer scheduledTimerWithTimeInterval:5.00 target:self selector:@selector(timerBarHideMethod:) userInfo:nil repeats: NO];
  }
  
  [self.segmentControl setEnabled:self.webView.canGoBack forSegmentAtIndex:0];
  [self.segmentControl setEnabled:self.webView.canGoForward forSegmentAtIndex:1];  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  if ([error code] != -999)
  {
    // load error, hide the activity indicator in the status bar
    if ([[error domain] isEqualToString:@"NSURLErrorDomain"])
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error - website not found." message:@"Please check that you are connected to the internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
      [alert release]; alert = nil;
      return;
    }
  }

}


- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
}


- (void)viewWillDisappear:(BOOL)animated
{
  if ( self.webView.loading ) {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
  }
  self.webView.delegate = nil;    // disconnect the delegate as the webview is hidden
  [self.barTimer invalidate];
}


- (void)viewDidUnload {
  
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  [self setWebView:nil];
  [self setSegmentControl:nil];
}

- (void)dealloc {
  [_webView release];
  [_barTimer release];
  [_barTapTimer release];
  [_segmentControl release];
  [_initialURL release];
  [_HTMLString release];
  [_baseURL release];
  [_pageTitle release];
  [super dealloc];
}


@end
