
#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "TCHRadioFeedItem.h"


@interface RadioItemViewController : HTMLItemViewController <TJMAudioCenterDelegate>

@property (strong, nonatomic) TCHRadioFeedItem *item;

- (void)pause;
- (void)play;
- (void)togglePlayPauseInWebView;

@end
