//
//  UINavigationBar+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (JXObjc)
- (void)jx_hideBottomLine:(BOOL)hided;

- (void)jx_configBottomLineColor:(UIColor *)color;

- (void)exSetupWithBackgroundImage:(UIImage *)backgroundImage titleColor:(UIColor *)titleColor;

+ (void)jx_appearanceWithParam:(NSDictionary *)param;
- (void)jx_configWithParam:(NSDictionary *)param;

//#ifdef JXEnableLibLTNavigationBar
- (void)jx_transparet;
- (void)jx_reset;
//#endif

//#pragma mark - Public methods
//- (void)jx_setupWithTranslucent:(BOOL)translucent
//                       barColor:(UIColor *)barColor
//                     titleColor:(UIColor *)titleColor
//                           font:(UIFont *)font JXAPIDeprecated;
//- (void)jx_setupWithBackgroundImage:(UIImage *)backgroundImage titleColor:(UIColor *)titleColor JXAPIDeprecated;
//
//#pragma mark - Class methods
//+ (void)jx_appearanceWithTranslucent:(BOOL)translucent
//                            barColor:(UIColor *)barColor
//                          titleColor:(UIColor *)titleColor
//                                font:(UIFont *)font JXAPIDeprecated;
//
//// 备份
//#pragma mark - Public methods
//- (void)exSetupWithTranslucent:(BOOL)translucent
//                      barColor:(UIColor *)barColor
//                    titleColor:(UIColor *)titleColor
//                          font:(UIFont *)font;
//
//
//#pragma mark - Class methods
//+ (void)exAppearanceWithTranslucent:(BOOL)translucent
//                           barColor:(UIColor *)barColor
//                         titleColor:(UIColor *)titleColor
//                               font:(UIFont *)font;

@end
