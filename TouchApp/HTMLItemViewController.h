
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "TJMAudioToggleViewController.h"


@interface HTMLItemViewController : TJMAudioToggleViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) WKWebView *webView;
//load from a string
@property (copy, nonatomic) NSString *HTMLString;

@end
