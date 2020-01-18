
#import "TCHRadioItemViewController.h"


@implementation TCHRadioItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TJMAudioCenter sharedInstance].delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_radio"]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [self togglePlayPauseInWebView];
    [super webView:webView didFinishNavigation:navigation];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.scheme isEqualToString:@"js2objc"]) {
        // remove leading / from path
        if ([[navigationAction.request.URL.path substringFromIndex:1] isEqualToString:@"play"]) {
            [self play];
        } else if ([[navigationAction.request.URL.path substringFromIndex:1] isEqualToString:@"pause"]) {
            [self pause];
        }
        decisionHandler(WKNavigationActionPolicyCancel); // prevent request
    } else {
        decisionHandler(WKNavigationActionPolicyAllow); // allow request
    }
}

- (void)togglePlayPauseInWebView {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    TJMAudioStatus audio = [[TJMAudioCenter sharedInstance] statusCheckForURL:[NSURL URLWithString:self.item.link]];
    
    if (audio == TJMAudioStatusCurrentPlaying) {
        [self.webView evaluateJavaScript:@"showPauseButton();" completionHandler:nil];
    } else if (audio == TJMAudioStatusCurrentPaused) {
        [self.webView evaluateJavaScript:@"showPlayButton();" completionHandler:nil];
    }
}

- (void)pause {
    [[TJMAudioCenter sharedInstance] pauseURL:[NSURL URLWithString:self.item.link]];
}

- (void)play {
    NSLog(@"Trying to play - %@",self.item.link);
    [[TJMAudioCenter sharedInstance] setCurrentPlayingWithInfoForArtist:nil album:self.item.title andTitle:self.item.titleLabel];
    [[TJMAudioCenter sharedInstance] playURL:[NSURL URLWithString:self.item.link] withTitle:_item.titleLabel];
}

#pragma mark TJM AudioCenterDelegate

- (void)URLIsPlaying:(NSURL *)url {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if ([[NSURL URLWithString:self.item.link] isEqual:url]) {
        [self.webView evaluateJavaScript:@"showPauseButton();" completionHandler:nil];
    }
}

- (void)URLIsPaused:(NSURL *)url {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if ([[NSURL URLWithString:self.item.link] isEqual:url]) {
         [self.webView evaluateJavaScript:@"showPlayButton();" completionHandler:nil];
    }
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
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    if ([TJMAudioCenter sharedInstance].delegate == self)
        [TJMAudioCenter sharedInstance].delegate = nil;
}

@end
