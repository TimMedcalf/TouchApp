
#import "TCHCatalogueItemViewController.h"

@implementation TCHCatalogueItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TJMAudioCenter sharedInstance].delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_catalog"]];
}

- (void)dealloc {
    if ([TJMAudioCenter sharedInstance].delegate == self) {
        [TJMAudioCenter sharedInstance].delegate = nil;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (void)pause {
    [[TJMAudioCenter sharedInstance] pauseURL:[NSURL URLWithString:self.item.mp3SampleURL]];
}

- (void)play {
    //[Flurry logEvent:@"Catalogue" withParameters:@{@"Played": _item.title}];
    [[TJMAudioCenter sharedInstance] setCurrentPlayingWithInfoForArtist:self.item.artist album:nil andTitle:self.item.title];
    [[TJMAudioCenter sharedInstance] playURL:[NSURL URLWithString:self.item.mp3SampleURL]];
}

- (void)buy {
    //[Flurry logEvent:@"Catalogue" withParameters:@{@"BuyPressed": _item.title}];
    NSURL *buyURL = [NSURL URLWithString:self.item.itunesURL];    
    if (buyURL) {
        [[UIApplication sharedApplication] openURL:buyURL options:@{} completionHandler:nil];
    }
}

- (void)togglePlayPauseInWebView {
    TJMAudioStatus audio = [[TJMAudioCenter sharedInstance] statusCheckForURL:[NSURL URLWithString:self.item.mp3SampleURL]];
    if (audio == TJMAudioStatusCurrentPlaying) {
        [self.webView evaluateJavaScript:@"showPauseButton();" completionHandler:nil];
    } else if (audio == TJMAudioStatusCurrentPaused) {
        [self.webView evaluateJavaScript:@"showPlayButton();" completionHandler:nil];
    }
}

#pragma mark - WKWebViewNavigation Delegate Methods

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.scheme isEqualToString:@"js2objc"]) {
        // remove leading / from path
        if ([[navigationAction.request.URL.path substringFromIndex:1] isEqualToString:@"play"]) {
            [self play];
        } else if ([[navigationAction.request.URL.path substringFromIndex:1] isEqualToString:@"pause"]) {
            [self pause];
        } else if ([[navigationAction.request.URL.path substringFromIndex:1] isEqualToString:@"buy"] && (self.item.itunesURL).length != 0) {
            [self buy];
        }
        //return NO; // prevent request
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self togglePlayPauseInWebView];
    [super webView:webView didFinishNavigation:navigation];
}

#pragma mark - TJMAudioCenterDelegate methodds

//- (void)URLDidFinish:(NSURL *)url {
//  if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url])
//    [self.webView stringByEvaluatingJavaScriptFromString:@"showPlayButton();"];
//}

- (void)URLIsPlaying:(NSURL *)url {
    if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url]) {
        [self.webView evaluateJavaScript:@"showPauseButton();" completionHandler:nil];
    }
}

- (void)URLIsPaused:(NSURL *)url {
    if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url]) {
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

@end
