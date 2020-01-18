
#import "TCHRecipeItemViewController.h"


@implementation TCHRecipeItemViewController

- (instancetype)init {
    self = [super init];
    if (self)  {
        self.disableAudioToggle = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (([MFMailComposeViewController canSendMail]) && (self.recipeItem)) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"730-envelope-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(sendRecipe)];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_recipes"]];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    if (self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
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
	
	//[self presentModalViewController:controller animated:YES]; iOS7Change
    [self presentViewController:controller animated:YES completion:nil];
	
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

	[self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

@end
