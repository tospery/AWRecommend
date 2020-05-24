//
//  UILabel+JXObjc.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JXObjc)
- (void)jx_animateCountWithDuration:(CGFloat)duration count:(CGFloat)count isInt:(BOOL)isInt format:(NSString *)format, ...;

@end
