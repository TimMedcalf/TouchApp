

#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "RecipeItem.h"

@interface RecipeItemViewController : HTMLItemViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) RecipeItem *recipeItem;

- (void)sendRecipe;
  
@end
