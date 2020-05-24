//
//  UIButton+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 17/4/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "UIButton+JXObjc.h"

@implementation UIButton (JXObjc)
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
    
    UIFont *font = self.titleLabel.font;
    if (!font) {
        return;
    }
    
    self.titleLabel.font = [UIFont fontWithName:font.fontName size:(font.pointSize * JXInstance.fontFactor)];
}

@end
