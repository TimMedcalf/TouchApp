#import "TJMAudioCenter.h"
#import "HTMLItemViewController.h"
#import "TCHRadioFeedItem.h"


@interface TCHRadioItemViewController : HTMLItemViewController <TJMAudioCenterDelegate>

@property (strong, nonatomic) TCHRadioFeedItem *item;

- (void)pause;
- (void)play;
- (void)togglePlayPauseInWebView;

@end
