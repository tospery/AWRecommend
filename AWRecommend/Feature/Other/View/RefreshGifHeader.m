//
//  RefreshGifHeader.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/19.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "RefreshGifHeader.h"

@implementation RefreshGifHeader
- (void)prepare {
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=19; i++) {
        UIImage *image = image = [UIImage imageNamed:[NSString stringWithFormat:@"icon00%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=20; i++) {
        //UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_loading_0%zd", i]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:1.2 forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:1.2 forState:MJRefreshStateRefreshing];
}

@end
