//
//  UIWebView+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIWebView+JXObjc.h"

@implementation UIWebView (JXObjc)
- (void)exExeAdaptiveWidthMeta {
    NSString *widthMeta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", self.frame.size.width];
    [self stringByEvaluatingJavaScriptFromString:widthMeta];
}

+ (void)jx_setupUserAgent:(NSString *)userAgent {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // NSString *info = JXStrWithFmt(@" appvworks/app/appvios/%@_v%@", [JXApp name], [JXApp version]);
    NSString *newAgent = [oldAgent stringByAppendingString:userAgent];
    
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}


//- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame {
//    //此处的title设置为nil，URL地址就没了
//    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [customAlert show];
//    
//}
//
//static BOOL diagStat = NO;
//- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame
//{
//    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"Confirm Title" message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
//    [confirmDiag show];
//    while (confirmDiag.hidden == NO && confirmDiag.superview != nil)
//        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
//    return diagStat;
//}
//
//
//- (void)alertView:(UIAlertView *)alertView clickeonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        diagStat = NO;
//    }
//    else if (buttonIndex == 1)
//    {
//        diagStat = YES;
//    }
//}

@end
