//
//  JXBannerView.m
//  JXSamples
//
//  Created by 杨建祥 on 16/5/15.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXBannerView.h"

@interface JXBannerView ()
//@property (nonatomic, assign, readwrite) NSUInteger total;

@end

@implementation JXBannerView
//@dynamic total;

- (void)customInit {
    [super customInit];
    
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.height.equalTo(@(kJXStdPageHeight));
    }];
    
    RAC(self.pageControl, numberOfPages) = RACObserve(self, total);
    RAC(self.pageControl, currentPage) = RACObserve(self, currentIndex);
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.enabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}

@end
