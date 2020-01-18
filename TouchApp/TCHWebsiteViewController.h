
#import <UIKit/UIKit.h>


@interface TCHWebsiteViewController : UIViewController <WKNavigationDelegate, UIGestureRecognizerDelegate>


//load from a url
@property (copy, nonatomic) NSString *initialURL;

@property (nonatomic, assign) BOOL dontHideNavigationBar;

@end
