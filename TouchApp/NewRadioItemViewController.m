
#import "NewRadioItemViewController.h"

@implementation NewRadioItemViewController

@synthesize item = _item;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [TJMAudioCenter instance].delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
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
  NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));  
  TJMAudioStatus audio = [[TJMAudioCenter instance] statusCheckForURL:[NSURL URLWithString:self.item.link]];
  
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
    [[TJMAudioCenter instance] pauseURL:[NSURL URLWithString:self.item.link]];
}

- (void)play {
    [[TJMAudioCenter instance] playURL:[NSURL URLWithString:self.item.link]];
}

#pragma mark TJM AudioCenterDelegate 
-(void)URLDidFinish:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.link] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
}

-(void)URLIsPlaying:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.link] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPauseButton();"];
  
}
-(void)URLIsPaused:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.link] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
}

-(void)URLDidFail:(NSURL *)url
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Audio stream failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert autorelease];
}


- (void)dealloc
{
  if ([TJMAudioCenter instance].delegate == self) 
    [TJMAudioCenter instance].delegate = nil;
  [_item release];
  [super dealloc];
}

@end
