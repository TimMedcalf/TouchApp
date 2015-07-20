//
//  TouchTableCell.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//


#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const TouchTableCellReuseID = @"TouchTableCellReuseID";
#pragma clang diagnostic pop

#import "TCHTouchTableCell.h"

static const CGFloat kAccessoryInset = 15.;

@interface TCHTouchTableCell ()
+ (CGFloat)verticalPadding;
+ (CGFloat)horizontalPadding;
+ (UIImage *)accessoryImage;
+ (CGSize)accessorySize;
+ (UIFont *)titleFont;
+ (UIFont *)subtitleFont;
+ (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font lineBreakingOn:(BOOL)lineBreakingOn maxWidth:(CGFloat)maxWidth;

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *subtitleString;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end


@implementation TCHTouchTableCell

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
  return [TCHTouchTableCell accessoryImage].size;
}

+ (UIFont *)titleFont {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIFont fontWithName:@"Helvetica" size:21] : [UIFont fontWithName:@"Helvetica" size:14];
}

+ (UIFont *)subtitleFont {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIFont fontWithName:@"Helvetica-Bold" size:15] : [UIFont fontWithName:@"Helvetica-Bold" size:10];
}

+ (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font lineBreakingOn:(BOOL)lineBreakingOn maxWidth:(CGFloat)maxWidth {
  //now work out the height the label needs to be
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  if (lineBreakingOn) {
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  } else {
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
  }
  NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName : paragraphStyle};
  CGRect stringRect = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil];
  return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
}


#pragma mark public
+ (CGFloat)estimatedRowHeight {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 81 : 58;
}

+ (CGFloat)actualRowHeightwithTitle:(NSString *)title subtitle:(NSString *)subtitle forTableWidth:(CGFloat)tableWidth {
  //first up, initialise a running total of the height so far
  CGFloat rollingHeight = 0;
  //so, the width of the content view will be the width of the table - minus the accessory inset - minus the width of the accessory view itself
  CGFloat usableWidth = tableWidth - kAccessoryInset - [TCHTouchTableCell accessorySize].width;
  //then we need to take off the insets
  usableWidth -= ([TCHTouchTableCell horizontalPadding] * 2);
  //okay - we know what the usable width of the strings can be - lets work out the heights - first up, the title
  CGSize aSize = [TCHTouchTableCell sizeOfString:title withFont:[TCHTouchTableCell titleFont] lineBreakingOn:YES maxWidth:usableWidth];
  //okay - we have the title height
  rollingHeight += ceil(aSize.height);
  //do we have a subtitle? if so, add the height of that to the rollingHeight
  if (subtitle && (subtitle.length > 0)) {
    //add one to rollingHeight to include a minor gap
    rollingHeight += 1;
    //now work out the size of the subtitle (and only one line of it)
    aSize = [TCHTouchTableCell sizeOfString:subtitle withFont:[TCHTouchTableCell subtitleFont] lineBreakingOn:NO maxWidth:usableWidth];
    rollingHeight += ceil(aSize.height);
  }
  //next up, add the top and bottom vertical padding
  rollingHeight += [TCHTouchTableCell verticalPadding] * 2;
  //and that should be it!
  DDLogDebug(@"ActualHeight %f",ceil(rollingHeight));
  return ceil(rollingHeight);
}


#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    self.accessoryView = [[UIImageView alloc] initWithImage:[TCHTouchTableCell accessoryImage]];
    //initial config of the title
    _titleLabel = [[UILabel alloc] init];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [TCHTouchTableCell titleFont];
    [self.contentView addSubview:self.titleLabel];

    //initial config of the subtitle (whether we show it or not)
    _subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.subtitleLabel.numberOfLines = 1;
    self.subtitleLabel.font = [TCHTouchTableCell subtitleFont];
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
  CGFloat titleInsetXVal = [TCHTouchTableCell horizontalPadding];
  
  CGSize titleSize = [TCHTouchTableCell sizeOfString:self.titleString withFont:self.titleLabel.font lineBreakingOn:YES maxWidth:self.contentView.bounds.size.width - ([TCHTouchTableCell horizontalPadding] * 2)];
  if (self.subtitleString) {
    CGSize subtitleSize = [TCHTouchTableCell sizeOfString:self.subtitleString withFont:self.subtitleLabel.font lineBreakingOn:NO  maxWidth:self.contentView.bounds.size.width - ([TCHTouchTableCell horizontalPadding] * 2)];
    //title AND subtitle
    [self.subtitleLabel setHidden:false];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      //iPad
      self.titleLabel.frame = CGRectMake(titleInsetXVal, [TCHTouchTableCell verticalPadding], self.contentView.frame.size.width - (titleInsetXVal * 2), titleSize.height);
      self.subtitleLabel.frame = CGRectMake(titleInsetXVal, CGRectGetMaxY(self.titleLabel.frame) + 1, self.contentView.frame.size.width - (titleInsetXVal * 2), subtitleSize.height);
    } else {
      //iPhone
      self.titleLabel.frame = CGRectMake(titleInsetXVal, [TCHTouchTableCell verticalPadding], self.contentView.frame.size.width - (titleInsetXVal * 2), titleSize.height);
      self.subtitleLabel.frame = CGRectMake(titleInsetXVal, CGRectGetMaxY(self.titleLabel.frame) + 1, self.contentView.frame.size.width - (titleInsetXVal * 2), subtitleSize.height);
    }
  } else {
    [self.subtitleLabel setHidden:true];
    //just title
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      //iPad
      self.titleLabel.frame = CGRectMake(titleInsetXVal, [TCHTouchTableCell verticalPadding], self.contentView.frame.size.width - (titleInsetXVal * 2),  titleSize.height);
    } else {
      //iPhone
      self.titleLabel.frame = CGRectMake(titleInsetXVal, [TCHTouchTableCell verticalPadding], self.contentView.frame.size.width - (titleInsetXVal * 2),  titleSize.height);
    }
  }
}









@end
