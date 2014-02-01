
#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "RadioItem.h"


@interface NewRadioItemViewController : HTMLItemViewController <TJMAudioCenterDelegate>

@property (strong, nonatomic) RadioItem *item;

- (void)pause;
- (void)play;
- (void)togglePlayPauseInWebView;

@end
