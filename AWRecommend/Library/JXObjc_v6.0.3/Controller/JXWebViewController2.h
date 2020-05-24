//
//  JXWebViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/2.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#ifdef JXEnableLibNJKWebViewProgress
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "JXObjc.h"

@interface JXWebViewController2 : JXViewController <UIWebViewDelegate, UIAlertViewDelegate, NJKWebViewProgressDelegate>
- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString title:(NSString *)title;

@end
#endif
