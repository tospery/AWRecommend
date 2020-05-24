//
//  JXViewController.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXViewController.h"


@interface JXViewController ()
@property (nonatomic, strong) UIBarButtonItem *dismissItem;

@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *executing;

@end

@implementation JXViewController
#pragma mark Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.viewBgColor) {
        self.viewBgColor = JXObjWithDft(JXInstance.viewBgColor, [UIColor whiteColor]);
    }
    
    if (!self.navItemColor) {
        self.navItemColor = JXObjWithDft(JXInstance.navItemColor, [UIColor whiteColor]);
    }
    
//    //self.shouldFetchLocalDataOnViewModelInitialize = YES;
//    
//    //self.view.backgroundColor = JXInstance.viewBgColor;
//    
//    if (self.presentingViewController &&
//        1 == self.navigationController.viewControllers.count &&
//        !self.hidesDismissBtnWhenPresented) {
//        self.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
//    }
    
//    if (!self.navItemColor) {
//        self.navItemColor = JXInstance.navItemColor;
//    }
//    if (!self.viewBgColor) {
//        self.viewBgColor = JXInstance.viewBgColor;
//    }
//    if (self.statusBarStyle == JXStatusBarStyleNone) {
//        self.statusBarStyle = JXInstance.statusBarStyle;
//    }
//    if (self.statusBarStyle == JXStatusBarStyleNone) {
//        self.statusBarStyle = JXStatusBarStyleDefault;
//    }
    
    if (self.hidesReturnBarItem) {
        
//        if (self.navigationItem.leftBarButtonItem &&
//            self.navigationController.viewControllers.count > 1) {
//            self.navigationItem.leftBarButtonItem = nil;
//            self.navigationItem.hidesBackButton = YES;
//        }
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        
        
//        if (self.presentingViewController) {
//            self.navigationItem.leftBarButtonItem = self.useBackAsReturn ? JXCreateBackItem(self, @selector(returnItemPressed:), JXInstance.navItemColor) : JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
//        }else {
//            if (self.navigationController.viewControllers.count > 1) {
//                self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
//            }
//        }
        
        
    }else {
//        UIColor *color = self.navItemColor;
//        
//        if (!color) {
//            UIColor *navColor = self.navigationController.navigationBar.barTintColor;
//            if ((nil == navColor)
//                || (CGColorEqualToColor(navColor.CGColor, [UIColor whiteColor].CGColor))) {
//                color = JXColorHex(0x333333);
//            }else {
//                color = [UIColor whiteColor];
//            }
//        }
        
        BOOL isPresenting = (self.presentingViewController != nil);
        BOOL isTopController = (self.navigationController.viewControllers.count == 1);
        
        if (isPresenting) {
            self.navigationItem.leftBarButtonItem = self.useCloseAsReturn ? JXCreateCloseItem(self, @selector(returnItemPressed:), self.navItemColor) : JXCreateBackItem(self, @selector(returnItemPressed:), self.navItemColor);
        }else {
            if (!isTopController) {
                self.navigationItem.leftBarButtonItem = self.useCloseAsReturn ? JXCreateCloseItem(self, @selector(returnItemPressed:), self.navItemColor) : JXCreateBackItem(self, @selector(returnItemPressed:), self.navItemColor);
            }
        }
    }
    
//    if (CGColorEqualToColor(self.navItemColor.CGColor, [UIColor whiteColor].CGColor)) {
//        [self.navigationItem.rightBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: self.navItemColor, kJXKeyTitleColorDisabled: JXColorHex(0x999999), kJXKeyTitleFont: JXFont(14)}];
//    }else {
//        [self.navigationItem.rightBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: self.navItemColor, kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: JXFont(14)}];
//    }
    
    self.view.backgroundColor = self.viewBgColor;
}

//- (void)loadView {
//    [super loadView];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifdef JXEnableFuncStatistics
    [MobClick beginLogPageView:NSStringFromClass([self class])];
#endif
    
