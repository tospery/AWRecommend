//
//  SkinManager.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "SkinManager.h"

// 3d8158 b81233红
@implementation SkinManager
- (instancetype)init {
    if (self = [super init]) {
        self.mainColor = JXColorHex(0x3d8158); // JXColorHex(0x66d6a6);
        self.navItemColor = [UIColor whiteColor];
        self.viewBgColor = JXColorHex(0xF5F5F5);
    }
    return self;
}

// 确定
- (void)configButtonStyle2:(UIButton *)button {
    button.titleLabel.font = JXFont(16.0f);
    button.backgroundColor = [UIColor clearColor];
    
    UIColor *titleColor = [UIColor whiteColor];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:[titleColor colorWithAlphaComponent:0.8]  forState:UIControlStateHighlighted];
    
    UIColor *bgColor = self.mainColor;
    [button setBackgroundImage:[UIImage jx_imageWithColor:bgColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage jx_imageWithColor:[bgColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
}

// 取消
- (void)configButtonStyle3:(UIButton *)button {
    button.titleLabel.font = JXFont(16.0f);
    button.backgroundColor = [UIColor clearColor];
    
    UIColor *titleColor = JXColorHex(0x999999);
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:[titleColor colorWithAlphaComponent:0.8]  forState:UIControlStateHighlighted];
    
    UIColor *bgColor = [UIColor whiteColor];
    [button setBackgroundImage:[UIImage jx_imageWithColor:bgColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage jx_imageWithColor:[bgColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
}

- (void)configAlertStyle {
    [[SIAlertView appearance] setTitleFont:JXFont(15)];
    [[SIAlertView appearance] setMessageFont:JXFont(13)];
    [[SIAlertView appearance] setButtonFont:JXFont(16)];
    [[SIAlertView appearance] setTitleColor:[UIColor blackColor]];
    [[SIAlertView appearance] setMessageColor:JXColorHex(0x333333)];
    [[SIAlertView appearance] setCornerRadius:8];
    //[[SIAlertView appearance] setShadowRadius:12];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    
    [[SIAlertView appearance] setCancelButtonColor:JXColorHex(0x999999)];
    [[SIAlertView appearance] setCancelButtonImage:[UIImage jx_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [[SIAlertView appearance] setCancelButtonImage:[UIImage jx_imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    
    [[SIAlertView appearance] setDefaultButtonImage:[UIImage jx_imageWithColor:self.mainColor] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDefaultButtonImage:[UIImage jx_imageWithColor:[self.mainColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    
    [[SIAlertView appearance] setTransitionStyle:SIAlertViewTransitionStyleBounce];
    [[SIAlertView appearance] setBackgroundStyle:SIAlertViewBackgroundStyleGradient];
    [[SIAlertView appearance] setButtonsListStyle:SIAlertViewButtonsListStyleNormal];
}

@end
