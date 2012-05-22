
#import <UIKit/UIKit.h>
#import "TJMAudioToggleViewController.h"


@interface WebsiteViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) UISegmentedControl *segmentControl;
//load from a url
@property (nonatomic) NSString *initialURL;
//load from a string
@property (nonatomic) NSString *HTMLString;
@property (nonatomic) NSString *baseURL;
@property (nonatomic, assign) BOOL openLinksInNewView;
@property (nonatomic, assign) BOOL dontHideNavigationBar;
@property (nonatomic) NSString *pageTitle;

@end
