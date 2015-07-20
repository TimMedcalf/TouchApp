
#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "TCHCatalogueFeedItem.h"
#import "TJMAudioCenter.h"


@interface TCHCatalogueItemViewController : HTMLItemViewController <TJMAudioCenterDelegate>

@property (strong, nonatomic) TCHCatalogueFeedItem *item;

- (void)pause;
- (void)play;
- (void)buy;
- (void)togglePlayPauseInWebView;

@end
