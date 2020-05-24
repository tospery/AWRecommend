//
//  ResultHeaderView.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/6.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultHeaderView.h"

@implementation ResultHeaderView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(100));
}

@end
