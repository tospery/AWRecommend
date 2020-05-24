//
//  UIViewController+JXPopup.m
//  JXSamples
//
//  Created by 杨建祥 on 16/11/10.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIViewController+JXPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "JXPopupBackgroundView.h"
#import <objc/runtime.h>

#define kJXPopupAnimationDuration               (0.25)
#define kJXPopupDurationTime                    (@"kJXPopupDurationTime")
#define kJXPopupViewController                  (@"kJXPopupViewController")
#define kJXPopupBackgroundView                  (@"kJXPopupBackgroundView")
#define kJXSourceViewTag                        (73941)
#define kJXPopupViewTag                         (73942)
#define kJXOverlayViewTag                       (73945)

static NSInteger const kJXPopupAnimationOptionCurveIOS7 = (7 << 16);
static NSString *kJXPopupViewDismissedKey = @"kJXPopupViewDismissedKey";

JXPopupLayout JXPopupLayoutMake(JXPopupLayoutHorizontal horizontal, JXPopupLayoutVertical vertical) {
    JXPopupLayout layout;
    layout.horizontal = horizontal;
    layout.vertical = vertical;
    return layout;
}

const JXPopupLayout JXPopupLayoutCenter = {JXPopupLayoutHorizontalCenter, JXPopupLayoutVerticalCenter};

@interface UIViewController (JXPopupPrivate)
- (UIView*)jx_topView;
- (void)presentPopupView:(UIView*)popupView;
@end

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

@implementation UIViewController (JXPopup)

static void * const keypath = (void*)&keypath;

//- (CGFloat)jx_popupDurationTime {
//    return [objc_getAssociatedObject(self, kJXPopupDurationTime) integerValue];
//}
//
//- (void)setJx_popupDurationTime:(CGFloat)durationTime {
//    objc_setAssociatedObject(self, kJXPopupDurationTime, @(durationTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (UIViewController*)jx_popupViewController {
    return objc_getAssociatedObject(self, kJXPopupViewController);
}

