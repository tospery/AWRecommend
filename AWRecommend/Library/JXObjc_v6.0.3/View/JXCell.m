//
//  JXCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXCell.h"

@implementation JXCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView bringSubviewToFront:self.separatorImageView];
    [self.contentView bringSubviewToFront:self.accessoryImageView];
}

- (void)custom {
    self.textLabel.font = JXFont(14);
    self.textLabel.textColor = JXColorHex(0x333333);
    
    [self addSubview:self.separatorImageView];
    [self.separatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.equalTo(@1);
    }];
    
    [self.contentView addSubview:self.accessoryImageView];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-12.0f);
        make.width.equalTo(@(JXAdaptScreen(16)));
        make.height.equalTo(@(JXAdaptScreen(16)));
    }];
    
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-8.0f);
    }];
}

- (UIImageView *)separatorImageView {
    if (!_separatorImageView) {
        _separatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _separatorImageView.backgroundColor = JXColorHex(0xE7E7E7);
    }
    return _separatorImageView;
}

- (UIImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _accessoryImageView.image = JXAdaptImage(JXImageWithName(@"jxres_arrow_right_blank"));
        _accessoryImageView.hidden = YES;
    }
    return _accessoryImageView;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textColor = JXColorHex(0x888888);
        _rightLabel.font = JXFont(14.0f);
        _rightLabel.hidden = YES;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

@end




