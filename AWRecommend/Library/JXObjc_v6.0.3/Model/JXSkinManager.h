//
//  JXSkinManager.h
//  JXSamples
//
//  Created by 杨建祥 on 16/12/26.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXSkinManager : NSObject
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *viewBgColor;
@property (nonatomic, strong) UIColor *navItemColor;

- (void)configButtonStyle1:(UIButton *)button fontSize:(CGFloat)fontSize borderRadius:(CGFloat)borderRadius;

+ (instancetype)sharedInstance;

//@property (nonatomic, strong) UIColor *textColor;
//@property (nonatomic, strong) UIColor *textDarkColor;
//@property (nonatomic, strong) UIColor *textLightColor;
//@property (nonatomic, strong) UIColor *navBarColor;
//@property (nonatomic, strong) UIColor *viewBgColor;
//@property (nonatomic, strong) UIColor *borderColor;
//@property (nonatomic, strong) UIColor *groundColor;
//@property (nonatomic, strong) UIColor *placeholderColor;

//- (void)configButtonStyle1:(UIButton *)button;
//- (void)configButtonStyle2:(UIButton *)button;
//- (void)configButtonStyle3:(UIButton *)button;

// - (void)configAlertStyle;
@end
