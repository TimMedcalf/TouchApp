
#import <UIKit/UIKit.h>


@interface TCHWebsiteViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UISegmentedControl *segmentControl;
//load from a url
@property (copy, nonatomic) NSString *initialURL;
//load from a string
@property (copy, nonatomic) NSString *HTMLString;
//@property (strong, nonatomic) NSString *baseURL;
@property (nonatomic, assign) BOOL openLinksInNewView;
@property (nonatomic, assign) BOOL dontHideNavigationBar;
//@property (strong, nonatomic) NSString *pageTitle;

@end
