//
//  UILabel+JXObjc.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "UILabel+JXObjc.h"

@implementation UILabel (JXObjc)
//#ifdef JXEnableFuncAdaptFont
+ (void)load{
    JXExchangeMethod(@selector(initWithFrame:), @selector(jx_ex_initWithFrame:));
    JXExchangeMethod(@selector(initWithCoder:), @selector(jx_ex_initWithCoder:));
}
//#endif

- (instancetype)jx_ex_initWithCoder:(NSCoder *)decoder {
    [self jx_ex_initWithCoder:decoder];
    [self jx_ex_custom];
    return self;
}

- (instancetype)jx_ex_initWithFrame:(CGRect)frame {
    [self jx_ex_initWithFrame:frame];
    [self jx_ex_custom];
    return self;
}

- (void)jx_ex_custom {
    if (!self) {
        return;
    }
    
    if (!self.font) {
        return;
    }
    
    self.font = [UIFont fontWithName:self.font.fontName size:(self.font.pointSize * JXInstance.fontFactor)];
}

- (void)jx_animateCountWithDuration:(CGFloat)duration count:(CGFloat)count isInt:(BOOL)isInt format:(NSString *)format, ... {
    // YJX_TODO 采用removeAnimationWhenCompletion
    NSString *name = @"popCountAnimation";
    [self pop_removeAnimationForKey:name];
    
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = duration;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [[obj description] floatValue];
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            if (isInt) {
                [obj setText:[NSString stringWithFormat:format, (long)values[0]]];
            }else {
                [obj setText:[NSString stringWithFormat:format, values[0]]];
            }
        };
        prop.threshold = 0.01;
    }];
    
    anim.property = prop;
    anim.fromValue = @(0);
    anim.toValue = @(count);
    [self pop_addAnimation:anim forKey:name];
}

@end
