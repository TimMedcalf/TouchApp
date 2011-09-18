//
//  ViewWebsiteViewController.m
//  Habitat Fitted Kitchens
//
//  Created by Tim Medcalf on 01/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "NewCatalogueItemViewController.h"

@implementation NewCatalogueItemViewController

@synthesize item = _item;

- (void)viewDidLoad
{
  [super viewDidLoad];
//  if (([MFMailComposeViewController canSendMail]) && (self.recipeItem)) {
//    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendRecipe)];
//    button.enabled = YES;
//    self.navigationItem.rightBarButtonItem = button;
//    [button release];
//  }
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

- (void)pause {
    [[TJMAudioCenter instance] pauseURL:[NSURL URLWithString:self.item.mp3SampleURL]];
}

- (void)play {
    [[TJMAudioCenter instance] playURL:[NSURL URLWithString:self.item.mp3SampleURL]];
}

- (void)togglePlayPauseInWebView {
    TJMAudioStatus audio = [[TJMAudioCenter instance] statusCheckForURL:[NSURL URLWithString:self.item.mp3SampleURL]];
    
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
  [_item release];
  [super dealloc];
}

@end
