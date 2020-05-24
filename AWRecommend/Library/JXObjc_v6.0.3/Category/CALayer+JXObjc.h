//
//  CALayer+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JXObjc)
- (void)exShadowWithColor:(UIColor *)color
                   radius:(CGFloat)radius
                  opacity:(CGFloat)opacity
                   offset:(CGSize)offset;

@end
