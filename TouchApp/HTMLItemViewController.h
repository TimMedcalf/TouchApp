
#import <UIKit/UIKit.h>
#import "TJMAudioToggleViewController.h"


@interface HTMLItemViewController : TJMAudioToggleViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
//load from a string
@property (weak, nonatomic) NSString *HTMLString;
@property (weak, nonatomic) NSString *baseURL;
@property (weak, nonatomic) NSString *pageTitle;

@end
