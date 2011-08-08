//
//  TJMLazyImageView.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 07/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMLazyImage.h"


@interface TJMLazyImageView : UIView <TJMLazyImageDelegate> {
}

- (id)initWithURL:(NSString *)imageURL cacheFilename:(NSString *)cacheFilename andFrame:(CGRect)frame;

@end
