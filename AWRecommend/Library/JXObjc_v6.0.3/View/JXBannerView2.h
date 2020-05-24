//
//  JXBannerView2.h
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/2.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXBannerView2;

@protocol JXBannerView2DataSource <NSObject>
@optional
- (UIImage *)bannerView:(JXBannerView2 *)bannerView imageAtIndex:(NSInteger)index;
- (NSURL *)bannerView:(JXBannerView2 *)bannerView urlAtIndex:(NSInteger)index;

@end

@protocol JXBannerView2Delegate <NSObject>
@optional
- (void)bannerView:(JXBannerView2 *)filterView didSelectAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, JXBannerView2Direction){
    JXBannerView2DirectionLandscape,
    JXBannerView2DirectionPortait
};

@interface JXBannerView2 : UIView <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, weak) IBOutlet id<JXBannerView2DataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<JXBannerView2Delegate> delegate;

- (void)setupWithLocalImages:(NSArray *)images
                      tapped:(void(^)(NSInteger index))tapped;

- (void)setupWithWebImages:(NSArray *)urlStrings
                    cached:(void(^)())cached
                    tapped:(void(^)(NSInteger index))tapped;

- (void)startRolling;
@end



