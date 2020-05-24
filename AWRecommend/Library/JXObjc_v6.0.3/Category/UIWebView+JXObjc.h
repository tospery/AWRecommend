//
//  UIWebView+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JXObjc)
+ (void)jx_setupUserAgent:(NSString *)userAgent;

/**
 *  执行自适应宽度的meta
 */
- (void)exExeAdaptiveWidthMeta;

//- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame;
//
//- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame;

@end
