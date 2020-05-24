//
//  UITextField+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UITextField+JXObjc.h"

@implementation UITextField (JXObjc)
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
    
    UIFont *font = self.font;
    if (!font) {
        return;
    }
    
    self.font = [UIFont fontWithName:font.fontName size:(font.pointSize * JXInstance.fontFactor)];
}

+ (void)jx_appearanceWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    UITextField *textField = [UITextField appearance];
    
    UIColor *tintColor = [param objectForKey:kJXKeyTintColor];
    if (tintColor) {
        textField.tintColor = tintColor;
    }
}
@end
