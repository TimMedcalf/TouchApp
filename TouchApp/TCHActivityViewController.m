//
//  TCHActivityViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2014.
//  Copyright (c) 2014 ErgoThis Ltd. All rights reserved.
//

#import "TCHActivityViewController.h"

@interface TCHActivityViewController ()

@end

@implementation TCHActivityViewController

//stops the status bar interferring with the custom status bar used in the image viewer
- (BOOL)prefersStatusBarHidden {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

@end
