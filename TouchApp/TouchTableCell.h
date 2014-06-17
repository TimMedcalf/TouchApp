//
//  TouchTableCell.h
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const TouchTableCellReuseID;

@interface TouchTableCell : UITableViewCell

- (void)configureWithTitle:(NSString *)titleString;
- (void)configureWithTitle:(NSString *)titleString subtitle:(NSString *)subtitleString;

+ (CGFloat)estimatedRowHeight;
+ (CGFloat)actualRowHeightwithTitle:(NSString *)title subtitle:(NSString *)subtitle forTableWidth:(CGFloat)tableWidth;

@end
