//
//  JXUIWebViewController.h
//  cdgas
//
//  Created by 杨建祥 on 2017/8/3.
//  Copyright © 2017年 千嘉科技. All rights reserved.
//

#ifdef JXEnableLibNJKWebViewProgress

#import "JXViewController.h"

// 缓存、邮件/支付/分享，新web，刷新，失败（无网/无服务），无导航栏，有导航栏（返回，功能按钮），透明导航栏（主动隐藏h5导航栏），JS处理，网页交互，第三方状态栏/导航栏压缩，原生提示框
@interface JXUIWebViewController : JXViewController <UIWebViewDelegate, UIAlertViewDelegate, NJKWebViewProgressDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) BOOL canNew;
@property (nonatomic, assign) BOOL canCache;
@property (nonatomic, assign) BOOL canRefresh;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) id jsData;
@property (nonatomic, copy) JXVoidBlock_id ocBlock;
@property (nonatomic, copy) JXVoidBlock_id newBlock;
@property (nonatomic, strong, readonly) NSString *jsCallbackIdentifier;

- (instancetype)initWithLink:(NSString *)link;
- (instancetype)initWithLink:(NSString *)link title:(NSString *)title;

@end

#endif
