//
//  JXCaptchaButton.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^JXCaptchaButtonStartBlock)(void);

@interface JXCaptchaButton : UIButton
@property (nonatomic, copy) JXCaptchaButtonStartBlock startBlock;
@property (nonatomic, assign, readonly) BOOL isTiming;
// @property (nonatomic, assign) BOOL disableBorder;

@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) UIColor *enableTextColor;
@property (nonatomic, strong) UIColor *enableBgColor;
@property (nonatomic, strong) UIColor *enableBorderColor;
@property (nonatomic, strong) UIColor *disableTextColor;
@property (nonatomic, strong) UIColor *disableBgColor;
@property (nonatomic, strong) UIColor *disableBorderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat borderRadius;

- (void)setupWithEnableTextColor:(UIColor *)enableTextColor
                   enableBgColor:(UIColor *)enableBgColor
               enableBorderColor:(UIColor *)enableBorderColor
                disableTextColor:(UIColor *)disableTextColor
                  disableBgColor:(UIColor *)disableBgColor
              disableBorderColor:(UIColor *)disableBorderColor
                        duration:(NSInteger)duration;

- (void)startTiming;
- (void)stopTiming;
- (void)reset;

@end
