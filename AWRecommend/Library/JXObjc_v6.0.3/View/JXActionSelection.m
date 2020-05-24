//
//  JXActionSelection.m
//  JXSamples
//
//  Created by 杨建祥 on 16/6/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXActionSelection.h"
#import "JXActionSelectionContent.h"

//@implementation JXActionSelectionContent
//
//@end

@interface JXActionSelection ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation JXActionSelection
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
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor clearColor];
//    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)]];
    [_backgroundView addGestureRecognizer:self.tapGesture];
    [self addSubview:_backgroundView];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //    if (JXiOSVersionGreaterThanOrEqual(8.0)) {
    //        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    //        effectView.alpha = 0.7f;
    //        [_backgroundView addSubview:effectView];
    //        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.edges.equalTo(self.backgroundView);
    //        }];
    //    }else {
    //    UIView *alphaView = [[UIView alloc] init];
    //    alphaView.backgroundColor = [UIColor blackColor];
    //    alphaView.alpha = 0.5f;
    //    [_backgroundView addSubview:alphaView];
    //    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.backgroundView);
    //    }];
    // }
    
    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.5f;
    [_backgroundView addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView);
    }];
}

- (void)bindModel {
    @weakify(self)
    [RACObserve(self, isAnimating) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if (x.boolValue) {
            [self.backgroundView removeGestureRecognizer:self.tapGesture];
        }else {
            [self.backgroundView addGestureRecognizer:self.tapGesture];
        }
    }];
}

- (CGFloat)contentHeight {
    if (0 == _contentHeight) {
        _contentHeight = CGRectGetHeight(self.contentView.frame);
    }
    return _contentHeight;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    }
    return _tapGesture;
}

- (void)tapRecognizer:(UITapGestureRecognizer *)recognizer {
//    if (_isAnimating) {
//        return;
//    }
    
    _isAnimating = YES;
    if ([_delegate respondsToSelector:@selector(actionSelection:didSelectIndex:withObject:)]) {
        [_delegate actionSelection:self didSelectIndex:(self.tag - JXActionBarTagBegin) withObject:nil];
    }
}

#pragma mark - Accessor methods
- (void)setContentView:(JXActionSelectionContent *)contentView {
    _contentView = contentView;
    [self addSubview:_contentView];
}
@end

