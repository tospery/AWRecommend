//
//  JXLoadView.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXLoadView.h"

static CGFloat lResultImageMaxRatio;
static UIColor *lBackgroundColor;

@interface JXLoadView ()
@property (nonatomic, strong) UIImageView *processingImageView;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) NSArray *whConstraintsForResult;
@property (nonatomic, strong) NSArray *whConstraintsForCallback;
@property (nonatomic, copy) JXLoadResultCallback callback;
@end

@implementation JXLoadView
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.superview isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.superview;
        self.frame = tableView.bounds;
    }
    
    [super layoutSubviews];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
- (void)setup {
    self.backgroundColor = [JXLoadViewManager backgroundColor];
    
    self.processingImageView = [[UIImageView alloc] init];
    self.processingImageView.image = JXImageWithName(@"jxres_loading_static");
    self.processingImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.processingImageView];
    //    [self.processingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(self);
    //        make.width.equalTo(@32);
    //        make.height.equalTo(self.processingImageView.mas_width);
    //    }];
    [self makeConstraintsForProcessingImageView];
    [self.processingImageView setHidden:YES];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont jx_deviceRegularFontOfSize:17.0f];
    self.messageLabel.textColor = JXColorHex(0x666666);
    [self.messageLabel sizeToFit];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.messageLabel];
    //    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(self);
    //    }];
    [self.messageLabel exMakeConstraintsCenter];
    [self.messageLabel setHidden:YES];
    
    
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.image = JXImageWithName(@"jxres_error_network");
    [self.resultImageView sizeToFit];
    self.resultImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.resultImageView];
    //    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.messageLabel);
    //        make.bottom.equalTo(self.messageLabel.mas_top).offset(-12.0f);
    //        make.width.equalTo(@120);
    //        make.height.equalTo(@120);
    //    }];
    [self makeConstraintsForResultImageView];
    [self.resultImageView setHidden:YES];
    
    [self addSubview:self.callbackButton];
    //    [_callbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.messageLabel);
    //        make.top.equalTo(self.messageLabel.mas_bottom).offset(16.0f);
    //        make.width.equalTo(@88);
    //        make.height.equalTo(@32);
    //    }];
    [self makeConstraintsForCallbackButton];
    [_callbackButton setHidden:YES];
}

- (void)makeConstraintsForProcessingImageView {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.processingImageView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:0];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.processingImageView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0f
                                               constant:0];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.processingImageView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0f
                                               constant:32.0f];
    [self.processingImageView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.processingImageView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0f
                                               constant:32.0f];
    [self.processingImageView addConstraint:constraint];
}

- (void)makeConstraintsForResultImageView {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.resultImageView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.messageLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:0];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.resultImageView
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.messageLabel
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0f
                                               constant:-12.0f];
    [self addConstraint:constraint];
    
    [self remakeResultImageViewConstraintsWithWidth:120.0f height:120.0f];
}

- (void)remakeResultImageViewConstraintsWithWidth:(CGFloat)width height:(CGFloat)height {
    if (self.whConstraintsForResult.count != 0) {
        [self.resultImageView removeConstraints:self.whConstraintsForResult];
    }
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.resultImageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0f
                                                                        constant:width];
    [self.resultImageView addConstraint:widthConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.resultImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:height];
    [self.resultImageView addConstraint:heightConstraint];
    
    self.whConstraintsForResult = @[widthConstraint, heightConstraint];
}

- (void)makeConstraintsForCallbackButton {
    //    [_callbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.messageLabel);
    //        make.top.equalTo(self.messageLabel.mas_bottom).offset(16.0f);
    //        make.width.equalTo(@88);
    //        make.height.equalTo(@32);
    //    }];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.callbackButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.messageLabel attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.callbackButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageLabel attribute:NSLayoutAttributeBottom multiplier:1.0f constant:16.0f];
    [self addConstraint:constraint];
    
    //    constraint = [NSLayoutConstraint constraintWithItem:self.callbackButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:88.0f];
    //    [self.callbackButton addConstraint:constraint];
    //
    //    constraint = [NSLayoutConstraint constraintWithItem:self.callbackButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    //    [self.callbackButton addConstraint:constraint];
    [self remakeConstraintsForCallbackButtonWithWidth:88.0f height:32.0f];
}

