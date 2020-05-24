//
//  JXCaptchaButton.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXCaptchaButton.h"
#import "JXObjc.h"


@interface JXCaptchaButton ()
@property (nonatomic, assign) NSInteger durationBak;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JXCaptchaButton
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self custom];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(90, 30);
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Access methods
- (BOOL)isTiming {
    return _timer != nil;
}

- (void)setEnableTextColor:(UIColor *)enableTextColor {
    _enableTextColor = enableTextColor;
    [self jx_borderWithColor:_enableTextColor width:self.borderWidth radius:self.borderRadius];
    [self setTitleColor:_enableTextColor forState:UIControlStateNormal];
}

- (void)setEnableBgColor:(UIColor *)enableBgColor {
    _enableBgColor = enableBgColor;
    [self setBackgroundImage:[UIImage jx_imageWithColor:_enableBgColor] forState:UIControlStateNormal];
}

- (void)setDisableTextColor:(UIColor *)disableTextColor {
    _disableTextColor = disableTextColor;
    [self setTitleColor:_disableTextColor forState:UIControlStateDisabled];
}

- (void)setDisableBgColor:(UIColor *)disableBgColor {
    _disableBgColor = disableBgColor;
    [self setBackgroundImage:[UIImage jx_imageWithColor:_disableBgColor] forState:UIControlStateDisabled];
}

#pragma mark - Private methods
- (void)custom {
    _duration = 10;
    _enableTextColor = JXColorHex(0x29D8D6);
    _enableBgColor = [UIColor clearColor];
    _disableTextColor = JXColorHex(0xAAAAAA);
    _disableBgColor = JXColorHex(0xE5E5E5);
    
    _borderWidth = 1.0f;
    _borderRadius = 4.0f;
    
    self.titleLabel.font = JXFont(14); // [UIFont jx_deviceRegularFontOfSize:14];

    [self jx_borderWithColor:_enableTextColor width:self.borderWidth radius:self.borderRadius];
    [self setTitleColor:_enableTextColor forState:UIControlStateNormal];
    [self setTitleColor:_disableTextColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage jx_imageWithColor:_enableBgColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage jx_imageWithColor:_disableBgColor] forState:UIControlStateDisabled];
    
    [self setTitle:kStringGetCode forState:UIControlStateNormal];
    [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startTiming {
    if (self.timer) {
        return;
    }
    
    if (_startBlock) {
        if (_startBlock()) {
            _duration = _durationBak;
            
            [self setEnabled:NO];
            [self jx_borderWithColor:_disableBorderColor width:self.borderWidth radius:self.borderRadius];
            [self setTitle:[NSString stringWithFormat:@"%@(%@)", kStringReget, @(self.duration)] forState:UIControlStateDisabled];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
        }
    }
}

- (void)stopTimingWithTitle:(NSString *)title {
    [self setEnabled:YES];
    [self setTitle:title forState:UIControlStateNormal];
    [self jx_borderWithColor:_enableBorderColor width:self.borderWidth radius:self.borderRadius];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Action methods
- (void)pressed:(id)sender {
    [self startTiming];
}

- (void)scheduledTimer {
    if (1 == self.duration) {
        [self stopTimingWithTitle:kStringReget];
    }else {
        [self setTitle:[NSString stringWithFormat:@"%@(%@)", kStringReget, @(--self.duration)] forState:UIControlStateDisabled];
    }
}

#pragma mark - Public methods
- (void)setupWithEnableTextColor:(UIColor *)enableTextColor
                   enableBgColor:(UIColor *)enableBgColor
               enableBorderColor:(UIColor *)enableBorderColor
                disableTextColor:(UIColor *)disableTextColor
                  disableBgColor:(UIColor *)disableBgColor
              disableBorderColor:(UIColor *)disableBorderColor
                        duration:(NSInteger)duration {
    _enableTextColor = enableTextColor;
    _enableBgColor = enableBgColor;
    _enableBorderColor = enableBorderColor;
    _disableTextColor = disableTextColor;
    _disableBgColor = disableBgColor;
    _disableBorderColor = disableBorderColor;
    _durationBak = duration;
    
    
    [self setTitleColor:_enableTextColor forState:UIControlStateNormal];
    [self setTitleColor:_disableTextColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage jx_imageWithColor:_enableBgColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage jx_imageWithColor:_disableBgColor] forState:UIControlStateDisabled];
    [self jx_borderWithColor:_enableBorderColor width:self.borderWidth radius:self.borderRadius];
}

- (void)stopTiming {
    [self stopTimingWithTitle:kStringReget];
}

- (void)reset {
    [self stopTimingWithTitle:kStringGetCode];
}


@end
