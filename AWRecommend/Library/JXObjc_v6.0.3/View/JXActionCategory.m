//
//  JXActionCategory.m
//  JXSamples
//
//  Created by 杨建祥 on 16/6/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXActionCategory.h"

@interface JXActionCategory ()

@end

@implementation JXActionCategory
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customInit];
        [self bindModel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self customInit];
        [self bindModel];
    }
    return self;
}

#pragma mark - Private methods
- (void)customInit {
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.tintColor = [UIColor blackColor];
    _titleLabel.font = JXFont(15.0f); // [UIFont jx_deviceRegularFontOfSize:15.0f];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    _indicatorImageView = [[UIImageView alloc] initWithImage:JXImageWithName(@"jxres_arrow_down_gray")];
    [self addSubview:_indicatorImageView];
    [_indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(2);
    }];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_actionButton];
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)bindModel {
    @weakify(self)
    [RACObserve(self, isAnimating) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if (x.boolValue) {
            [self.actionButton removeTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [self.actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

#pragma mark - Action methods
- (void)buttonPressed:(UIButton *)button {
//    if (_isAnimating) {
//        return;
//    }
    
    _isAnimating = YES;
    button.selected = !button.selected;
    if ([_delegate respondsToSelector:@selector(actionCategory:didSelectIndex:)]) {
        [_delegate actionCategory:self didSelectIndex:self.tag];
    }
}
@end