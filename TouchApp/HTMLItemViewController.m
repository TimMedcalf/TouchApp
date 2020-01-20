
#import "HTMLItemViewController.h"
#import "TCHWebsiteViewController.h"
#import "UIApplication+TJMNetworkActivity.h"
#import "TJMAudioCenter.h"


@implementation HTMLItemViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
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
    
    [self.webView setOpaque:NO];
    
    #warning reinstate webpage scale pages to fit?
    //self.webView.scalesPageToFit = YES;
    
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.navigationItem.title = @"";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",@"Back")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    
    self.navigationItem.backBarButtonItem = backButton;   // Affect child view controller’s back button.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.webView.navigationDelegate = self;
    if (self.HTMLString) {
        //set the baseURL to be local the for CSS loading...
        NSString *path = [NSBundle mainBundle].bundlePath;
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadHTMLString:self.HTMLString baseURL:baseURL];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ( self.webView.loading ) {
        [self.webView stopLoading];
        [[UIApplication sharedApplication] tjm_popNetworkActivity];
    }
    self.webView.navigationDelegate = nil;    // disconnect the delegate as the webView is hidden
}

- (void)dealloc {
    // to avoid compiler warning from Fauxpas, i'm also setting the delegate to nil here...
    self.webView.navigationDelegate = nil;    // disconnect the delegate as the webView is hidden
    //[super dealloc];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

#pragma mark - WKWebViewNavigationDelegate methods
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // if user taps a link to load a touch radio page, trap it and do nothing
    NSString *tmpStr = navigationAction.request.URL.absoluteString;
    NSLog(@"Should Load %@",tmpStr);
    NSRange found = [tmpStr rangeOfString:@"http://www.touchradio.org.uk/"];
    if (found.location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //if user taps an mp3 link, trap it and load it in the audio center
    tmpStr = (navigationAction.request.URL).absoluteString.pathExtension.lowercaseString;
    if ([tmpStr isEqualToString:@"mp3"]) {
        [[TJMAudioCenter sharedInstance] setCurrentPlayingWithInfoForArtist:nil album:nil andTitle:nil];
        [[TJMAudioCenter sharedInstance] playURL:navigationAction.request.URL];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated ) {
        TCHWebsiteViewController *newWeb = [[TCHWebsiteViewController alloc] init];
        newWeb.initialURL = (navigationAction.request.URL).absoluteString;
        newWeb.dontHideNavigationBar = YES;
        [self.navigationController pushViewController:newWeb animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // starting the load, show the activity indicator in the status bar
    [[UIApplication sharedApplication] tjm_pushNetworkActivity];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // finished loading, hide the activity indicator in the status bar
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] tjm_popNetworkActivity];
    if (error.code != -999) {
        // load error, hide the activity indicator in the status bar
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error - website not found.",@"Error - website not found.")
                                                                           message:NSLocalizedString(@"Please check that you are connected to the internet.",@"Please check that you are connected to the internet.")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


@end
