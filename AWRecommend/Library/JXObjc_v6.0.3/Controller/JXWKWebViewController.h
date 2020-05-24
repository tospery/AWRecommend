//
//  JXWKWebViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"
#import <WebKit/WebKit.h>

// 返回|关闭 左菜单
//processPool
//userContentController
//WKUserScript
// 缓存、电话/邮件/支付/分享，新web，刷新，失败（无网/无服务），无导航栏，有导航栏（返回，功能按钮），透明导航栏（主动隐藏h5导航栏），JS处理，网页交互，第三方状态栏/导航栏压缩，原生提示框
@interface JXWKWebViewController : JXViewController <WKNavigationDelegate, WKUIDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSURL *webURL;
@property (nonatomic, assign) BOOL canNew;
@property (nonatomic, assign) BOOL canCache;
@property (nonatomic, assign) BOOL canRefresh;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) id jsInitData;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title;

- (void)requestFromJSData:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)responseFromJSData:(id)data;
- (void)didLoadURL:(NSURL *)url;

- (void)willRefresh;
- (void)didRefresh;

+ (NSArray *)canRefreshLinks;
+ (NSArray *)canNewLinks;

@end

