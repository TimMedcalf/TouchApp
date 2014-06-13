
#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "CatalogueItem.h"


@interface CatalogueItemViewController : HTMLItemViewController <TJMAudioCenterDelegate>

@property (strong, nonatomic) CatalogueItem *item;

- (void)pause;
- (void)play;
- (void)buy;
- (void)togglePlayPauseInWebView;

@end
