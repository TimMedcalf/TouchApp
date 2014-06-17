//
//  TouchTableCell.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//


NSString *const TouchTableCellReuseID = @"TouchTableCellReuseID";

#import "TouchTableCell.h"

static const CGFloat kAccessoryInset = 15.;

@interface TouchTableCell ()
+ (CGFloat)verticalPadding;
+ (CGFloat)horizontalPadding;
+ (UIImage *)accessoryImage;
+ (CGSize)accessorySize;

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *subtitleString;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *disclosure;

@end


@implementation TouchTableCell

#pragma mark - class methods

#pragma mark private
+ (CGFloat)horizontalPadding {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 50 : 17;
}

+ (CGFloat)verticalPadding {
  return 14;
}

+ (UIImage *)accessoryImage {
  return [UIImage imageNamed:@"go"];
}

+ (CGSize)accessorySize {
  return [TouchTableCell accessoryImage].size;
}

+ (UIFont *)titleFont {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIFont fontWithName:@"Helvetica" size:21] : [UIFont fontWithName:@"Helvetica" size:14];
}

+ (UIFont *)subtitleFont {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIFont fontWithName:@"Helvetica-Bold" size:15] : [UIFont fontWithName:@"Helvetica-Bold" size:10];
}

#pragma mark public
+ (CGFloat)estimatedRowHeight {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 81 : 58;
}

+ (CGFloat)actualRowHeightwithTitle:(NSString *)title subtitle:(NSString *)subtitle forTableWidth:(CGFloat)tableWidth {
  //so, the width of the content view will be the width of the table - minus the accessory inset - minus the width of the accessory view itself
  CGFloat usableWidth = tableWidth - kAccessoryInset - [TouchTableCell accessorySize].width;
  //then we need to take off the insets
  usableWidth -= ([TouchTableCell horizontalPadding] * 2);
  //okay - we know what the usable width of the strings can be - lets work out the heights - first up, the title
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
  CGFloat rollingHeight = 0;
  NSDictionary *attributes = @{NSFontAttributeName: [TouchTableCell titleFont], NSParagraphStyleAttributeName : paragraphStyle};
  CGRect aRect = [title boundingRectWithSize:CGSizeMake(usableWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
  //okay - we have the title height
  rollingHeight += ceil(aRect.size.height);
  //do we have a subtitle? if so, add the height of that to the rollingHeight
  if (subtitle && ([subtitle length] > 0)) {
    //add one to rollingHeight to include a minor gap
    rollingHeight += 1;
    //now work out the size of the subtitle (and only one line of it)
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = @{NSFontAttributeName: [TouchTableCell subtitleFont], NSParagraphStyleAttributeName : paragraphStyle};
    aRect = [subtitle boundingRectWithSize:CGSizeMake(usableWidth, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    rollingHeight += ceil(aRect.size.height);
  }
  //next up, add the top and bottom vertical padding
  rollingHeight += [TouchTableCell verticalPadding] * 2;
  //and that should be it!
  return rollingHeight;
}


#pragma mark - lifecycle
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
    [self setAccessoryView:[[UIImageView alloc] initWithImage:[TouchTableCell accessoryImage]]];
    //initial config of the title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [TouchTableCell titleFont];
    [self.contentView addSubview:self.titleLabel];

    //initial config of the subtitle (whether we show it or not)
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.subtitleLabel.numberOfLines = 1;
    self.subtitleLabel.font = [TouchTableCell subtitleFont];
    [self.contentView addSubview:self.subtitleLabel];
  }
  return self;
}


#pragma mark - property overrides
- (void)setTitleString:(NSString *)titleString {
  _titleString = titleString;
  self.titleLabel.text = self.titleString;
}

- (void)setSubtitleString:(NSString *)subtitleString {
  _subtitleString = subtitleString;
  self.subtitleLabel.text = self.subtitleString;
}

#pragma mark - public config
- (void)configureWithTitle:(NSString *)titleString subtitle:(NSString *)subtitleString {
  self.titleString = titleString;
  self.subtitleString = subtitleString;
  [self setNeedsLayout];
}

- (void)configureWithTitle:(NSString *)titleString {
  [self configureWithTitle:titleString subtitle:nil];
}

#pragma mark - super overrides
- (void)prepareForReuse {
  [super prepareForReuse];
  [self configureWithTitle:nil];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  //store an inset value that's different for each device
  CGFloat titleInsetXVal = [TouchTableCell horizontalPadding];
  
  CGSize titleSize = [self sizeOfString:self.titleString withFont:self.titleLabel.font lineBreakingOn:YES];
  if (self.subtitleString) {
    CGSize subtitleSize = [self sizeOfString:self.subtitleString withFont:self.subtitleLabel.font lineBreakingOn:NO];
    //title AND subtitle
    [self.subtitleLabel setHidden:false];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      //iPad
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 17, self.contentView.frame.size.width - (titleInsetXVal * 2), titleSize.height);
      self.subtitleLabel.frame = CGRectMake(titleInsetXVal, CGRectGetMaxY(self.titleLabel.frame) + 1, self.frame.size.width - (titleInsetXVal * 2), subtitleSize.height);
    } else {
      //iPhone
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 16, self.contentView.frame.size.width - (titleInsetXVal * 2), titleSize.height);
      self.subtitleLabel.frame = CGRectMake(titleInsetXVal, CGRectGetMaxY(self.titleLabel.frame) + 1, self.frame.size.width - (titleInsetXVal * 2), subtitleSize.height);
    }
  } else {
    [self.subtitleLabel setHidden:true];
    //just title
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      //iPad
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 26, self.contentView.frame.size.width - (titleInsetXVal * 2),  titleSize.height);
    } else {
      //iPhone
      self.titleLabel.frame = CGRectMake(titleInsetXVal, 22, self.contentView.frame.size.width - (titleInsetXVal * 2),  titleSize.height);
    }
  }
  NSLog(@"Content)View = %@", NSStringFromCGRect(self.contentView.frame));
  NSLog(@"AccessoryView = %@", NSStringFromCGRect(self.accessoryView.frame));
}

- (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font lineBreakingOn:(BOOL)lineBreakingOn {
  //work out the usable width
  CGFloat titleWidth = self.contentView.frame.size.width - ([TouchTableCell horizontalPadding] * 2);
  //now work out the height the label needs to be
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  if (lineBreakingOn) {
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
  } else {
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
  }
  NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName : paragraphStyle};
  CGRect titleRect = [self.titleString boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
  return CGSizeMake(ceil(titleRect.size.width), ceil(titleRect.size.height));
}








@end