- (void)remakeConstraintsForCallbackButtonWithWidth:(CGFloat)width height:(CGFloat)height {
    if (self.whConstraintsForCallback.count != 0) {
        [self.callbackButton removeConstraints:self.whConstraintsForCallback];
    }
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.callbackButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0f
                                                                        constant:width];
    [self.callbackButton addConstraint:widthConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.callbackButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:height];
    [self.callbackButton addConstraint:heightConstraint];
    
    self.whConstraintsForCallback = @[widthConstraint, heightConstraint];
}

//- (void)notifyApplicationDidBecomeActive:(NSNotification *)notify {
//    if (!self.processingImageView.hidden) {
//        [self.processingImageView exRotateWithOncetime:1.2];
//    }
//}
//
//- (void)notifyApplicationDidEnterBackground:(NSNotification *)notify {
//    if (!self.processingImageView.hidden) {
//        [self.processingImageView exStopRotation];
//    }
//}

- (void)showProcessing {
    [self.resultImageView setHidden:YES];
    [self.messageLabel setHidden:YES];
    [self.callbackButton setHidden:YES];
    
    [self.processingImageView setHidden:NO];
    [self.processingImageView exRotateWithDuration:0.8 repeat:YES];
}

- (void)showResultWithError:(NSError *)error callback:(JXLoadResultCallback)callback {
    self.callback = callback;
    
    [self.processingImageView exStopRotation];
    [self.processingImageView setHidden:YES];
    
    [self.callbackButton setHidden:(callback ? NO : YES)];
    
    if (JXErrorCodeNetworkException == error.code) {
        [self.resultImageView setHidden:NO];
        [self.messageLabel setHidden:NO];
        self.resultImageView.image = JXImageWithName(@"jxres_error_network");
        self.messageLabel.text = error.localizedDescription;
    }else if (JXErrorCodeServerException == error.code) {
        [self.resultImageView setHidden:NO];
        [self.messageLabel setHidden:NO];
        self.resultImageView.image = JXImageWithName(@"jxres_error_server");
        self.messageLabel.text = error.localizedDescription;
    }else {
        [self.resultImageView setHidden:YES];
        [self.messageLabel setHidden:NO];
        self.messageLabel.text = error.localizedDescription;
    }
}

- (void)showResultWithImage:(UIImage *)image message:(NSString *)message functitle:(NSString *)functitle callback:(JXLoadResultCallback)callback {
    [self.processingImageView exStopRotation];
    [self.processingImageView setHidden:YES];
    
    if (image) {
        self.resultImageView.image = image;
        [self.resultImageView setHidden:NO];
        
        CGSize size = image.size;
        BOOL flag = size.width > JXScreenWidth * [JXLoadViewManager resultImageMaxRatio];
        CGFloat width = size.width;
        CGFloat height = size.height;
        if (flag) {
            width = JXScreenWidth * [JXLoadViewManager resultImageMaxRatio];
            height = (CGFloat)width / size.width * size.height;
        }
        //        [self.resultImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.width.equalTo(@(width));
        //            make.height.equalTo(@(height));
        //        }];
        [self remakeResultImageViewConstraintsWithWidth:width height:height];
    }else {
        self.resultImageView.image = nil;
        [self.resultImageView setHidden:YES];
    }
    
    if (message.length != 0) {
        self.messageLabel.text = message;
        [self.messageLabel setHidden:NO];
    }else {
        self.messageLabel.text = nil;
        [self.messageLabel setHidden:YES];
    }
    
    if (functitle.length != 0 && callback) {
        self.callback = callback;
        [self.callbackButton setTitle:functitle forState:UIControlStateNormal];
        [self.callbackButton setHidden:NO];
    }else {
        self.callback = NULL;
        [self.callbackButton setHidden:YES];
    }
}

#pragma mark - Action methods
- (void)callbackButtonPressed:(id)sender {
    if (self.callback) {
        self.callback();
    }
}

