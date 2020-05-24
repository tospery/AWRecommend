//
//  JXRatingView.h
//  JXSamples
//
//  Created by 杨建祥 on 16/8/9.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JXRatingView : UIView
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIImage *fgImage;

- (void)setScore:(CGFloat)score animated:(BOOL)animated completion:(JXVoidBlock)completion;

@end