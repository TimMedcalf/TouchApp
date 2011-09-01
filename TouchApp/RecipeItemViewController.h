//
//  ViewFittedKitchensWebsiteViewController.h
//  Habitat Fitted Kitchens
//
//  Created by Tim Medcalf on 01/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebsiteViewController.h"
#import "RecipeItem.h"

@interface RecipeItemViewController : WebsiteViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) RecipeItem *recipeItem;

- (void)sendRecipe;
  
@end
