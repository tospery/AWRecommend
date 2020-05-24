//
//  UITextView+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UITextView+JXObjc.h"

@implementation UITextView (JXObjc)
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

+ (void)jx_appearanceWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    UITextView *textView = [UITextView appearance];
    
    UIColor *tintColor = [param objectForKey:kJXKeyTintColor];
    if (tintColor) {
        textView.tintColor = tintColor;
    }
}

@end
