//
//  UINavigationBar+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UINavigationBar+JXObjc.h"

@implementation UINavigationBar (JXObjc)
- (void)jx_hideBottomLine:(BOOL)hided {
    UIImage *image = hided ? [UIImage new] : nil;
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:image];
}

- (void)jx_configBottomLineColor:(UIColor *)color {
    [self setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage jx_imageWithColor:color]];
}

- (void)exSetupWithBackgroundImage:(UIImage *)backgroundImage titleColor:(UIColor *)titleColor {
    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                titleColor, NSForegroundColorAttributeName, nil];
}

- (void)jx_configWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        BOOL translucent = [[param objectForKey:kJXKeyTranslucent] boolValue];
        self.translucent = translucent;
    }
    
    UIColor *barTintColor = [param objectForKey:kJXKeyBarTintColor];
    if (barTintColor) {
        if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
            self.barTintColor = barTintColor;
        }else {
            [self setBackgroundImage:[UIImage jx_imageWithColor:barTintColor] forBarMetrics:UIBarMetricsDefault];
        }
    }else {
        self.barTintColor = nil;
    }
    
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    UIColor *titleColor = [param objectForKey:kJXKeyTitleColor];
    if (titleColor) {
        [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
    }
    UIFont *titleFont = [param objectForKey:kJXKeyTitleFont];
    if (titleColor) {
        [titleTextAttributes setObject:titleFont forKey:NSFontAttributeName];
    }
    self.titleTextAttributes = titleTextAttributes;
    
    UIImage *image = [param objectForKey:kJXKeyImageBackground];
    if (image) {
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

+ (void)jx_appearanceWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar jx_configWithParam:param];
    
    //    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
    //        BOOL translucent = [[param objectForKey:kJXKeyTranslucent] boolValue];
    //        navBar.translucent = translucent;
    //    }
    //
    //    UIColor *barTintColor = [param objectForKey:kJXKeyBarTintColor];
    //    if (barTintColor) {
    //        if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
    //            navBar.barTintColor = barTintColor;
    //        }else {
    //            [navBar setBackgroundImage:[UIImage jx_imageWithColor:barTintColor] forBarMetrics:UIBarMetricsDefault];
    //        }
    //    }
    //
    //    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    //    UIColor *titleColor = [param objectForKey:kJXKeyTitleColor];
    //    if (titleColor) {
    //        [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
    //    }
    //    UIFont *titleFont = [param objectForKey:kJXKeyTitleFont];
    //    if (titleColor) {
    //        [titleTextAttributes setObject:titleFont forKey:NSFontAttributeName];
    //    }
    //    navBar.titleTextAttributes = titleTextAttributes;
}

//#ifdef JXEnableLibLTNavigationBar
- (void)jx_transparet {
    self.translucent = YES;
    [self setShadowImage:[UIImage new]];
    [self lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)jx_reset {
    self.translucent = NO;
    [self setShadowImage:nil];
    [self lt_reset];
}
//#endif

//#pragma mark - Public methods
//- (void)jx_setupWithTranslucent:(BOOL)translucent
//                       barColor:(UIColor *)barColor
//                     titleColor:(UIColor *)titleColor
//                           font:(UIFont *)font {
//    if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
//        self.translucent = translucent;
//        self.barTintColor = barColor;
//    } else {
//        [self setBackgroundImage:[UIImage jx_imageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
//    }
//
//    self.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor,
//                                 NSFontAttributeName: font};
//}
//
//- (void)jx_setupWithBackgroundImage:(UIImage *)backgroundImage titleColor:(UIColor *)titleColor {
//    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                titleColor, NSForegroundColorAttributeName, nil];
//}
//
//#pragma mark - Class methods
//+ (void)jx_appearanceWithTranslucent:(BOOL)translucent
//                            barColor:(UIColor *)barColor
//                          titleColor:(UIColor *)titleColor
//                                font:(UIFont *)font {
//    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
//        [UINavigationBar appearance].translucent = translucent;
//    }
//
//    if (barColor) {
//        if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
//            [UINavigationBar appearance].barTintColor = barColor;
//        }else {
//            [[UINavigationBar appearance] setBackgroundImage:[UIImage jx_imageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
//        }
//    }
//
//    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: titleColor,
//                                                         NSFontAttributeName: font};
//}

//// Backup
//#pragma mark - Public methods
//- (void)exSetupWithTranslucent:(BOOL)translucent
//                      barColor:(UIColor *)barColor
//                    titleColor:(UIColor *)titleColor
//                          font:(UIFont *)font {
//    if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
//        self.translucent = translucent;
//        self.barTintColor = barColor;
//    } else {
//        [self setBackgroundImage:[UIImage jx_imageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
//    }
//
//    self.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor,
//                                 NSFontAttributeName: font};
//
//
//    //    if (JXiOSVersionGreaterThanOrEqual(8.0)) {
//    //        [UINavigationBar appearance].translucent = translucent;
//    //    }
//    //
//    //    if (barColor) {
//    //        if (JXiOSVersionGreaterThanOrEqual(7.0)) {
//    //            [UINavigationBar appearance].barTintColor = barColor;
//    //        }else {
//    //            [[UINavigationBar appearance] setBackgroundImage:[UIImage exImageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
//    //        }
//    //    }
//    //
//    //    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: titleColor,
//    //                                                         NSFontAttributeName: font};
//}

//#pragma mark - Class methods
//+ (void)exAppearanceWithTranslucent:(BOOL)translucent
//                           barColor:(UIColor *)barColor
//                         titleColor:(UIColor *)titleColor
//                               font:(UIFont *)font {
//    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
//        [UINavigationBar appearance].translucent = translucent;
//    }
//
//    if (barColor) {
//        if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
//            [UINavigationBar appearance].barTintColor = barColor;
//        }else {
//            [[UINavigationBar appearance] setBackgroundImage:[UIImage jx_imageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
//        }
//    }
//
//    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: titleColor,
//                                                         NSFontAttributeName: font};
//}
@end



