//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"

@interface SVWebViewController : JXViewController
@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, weak) id<UIWebViewDelegate> delegate;

- (instancetype)initWithLink:(NSString *)link;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithLink:(NSString *)link title:(NSString *)title;
- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title;

- (void)loadURL:(NSURL *)URL;

@end
