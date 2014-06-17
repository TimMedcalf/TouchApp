//
//  TouchTableCell.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//


NSString *const TouchTableCellReuseID = @"TouchTableCellReuseID";

#import "TouchTableCell.h"


@interface TouchTableCell ()

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *subtitleString;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *disclosure;

@end


@implementation TouchTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  //touch cells can only handle the default and subtitle styles
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    //background colors
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *selView = [[UIView alloc] initWithFrame:self.bounds];
    //selected state
    selView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    selView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    self.selectedBackgroundView = selView;
    //accessory
    [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go"]]];
    //initial config of the title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIFont fontWithName:@"Helvetica" size:21] : [UIFont fontWithName:@"Helvetica" size:14];
    [self.contentView addSubview:self.titleLabel];

    //initial config of the subtitle (whether we show it or not)
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subtitleLabel.contentMode = UIViewContentModeCenter;
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.subtitleLabel.numberOfLines = 1;
    self.subtitleLabel.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIFont fontWithName:@"Helvetica-Bold" size:15] : [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [self.contentView addSubview:self.subtitleLabel];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark class methods
+ (CGFloat)estimatedRowHeight {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 81 : 58;
}

- (void)setTitleString:(NSString *)titleString {
  _titleString = titleString;
  self.titleLabel.text = self.titleString;
}

- (void)setSubtitleString:(NSString *)subtitleString {
  _subtitleString = subtitleString;
  self.subtitleLabel.text = self.subtitleString;
}

- (void)configureWithTitle:(NSString *)titleString subtitle:(NSString *)subtitleString {
  self.titleString = titleString;
  self.subtitleString = subtitleString;
  [self setNeedsLayout];
}

- (void)configureWithTitle:(NSString *)titleString {
  [self configureWithTitle:titleString subtitle:nil];
}


- (void)prepareForReuse {
  [self configureWithTitle:nil];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  //store an inset value that's different for each device
  CGFloat titleInsetXVal = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 50 : 17;

  //work out the usable width
  CGFloat titleWidth = self.contentView.frame.size.width - (titleInsetXVal * 2);
  //now work out the height the label needs to be
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
  NSDictionary *attributes = @{NSFontAttributeName: self.titleLabel.font, NSParagraphStyleAttributeName : paragraphStyle};
  CGRect titleRect = [self.titleString boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
  if (self.subtitleString) {
    //title AND subtitle
    [self.subtitleLabel setHidden:false];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      //iPad
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 17, self.contentView.frame.size.width - (titleInsetXVal * 2), titleRect.size.height);
      self.subtitleLabel.frame = CGRectMake(titleInsetXVal, CGRectGetMaxY(self.titleLabel.frame), self.frame.size.width - (titleInsetXVal * 2), 22);
    } else {
      //iPhone
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 16, self.contentView.frame.size.width - (titleInsetXVal * 2), titleRect.size.height);
      self.subtitleLabel.frame = CGRectMake(titleInsetXVal, CGRectGetMaxY(self.titleLabel.frame), self.frame.size.width - (titleInsetXVal * 2), 15);
    }
  } else {
    [self.subtitleLabel setHidden:true];
    //just title
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      //iPad
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 26, self.contentView.frame.size.width - (titleInsetXVal * 2),  titleRect.size.height);
    } else {
      //iPhone
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 22, self.contentView.frame.size.width - (titleInsetXVal * 2),  titleRect.size.height);
    }
  }
}



@end
