
#import "HTMLItemViewController.h"
#import "WebsiteViewController.h"
#import "UIApplication+TJMNetworkActivity.h"
#import "TJMAudioCenter.h"


@implementation HTMLItemViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:self.webView];
  
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
  
  self.navigationItem.title = @"";
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
  
  self.navigationItem.backBarButtonItem = backButton;   // Affect child view controller’s back button.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  //self.navigationController.toolbarHidden = NO;
  [self.navigationController setToolbarHidden:YES animated:YES];
  self.webView.delegate = self;
  if (self.HTMLString) {
    //set the baseURL to be local the for CSS loading...
    NSString *path = [NSBundle mainBundle].bundlePath;
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:self.HTMLString baseURL:baseURL];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

#pragma mark UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  //NSLog(@"Should Load");
  // if user taps a link to load a touch radio page, trap it and do nothing
  NSString *tmpStr = (request.URL).absoluteString;
  //NSLog(@"%@",tmpStr);
  NSRange found = [tmpStr rangeOfString:@"http://www.touchradio.org.uk/"];
  if (found.location != NSNotFound) {
    return NO;
  }
  
  //if user taps an mp3 link, trap it and load it in the audio center
  tmpStr = (request.URL).absoluteString.pathExtension.lowercaseString;
  if ([tmpStr isEqualToString:@"mp3"]) {
    [[TJMAudioCenter sharedInstance] setCurrentPlayingWithInfoForArtist:nil album:nil andTitle:nil];
    [[TJMAudioCenter sharedInstance] playURL:request.URL];
    return NO;
  }
  
  if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
    WebsiteViewController *newWeb = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // finished loading, hide the activity indicator in the status bar
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [[UIApplication sharedApplication] tjm_popNetworkActivity];
  if (error.code != -999) {
    // load error, hide the activity indicator in the status bar
    if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error - website not found." message:@"Please check that you are connected to the internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
}

@end
