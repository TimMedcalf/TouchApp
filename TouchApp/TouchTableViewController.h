//
//  TouchTableViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import "TJMAudioTableViewController.h"

@interface TouchTableViewController : TJMAudioTableViewController

@property (nonatomic, strong, readonly) NSDictionary *settings;

- (id)initWithSettingsDictionary:(NSDictionary *)settings;

@end
