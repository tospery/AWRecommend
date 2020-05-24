//
//  JXUIWebViewController.m
//  cdgas
//
//  Created by 杨建祥 on 2017/8/3.
//  Copyright © 2017年 千嘉科技. All rights reserved.
//

#ifdef JXEnableLibNJKWebViewProgress
#import "JXUIWebViewController.h"

@interface JXUIWebViewController ()
@property (nonatomic, strong, readwrite) NSString *jsCallbackIdentifier;

@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, assign) BOOL onceTokenForNew;

@property (nonatomic, copy) NSString *webLink;
@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *failLink;

@end

@implementation JXUIWebViewController
#pragma mark - Override
#pragma mark init
- (instancetype)initWithLink:(NSString *)link title:(NSString *)title {
    if (self = [self init]) {
        _webLink = link;
        _navTitle = title;
    }
    return self;
}

- (instancetype)initWithLink:(NSString *)link {
    return [self initWithLink:link title:nil];
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark setup
- (void)setupVar {
    self.jsCallbackIdentifier = @"jsCallback";
}

- (void)setupView {
    // UIWebView顶部20点的空白条，和状态栏似的，终于去掉了 -> http://blog.csdn.net/u011439689/article/details/45171317
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = JXStrWithDft(self.navTitle, nil);
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = self.navigationController.navigationBar.hidden ? 20.0f : 0;
        make.leading.equalTo(self.view);
        make.top.equalTo(self.view).offset(offset);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.webView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.webView);
        make.top.equalTo(self.webView);
        make.trailing.equalTo(self.webView);
        make.height.equalTo(@2);
    }];
    
    @weakify(self)
    [self.bridge registerHandler:@"nativeCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        [self nativeResponse:data responseCallback:responseCallback];
    }];
    if (self.jsData) {
        [self.bridge callHandler:self.jsCallbackIdentifier data:self.jsData responseCallback:^(id responseData) {
            @strongify(self)
            [self jsResponse:responseData];
        }];
    }
    
    if (self.canRefresh) {
        @weakify(self)
        self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self reloadHTML];
        }];
    }
    
    // self.webView.delegate = self.progressProxy;
    self.webView.backgroundColor = self.viewBgColor;
}

- (void)setupNet {
    [self requestHTML];
}

#pragma mark empty
#pragma mark - Accessor
- (UIColor *)progressColor {
    if (!_progressColor) {
        _progressColor = [UIColor greenColor];
    }
    return _progressColor;
}

- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self.bridge;
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectZero];
        _progressView.progressBarView.backgroundColor = self.progressColor;
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = YES;
        _webView.delegate = self.progressProxy;
        _webView.scrollView.emptyDataSetSource = self;
        _webView.scrollView.emptyDataSetDelegate = self;
    }
    return _webView;
}

- (WebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

#pragma mark - Private
- (void)requestHTML {
//    // NSURLRequest *request =[NSURLRequest requestWithURL:JXURLWithStr(self.webLink)];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:JXURLWithStr(self.webLink)];
////    id a = request.allHTTPHeaderFields;
////    [request setValue:@"appvworks" forHTTPHeaderField:@"User-Agent"];
////    a = request.allHTTPHeaderFields;
//    
//    [self.webView loadRequest:request];
    
    
    //NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:self.webURL];
    NSURLRequestCachePolicy policy = NSURLRequestReloadIgnoringLocalCacheData;
    if (self.canCache) {
        policy = NSURLRequestReturnCacheDataElseLoad;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:JXURLWithStr(self.webLink) cachePolicy:policy timeoutInterval:20];
    [self.webView loadRequest:request];
}

- (void)reloadHTML {
    self.onceTokenForNew = NO;
    self.error = nil;
    [self.webView.scrollView reloadEmptyDataSet];
    
    if (0 != self.webView.request.URL.absoluteString.length) {
        [self.webView reload];
        return;
    }
    
    NSString *link = JXStrWithDft(self.failLink, self.webLink);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:JXURLWithStr(link) cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [self.webView loadRequest:request];
}

//- (void)reloadWeb {
//    self.error = nil;
//    [self.webView.scrollView reloadEmptyDataSet];
//    
//    [self.webView reload];
//}

- (NSError *)genError:(NSError *)error {
    NSError *ret = error;
    if (401 == error.code) {
        ret = [NSError jx_errorWithCode:JXErrorCodeLoginExpired];
    }else if (-1009 == error.code) {
        ret = [NSError jx_errorWithCode:JXErrorCodeNetworkException];
    }else {
        ret = [NSError jx_errorWithCode:JXErrorCodeServerException];
    }
    return ret;
}

#pragma mark - Public
- (void)nativeResponse:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    NSLog(@"【JS->Native】的请求数据: %@", data);
    responseCallback(@"Response from testObjcCallback");
}

