//
//  JXWebViewController.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/18.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifdef JXEnableLibNJKWebViewProgress
#import "JXWebViewController3.h"

@interface JXWebViewController3 () <UIWebViewDelegate>
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;

@end

@implementation JXWebViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.delegate = self.progressProxy;
    @weakify(self);
    self.progressProxy.progressBlock = ^(float progress) {
        @strongify(self);
        [self.progressView setProgress:progress animated:YES];
    };
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressView.progressBarView.backgroundColor = JXColorHex(0x29D8D6);

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    int a = 0;
//    [super webViewDidStartLoad:webView];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
////    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
////    [self updateToolbarItems];
////    
////    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
////        [self.delegate webView:webView didFailLoadWithError:error];
////    }
////    
////    if (error) {
////        [self handleError:error];
////    }
//    int a = 0;
//}
@end

#endif
