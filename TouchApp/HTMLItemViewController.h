
#import <UIKit/UIKit.h>
#import "TJMAudioToggleViewController.h"


@interface HTMLItemViewController : TJMAudioToggleViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) IBOutlet UIWebView *webView;
//load from a string
@property (nonatomic) NSString *HTMLString;
@property (nonatomic) NSString *baseURL;
@property (nonatomic) NSString *pageTitle;

@end
