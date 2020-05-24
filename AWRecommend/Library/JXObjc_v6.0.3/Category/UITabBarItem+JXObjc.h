//
//  UITabBarItem+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (JXObjc)
- (void)jx_setupWithTitle:(NSString *)title
              normalImage:(UIImage *)normalImage
            selectedImage:(UIImage *)selectedImage JXAPIDeprecated601;

- (void)jx_setupWithTitle:(NSString *)title
       selectedTitleColor:(UIColor *)selectedTitleColor
              normalImage:(UIImage *)normalImage
            selectedImage:(UIImage *)selectedImage JXAPIDeprecated601;

- (void)jx_setupWithTitle:(NSString *)title
         normalTitleColor:(UIColor *)normalTitleColor
       selectedTitleColor:(UIColor *)selectedTitleColor
          normalTitleFont:(UIFont *)normalTitleFont
        selectedTitleFont:(UIFont *)selectedTitleFont
              normalImage:(UIImage *)normalImage
            selectedImage:(UIImage *)selectedImage JXAPIDeprecated601;

- (void)jx_configWithParam:(NSDictionary *)param;

@end
