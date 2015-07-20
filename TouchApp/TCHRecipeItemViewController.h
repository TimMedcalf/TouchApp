

#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "TCHRecipeFeedItem.h"


@interface TCHRecipeItemViewController : HTMLItemViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) TCHRecipeFeedItem *recipeItem;

- (void)sendRecipe;
  
@end
