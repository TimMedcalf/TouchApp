//
//  TJMImageResourceView.h
//  TouchApp
//
//  Created by Tim Medcalf on 15/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHImageFeedItem.h"


@interface TJMImageResourceView : UIImageView

//value to store any useful info - like an array index - not used internally.
@property (nonatomic, assign) NSUInteger index;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;


- (id)initWithFrame:(CGRect)frame;
- (id)initWithImageItem:(TCHImageFeedItem *)item;
- (void)setURL:(NSURL *)url;

@end
