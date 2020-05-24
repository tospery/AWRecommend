//
//  UIBarButtonItem+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIBarButtonItem+JXObjc.h"

@implementation UIBarButtonItem (JXObjc)
+ (UIBarButtonItem *)jx_barItemWithType:(FlatButtonType)type color:(UIColor *)color target:(id)target action:(SEL)action {
    VBFPopFlatButton *popFlatButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)
                                                                   buttonType:(FlatButtonType)type
                                                                  buttonStyle:buttonPlainStyle
                                                        animateToInitialState:NO];
    popFlatButton.lineThickness = 2.0;
    popFlatButton.tintColor = color;
    if (target && action) {
        [popFlatButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:popFlatButton];
}

+ (UIBarButtonItem *)jx_barItemWithImage:(UIImage *)image size:(CGSize)size target:(id)target action:(SEL)action {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if(action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)jx_barItemWithImages:(NSDictionary *)images target:(id)target action:(SEL)action {
    CGRect frame = CGRectMake(0, 0, 20, 20);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconNormal] forState:UIControlStateNormal];
    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconHighlighted] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconDisabled] forState:UIControlStateDisabled];
    [button setBackgroundImage:[images objectForKey:kJXBarButtonItemIconSelected] forState:UIControlStateSelected];
    
    if(action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (void)jx_appearanceWithColor:(UIColor *)color font:(UIFont *)font {
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color,
                                                           NSFontAttributeName: font}
                                                forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor],
                                                           NSFontAttributeName: font}
                                                forState:UIControlStateDisabled];
    
    
    //    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    //    attrs[NSForegroundColorAttributeName] = JXColorHex(0x666666);
    //    attrs[NSFontAttributeName]            = [UIFont exDeviceRegularFontOfSize:14];
    //    NSShadow *shadow                      = [[NSShadow alloc] init];
    //    shadow.shadowOffset                   = CGSizeZero;
    //    attrs[NSShadowAttributeName]          = shadow;
    //    [[UIBarButtonItem appearance] setTitleTextAttributes:attrs forState:UIControlStateNormal];
    //    [[UIBarButtonItem appearance] setTitleTextAttributes:attrs forState:UIControlStateHighlighted];
    //
    //    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    //    disabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    //    [[UIBarButtonItem appearance] setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
}

- (void)jx_configWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *disabledAttributes = [NSMutableDictionary dictionary];
    
    UIFont *titleFont = [param objectForKey:kJXKeyTitleFont];
    if (titleFont) {
        [normalAttributes setObject:titleFont forKey:NSFontAttributeName];
        [disabledAttributes setObject:titleFont forKey:NSFontAttributeName];
    }
    
    UIColor *normalTitleColor = [param objectForKey:kJXKeyTitleColor];
    if (normalTitleColor) {
        [normalAttributes setObject:normalTitleColor forKey:NSForegroundColorAttributeName];
    }
    
    UIColor *disabledTitleColor = [param objectForKey:kJXKeyTitleColorDisabled];
    if (disabledTitleColor) {
        [disabledAttributes setObject:disabledTitleColor forKey:NSForegroundColorAttributeName];
    }
    
    if (!JXDataIsEmpty(normalAttributes)) {
        [self setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    }
    
    if (!JXDataIsEmpty(disabledAttributes)) {
        [self setTitleTextAttributes:disabledAttributes forState:UIControlStateDisabled];
    }
}


+ (void)jx_appearanceWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *disabledAttributes = [NSMutableDictionary dictionary];
    
    UIFont *titleFont = [param objectForKey:kJXKeyTitleFont];
    if (titleFont) {
        [normalAttributes setObject:titleFont forKey:NSFontAttributeName];
        [disabledAttributes setObject:titleFont forKey:NSFontAttributeName];
    }
    
    UIColor *normalTitleColor = [param objectForKey:kJXKeyTitleColor];
    if (normalTitleColor) {
        [normalAttributes setObject:normalTitleColor forKey:NSForegroundColorAttributeName];
    }
    
    UIColor *disabledTitleColor = [param objectForKey:kJXKeyTitleColorDisabled];
    if (disabledTitleColor) {
        [disabledAttributes setObject:disabledTitleColor forKey:NSForegroundColorAttributeName];
    }
    
    if (!JXDataIsEmpty(normalAttributes)) {
        [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    }
    
    if (!JXDataIsEmpty(disabledAttributes)) {
        [barItem setTitleTextAttributes:disabledAttributes forState:UIControlStateDisabled];
    }
}
@end
