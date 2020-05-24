//
//  MytestIntro.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/12/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MytestIntro.h"

@implementation MytestIntro
- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat width = JXAdaptScreen(280);
    CGFloat height = width / 280.0 * 442.0f;
    self.frame = CGRectMake(0, 0, width, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
}

@end
