
#import <UIKit/UIKit.h>
#import "TJMAudioToggleViewController.h"


@interface HTMLItemViewController : TJMAudioToggleViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIWebView *webView;
//load from a string
@property (copy, nonatomic) NSString *HTMLString;

@end
