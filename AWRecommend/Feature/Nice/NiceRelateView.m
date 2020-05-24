//
//  NiceRelateView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/19.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceRelateView.h"

@interface NiceRelateView ()
// @property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation NiceRelateView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.adjustsImageWhenHighlighted = NO;
        [_iconButton setBackgroundImage:kJXImagePHSquare forState:UIControlStateNormal];
        [_iconButton addTarget:self action:@selector(iconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_iconButton];
        [_iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.trailing.equalTo(self).offset(-10);
            make.width.equalTo(self.iconButton.mas_height);
        }];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = JXFont(13);
        _nameLabel.textColor = JXColorHex(0x333333);
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.top.equalTo(self.iconButton.mas_bottom).offset(8);
            make.trailing.equalTo(self).offset(-10);
        }];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = JXFont(13);
        _priceLabel.textColor = SMInstance.mainColor;
        _priceLabel.numberOfLines = 1;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.trailing.equalTo(self).offset(-10);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return self;
}

- (void)setR:(NiceRelate *)r {
    _r = r;
    
    self.iconButton.tag = r.jxID.integerValue;
    [self.iconButton sd_setBackgroundImageWithURL:JXURLWithStr(r.articleTitleImage) forState:UIControlStateNormal placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = r.articleTitle;
    self.priceLabel.text = r.articlePrice;
}

- (void)iconButtonPressed:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock(self.r);
    }
}

@end
