//
//  TJMImageResourceView.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 15/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageItem.h"

@interface TJMImageResourceView : UIImageView

//value to store any useful info - like an array index - not used internally.
@property (nonatomic, assign) NSInteger index;
@property (nonatomic) NSURL *url;
@property (nonatomic) UIActivityIndicatorView *spinner;


- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andURL:(NSURL *)url;
- (id)initWithImageItem:(ImageItem *)item forSize:(CGSize)size;
- (id)initWithImageItem:(ImageItem *)item;
- (void)setURL:(NSURL *)url;

@end
