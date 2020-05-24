//
//  JXAutoRollView.h
//  JXSamples
//
//  Created by 杨建祥 on 16/5/15.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXAutoRollView : UIView
// @property (nonatomic, copy) JXVoidBlock_int didScrollBlock;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign, readonly) NSUInteger total;

- (void)customInit;

- (void)setupViews:(NSArray *)views didTapBlock:(JXVoidBlock_int)didTapBlock;
- (void)setupViews:(NSArray *)views didTapBlock:(JXVoidBlock_int)didTapBlock duration:(NSTimeInterval)duration;

@end
