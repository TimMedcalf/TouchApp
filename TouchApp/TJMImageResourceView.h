//
//  TJMImageResourceView.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 15/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMImageResourceView : UIView

//value to store any useful info - like an array index - not used internally.
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSURL *url;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andURL:(NSURL *)url;
- (id)initWithFrame:(CGRect)frame andURL:(NSURL *)url forThumbnailofSize:(CGSize)size;
- (void)setURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url;



@end
