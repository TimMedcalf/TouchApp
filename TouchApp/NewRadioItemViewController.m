
#import "NewRadioItemViewController.h"

@implementation NewRadioItemViewController

@synthesize item = _item;

- (void)viewDidLoad
{
  [super viewDidLoad];
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

- (void)dealloc
{
  [_item release];
  [super dealloc];
}

@end