- (void)jsResponse:(id)responseData {
    NSLog(@"【Native->JS】的响应数据: %@", responseData);
}

#pragma mark - Action
//- (void)returnItemPressed:(id)sender {
//    if (self.webView.canGoBack) {
//        [self.webView goBack];
//    }else {
//        [super returnItemPressed:sender];
//    }
//}

#pragma mark - Notification
#pragma mark - Delegate
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *target = request.URL.absoluteString;
    // 支付宝
    NSString *decodeURL = [target stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([decodeURL containsString:@"alipays://"]) {
        if ([decodeURL containsString:@"&businessPath="]) {
            // https://ds.alipay.com/?scheme=alipays://platformapi/startapp?appId=20000193&url=%2Fwww%2FeBill.htm%3Freferer%3DGOPAY%26billKey%3D1001747455%26instId%3DCDCSRQ1668%26subBizType%3DGAS&businessPath=http://website.test.cdgas.com&websitePath=http://www.cdgas.com&hallsitePath=http://hallsite.test.cdgas.com&filesPath=http://files.test.cdgas.com&browser=otherBrowser&isLogin=true&isSetCode=false
            if ([decodeURL hasPrefix:@"https://ds.alipay.com"]) {
                NSArray *arr = [decodeURL componentsSeparatedByString:@"alipays://"];
                NSString *app = JXStrWithFmt(@"alipays://%@", [arr lastObject]);
                arr = [app componentsSeparatedByString:@"&businessPath="];
                app = [arr firstObject];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                    
                }];
                
                return YES;
            }
        }else {
            // alipays://platformapi/startapp?appId=20000193&url=%2Fwww%2FeBill.htm%3Freferer%3DGOPAY%26billKey%3D1001747455%26instId%3DCDCSRQ1668%26subBizType%3DGAS
            if ([decodeURL hasPrefix:@"alipays://platformapi/startapp"]) {
                NSString *app = target;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                    
                }];
                return NO;
            }
        }
    }
    
    // 新建窗口
    if (self.canNew) {
//        if (self.onceToken) {
//            JXUIWebViewController *vc = [[JXUIWebViewController alloc] initWithLink:target];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//            return NO;
//        }else {
//            self.onceToken = YES;
//        }
        
        if (self.onceTokenForNew/* && !self.webView.scrollView.mj_header.isRefreshing*/) {
//            if (self.newBlock) {
//                self.newBlock(RACTuplePack(self.navigationController, target));
//            }
            [self openAgain:target];
            return NO;
        }
    }
    
    return YES;
}

- (void)openAgain:(NSString *)target {
    
}

- (void)finishLoad {
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // [self.progressView setProgress:0 animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.onceTokenForNew = YES;
    
    if (0 == self.navigationItem.title.length) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    if (self.canRefresh) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
    
    [self finishLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.progressView setProgress:0.0 animated:YES];
    
    if (self.canRefresh) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
    
//    NSString *url = [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];
//    if ([url isEqualToString:self.webLink]) {
//        self.error = [self genError:error];
//        [self.webView.scrollView reloadEmptyDataSet];
//    }else {
//        // JXAlert(kStringError, [error localizedDescription]);
//    }
    
    
    if (-1009 == error.code) {
        self.error = [NSError jx_errorWithCode:JXErrorCodeNetworkException];
        self.failLink = [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];
        [self.webView.scrollView reloadEmptyDataSet];
    }
}

//- (void)webView:(UIWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler {
//    int a = 0;
//}
//
//- (void)webView:(UIWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
//    int a = 0;
//}

#pragma mark NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
    self.progressView.hidden = NO;
}

#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringServerException);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(14.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = JXImageWithColor(JXInstance.mainColor ? JXInstance.mainColor : [UIColor blueColor]);
    image = [image scaleToSize:CGSizeMake(JXAdaptScreen(120), JXAdaptScreen(30)) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:JXAdaptScreen(2.0)];
    
    CGFloat slide = JXAdaptValue(-84, -96, -106);
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, slide, 0, slide)];
    
    return (UIControlStateNormal == state ? image : nil);;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return JXObjWithDft([self.error jx_reasonImage], JXImageWithName(@"jxres_error_server"));
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.webView.backgroundColor;
}

#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.error != nil;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self reloadHTML];
}

#pragma mark - Class


@end
#endif







