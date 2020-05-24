//
//  CompClassifyCoverView.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompClassifyCoverView.h"

@interface CompClassifyCoverView ()

@end

@implementation CompClassifyCoverView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.font = JXFont(9);
    self.textLabel.backgroundColor = SMInstance.mainColor;
    self.textLabel.textColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(self.textLabel.jx_x, self.textLabel.jx_y, self.textLabel.jx_width + 8, self.textLabel.jx_height + 2);
    [self.textLabel jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
}

@end
