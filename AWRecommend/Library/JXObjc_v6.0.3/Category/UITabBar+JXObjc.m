//
//  UITabBar+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UITabBar+JXObjc.h"

@implementation UITabBar (JXObjc)
//- (void)jx_setupWithTranslucent:(BOOL)translucent
//                   barTintColor:(UIColor *)barTintColor
//                      tintColor:(UIColor *)tintColor {
//    self.translucent = translucent;
//    self.barTintColor = barTintColor;
//    self.tintColor = tintColor;
//    
//    //    if (barTintColor) {
//    //        self.barTintColor = barTintColor;
//    //    }
//    //    if (tintColor) {
//    //        self.tintColor = tintColor;
//    //    }
//}
//
//+ (void)jx_appearanceWithTranslucent:(BOOL)translucent
//                        barTintColor:(UIColor *)barTintColor
//                           tintColor:(UIColor *)tintColor {
//    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
//        [UITabBar appearance].translucent = translucent;
//        [UITabBar appearance].barTintColor = barTintColor;
//        [UITabBar appearance].tintColor = tintColor;
//        
//        //        if (barTintColor) {
//        //            [UITabBar appearance].barTintColor = barTintColor;
//        //        }
//        //        if (tintColor) {
//        //            [UITabBar appearance].tintColor = tintColor;
//        //        }
//    }
//}

- (void)jx_configWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    [UITabBar configWithTabBar:self param:param];
}


+ (void)jx_appearanceWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    if (!JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        return;
    }
    
    [self configWithTabBar:[UITabBar appearance] param:param];
}

+ (void)configWithTabBar:(UITabBar *)tabBar param:(NSDictionary *)param {
    BOOL translucent = [[param objectForKey:kJXKeyTranslucent] boolValue];
    tabBar.translucent = translucent;
    
    UIColor *barTintColor = [param objectForKey:kJXKeyBarTintColor];
    if (barTintColor) {
        tabBar.barTintColor = barTintColor;
    }
    
    UIColor *tintColor = [param objectForKey:kJXKeyTintColor];
    if (tintColor) {
        tabBar.tintColor = tintColor;
    }
}
@end
