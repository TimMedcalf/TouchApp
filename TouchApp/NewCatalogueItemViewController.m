
#import "NewCatalogueItemViewController.h"
#import "FlurryAnalytics.h"

@implementation NewCatalogueItemViewController

@synthesize item = _item;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [TJMAudioCenter sharedInstance].delegate = self;
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
        else if ([[[[request URL] path] substringFromIndex:1] isEqualToString:@"buy"] && [self.item.itunesURL length] != 0) {
            [self buy];
        }
        return NO; // prevent request
    } else {
        return YES; // allow request
    }
}

- (void)pause {
    [[TJMAudioCenter sharedInstance] pauseURL:[NSURL URLWithString:self.item.mp3SampleURL]];
}

- (void)play {
  [FlurryAnalytics logEvent:@"Catalogue" withParameters:[NSDictionary dictionaryWithObject:_item.title forKey:@"Played"]];
  [[TJMAudioCenter sharedInstance] playURL:[NSURL URLWithString:self.item.mp3SampleURL]];
}

- (void)buy {
    [FlurryAnalytics logEvent:@"Catalogue" withParameters:[NSDictionary dictionaryWithObject:_item.title forKey:@"BuyPressed"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item.itunesURL]];
}

- (void)togglePlayPauseInWebView {
    TJMAudioStatus audio = [[TJMAudioCenter sharedInstance] statusCheckForURL:[NSURL URLWithString:self.item.mp3SampleURL]];
    
    if (audio == TJMAudioStatusCurrentPlaying)
    {  
        [self.webView stringByEvaluatingJavaScriptFromString:@"showPauseButton();"];
    }
    else if (audio == TJMAudioStatusCurrentPaused)
    { 
        [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
    }
}

- (void)dealloc
{
  if ([TJMAudioCenter sharedInstance].delegate == self) 
    [TJMAudioCenter sharedInstance].delegate = nil;
}

#pragma mark TJM AudioCenterDelegate 
-(void)URLDidFinish:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
}

-(void)URLIsPlaying:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPauseButton();"];
  
}
-(void)URLIsPaused:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url])
    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
}

-(void)URLDidFail:(NSURL *)url
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Audio stream failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
  //ARC
	//[alert autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


@end
