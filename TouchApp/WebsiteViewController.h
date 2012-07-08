
#import <UIKit/UIKit.h>
#import "TJMAudioToggleViewController.h"


@interface WebsiteViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) UISegmentedControl *segmentControl;
//load from a url
@property (weak, nonatomic) NSString *initialURL;
//load from a string
@property (weak, nonatomic) NSString *HTMLString;
@property (weak, nonatomic) NSString *baseURL;
@property (nonatomic, assign) BOOL openLinksInNewView;
@property (nonatomic, assign) BOOL dontHideNavigationBar;
@property (weak, nonatomic) NSString *pageTitle;

@end
