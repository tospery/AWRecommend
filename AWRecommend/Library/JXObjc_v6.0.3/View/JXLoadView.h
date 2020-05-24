//
//  JXLoadView.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef JXVoidBlock JXLoadResultCallback;

@interface JXLoadView : UIView
@property (nonatomic, strong) UIButton *callbackButton;
- (void)remakeConstraintsForCallbackButtonWithWidth:(CGFloat)width height:(CGFloat)height;

+ (void)showProcessingAddedTo:(UIView *)view;

+ (void)showResultAddedTo:(UIView *)view
                    error:(NSError *)error
                 callback:(JXLoadResultCallback)callback;

+ (void)showResultAddedTo:(UIView *)view
                    image:(UIImage *)image
                  message:(NSString *)message
                functitle:(NSString *)functitle
                 callback:(JXLoadResultCallback)callback;

+ (void)hideForView:(UIView *)view;
+ (JXLoadView *)loadForView:(UIView *)view;
@end


@interface JXLoadViewManager : NSObject
+ (void)setBackgroundColor:(UIColor *)backgroundColor;
+ (UIColor *)backgroundColor;

+ (void)setResultImageMaxRatio:(CGFloat)resultImageMaxRatio;
+ (CGFloat)resultImageMaxRatio;

@end
