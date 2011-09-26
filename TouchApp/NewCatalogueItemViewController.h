
#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "CatalogueItem.h"

@interface NewCatalogueItemViewController : HTMLItemViewController <TJMAudioCenterDelegate>

@property (nonatomic, retain) CatalogueItem *item;

- (void)pause;
- (void)play;
- (void)buy;
- (void)togglePlayPauseInWebView;

@end