#ifdef JXEnableLibRDVTabBarController
    // 另一种实现方式是交互viewWillAppear:的实现，在自定义实现里添加如下代码。参考Coding->swizzleAllViewController
    if (self.navigationController.childViewControllers.count > 1) {
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

#ifdef JXEnableLibRDVTabBarController
    if (self.navigationController.childViewControllers.count == 1) {
        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#ifdef JXEnableFuncStatistics
    [MobClick endLogPageView:NSStringFromClass([self class])];
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (!self.statusBarStyle) {
        self.statusBarStyle = JXIntWithDft(JXInstance.statusBarStyle, JXStatusBarStyleDefault);
    }
    return (self.statusBarStyle - 1);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Accessor
//- (UIColor *)viewBgColor {
//    if (!_viewBgColor) {
//        _viewBgColor = JXObjWithDft(JXInstance.viewBgColor, [UIColor whiteColor]);
//    }
//    return _viewBgColor;
//}
//
//- (UIColor *)barItemColor {
//    if (!_barItemColor) {
//        _barItemColor = JXObjWithDft(JXInstance.navItemColor, [UIColor whiteColor]);
//    }
//    return _barItemColor;
//}
//
//- (JXStatusBarStyle)statusBarStyle {
//    if (!_statusBarStyle) {
//        _statusBarStyle = JXIntWithDft(JXInstance.statusBarStyle, JXStatusBarStyleDefault);
//    }
//    return _statusBarStyle;
//}

- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

- (RACSubject *)executing {
    if (!_executing) {
        _executing = [RACSubject subject];
    }
    return _executing;
}

#pragma mark Assist
- (void)bindViewModel {
    [[self.executing skip:1] subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
            // JXHUDProcessing(nil);
            [JXDialog showHUD:nil];
        }
    }];
    
    [self.errors subscribeNext:^(NSError *error) {
//        BOOL pass = [gUser checkLoginWithFinish:NULL error:error];
//        if (pass) {
//            JXHUDError(error.localizedDescription, YES);
//        }
        
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                
            }else {
                [JXDialog showPopup:error.localizedDescription];
            }
        } error:error];
        
        
        // YJX_TODO 登录过期
        //        if ([error.domain isEqual:OCTClientErrorDomain] && error.code == OCTClientErrorAuthenticationFailed) {
        //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:JX_ALERT_TITLE
        //                                                                                     message:@"Your authorization has expired, please login again"
        //                                                                              preferredStyle:UIAlertControllerStyleAlert];
        //
        //            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //                @strongify(self)
        //                [SSKeychain deleteAccessToken];
        //
        //                JXLoginViewModel *loginViewModel = [[JXLoginViewModel alloc] initWithServices:self.viewModel.services params:nil];
        //                [self.viewModel.services resetRootViewModel:loginViewModel];
        //            }]];
        //
        //            [self presentViewController:alertController animated:YES completion:NULL];
        //        } else if (error.code != OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired && error.code != OCTClientErrorConnectionFailed) {
        //            JXError(error.localizedDescription);
        //        }
    }];
}

#pragma mark Action
- (void)returnItemPressed:(id)sender {
    BOOL isPresenting = (self.presentingViewController != nil);
    BOOL isTopController = (self.navigationController.viewControllers.count == 1);
    
    if (isPresenting) {
        if (isTopController) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Class
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    JXViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}

@end



//@implementation JXViewControllerManager
//- (UIColor *)backgroundColor {
//    if (JXDataIsEmpty(_backgroundColor)) {
//        _backgroundColor = JXColorHex(0xEFEFF5); // [UIColor redColor];
//    }
//    return _backgroundColor;
//}
//
////+ (JXViewControllerManager *)sharedInstance {
////    static JXViewControllerManager *instance;
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        instance = [[JXViewControllerManager alloc] init];
////    });
////    return instance;
////}
//
//+ (instancetype)sharedInstance {
//    static id instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[[self class] alloc] init];
//    });
//    return instance;
//}
//@end





