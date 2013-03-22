//
//  TouchTableCell.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//


NSString * const TouchTableCellDefaultReuseID = @"TouchTableCellDefaultReuseID";
NSString * const TouchTableCellSubtitleReuseID = @"TouchTableCellSubtitleReuseID";

#import "TouchTableCell.h"

@interface TouchTableCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *disclosure;
@end

@implementation TouchTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  //touch cells can only handle the default and subtitle styles
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.titleLabel = [[UILabel alloc] init];
    self.disclosure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go"]];
    self.disclosure.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *selView = [[UIView alloc] initWithFrame:self.bounds];
    selView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    selView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    self.selectedBackgroundView = selView;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.contentMode = UIViewContentModeCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIFont fontWithName:@"Helvetica" size:21] : [UIFont fontWithName:@"Helvetica" size:14];
    self.titleLabel.numberOfLines = 1;
    
    if (style == UITableViewCellStyleSubtitle) {
      self.subtitleLabel = [[UILabel alloc] init];
      self.subtitleLabel.textColor = [UIColor grayColor];
      self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
      self.subtitleLabel.contentMode = UIViewContentModeCenter;
      self.subtitleLabel.backgroundColor = [UIColor clearColor];
      self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
      self.subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      self.subtitleLabel.numberOfLines = 1;

      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        self.titleLabel.frame = CGRectMake(50,17,self.frame.size.width-195,25);
        self.subtitleLabel.frame = CGRectMake(50,42,self.frame.size.width-195,22);
        self.subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.disclosure.frame = CGRectMake(self.frame.size.width-95, 16, 45, 45);
      } else {
        //iPhone
        self.titleLabel.frame = CGRectMake(17,16,self.frame.size.width-81,15);
        self.subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.subtitleLabel.frame = CGRectMake(17,31,self.frame.size.width-81,15);
        self.subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        self.disclosure.frame = CGRectMake(self.frame.size.width-47, 14, 30, 30);
      }
    } else {
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad
        self.titleLabel.frame = CGRectMake(50,26,self.frame.size.width-195,25);
        self.disclosure.frame = CGRectMake(self.frame.size.width-95, 16, 45, 45);
      } else {
        //iPhone
        self.titleLabel.frame = CGRectMake(17,22,self.frame.size.width-81,15);
        self.disclosure.frame = CGRectMake(self.frame.size.width-47, 14, 30, 30);
      }
    }
    [self.contentView addSubview:self.titleLabel];
    if (self.subtitleLabel) [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.disclosure];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
