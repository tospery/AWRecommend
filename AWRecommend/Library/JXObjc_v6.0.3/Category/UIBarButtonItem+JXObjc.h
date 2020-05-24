//
//  UIBarButtonItem+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kJXBarButtonItemIconNormal                  (@"kJXBarButtonItemIconNormal")
#define kJXBarButtonItemIconHighlighted             (@"kJXBarButtonItemIconHighlighted")
#define kJXBarButtonItemIconDisabled                (@"kJXBarButtonItemIconDisabled")
#define kJXBarButtonItemIconSelected                (@"kJXBarButtonItemIconSelected")

@interface UIBarButtonItem (JXObjc)
+ (UIBarButtonItem *)jx_barItemWithType:(FlatButtonType)type color:(UIColor *)color target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)jx_barItemWithImage:(UIImage *)image size:(CGSize)size target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)jx_barItemWithImages:(NSDictionary *)images target:(id)target action:(SEL)action;

+ (void)jx_appearanceWithColor:(UIColor *)color font:(UIFont *)font JXAPIDeprecated601;
+ (void)jx_appearanceWithParam:(NSDictionary *)param;
- (void)jx_configWithParam:(NSDictionary *)param;

@end
