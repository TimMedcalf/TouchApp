//
//  ViewWebsiteViewController.m
//  Habitat Fitted Kitchens
//
//  Created by Tim Medcalf on 01/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeItemViewController.h"


@implementation RecipeItemViewController

@synthesize recipeItem = _recipeItem;

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (([MFMailComposeViewController canSendMail]) && (self.recipeItem)) {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendRecipe)];
    button.enabled = YES;
    self.navigationItem.rightBarButtonItem = button;
    [button release];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [super webViewDidFinishLoad:webView];
  if (self.navigationItem.rightBarButtonItem)
    self.navigationItem.rightBarButtonItem.enabled = YES;

}

- (void)sendRecipe {
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	
	NSString *subject = [NSString stringWithFormat:@"A recipe cooked up by "];
	subject = [subject stringByAppendingString:self.recipeItem.recipeTitle];
	subject = [subject stringByAppendingString:@" for Touch"];
	
	NSString *recipeHTML = [NSString stringWithFormat:@"<p id='title'><strong>"];
	recipeHTML = [recipeHTML stringByAppendingString:self.recipeItem.recipeExcerpt];
	recipeHTML = [recipeHTML stringByAppendingString:@"</strong>"];
	recipeHTML = [recipeHTML stringByAppendingString:@"<br />by "];
	recipeHTML = [recipeHTML stringByAppendingString:self.recipeItem.recipeTitle];
	recipeHTML = [recipeHTML stringByAppendingString:@"</p>"];
	recipeHTML = [recipeHTML stringByAppendingString:self.recipeItem.recipeDescription];
	
	[controller setSubject:subject];
	[controller setMessageBody:recipeHTML isHTML:YES];
	
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}



- (void)dealloc
{
  [_recipeItem release];
  [super dealloc];
}

@end