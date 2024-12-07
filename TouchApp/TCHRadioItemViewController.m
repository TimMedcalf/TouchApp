
#import "TCHRadioItemViewController.h"
//#import "Flurry.h"


@implementation TCHRadioItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TJMAudioCenter sharedInstance].delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_radio"]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [self togglePlayPauseInWebView];
    [super webViewDidFinishLoad:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"js2objc"]) {
        // remove leading / from path
        if ([[request.URL.path substringFromIndex:1] isEqualToString:@"play"]) {
            [self play];
        } else if ([[request.URL.path substringFromIndex:1] isEqualToString:@"pause"]) {
            [self pause];
        }
        
        return NO; // prevent request
    } else {
        return YES; // allow request
    }
}

- (void)togglePlayPauseInWebView {
    //DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    TJMAudioStatus audio = [[TJMAudioCenter sharedInstance] statusCheckForURL:[NSURL URLWithString:self.item.link]];
    
    if (audio == TJMAudioStatusCurrentPlaying) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"showPauseButton();"];
    } else if (audio == TJMAudioStatusCurrentPaused) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
    }
}

- (void)pause {
    [[TJMAudioCenter sharedInstance] pauseURL:[NSURL URLWithString:self.item.link]];
}

- (void)play {
//    [Flurry logEvent:@"Radio" withParameters:@{@"Played": _item.titleLabel}];
//    DDLogDebug(@"Trying to play - %@",self.item.link);
    [[TJMAudioCenter sharedInstance] setCurrentPlayingWithInfoForArtist:nil album:self.item.title andTitle:self.item.titleLabel];
    [[TJMAudioCenter sharedInstance] playURL:[NSURL URLWithString:self.item.link] withTitle:_item.titleLabel];
}

#pragma mark TJM AudioCenterDelegate
//- (void)URLDidFinish:(NSURL *)url {
//  if ([[NSURL URLWithString:self.item.link] isEqual:url])
//    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
//}

- (void)URLIsPlaying:(NSURL *)url {
//    DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if ([[NSURL URLWithString:self.item.link] isEqual:url])
        [self.webView stringByEvaluatingJavaScriptFromString:@"showPauseButton();"];
}

- (void)URLIsPaused:(NSURL *)url {
//    DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if ([[NSURL URLWithString:self.item.link] isEqual:url])
        [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
}

- (void)URLDidFail:(NSURL *)url {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:NSLocalizedString(@"Audio stream failed.", @"Audio stream failed.")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    if ([TJMAudioCenter sharedInstance].delegate == self)
        [TJMAudioCenter sharedInstance].delegate = nil;
}

@end
