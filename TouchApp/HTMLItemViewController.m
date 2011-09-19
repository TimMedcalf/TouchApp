
#import "HTMLItemViewController.h"
#import "WebsiteViewController.h"
#import "UIApplication+TJMNetworkActivity.h"


@implementation HTMLItemViewController

@synthesize webView = _webView;
@synthesize HTMLString = _HTMLString;
@synthesize baseURL = _baseURL;
@synthesize pageTitle = _pageTitle;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.webView.backgroundColor = [UIColor whiteColor];

  //remove shadow when scrolling the background of the webview
  for (UIView* subView in [self.webView subviews])
  {
    if ([subView isKindOfClass:[UIScrollView class]]) {
      for (UIView* shadowView in [subView subviews])
      {
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
  
  self.navigationItem.title = @"";
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
  
  self.navigationItem.backBarButtonItem = backButton;   // Affect child view controller’s back button.
  [backButton release];  
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  //self.navigationController.toolbarHidden = NO;
  [self.navigationController setToolbarHidden:YES animated:YES];
  self.webView.delegate = self;
  if (self.HTMLString){
    //set the baeURL to be local the for CSS loading...
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:self.HTMLString baseURL:baseURL];
  }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Overriden to allow any orientation.
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

  
#pragma mark Gestures
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
//  return YES;
//}


#pragma mark UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  //NSLog(@"Should Load");
  if (navigationType == UIWebViewNavigationTypeLinkClicked )
  {
    WebsiteViewController *newWeb = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
    newWeb.initialURL = [request.URL absoluteString];
    newWeb.dontHideNavigationBar = YES;
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  // finished loading, hide the activity indicator in the status bar
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
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
  [super viewWillDisappear:animated];
  
  if ( self.webView.loading ) {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
  }
  self.webView.delegate = nil;    // disconnect the delegate as the webview is hidden
}


- (void)viewDidUnload {
  
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  [super viewDidUnload];
  
  [self setWebView:nil];
}

- (void)dealloc {
  [_webView release];
  [_HTMLString release];
  [_baseURL release];
  [_pageTitle release];
  [super dealloc];
}


@end
