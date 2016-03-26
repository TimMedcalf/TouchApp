
#import <UIKit/UIKit.h>


@interface TCHWebsiteViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>


//load from a url
@property (copy, nonatomic) NSString *initialURL;

@property (nonatomic, assign) BOOL dontHideNavigationBar;

@end
