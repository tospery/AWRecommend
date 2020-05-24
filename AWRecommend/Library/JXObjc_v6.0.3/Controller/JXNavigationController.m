//
//  JXNavigationController.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXNavigationController.h"

@interface JXNavigationController ()

@end

@implementation JXNavigationController
#pragma mark - Override methods
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    for (JXViewController *vc in self.viewControllers) {
//        if ([vc isKindOfClass:[AWWebViewController class]]) {
//            NSLog(@"%@", [(AWWebViewController *)vc webURL]);
//        }
//    }
    
    if (self.viewControllers.count >= 1) {
        UIViewController *cur = viewController; // (UIViewController *)viewController;
        UIViewController *pre = self.viewControllers[self.viewControllers.count - 1];
        
        if ([cur isKindOfClass:[JXViewController class]]
            && [pre isKindOfClass:[JXViewController class]]) {
            JXViewController *c = (JXViewController *)cur;
            JXViewController *p = (JXViewController *)pre;
            
            if (c.viewBgColor == nil) {
                c.viewBgColor = p.viewBgColor;
            }
            if (c.navItemColor == nil) {
                c.navItemColor = p.navItemColor;
            }
            if (c.statusBarStyle == JXStatusBarStyleNone) {
                c.statusBarStyle = p.statusBarStyle;
            }
        }
    }

    [super pushViewController:viewController animated:animated];
}

#pragma mark - Action methods
//- (void)backItemPressed:(id)sender {
//    [self popViewControllerAnimated:YES];
//}

#pragma mark - RAC methods
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}
@end
