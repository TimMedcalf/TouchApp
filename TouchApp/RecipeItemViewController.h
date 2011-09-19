

#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "RecipeItem.h"

@interface RecipeItemViewController : HTMLItemViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) RecipeItem *recipeItem;

- (void)sendRecipe;
  
@end
