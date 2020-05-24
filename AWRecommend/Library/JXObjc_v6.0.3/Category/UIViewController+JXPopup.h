//
//  UIViewController+JXPopup.h
//  JXSamples
//
//  Created by 杨建祥 on 16/11/10.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 1. 添加动画 --- 已完成
 2. 添加位置 --- 已完成
 3. 添加回调 --- 待完成（isBeingShown，isShowing，isBeingDismissed）
 4. 关闭方式 --- 已完成
 5. 动画时间
 6. 适配屏幕 --- 已完成
 7. 适配文本
 8. 添加背景
 9. 代码复用
 */

@class JXPopupBackgroundView;

#pragma mark - 动画类型
typedef NS_ENUM(NSInteger, JXPopupShowType){
    JXPopupShowTypeNone,
    JXPopupShowTypeFadeIn,
    JXPopupShowTypeGrowIn,
    JXPopupShowTypeShrinkIn,
    JXPopupShowTypeSlideInFromTop,
    JXPopupShowTypeSlideInFromBottom,
    JXPopupShowTypeSlideInFromLeft,
    JXPopupShowTypeSlideInFromRight,
    JXPopupShowTypeBounceIn,
    JXPopupShowTypeBounceInFromTop,
    JXPopupShowTypeBounceInFromBottom,
    JXPopupShowTypeBounceInFromLeft,
    JXPopupShowTypeBounceInFromRight
};

typedef NS_ENUM(NSInteger, JXPopupDismissType){
    JXPopupDismissTypeNone,
    JXPopupDismissTypeFadeOut,
    JXPopupDismissTypeGrowOut,
    JXPopupDismissTypeShrinkOut,
    JXPopupDismissTypeSlideOutToTop,
    JXPopupDismissTypeSlideOutToBottom,
    JXPopupDismissTypeSlideOutToLeft,
    JXPopupDismissTypeSlideOutToRight,
    JXPopupDismissTypeBounceOut,
    JXPopupDismissTypeBounceOutToTop,
    JXPopupDismissTypeBounceOutToBottom,
    JXPopupDismissTypeBounceOutToLeft,
    JXPopupDismissTypeBounceOutToRight,
};

#pragma mark - 位置类型
typedef NS_ENUM(NSInteger, JXPopupLayoutHorizontal) {
    JXPopupLayoutHorizontalCustom = 0,
    JXPopupLayoutHorizontalLeft,
    JXPopupLayoutHorizontalLeadCenter,
    JXPopupLayoutHorizontalCenter,
    JXPopupLayoutHorizontalTrailCenter,
    JXPopupLayoutHorizontalRight,
};

typedef NS_ENUM(NSInteger, JXPopupLayoutVertical) {
    JXPopupLayoutVerticalCustom = 0,
    JXPopupLayoutVerticalTop,
    JXPopupLayoutVerticalAboveCenter,
    JXPopupLayoutVerticalCenter,
    JXPopupLayoutVerticalBelowCenter,
    JXPopupLayoutVerticalBottom,
};

struct JXPopupLayout {
    JXPopupLayoutHorizontal horizontal;
    JXPopupLayoutVertical vertical;
};
typedef struct JXPopupLayout JXPopupLayout;

extern JXPopupLayout JXPopupLayoutMake(JXPopupLayoutHorizontal horizontal, JXPopupLayoutVertical vertical);
extern const JXPopupLayout JXPopupLayoutCenter;


@interface UIViewController (JXPopup)
// @property (nonatomic, assign) CGFloat jx_popupDurationTime;
@property (nonatomic, retain) UIViewController *jx_popupViewController;
@property (nonatomic, retain) JXPopupBackgroundView *jx_popupBackgroundView;

- (void)jx_presentPopupViewController:(UIViewController*)popupViewController animationType:(JXPopupShowType)animationType layout:(JXPopupLayout)layout bgTouch:(BOOL)bgTouch dismissed:(void(^)(void))dismissed;
- (void)jx_dismissPopupViewControllerWithAnimationType:(JXPopupDismissType)animationType;
- (void)jx_dismissPopupViewControllerWithAnimationType:(JXPopupDismissType)animationType dismissed:(void(^)(void))dismissed;
@end











