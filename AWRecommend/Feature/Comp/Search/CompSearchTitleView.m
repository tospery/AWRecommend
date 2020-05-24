//
//  SearchTitleView.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompSearchTitleView.h"

@implementation CompSearchTitleView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //CGFloat width =
    
    self.frame = CGRectMake(0, 0, JXScreenScale(240), 30);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
}

@end
