//
//  UITabBar+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (JXObjc)
//- (void)jx_setupWithTranslucent:(BOOL)translucent
//                   barTintColor:(UIColor *)barTintColor
//                      tintColor:(UIColor *)tintColor JXAPIDeprecated;
//+ (void)jx_appearanceWithTranslucent:(BOOL)translucent
//                        barTintColor:(UIColor *)barTintColor
//                           tintColor:(UIColor *)tintColor JXAPIDeprecated;

- (void)jx_configWithParam:(NSDictionary *)param;

+ (void)jx_appearanceWithParam:(NSDictionary *)param;
@end
