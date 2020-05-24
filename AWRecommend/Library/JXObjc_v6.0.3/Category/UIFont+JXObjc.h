//
//  UIFont+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (JXObjc)
+ (UIFont *)jx_systemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)jx_boldSystemFontOfSize:(CGFloat)fontSize;

+ (UIFont *)jx_deviceRegularFontOfSize:(CGFloat)fontSize;
+ (UIFont *)jx_deviceBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *)jx_deviceCustomFontWithName:(NSString *)name size:(CGFloat)size;

@end
