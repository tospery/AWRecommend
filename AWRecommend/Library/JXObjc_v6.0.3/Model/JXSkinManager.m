//
//  JXSkinManager.m
//  JXSamples
//
//  Created by 杨建祥 on 16/12/26.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXSkinManager.h"

@implementation JXSkinManager
- (instancetype)init {
    if (self = [super init]) {
//        _mainColor = JXColorHex(0x66D6A6);
//        
//        _viewBgColor = [UIColor whiteColor];
//        _barItemColor = [UIColor whiteColor];
        
        
        //        _textColor = JXColorHex(0x333333);
        //        _textDarkColor = [UIColor blackColor];
        //        _textLightColor = JXColorHex(0x999999);
        //
        //        _navBarColor = _mainColor;
        //
        //        _viewBgColor = [UIColor whiteColor];
        //        _borderColor = [UIColor clearColor];
        //        _groundColor = JXColorHex(0x36353A);
        //
        //        _placeholderColor = JXColorHex(0x999999);
        
        //[self setupAlertStyle];
    }
    return self;
}

- (void)configButtonStyle1:(UIButton *)button fontSize:(CGFloat)fontSize borderRadius:(CGFloat)borderRadius {
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = JXFont(fontSize);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]  forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage jx_imageWithColor:self.mainColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage jx_imageWithColor:JXColorHex(0xE3E3E3)] forState:UIControlStateDisabled];
    
    [button jx_borderWithColor:[UIColor clearColor] width:0.0 radius:borderRadius];
}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

//- (void)setupAlertStyle {
    
//}

//- (void)configAlertStyle {
    //    [[SIAlertView appearance] setTitleFont:JXFont(16)];
    //    [[SIAlertView appearance] setMessageFont:JXFont(15)];
    //    [[SIAlertView appearance] setButtonFont:JXFont(17)];
    //    [[SIAlertView appearance] setTitleColor:JXColorHex(0xA5463B)];
    //    [[SIAlertView appearance] setMessageColor:JXColorHex(0xA5463B)];
    //    [[SIAlertView appearance] setCornerRadius:4];
    //    //[[SIAlertView appearance] setShadowRadius:12];
    //    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    //    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    //    [[SIAlertView appearance] setCancelButtonColor:[UIColor whiteColor]];
    //
    //    [[SIAlertView appearance] setCancelButtonImage:[UIImage jx_imageWithColor:[JXColorHex(0xC34239) colorWithAlphaComponent:0.8]] forState:UIControlStateNormal];
    //    [[SIAlertView appearance] setCancelButtonImage:[UIImage jx_imageWithColor:JXColorHex(0xC34239)] forState:UIControlStateHighlighted];
    //    [[SIAlertView appearance] setDefaultButtonImage:[UIImage jx_imageWithColor:JXColorHex(0x554E54)] forState:UIControlStateNormal];
    //    [[SIAlertView appearance] setDefaultButtonImage:[UIImage jx_imageWithColor:JXColorHex(0x322F32)] forState:UIControlStateHighlighted];
    //
    //    [[SIAlertView appearance] setTransitionStyle:SIAlertViewTransitionStyleBounce];
    //    [[SIAlertView appearance] setBackgroundStyle:SIAlertViewBackgroundStyleGradient];
    //    [[SIAlertView appearance] setButtonsListStyle:SIAlertViewButtonsListStyleNormal];
//}

//- (void)configButton:(UIButton *)button
//            fontSize:(CGFloat)fontSize
//     textEnableColor:(UIColor *)textEnableColor
//    textDisableColor:(UIColor *)textDisableColor
//       bgEnableColor:(UIColor *)bgEnableColor
//      bgDisableColor:(UIColor *)bgDisableColor
//         borderWidth:(CGFloat)borderWidth
//        borderRadius:(CGFloat)borderRadius {
//    button.titleLabel.font = JXFont(fontSize);
//    button.backgroundColor = [UIColor clearColor];
//    
//    [button setTitleColor:textEnableColor forState:UIControlStateNormal];
//    [button setTitleColor:[textEnableColor colorWithAlphaComponent:0.8]  forState:UIControlStateHighlighted];
//    [button setTitleColor:textDisableColor forState:UIControlStateDisabled];
//    
//    [button setBackgroundImage:[UIImage jx_imageWithColor:backgroundColor] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage jx_imageWithColor:JXColorHex(0xE3E3E3)] forState:UIControlStateDisabled];
//    
//    [button jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0f];
//}

//- (void)configButtonStyle1:(UIButton *)button {
//    button.titleLabel.font = JXFont(14.0f);
//    button.backgroundColor = [UIColor clearColor];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]  forState:UIControlStateHighlighted];
//    [button setBackgroundImage:[UIImage jx_imageWithColor:self.mainColor] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage jx_imageWithColor:JXColorHex(0xE3E3E3)] forState:UIControlStateDisabled];
//    [button jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0f];
//}
//
//- (void)configButtonStyle2:(UIButton *)button {
//    button.titleLabel.font = JXFont(12.0f);
//    button.backgroundColor = [UIColor clearColor];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]  forState:UIControlStateHighlighted];
//    [button setBackgroundImage:[UIImage jx_imageWithColor:self.mainColor] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage jx_imageWithColor:JXColorHex(0xE3E3E3)] forState:UIControlStateDisabled];
//    [button jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0f];
//}
//
//- (void)configButtonStyle3:(JXCaptchaButton *)button {
//    
//}

@end
