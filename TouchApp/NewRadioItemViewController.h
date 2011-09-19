
#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "RadioItem.h"

@interface NewRadioItemViewController : HTMLItemViewController

@property (nonatomic, retain) RadioItem *item;

- (void)pause;
- (void)play;
- (void)togglePlayPauseInWebView;

@end
