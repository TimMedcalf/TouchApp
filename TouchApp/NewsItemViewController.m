//
//  NewsItemViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 17/10/2012.
//  Copyright (c) 2012 ErgoThis Ltd. All rights reserved.
//

#import "NewsItemViewController.h"

@interface NewsItemViewController ()

@end

@implementation NewsItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_news"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
