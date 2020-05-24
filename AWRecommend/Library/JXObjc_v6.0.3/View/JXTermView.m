//
//  JXTermView.m
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/12.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//


#import "JXTermView.h"
#import "VBFPopFlatButton.h"
#import "JXObjc.h"

@interface JXTermView ()
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) VBFPopFlatButton *checkButton;
@end

@implementation JXTermView
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

#pragma mark - Private methods
- (void)custom {
    CGFloat side = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
    CGFloat adopt = side / 5 * 3;
    CGFloat offset = (side - adopt) / 2;
    
    CGRect frame = CGRectMake(offset, offset, adopt, adopt);
    _borderView = [[UIView alloc] initWithFrame:frame];
    [_borderView jx_borderWithColor:[UIColor orangeColor] width:2.0f radius:4.0f];
    [self addSubview:_borderView];
    
    frame = CGRectMake(adopt / 5 + offset,
                       offset,
                       adopt / 5 * 3,
                       adopt / 5 * 4);
    _checkButton = [[VBFPopFlatButton alloc] initWithFrame:frame
                                                buttonType:buttonOkType
                                               buttonStyle:buttonPlainStyle
                                     animateToInitialState:NO];
    _checkButton.lineThickness = 2.5;
    _checkButton.tintColor = [UIColor orangeColor];
    _checkButton.hidden = YES;
    [self addSubview:_checkButton];
    
    UIButton *fgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fgButton.frame = self.bounds;
    [fgButton addTarget:self action:@selector(fgButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fgButton];
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Accessor methods
- (BOOL)checked {
    return !_checkButton.hidden;
}

- (void)setChecked:(BOOL)checked {
    [_checkButton setHidden:!checked];
}

#pragma mark - Action methods
- (void)fgButtonPressed:(id)sender {
    [_checkButton setHidden:!_checkButton.hidden];
}

#pragma mark - Public methods
- (void)configColor:(UIColor *)color{
    [_borderView jx_borderWithColor:color width:2.0f radius:4.0f];
    _checkButton.tintColor = color;
}
@end
