
#import <UIKit/UIKit.h>
#import "TJMAudioToggleViewController.h"


@interface HTMLItemViewController : TJMAudioToggleViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
//load from a string
@property (strong, nonatomic) NSString *HTMLString;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSString *pageTitle;

@end
