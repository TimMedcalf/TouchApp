
#import <UIKit/UIKit.h>
#import "TJMAudioToggleViewController.h"


@interface HTMLItemViewController : TJMAudioToggleViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
//load from a string
@property (nonatomic, retain) NSString *HTMLString;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *pageTitle;

@end
