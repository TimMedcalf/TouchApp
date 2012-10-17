
#import "NewRadioItemViewController.h"
#import "FlurryAnalytics.h"

@implementation NewRadioItemViewController

@synthesize item = _item;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [TJMAudioCenter sharedInstance].delegate = self;
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_radio"]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));  
    [self togglePlayPauseInWebView];
    [super webViewDidFinishLoad:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] scheme] isEqualToString:@"js2objc"]) {
        // remove leading / from path
        if ([[[[request URL] path] substringFromIndex:1] isEqualToString:@"play"]) {
            [self play];
        }
        else if ([[[[request URL] path] substringFromIndex:1] isEqualToString:@"pause"]) {
            [self pause];
        }
        
        return NO; // prevent request
    } else {
        return YES; // allow request
    }
}

- (void)togglePlayPauseInWebView {
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));  
  TJMAudioStatus audio = [[TJMAudioCenter sharedInstance] statusCheckForURL:[NSURL URLWithString:self.item.link]];
  
  if (audio == TJMAudioStatusCurrentPlaying)
  {  
      [self.webView stringByEvaluatingJavaScriptFromString:@"showPauseButton();"];
  }
  else if (audio == TJMAudioStatusCurrentPaused)
  { 
      [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
  }
}

- (void)pause {
    [[TJMAudioCenter sharedInstance] pauseURL:[NSURL URLWithString:self.item.link]];
}

- (void)play {
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  [FlurryAnalytics logEvent:@"Radio" withParameters:@{@"Played": _item.titleLabel}];
  //NSLog(@"Trying to play - %@",self.item.link);
  [[TJMAudioCenter sharedInstance] playURL:[NSURL URLWithString:self.item.link]];
}

#pragma mark TJM AudioCenterDelegate 
-(void)URLDidFinish:(NSURL *)url
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));  
  if ([[NSURL URLWithString:self.item.link] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
}

-(void)URLIsPlaying:(NSURL *)url
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));  
  if ([[NSURL URLWithString:self.item.link] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPauseButton();"];
}
-(void)URLIsPaused:(NSURL *)url
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));  
  if ([[NSURL URLWithString:self.item.link] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
}

-(void)URLDidFail:(NSURL *)url
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Audio stream failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
  //ARC
	//alert autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


- (void)dealloc
{
  if ([TJMAudioCenter sharedInstance].delegate == self) 
    [TJMAudioCenter sharedInstance].delegate = nil;
}

@end
