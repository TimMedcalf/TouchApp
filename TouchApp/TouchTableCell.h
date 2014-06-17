//
//  TouchTableCell.h
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define TouchTableCellTitleTag 6712
//#define TouchTableCellSubtitleTag 6713

FOUNDATION_EXPORT NSString *const TouchTableCellDefaultReuseID;
FOUNDATION_EXPORT NSString *const TouchTableCellSubtitleReuseID;


@interface TouchTableCell : UITableViewCell

- (void)configureWithTitle:(NSString *)titleString;
- (void)configureWithTitle:(NSString *)titleString subtitle:(NSString *)subtitleString;

+ (CGFloat)estimatedRowHeight;

@end
