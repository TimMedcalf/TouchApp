

#import <UIKit/UIKit.h>
#import "HTMLItemViewController.h"
#import "RecipeItem.h"

@interface RecipeItemViewController : HTMLItemViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic) RecipeItem *recipeItem;

- (void)sendRecipe;
  
@end
