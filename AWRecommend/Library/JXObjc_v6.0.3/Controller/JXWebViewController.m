//
//  JXWebViewController.m
//  GDLBLotteryLiaoning
//
//  Created by 杨建祥 on 17/1/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXWebViewController.h"

@interface JXWebViewController ()
@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, strong) NSURL *webURL;

//@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
//@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) WKWebView *webView;
//@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIView *contentView;

@end

@implementation JXWebViewController
#pragma mark - Override methods
//- (instancetype)init {
//    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupData];
    [self setupView];
    [self setupSignal];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.progressView removeFromSuperview];
}

- (void)bindViewModel {
    [super bindViewModel];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
    //    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:100 * 1024 * 1024
    //                                                                 diskCapacity:200 * 1024 * 1024
    //                                                                     diskPath:nil
    //                                                                    cacheTime:0];
    //    [CustomURLCache setSharedURLCache:urlCache];
    
    //[JXCacheURLProtocol setCachingEnabled:self.canCache];
    
//    if (self.canCache) {
//        JXURLCache *urlCache = [[JXURLCache alloc] initWithMemoryCapacity:100 * 1024 * 1024 diskCapacity:200 * 1024 * 1024 diskPath:nil cacheTime:0];
//        [JXURLCache setSharedURLCache:urlCache];
//        [JXURLProtocol setCachingEnabled:YES];
//    }
    
    //[JXURLProtocol setCachingEnabled:self.canCache];
    
//    DPLocalCache *urlCache = [[DPLocalCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
//                                                             diskCapacity:200 * 1024 * 1024
//                                                                 diskPath:nil
//                                                                cacheTime:60*60*24  //每隔24小时更新一次数据
//                                                                 modeTybe:DOWNLOAD_MODE
//                                                             subDirectory:@"dir"];
//    [NSURLCache setSharedURLCache:urlCache];
    
//    [[[self.webView rac_valuesAndChangesForKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew observer:self] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple *tuple) {
//        int a = 0;
//    }];
    
    //[self.webView rac_valuesAndChangesForKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> observer:<#(NSObject * _Nonnull __weak)#>
}

- (void)setupData {
}

- (void)setupView {
//    self.navigationItem.title = @"待办任务";
//    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.title = JXStrWithDft(self.webTitle, nil);
    
//    self.scrollView = [[UIScrollView alloc] init];
//    [self.view addSubview:self.scrollView];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    self.contentView = [[UIView alloc] init];
//    [self.scrollView addSubview:self.contentView];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView);
//        make.height.equalTo(self.scrollView);
//    }];
//    
//    [self.contentView addSubview:self.webView];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //[self.view addSubview:self.progressView];
    
//    [self.webView addSubview:self.progressView];
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.webView);
//        make.top.equalTo(self.webView.mas_top);
//        make.trailing.equalTo(self.webView);
//        make.height.equalTo(@2);
//    }];
    
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@2);
    }];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
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
            [self.progressView removeFromSuperview];
            self.progressView = nil;
            [self loadRequest];
        }];
    }
}

- (void)setupSignal {
}

- (void)setupNet {
    [self loadRequest];
}

#pragma mark fetch
#pragma mark request
- (void)loadRequest {
    //NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:self.webURL];
    NSURLRequestCachePolicy policy = NSURLRequestReloadIgnoringLocalCacheData;
    if (self.canCache) {
        policy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    NSTimeInterval timeout = 10;
//#ifdef kHTTPTimeout
//    timeout = kHTTPTimeout;
//#endif
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.webURL cachePolicy:policy timeoutInterval:timeout];
    [self.webView loadRequest:request];
}

#pragma mark assist

//#pragma mark - Table
//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    DhzyDaibanCell *myCell = (DhzyDaibanCell *)cell;
//    myCell.data = object;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [DhzyDaibanCell height];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:[DhzyDaibanCell identifier] forIndexPath:indexPath];
//}

#pragma mark - Accessor methods
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
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
//        CGFloat progressBarHeight = 2.f;
//        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
//        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        
        //CGFloat height = 2.0f;
        //_progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.jx_height - height, self.navigationController.navigationBar.jx_width, height)];
        
        //_progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, JXScreenWidth, 2)];
        _progressView = [[UIProgressView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressTintColor = self.progressColor;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

#pragma mark - Action methods
#pragma mark - Notification methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        //[self.navigationController.navigationBar bringSubviewToFront:self.progressView];
        
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            // __weak typeof (self)weakSelf = self;
            //__unsafe_unretained typeof (self)weakSelf = self;
            
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
/*
 *5.在WKWebViewd的代理中展示进度条，加载完成后隐藏进度条
 */

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    //[self.navigationController.navigationBar bringSubviewToFront:self.progressView];
    //[self.webView bringSubviewToFront:self.progressView];
    [self.view bringSubviewToFront:self.progressView];
}

// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //    self.progressView.hidden = YES;
    if (0 == self.navigationItem.title.length) {
        //self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if ([result isKindOfClass:[NSString class]]) {
                self.navigationItem.title = result;
            }
        }];
    }
    
    if (self.canRefresh) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    if (self.canRefresh) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

// 页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *str1 = self.webURL.absoluteString;
    NSString *str2 = navigationAction.request.URL.absoluteString;
    
    if ([str2 hasPrefix:@"tel:"]) {
        // tel:02884433365
        NSString *phone = [str2 substringFromIndex:4];
        [JXDevice dialNumber:phone];
        
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    if (!self.canNew || [str1 isEqualToString:str2]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    JXWebViewController *vc = [[JXWebViewController alloc] initWithURL:navigationAction.request.URL];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    decisionHandler(WKNavigationActionPolicyCancel);
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


@end




