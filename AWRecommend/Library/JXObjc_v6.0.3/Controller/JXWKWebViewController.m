//
//  JXWKWebViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXWKWebViewController.h"

@interface JXWKWebViewController ()
@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL loadToken;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

@implementation JXWKWebViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupData];
    [self setupView];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)bindViewModel {
    [super bindViewModel];
    
//    @weakify(self)
//    [RACObserve(self.webView, canGoBack) subscribeNext:^(NSNumber *canGoBack) {
//        @strongify(self)
//        if (canGoBack.boolValue) {
//            self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
//        }else {
//            self.navigationItem.leftBarButtonItems = @[self.backItem];
//        }
//    }];
    
    @weakify(self)
    [[[RACObserve(self, error) skip:1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.webView.scrollView reloadEmptyDataSet];
    }];
}

- (void)dealloc {
    if (_webView) {
        _webView.navigationDelegate = nil;
        _webView.UIDelegate = nil;
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    _webView = nil;
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    if ([[[self class] canRefreshLinks] containsObject:self.webURL.absoluteString]) {
        self.canRefresh = YES;
    }
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = JXStrWithDft(self.webTitle, nil);
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@2.2);
    }];
    
    //    self.progressProxy = [[NJKWebViewProgress alloc] init];
    //    self.webView.delegate = self.progressProxy;
    //    self.progressProxy.webViewProxyDelegate = self.bridge;
    //    self.progressProxy.progressDelegate = self;
    //
    //    CGFloat progressBarHeight = 2.f;
    //    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    //    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    //    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    //    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //    // self.progressView.progressBarView.backgroundColor = JXColorHex(0x29D8D6);
    //    [self.progressView setProgress:0.0 animated:NO];
    
    if (self.canRefresh) {
        @weakify(self)
        self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
//            [self.progressView removeFromSuperview];
//            self.progressView = nil;
            [self willRefresh];
            [self loadRequest];
        }];
    }
    
    @weakify(self)
    [self.bridge registerHandler:kJXWebNativeCallback handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        [self requestFromJSData:data responseCallback:responseCallback];
    }];
    if (self.jsInitData) {
        [self.bridge callHandler:kJXWebJSCallback data:self.jsInitData responseCallback:^(id responseData) {
            @strongify(self)
            [self responseFromJSData:responseData];
        }];
    }
    
    self.webView.scrollView.emptyDataSetSource = self;
    self.webView.scrollView.emptyDataSetDelegate = self;
}

- (void)setupNet {
    [self loadRequest];
}

#pragma mark fetch
#pragma mark request
- (void)loadRequest {
    self.error = nil;
    self.loadToken = NO;
    
    NSURLRequestCachePolicy policy = NSURLRequestReloadIgnoringLocalCacheData;
    if (self.canCache) {
        policy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.webURL cachePolicy:policy timeoutInterval:30];
    [self.webView loadRequest:request];
}

#pragma mark assist
- (void)requestFromJSData:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    JXLogInfo(@"App已收到Web的请求数据：%@", data);
    responseCallback(JXStrWithFmt(@"App已收到Web的请求数据：%@", data));
}

- (void)responseFromJSData:(id)data {
    JXLogInfo(@"Web的响应数据：%@", data);
}

- (void)clickURL:(NSURL *)url decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
}

- (void)didLoadURL:(NSURL *)url {
    
}

- (void)willRefresh {
    
}

- (void)didRefresh {
    
}

#pragma mark - Accessor methods
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        config.mediaPlaybackRequiresUserAction = NO;
        if (JXiOSVersionGreaterThanOrEqual(@"9.0")) {
            config.allowsPictureInPictureMediaPlayback = YES;
        }
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressTintColor = self.progressColor;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

- (WebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [UIBarButtonItem jx_barItemWithType:buttonCloseType color:[UIColor redColor] target:self action:@selector(closeItemPressed:)];
    }
    return _closeItem;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem = [UIBarButtonItem jx_barItemWithType:buttonBackType color:[UIColor redColor] target:self action:@selector(backItemPressed:)];
    }
    return _backItem;
}

#pragma mark - Action methods
- (void)backItemPressed:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }
    
    [super returnItemPressed:sender];
}

- (void)closeItemPressed:(id)sender {
    [super returnItemPressed:sender];
}

#pragma mark - Notification methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;

        if (self.progressView.progress == 1) {
            @weakify(self)
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                @strongify(self)
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                self.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Delegate methods
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始");
    self.error = nil;
    
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"成功");
    self.error = nil;
    
    self.loadToken = YES;
    if (0 == self.navigationItem.title.length) {
        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if ([result isKindOfClass:[NSString class]]) {
                self.navigationItem.title = result;
            }
        }];
    }
    
    if (self.canRefresh) {
        [self didRefresh];
        [self.webView.scrollView.mj_header endRefreshing];
    }
    
    [self didLoadURL:webView.URL];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"失败");
    self.error = [error jx_adapt];
    self.loadToken = YES;
    self.progressView.hidden = YES;
    if (self.canRefresh) {
        [self didRefresh];
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *link = navigationAction.request.URL.absoluteString;
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if ([link hasPrefix:@"tel:"]) {
        // tel:02884433365
        NSString *phone = [link substringFromIndex:4];
        [JXDevice dialNumber:phone];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if (!self.loadToken) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if (![navigationAction.request.URL.host isEqualToString:@"m.appvworks.com"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
#ifdef JXEnableAppAWKSZhixuan
    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:navigationAction.request.URL];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    decisionHandler(WKNavigationActionPolicyCancel);
#endif
    
//    if ([[[self class] canNewLinks] containsObject:self.webURL.absoluteString]) {
//        AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:navigationAction.request.URL];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    
//    decisionHandler(WKNavigationActionPolicyAllow);
    
//    if ([link isEqualToString:@"wvjbscheme://__BRIDGE_LOADED__"]
//        || [link isEqualToString:@"https://__wvjb_queue_message__/"]) {
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
//
//    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:navigationAction.request.URL];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark WKUIDelegate
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(nonnull WKWebViewConfiguration *)configuration forNavigationAction:(nonnull WKNavigationAction *)navigationAction windowFeatures:(nonnull WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    if (message.length == 0) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    if (message.length == 0) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    if (prompt.length == 0) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringUnknownError);
    switch (self.error.code) {
        case JXErrorCodeNetworkException:
            title = @"网络异常";
            break;
        case JXErrorCodeServerException:
            title = @"服务异常";
            break;
        default:
            break;
    }
    
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(14.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    if (!self.error) {
//        return nil;
//    }
//    
//    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
//    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
    return nil;
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
    if (!self.error) {
        return JXImageWithName(@"jxres_loading");
    }
    
    UIImage *image = JXObjWithDft([self.error jx_reasonImage], JXImageWithName(@"jxres_error_empty"));
    switch (self.error.code) {
        case JXErrorCodeNetworkException:
        case JXErrorCodeServerException:
            image = JXAdaptImage(JXImageWithName(@"img_anomaly"));
            break;
        default:
            break;
    }

    return image;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    
    return animation;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 44.0f;
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
    [self loadRequest];
}

#pragma mark - Public methods
- (instancetype)initWithURL:(NSURL *)url {
    if (self = [self initWithURL:url title:nil]) {
        
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title {
    if (self = [super init]) {
        _webURL = url;
        _webTitle = title;
        _progressColor = [UIColor greenColor];
    }
    return self;
}

#pragma mark - Class methods
+ (NSArray *)canRefreshLinks {
    return nil;
}

+ (NSArray *)canNewLinks {
    return nil;
}


@end