- (void)setJx_popupViewController:(UIViewController *)jx_popupViewController {
    objc_setAssociatedObject(self, kJXPopupViewController, jx_popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JXPopupBackgroundView*)jx_popupBackgroundView {
    return objc_getAssociatedObject(self, kJXPopupBackgroundView);
}

- (void)setJx_popupBackgroundView:(JXPopupBackgroundView *)jx_popupBackgroundView {
    objc_setAssociatedObject(self, kJXPopupBackgroundView, jx_popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

//- (void)presentPopupViewController:(UIViewController *)popupViewController animationType:(JXPopupShowType)animationType {
//    [self presentPopupViewController:popupViewController animationType:animationType layout:JXPopupLayoutCenter dismissed:nil];
//}
//
//- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(JXPopupShowType)animationType dismissed:(void(^)(void))dismissed {
//    [self presentPopupViewController:popupViewController animationType:animationType layout:JXPopupLayoutCenter dismissed:dismissed];
//}
//
//- (void)presentPopupViewController:(UIViewController *)popupViewController animationType:(JXPopupShowType)animationType layout:(JXPopupLayout)layout {
//    [self presentPopupViewController:popupViewController animationType:animationType layout:layout dismissed:nil];
//}

- (void)jx_presentPopupViewController:(UIViewController*)popupViewController animationType:(JXPopupShowType)animationType layout:(JXPopupLayout)layout bgTouch:(BOOL)bgTouch dismissed:(void(^)(void))dismissed {
    self.jx_popupViewController = popupViewController;
    [self presentPopupView:popupViewController.view animationType:animationType layout:layout bgTouch:bgTouch dismissed:dismissed];
}

- (void)jx_dismissPopupViewControllerWithAnimationType:(JXPopupDismissType)animationType {
    [self jx_dismissPopupViewControllerWithAnimationType:animationType dismissed:NULL];
}

- (void)jx_dismissPopupViewControllerWithAnimationType:(JXPopupDismissType)animationType dismissed:(void(^)(void))dismissed {
    UIView *sourceView = [self jx_topView];
    UIView *popupView = [sourceView viewWithTag:kJXPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kJXOverlayViewTag];
    
    //    switch (animationType) {
    //        case JXPopupDismissTypeNone:
    //            [self hideViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case JXPopupDismissTypeFadeOut:
    //            [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case JXPopupDismissTypeGrowOut:
    //            [self growViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case JXPopupDismissTypeShrinkOut:
    //            [self shrinkViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case JXPopupDismissTypeSlideOutToTop:
    //        case JXPopupDismissTypeSlideOutToBottom:
    //        case JXPopupDismissTypeSlideOutToLeft:
    //        case JXPopupDismissTypeSlideOutToRight:
    //            [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    //            break;
    //        case JXPopupDismissTypeBounceOut:
    //        case JXPopupDismissTypeBounceOutToTop:
    //        case JXPopupDismissTypeBounceOutToBottom:
    //        case JXPopupDismissTypeBounceOutToLeft:
    //        case JXPopupDismissTypeBounceOutToRight:
    //            [self bounceViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    //            break;
    //        default:
    //            break;
    //    }
    [self hideViewIn:popupView sourceView:sourceView overlayView:overlayView animationType:animationType];
    [self setDismissedCallback:dismissed];
}

#pragma mark - Private
- (CGRect)getEndRectWithPopupView:(UIView *)popupView popupSize:(CGSize)popupSize sourceSize:(CGSize)sourceSize animationIndex:(NSInteger)animationIndex {
    CGRect endRect = CGRectZero;
    switch (animationIndex) {
        case 0:
            break;
        case 1:
            endRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                 -popupSize.height,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        case 2:
            endRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                 sourceSize.height,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        case 3:
            endRect = CGRectMake(-popupSize.width,
                                 popupView.frame.origin.y,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        case 4:
            endRect = CGRectMake(sourceSize.width,
                                 popupView.frame.origin.y,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        default:
            JXLogDebug(@"不支持的动画类型！");
            break;
    }
    return endRect;
}


////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling
//- (void)presentPopupView:(UIView *)popupView animationType:(JXPopupShowType)animationType {
//    [self presentPopupView:popupView animationType:animationType layout:JXPopupLayoutCenter dismissed:nil];
//}

- (void)presentPopupView:(UIView *)popupView animationType:(JXPopupShowType)animationType layout:(JXPopupLayout)layout bgTouch:(BOOL)bgTouch dismissed:(void(^)(void))dismissed {
    UIView *sourceView = [self jx_topView];
    sourceView.tag = kJXSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kJXPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kJXOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    self.jx_popupBackgroundView = [[JXPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
    self.jx_popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.jx_popupBackgroundView.backgroundColor = [UIColor clearColor];
    self.jx_popupBackgroundView.alpha = 0.0f;
    [overlayView addSubview:self.jx_popupBackgroundView];
    
    // Make the Background Clickable
    if (bgTouch) {
        UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = sourceView.bounds;
        dismissButton.tag = animationType;
        [dismissButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview:dismissButton];
    }
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
    [self showViewIn:popupView sourceView:sourceView overlayView:overlayView animationType:animationType layout:layout];
    [self setDismissedCallback:dismissed];
}

-(UIView*)jx_topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

- (void)dismissButtonPressed:(UIButton *)sender {
    [self jx_dismissPopupViewControllerWithAnimationType:(JXPopupDismissType)sender.tag];
//    if ([sender isKindOfClass:[UIButton class]]) {
//        UIButton* dismissButton = sender;
////        switch (dismissButton.tag) {
////                //            case JXPopupViewAnimationSlideBottomTop:
////                //            case JXPopupViewAnimationSlideBottomBottom:
////                //            case JXPopupViewAnimationSlideTopTop:
////                //            case JXPopupViewAnimationSlideTopBottom:
////                //            case JXPopupViewAnimationSlideLeftLeft:
////                //            case JXPopupViewAnimationSlideLeftRight:
////                //            case JXPopupViewAnimationSlideRightLeft:
////                //            case JXPopupViewAnimationSlideRightRight:
////                //                [self dismissPopupViewControllerWithanimationType:(JXPopupViewAnimation)dismissButton.tag];
////                //                break;
////                //            default:
////                //                [self dismissPopupViewControllerWithanimationType:JXPopupViewAnimationFade];
////                //                break;
////            case JXPopupDismissTypeFadeOut:
////                break;
////            default:
////                break;
////        }
//        [self dismissPopupViewControllerWithanimation:<#(id)#>]
//    } else {
//        // [self dismissPopupViewControllerWithanimationType:JXPopupViewAnimationFade];
//    }
}

//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Animations
- (void)showViewIn:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView animationType:(JXPopupShowType)animationType layout:(JXPopupLayout)layout {
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size; // popupView.frame.size;

    CGRect containerFrame = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                       (sourceSize.height - popupSize.height) / 2,
                                       popupSize.width,
                                       popupSize.height);
    
    CGRect finalContainerFrame = containerFrame;
    UIViewAutoresizing containerAutoresizingMask = UIViewAutoresizingNone;
    
    switch (layout.horizontal) {
            
        case JXPopupLayoutHorizontalLeft: {
            finalContainerFrame.origin.x = 0.0;
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case JXPopupLayoutHorizontalLeadCenter: {
            finalContainerFrame.origin.x = floorf(CGRectGetWidth(sourceView.bounds)/3.0 - CGRectGetWidth(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case JXPopupLayoutHorizontalCenter: {
            finalContainerFrame.origin.x = floorf((CGRectGetWidth(sourceView.bounds) - CGRectGetWidth(containerFrame))/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case JXPopupLayoutHorizontalTrailCenter: {
            finalContainerFrame.origin.x = floorf(CGRectGetWidth(sourceView.bounds)*2.0/3.0 - CGRectGetWidth(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case JXPopupLayoutHorizontalRight: {
            finalContainerFrame.origin.x = CGRectGetWidth(sourceView.bounds) - CGRectGetWidth(containerFrame);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin;
            break;
        }
            
        default:
            break;
    }
    
    // Vertical
    switch (layout.vertical) {
        case JXPopupLayoutVerticalTop: {
            finalContainerFrame.origin.y = 0;
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case JXPopupLayoutVerticalAboveCenter: {
            finalContainerFrame.origin.y = floorf(CGRectGetHeight(sourceView.bounds)/3.0 - CGRectGetHeight(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case JXPopupLayoutVerticalCenter: {
            finalContainerFrame.origin.y = floorf((CGRectGetHeight(sourceView.bounds) - CGRectGetHeight(containerFrame))/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case JXPopupLayoutVerticalBelowCenter: {
            finalContainerFrame.origin.y = floorf(CGRectGetHeight(sourceView.bounds)*2.0/3.0 - CGRectGetHeight(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case JXPopupLayoutVerticalBottom: {
            finalContainerFrame.origin.y = CGRectGetHeight(sourceView.bounds) - CGRectGetHeight(containerFrame);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin;
            break;
        }
            
        default:
            break;
    }
    
    popupView.autoresizingMask = containerAutoresizingMask;
    void (^animationBlock)() = ^() {
        [self.jx_popupViewController viewWillAppear:NO];
        self.jx_popupBackgroundView.alpha = 0.5f;
    };
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        [self.jx_popupViewController viewDidAppear:NO];
    };
    
//    CGFloat durationTime = self.jx_popupDurationTime;
//    if (!durationTime) {
//        durationTime = kJXPopupAnimationDuration;
//    }
    
    CGFloat durationTime = kJXPopupAnimationDuration;
    
    switch (animationType) {
        case JXPopupShowTypeNone: {
            animationBlock();
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            popupView.frame = finalContainerFrame;
            completionBlock(YES);
            break;
        }
        case JXPopupShowTypeFadeIn: {
            popupView.frame = finalContainerFrame;
            popupView.alpha = 0.0f;
            [UIView animateWithDuration:durationTime animations:^{
                animationBlock();
                popupView.alpha = 1.0f;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeGrowIn: {
            popupView.alpha = 0.0;
            popupView.frame = finalContainerFrame; // set frame before transform here...
            popupView.transform = CGAffineTransformMakeScale(0.85, 0.85);
            [UIView animateWithDuration:(durationTime / 2.0) delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 1.0;
                popupView.transform = CGAffineTransformIdentity; // set transform before frame here...
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeShrinkIn: {
            popupView.alpha = 0.0;
            popupView.frame = finalContainerFrame;
            popupView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            [UIView animateWithDuration:(durationTime / 2.0) delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 1.0;
                popupView.transform = CGAffineTransformIdentity; // set transform before frame here...
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeSlideInFromTop: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = -CGRectGetHeight(finalContainerFrame);
            popupView.frame = startFrame;
            

            [UIView animateWithDuration:durationTime delay:0.0f options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeSlideInFromBottom: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = CGRectGetHeight(sourceView.bounds);
            popupView.frame = startFrame;

            [UIView animateWithDuration:durationTime delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeSlideInFromLeft: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = -CGRectGetWidth(finalContainerFrame);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:durationTime delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeSlideInFromRight: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = CGRectGetWidth(sourceView.bounds);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:durationTime delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeBounceIn: {
            popupView.alpha = 0.0;
            // set frame before transform here...
            CGRect startFrame = finalContainerFrame;
            popupView.frame = startFrame;
            popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:15.0 options:0 animations:^{
                animationBlock();
                popupView.alpha = 1.0;
                popupView.transform = CGAffineTransformIdentity;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeBounceInFromTop: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = -CGRectGetHeight(finalContainerFrame);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeBounceInFromBottom: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = CGRectGetHeight(sourceView.bounds);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeBounceInFromLeft: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = -CGRectGetWidth(finalContainerFrame);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupShowTypeBounceInFromRight: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = CGRectGetWidth(sourceView.bounds);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        default:
            break;
    }
}

- (void)hideViewIn:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView animationType:(JXPopupDismissType)animationType {
//    CGFloat durationTime = self.jx_popupDurationTime;
//    if (!durationTime) {
//        durationTime = kJXPopupAnimationDuration;
//    }
    
    CGFloat durationTime = kJXPopupAnimationDuration;
    
    NSTimeInterval duration1 = (durationTime / 2.0);
    NSTimeInterval duration2 = durationTime;
    void (^animationBlock)() = ^() {
        [self.jx_popupViewController viewWillDisappear:NO];
        self.jx_popupBackgroundView.alpha = 0.0f;
    };
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.jx_popupViewController viewDidDisappear:NO];
        self.jx_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil) {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    };
    
    switch (animationType) {
        case JXPopupDismissTypeNone: {
            animationBlock();
            popupView.alpha = 0.0f;
            completionBlock(YES);
            break;
        }
        case JXPopupDismissTypeFadeOut: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                animationBlock();
                popupView.alpha = 0.0;
            } completion:completionBlock];
            break;
        }
        case JXPopupDismissTypeGrowOut: {
            [UIView animateWithDuration:duration1 delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 0.0;
                popupView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:completionBlock];
            break;
        }
        case JXPopupDismissTypeShrinkOut: {
            [UIView animateWithDuration:duration1 delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 0.0;
                popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:completionBlock];
            break;
        }
        case JXPopupDismissTypeSlideOutToTop: {
            [UIView animateWithDuration:durationTime delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y = -CGRectGetHeight(finalFrame);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupDismissTypeSlideOutToBottom: {
            [UIView animateWithDuration:durationTime delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y = CGRectGetHeight(sourceView.bounds);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupDismissTypeSlideOutToLeft: {
            [UIView animateWithDuration:durationTime delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x = -CGRectGetWidth(finalFrame);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupDismissTypeSlideOutToRight: {
            [UIView animateWithDuration:durationTime delay:0 options:kJXPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x = CGRectGetWidth(sourceView.bounds);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case JXPopupDismissTypeBounceOut: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                popupView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    popupView.alpha = 0.0;
                    popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                } completion:completionBlock];
            }];
            break;
        }
        case JXPopupDismissTypeBounceOutToTop: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y += 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.y = -CGRectGetHeight(finalFrame);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        case JXPopupDismissTypeBounceOutToBottom: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y -= 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.y = CGRectGetHeight(sourceView.bounds);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        case JXPopupDismissTypeBounceOutToLeft: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x += 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.x = -CGRectGetWidth(finalFrame);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        case JXPopupDismissTypeBounceOutToRight: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x -= 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.x = CGRectGetWidth(sourceView.bounds);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        default:
            break;
    }
}

//#pragma mark --- None
//- (void)showViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                     (sourceSize.height - popupSize.height) / 2,
//                                     popupSize.width,
//                                     popupSize.height);
//    // show
//    [self.jx_popupViewController viewWillAppear:NO];
//    self.jx_popupBackgroundView.alpha = 0.5f;
//    popupView.alpha = 1.0;
//    // finish
//    popupView.transform = CGAffineTransformIdentity;
//    popupView.frame = popupEndRect;
//    [self.jx_popupViewController viewDidAppear:NO];
//}
//
//- (void)hideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    // hide
//    [self.jx_popupViewController viewWillDisappear:NO];
//    self.jx_popupBackgroundView.alpha = 0.0f;
//    popupView.alpha = 0.0f;
//    // finish
//    [popupView removeFromSuperview];
//    [overlayView removeFromSuperview];
//    [self.jx_popupViewController viewDidDisappear:NO];
//    self.jx_popupViewController = nil;
//    
//    id dismissed = [self dismissedCallback];
//    if (dismissed != nil)
//    {
//        ((void(^)(void))dismissed)();
//        [self setDismissedCallback:nil];
//    }
//}
//
//#pragma mark --- Fade
//- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                     (sourceSize.height - popupSize.height) / 2,
//                                     popupSize.width,
//                                     popupSize.height);
//    
//    // Set starting properties
//    popupView.frame = popupEndRect;
//    popupView.alpha = 0.0f;
//    
//    [UIView animateWithDuration:durationTime animations:^{
//        [self.jx_popupViewController viewWillAppear:NO];
//        self.jx_popupBackgroundView.alpha = 0.5f;
//        popupView.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//        [self.jx_popupViewController viewDidAppear:NO];
//    }];
//}
//
//- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    [UIView animateWithDuration:durationTime animations:^{
//        [self.jx_popupViewController viewWillDisappear:NO];
//        self.jx_popupBackgroundView.alpha = 0.0f;
//        popupView.alpha = 0.0f;
//    } completion:^(BOOL finished) {
//        [popupView removeFromSuperview];
//        [overlayView removeFromSuperview];
//        [self.jx_popupViewController viewDidDisappear:NO];
//        self.jx_popupViewController = nil;
//        
//        id dismissed = [self dismissedCallback];
//        if (dismissed != nil)
//        {
//            ((void(^)(void))dismissed)();
//            [self setDismissedCallback:nil];
//        }
//    }];
//}
//
//#pragma mark --- Grow
//- (void)growViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                     (sourceSize.height - popupSize.height) / 2,
//                                     popupSize.width,
//                                     popupSize.height);
//    
//    popupView.alpha = 0.0;
//    popupView.frame = popupEndRect; // set frame before transform here...
//    popupView.transform = CGAffineTransformMakeScale(0.85, 0.85);
//    
//    [UIView animateWithDuration:(durationTime / 2.0)
//                          delay:0
//                        options:kJXPopupAnimationOptionCurveIOS7 // note: this curve ignores durations
//                     animations:^{
//                         [self.jx_popupViewController viewWillAppear:NO];
//                         self.jx_popupBackgroundView.alpha = 0.5f;
//                         
//                         popupView.alpha = 1.0;
//                         popupView.transform = CGAffineTransformIdentity; // set transform before frame here...
//                         popupView.frame = popupEndRect;
//                     }
//                     completion:^(BOOL finished) {
//                         [self.jx_popupViewController viewDidAppear:NO];
//                     }];
//}
//
//- (void)growViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    [UIView animateWithDuration:(durationTime / 2.0)
//                          delay:0
//                        options:kJXPopupAnimationOptionCurveIOS7
//                     animations:^{
//                         [self.jx_popupViewController viewWillDisappear:NO];
//                         self.jx_popupBackgroundView.alpha = 0.0f;
//                         popupView.alpha = 0.0f;
//                         popupView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//                     } completion:^(BOOL finished) {
//                         [popupView removeFromSuperview];
//                         [overlayView removeFromSuperview];
//                         [self.jx_popupViewController viewDidDisappear:NO];
//                         self.jx_popupViewController = nil;
//                         
//                         id dismissed = [self dismissedCallback];
//                         if (dismissed != nil)
//                         {
//                             ((void(^)(void))dismissed)();
//                             [self setDismissedCallback:nil];
//                         }
//                     }];
//}
//
//#pragma mark --- Shrink
//- (void)shrinkViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                     (sourceSize.height - popupSize.height) / 2,
//                                     popupSize.width,
//                                     popupSize.height);
//    
//    // Set starting properties
//    popupView.alpha = 0.0;
//    popupView.frame = popupEndRect;
//    popupView.transform = CGAffineTransformMakeScale(1.25, 1.25);
//    
//    [UIView animateWithDuration:0.15
//                          delay:0
//                        options:kJXPopupAnimationOptionCurveIOS7 // note: this curve ignores durations
//                     animations:^{
//                         [self.jx_popupViewController viewWillAppear:NO];
//                         self.jx_popupBackgroundView.alpha = 0.5f;
//                         
//                         popupView.alpha = 1.0;
//                         // set transform before frame here...
//                         popupView.transform = CGAffineTransformIdentity;
//                         popupView.frame = popupEndRect;
//                     }
//                     completion:^(BOOL finished) {
//                         [self.jx_popupViewController viewDidAppear:NO];
//                     }];
//}
//
//- (void)shrinkViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
//    [UIView animateWithDuration:(durationTime / 2.0)
//                          delay:0
//                        options:kJXPopupAnimationOptionCurveIOS7
//                     animations:^{
//                         [self.jx_popupViewController viewWillDisappear:NO];
//                         self.jx_popupBackgroundView.alpha = 0.0f;
//                         popupView.alpha = 0.0;
//                         popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
//                     } completion:^(BOOL finished) {
//                         [popupView removeFromSuperview];
//                         [overlayView removeFromSuperview];
//                         [self.jx_popupViewController viewDidDisappear:NO];
//                         self.jx_popupViewController = nil;
//                         
//                         id dismissed = [self dismissedCallback];
//                         if (dismissed != nil)
//                         {
//                             ((void(^)(void))dismissed)();
//                             [self setDismissedCallback:nil];
//                         }
//                     }];
//}
//
//#pragma mark --- Slide
//- (void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(JXPopupShowType)animationType {
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupStartRect;
//    switch (animationType) {
//        case JXPopupShowTypeSlideInFromTop:
//            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                        -popupSize.height,
//                                        popupSize.width,
//                                        popupSize.height);
//            break;
//        case JXPopupShowTypeSlideInFromBottom:
//            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                        sourceSize.height,
//                                        popupSize.width,
//                                        popupSize.height);
//            
//            break;
//        case JXPopupShowTypeSlideInFromLeft:
//            popupStartRect = CGRectMake(-sourceSize.width,
//                                        (sourceSize.height - popupSize.height) / 2,
//                                        popupSize.width,
//                                        popupSize.height);
//            break;
//        case JXPopupShowTypeSlideInFromRight:
//            popupStartRect = CGRectMake(sourceSize.width,
//                                        (sourceSize.height - popupSize.height) / 2,
//                                        popupSize.width,
//                                        popupSize.height);
//            break;
//        default:
//            JXLogDebug(@"不支持的动画类型！");
//            break;
//    }
//    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                     (sourceSize.height - popupSize.height) / 2,
//                                     popupSize.width,
//                                     popupSize.height);
//    
//    // Set starting properties
//    popupView.frame = popupStartRect;
//    popupView.alpha = 1.0f;
//    [UIView animateWithDuration:durationTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self.jx_popupViewController viewWillAppear:NO];
//        self.jx_popupBackgroundView.alpha = 1.0f;
//        popupView.frame = popupEndRect;
//    } completion:^(BOOL finished) {
//        [self.jx_popupViewController viewDidAppear:NO];
//    }];
//}
//
//- (void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(JXPopupDismissType)animationType {
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupEndRect;
//    switch (animationType) {
//        case JXPopupDismissTypeSlideOutToTop:
//            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                      -popupSize.height,
//                                      popupSize.width,
//                                      popupSize.height);
//            break;
//            
//        case JXPopupDismissTypeSlideOutToBottom:
//            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                      sourceSize.height,
//                                      popupSize.width,
//                                      popupSize.height);
//            break;
//            
//        case JXPopupDismissTypeSlideOutToLeft:
//            popupEndRect = CGRectMake(-popupSize.width,
//                                      popupView.frame.origin.y,
//                                      popupSize.width,
//                                      popupSize.height);
//            break;
//            
//        case JXPopupDismissTypeSlideOutToRight:
//            popupEndRect = CGRectMake(sourceSize.width,
//                                      popupView.frame.origin.y,
//                                      popupSize.width,
//                                      popupSize.height);
//            break;
//            
//        default:
//            JXLogDebug(@"不支持的动画类型！");
//            break;
//    }
//    
//    [UIView animateWithDuration:durationTime delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [self.jx_popupViewController viewWillDisappear:NO];
//        popupView.frame = popupEndRect;
//        self.jx_popupBackgroundView.alpha = 0.0f;
//    } completion:^(BOOL finished) {
//        [popupView removeFromSuperview];
//        [overlayView removeFromSuperview];
//        [self.jx_popupViewController viewDidDisappear:NO];
//        self.jx_popupViewController = nil;
//        
//        id dismissed = [self dismissedCallback];
//        if (dismissed != nil)
//        {
//            ((void(^)(void))dismissed)();
//            [self setDismissedCallback:nil];
//        }
//    }];
//}
//
//#pragma mark --- Bounce
//- (void)bounceViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(JXPopupShowType)animationType layout:(JXPopupLayout)layout {
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect containerFrame = CGRectMake((sourceSize.width - popupSize.width) / 2,
//                                       (sourceSize.height - popupSize.height) / 2,
//                                       popupSize.width,
//                                       popupSize.height);
//    
//    CGRect finalContainerFrame = containerFrame;
//    UIViewAutoresizing containerAutoresizingMask = UIViewAutoresizingNone;
//    
//    switch (layout.horizontal) {
//            
//        case JXPopupLayoutHorizontalLeft: {
//            finalContainerFrame.origin.x = 0.0;
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleRightMargin;
//            break;
//        }
//            
//        case JXPopupLayoutHorizontalLeadCenter: {
//            finalContainerFrame.origin.x = floorf(CGRectGetWidth(sourceView.bounds)/3.0 - CGRectGetWidth(containerFrame)/2.0);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//            break;
//        }
//            
//        case JXPopupLayoutHorizontalCenter: {
//            finalContainerFrame.origin.x = floorf((CGRectGetWidth(sourceView.bounds) - CGRectGetWidth(containerFrame))/2.0);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//            break;
//        }
//            
//        case JXPopupLayoutHorizontalTrailCenter: {
//            finalContainerFrame.origin.x = floorf(CGRectGetWidth(sourceView.bounds)*2.0/3.0 - CGRectGetWidth(containerFrame)/2.0);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//            break;
//        }
//            
//        case JXPopupLayoutHorizontalRight: {
//            finalContainerFrame.origin.x = CGRectGetWidth(sourceView.bounds) - CGRectGetWidth(containerFrame);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin;
//            break;
//        }
//            
//        default:
//            break;
//    }
//    
//    // Vertical
//    switch (layout.vertical) {
//        case JXPopupLayoutVerticalTop: {
//            finalContainerFrame.origin.y = 0;
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleBottomMargin;
//            break;
//        }
//            
//        case JXPopupLayoutVerticalAboveCenter: {
//            finalContainerFrame.origin.y = floorf(CGRectGetHeight(sourceView.bounds)/3.0 - CGRectGetHeight(containerFrame)/2.0);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//            break;
//        }
//            
//        case JXPopupLayoutVerticalCenter: {
//            finalContainerFrame.origin.y = floorf((CGRectGetHeight(sourceView.bounds) - CGRectGetHeight(containerFrame))/2.0);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//            break;
//        }
//            
//        case JXPopupLayoutVerticalBelowCenter: {
//            finalContainerFrame.origin.y = floorf(CGRectGetHeight(sourceView.bounds)*2.0/3.0 - CGRectGetHeight(containerFrame)/2.0);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//            break;
//        }
//            
//        case JXPopupLayoutVerticalBottom: {
//            finalContainerFrame.origin.y = CGRectGetHeight(sourceView.bounds) - CGRectGetHeight(containerFrame);
//            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin;
//            break;
//        }
//            
//        default:
//            break;
//    }
//    
//    popupView.autoresizingMask = containerAutoresizingMask;
//    
//    int a = 0;
//    
//    //    // Generating Start and Stop Positions
//    //    CGSize sourceSize = sourceView.bounds.size;
//    //    CGSize popupSize = popupView.bounds.size;
//    //    CGRect popupStartRect = CGRectZero;
//    //
//    //    switch (animationType) {
//    //        case JXPopupShowTypeBounceIn:
//    //            break;
//    //        case JXPopupShowTypeBounceInFromTop:
//    //            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//    //                                        -popupSize.height,
//    //                                        popupSize.width,
//    //                                        popupSize.height);
//    //            break;
//    //        case JXPopupShowTypeBounceInFromBottom:
//    //            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//    //                                        sourceSize.height,
//    //                                        popupSize.width,
//    //                                        popupSize.height);
//    //
//    //            break;
//    //        case JXPopupShowTypeBounceInFromLeft:
//    //            popupStartRect = CGRectMake(-sourceSize.width,
//    //                                        (sourceSize.height - popupSize.height) / 2,
//    //                                        popupSize.width,
//    //                                        popupSize.height);
//    //            break;
//    //        case JXPopupShowTypeBounceInFromRight:
//    //            popupStartRect = CGRectMake(sourceSize.width,
//    //                                        (sourceSize.height - popupSize.height) / 2,
//    //                                        popupSize.width,
//    //                                        popupSize.height);
//    //            break;
//    //        default:
//    //            JXLogDebug(@"不支持的动画类型！");
//    //            break;
//    //    }
//    //    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
//    //                                     (sourceSize.height - popupSize.height) / 2,
//    //                                     popupSize.width,
//    //                                     popupSize.height);
//    //
//    //    CGFloat velocity = 15.0;
//    //    if (JXPopupShowTypeBounceIn == animationType) {
//    //        popupView.frame = popupEndRect;
//    //        popupView.alpha = 0.0f;
//    //        popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
//    //    }else {
//    //        velocity = velocity / 3.0 * 2.0;
//    //
//    //        popupView.transform = CGAffineTransformIdentity;
//    //        popupView.frame = popupStartRect;
//    //        popupView.alpha = 1.0;
//    //    }
//    //
//    //    [UIView animateWithDuration:(durationTime * 2)
//    //                          delay:0.0
//    //         usingSpringWithDamping:0.8
//    //          initialSpringVelocity:velocity
//    //                        options:0
//    //                     animations:^{
//    //                         [self.jx_popupViewController viewWillAppear:NO];
//    //                         self.jx_popupBackgroundView.alpha = 0.5f;
//    //
//    //                         if (JXPopupShowTypeBounceIn == animationType) {
//    //                             popupView.alpha = 1.0f;
//    //                             popupView.transform = CGAffineTransformIdentity;
//    //                         }else {
//    //                             popupView.frame = popupEndRect;
//    //                         }
//    //                     }
//    //                     completion:^(BOOL finished) {
//    //                         [self.jx_popupViewController viewDidAppear:NO];
//    //                     }];
//}
//
//- (void)bounceViewOut:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView withAnimationType:(JXPopupDismissType)animationType {
//    // Generating Start and Stop Positions
//    CGSize sourceSize = sourceView.bounds.size;
//    CGSize popupSize = popupView.bounds.size;
//    CGRect popupEndRect = [self getEndRectWithPopupView:popupView popupSize:popupSize sourceSize:sourceSize animationIndex:(animationType - JXPopupDismissTypeBounceOut)];
//    
//    CGFloat bounce1Duration = (durationTime / 2.0);
//    CGFloat bounce2Duration = durationTime;
//    void (^animationBlock)() = ^() {
//        [self.jx_popupViewController viewWillDisappear:NO];
//        self.jx_popupBackgroundView.alpha = 0.0f;
//        
//        popupView.frame = popupEndRect;
//    };
//    void (^completionBlock)(BOOL) = ^(BOOL finished) {
//        [popupView removeFromSuperview];
//        [overlayView removeFromSuperview];
//        [self.jx_popupViewController viewDidDisappear:NO];
//        self.jx_popupViewController = nil;
//        
//        id dismissed = [self dismissedCallback];
//        if (dismissed != nil)
//        {
//            ((void(^)(void))dismissed)();
//            [self setDismissedCallback:nil];
//        }
//    };
//    
//    switch (animationType) {
//        case JXPopupDismissTypeBounceOut: {
//            [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                popupView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                    [self.jx_popupViewController viewWillDisappear:NO];
//                    self.jx_popupBackgroundView.alpha = 0.0f;
//                    
//                    popupView.alpha = 0.0;
//                    popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
//                } completion:completionBlock];
//            }];
//            break;
//        }
//        case JXPopupDismissTypeBounceOutToTop: {
//            [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                CGRect bounceFrame = popupView.frame;
//                bounceFrame.origin.y += 40.0;
//                popupView.frame = bounceFrame;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:animationBlock completion:completionBlock];
//            }];
//            break;
//        }
//        case JXPopupDismissTypeBounceOutToBottom: {
//            [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                CGRect bounceFrame = popupView.frame;
//                bounceFrame.origin.y -= 40.0;
//                popupView.frame = bounceFrame;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:animationBlock completion:completionBlock];
//            }];
//            break;
//        }
//        case JXPopupDismissTypeBounceOutToLeft: {
//            [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                CGRect bounceFrame = popupView.frame;
//                bounceFrame.origin.x += 40.0;
//                popupView.frame = bounceFrame;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:animationBlock completion:completionBlock];
//            }];
//            break;
//        }
//        case JXPopupDismissTypeBounceOutToRight: {
//            [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                CGRect bounceFrame = popupView.frame;
//                bounceFrame.origin.x -= 40.0;
//                popupView.frame = bounceFrame;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:animationBlock completion:completionBlock];
//            }];
//            break;
//        }
//        default:
//            JXLogDebug(@"不支持的动画类型！");
//            break;
//    }
//}

#pragma mark -
#pragma mark Category Accessors

#pragma mark --- Dismissed

- (void)setDismissedCallback:(void(^)(void))dismissed
{
    objc_setAssociatedObject(self, &kJXPopupViewDismissedKey, dismissed, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(void))dismissedCallback
{
    return objc_getAssociatedObject(self, &kJXPopupViewDismissedKey);
}

@end