#pragma mark - Accessor methods
- (UIButton *)callbackButton {
    if (!_callbackButton) {
        _callbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callbackButton.titleLabel.font = [UIFont jx_deviceRegularFontOfSize:16.0f];
        [_callbackButton setTitle:kStringReload forState:UIControlStateNormal];
        [_callbackButton setTitleColor:JXColorHex(0x666666) forState:UIControlStateNormal];
        [_callbackButton setBackgroundImage:[UIImage jx_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_callbackButton setBackgroundImage:[UIImage jx_imageWithColor:JXColorHex(0xF4F4F4)] forState:UIControlStateHighlighted];
        [_callbackButton addTarget:self action:@selector(callbackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_callbackButton jx_borderWithColor:JXColorHex(0x666666) width:1.0f radius:4.0f];
        [_callbackButton sizeToFit];
        _callbackButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _callbackButton;
}

#pragma mark - Class methods
+ (void)showProcessingAddedTo:(UIView *)view{
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:NO];
    }
    
    JXLoadView *loadView = [JXLoadView loadForView:view];
    if (!loadView) {
        loadView = [[JXLoadView alloc] init];
        if (![view isKindOfClass:[UITableView class]]) {
            //            [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.edges.equalTo(view);
            //            }];
            loadView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:loadView];
            [loadView exMakeConstraintsEdges];
        }else {
            [view addSubview:loadView];
        }
    }
    [loadView showProcessing];
}

+ (void)showResultAddedTo:(UIView *)view error:(NSError *)error callback:(JXLoadResultCallback)callback {
    UIImage *image;
    if (JXErrorCodeNetworkException == error.code) {
        image = JXImageWithName(@"jxres_error_network");
    }else if (JXErrorCodeServerException == error.code) {
        image = JXImageWithName(@"jxres_error_server");
    }else {
        image = nil;
    }
    
    [JXLoadView showResultAddedTo:view image:image message:error.localizedDescription functitle:kStringReload callback:callback];
}

+ (void)showResultAddedTo:(UIView *)view image:(UIImage *)image message:(NSString *)message functitle:(NSString *)functitle callback:(JXLoadResultCallback)callback {
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:YES];
    }
    
    JXLoadView *loadView = [JXLoadView loadForView:view];
    if (!loadView) {
        loadView = [[JXLoadView alloc] init];
        if (![view isKindOfClass:[UITableView class]]) {
            //            [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.edges.equalTo(view);
            //            }];
            loadView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:loadView];
            [loadView exMakeConstraintsEdges];
        }else {
            [view addSubview:loadView];
        }
        
        
        //        if (CGRectEqualToRect(rect, CGRectZero)) {
        //            [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.edges.equalTo(view);
        //            }];
        //        }else {
        //            loadView.frame = rect;
        //        }
    }
    [loadView showResultWithImage:image message:message functitle:functitle callback:callback];
}

+ (void)hideForView:(UIView *)view {
    if ([view isKindOfClass:[UITableView class]]) {
        [(UITableView *)view setScrollEnabled:YES];
    }
    
    JXLoadView *loadView = [JXLoadView loadForView:view];
    if (loadView) {
        [loadView removeFromSuperview];
    }
}

+ (JXLoadView *)loadForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[JXLoadView class]]) {
            return  (JXLoadView *)subview;
        }
    }
    return nil;
}
@end


@implementation JXLoadViewManager
+ (void)setBackgroundColor:(UIColor *)backgroundColor {
    lBackgroundColor = backgroundColor;
}

+ (UIColor *)backgroundColor {
    if (!lBackgroundColor) {
        lBackgroundColor = [UIColor whiteColor];
    }
    return lBackgroundColor;
}

+ (void)setResultImageMaxRatio:(CGFloat)resultImageMaxRatio {
    lResultImageMaxRatio = resultImageMaxRatio;
}

+ (CGFloat)resultImageMaxRatio {
    if (!lResultImageMaxRatio) {
        lResultImageMaxRatio = 0.5;
    }
    return lResultImageMaxRatio;
}

@end
