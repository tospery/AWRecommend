//
//  UITabBarItem+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UITabBarItem+JXObjc.h"

@implementation UITabBarItem (JXObjc)
- (void)jx_setupWithTitle:(NSString *)title
              normalImage:(UIImage *)normalImage
            selectedImage:(UIImage *)selectedImage {
    [self jx_setupWithTitle:title normalTitleColor:nil selectedTitleColor:nil normalTitleFont:nil selectedTitleFont:nil normalImage:normalImage selectedImage:selectedImage];
}

- (void)jx_setupWithTitle:(NSString *)title
       selectedTitleColor:(UIColor *)selectedTitleColor
              normalImage:(UIImage *)normalImage
            selectedImage:(UIImage *)selectedImage {
    [self jx_setupWithTitle:title normalTitleColor:nil selectedTitleColor:selectedTitleColor normalTitleFont:nil selectedTitleFont:nil normalImage:normalImage selectedImage:selectedImage];
}

- (void)jx_setupWithTitle:(NSString *)title
         normalTitleColor:(UIColor *)normalTitleColor
       selectedTitleColor:(UIColor *)selectedTitleColor
          normalTitleFont:(UIFont *)normalTitleFont
        selectedTitleFont:(UIFont *)selectedTitleFont
              normalImage:(UIImage *)normalImage
            selectedImage:(UIImage *)selectedImage {
    if (title) {
        self.title = title;
    }else {
        [self setImageInsets:UIEdgeInsetsMake(4, 0, -4, 0)];
    }
    
    self.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *normalTextAttrs = [NSMutableDictionary dictionary];
    if (normalTitleColor) {
        [normalTextAttrs setObject:normalTitleColor forKey:NSForegroundColorAttributeName];
    }
    if (normalTitleFont) {
        [normalTextAttrs setObject:normalTitleFont forKey:NSFontAttributeName];
    }
    if (normalTextAttrs.count != 0) {
        [self setTitleTextAttributes:normalTextAttrs forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    if (selectedTitleColor) {
        [selectedTextAttrs setObject:selectedTitleColor forKey:NSForegroundColorAttributeName];
    }
    if (selectedTitleFont) {
        [selectedTextAttrs setObject:selectedTitleFont forKey:NSFontAttributeName];
    }
    if (selectedTextAttrs.count != 0) {
        [self setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    }
}

- (void)jx_configWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    NSString *title = [param objectForKey:kJXKeyTitleText];
    if (title) {
        self.title = title;
    }else {
        [self setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    }
    
    UIImage *image = [param objectForKey:kJXKeyImage];
    if (image) {
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    image = [param objectForKey:kJXKeyImageSelected];
    if (image) {
        self.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithCapacity:2];
    UIColor *color = [param objectForKey:kJXKeyTitleColor];
    if (color) {
        [attr setObject:color forKey:NSForegroundColorAttributeName];
    }
    UIFont *font = [param objectForKey:kJXKeyTitleFont];
    if (font) {
        [attr setObject:font forKey:NSFontAttributeName];
    }
    if (0 != attr.count) {
        [self setTitleTextAttributes:attr forState:UIControlStateNormal];
    }
    
    [attr removeAllObjects];
    color = [param objectForKey:kJXKeyTitleColorSelected];
    if (color) {
        [attr setObject:color forKey:NSForegroundColorAttributeName];
    }
    font = [param objectForKey:kJXKeyTitleFontSelected];
    if (font) {
        [attr setObject:font forKey:NSFontAttributeName];
    }
    if (0 != attr.count) {
        [self setTitleTextAttributes:attr forState:UIControlStateSelected];
    }
}


@end




