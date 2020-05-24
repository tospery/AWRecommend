//
//  SettingAvatarCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/25.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SettingAvatarCell.h"

@implementation SettingAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height{
    return JXScreenScale(70.0f);
}

@end
