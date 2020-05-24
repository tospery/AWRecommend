//
//  CALayer+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "CALayer+JXObjc.h"

@implementation CALayer (JXObjc)
- (void)exShadowWithColor:(UIColor *)color
                   radius:(CGFloat)radius
                  opacity:(CGFloat)opacity
                   offset:(CGSize)offset {
    self.shadowColor = color.CGColor;
    self.shadowRadius = radius;
    self.shadowOpacity = opacity;
    self.shadowOffset = offset;
}

@end
