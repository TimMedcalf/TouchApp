//
//  NewsItemViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 17/10/2012.
//  Copyright (c) 2012 ErgoThis Ltd. All rights reserved.
//

#import "TCHNewsItemViewController.h"


@implementation TCHNewsItemViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_news"]];
}

@end
