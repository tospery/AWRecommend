//
//  UIViewController+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIViewController+JXObjc.h"

@implementation UIViewController (JXObjc)
//// - (BOOL)checkLogin:(JXLoginPassBlock)finish {
//- (BOOL)checkLoginWithError:(NSError *)error
//                     finish:(JXLoginDidPassBlock)finish {
//    // YJX_TODO
//    if (!gUser.isLogined) {
//    if (0 != error.localizedDescription) {
//        JXHUDError(error.localizedDescription, YES);
//    }
//        return NO;
//    }
//    
//    if (JXErrorCodeTokenInvalid == error.code) {
//        [Util handleLogout];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            JXHUDError(error.localizedDescription, YES);
//        });
//        return NO;
//    }
//    
//    if (finish) {
//        finish();
//    }
//    
//    return YES;
//    
////#if defined(JXEnableAppGLTicket) || defined(JXEnableAppGLTicketCenter)
////    //BOOL pass = YES;
////    if (error) {
////        if (JXErrorCodeTokenInvalid != error.code) {
////            return YES;
////        }
////        
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            JXHUDError(error.localizedDescription, YES);
////        });
////        [Util handleLogout];
////    }else {
////        if (gUser.isLogined) {
////            if (finish) {
////                finish();
////            }
////            return YES;
////        }
////    }
////    
////    //    if (pass) {
////    //        if (finish && gUser.isLogined) {
////    //            finish();
////    //        }
////    //        return YES;
////    //    }
////    
////    
////    //    if (gUser.isLogined) {
////    //        if (finish) {
////    //            finish();
////    //        }
////    //        return YES;
////    //    }
////    //
////    //    if (pass) {
////    //        if (checkPass) {
////    //            checkPass();
////    //            checkPass = NULL;
////    //            return NO;
////    //        }
////    //
////    //        if (finish) {
////    //            finish();
////    //            finish = NULL;
////    //            return NO;
////    //        }
////    //    }
////    //
////    //
////    //    // 需要登录
////    //    // static JXNavigationController *loginNav;
////    //    static LoginViewController *loginVC = nil;
////    //    if (!loginVC) {
////    //        // loginNav = [[JXNavigationController alloc] initWithRootViewController:self];
////    //        loginVC = [[LoginViewController alloc] init];
////    //    }
////    //    if (loginVC.isBeingPresented || loginVC.isBeingDismissed) {
////    //        return NO;
////    //    }
////    //
////    //    if (loginVC.presentingViewController) {
////    //        return NO;
////    //    }
////    
////    static JXNavigationController *loginNC;
////    if (!loginNC) {
////        LoginViewController *loginVC = [[LoginViewController alloc] init];
////        loginVC.hidesDismissBtnWhenPresented = YES;
////        loginNC = [[JXNavigationController alloc] initWithRootViewController:loginVC];
////    }
////    
////    if (loginNC.isBeingPresented ||
////        loginNC.isBeingDismissed) {
////        return NO;
////    }
////    
////    if (loginNC.presentingViewController) {
////        return NO;
////    }
////    
////    LoginViewController *loginVC = (LoginViewController *)loginNC.topViewController;
////    loginVC.didSuccessBlock = finish;
////    
////    [self presentViewController:loginNC animated:YES completion:^{
////        if (error) {
////            JXHUDError(error.localizedDescription, YES);
////        }
////    }];
////    //
////    //    loginVC.finish = finish;
////    //    loginVC.willCancel = willCancel;
////    //    loginVC.didCancel = didCancel;
////    //    loginVC.willRelogin = willRelogin;
////    //    loginVC.didRelogin = didRelogin;
////    //
////    //    if (willPresent) {
////    //        willPresent();
////    //        willPresent = NULL;
////    //    }
////    //    __block JXLoginDidPresentBlock bDidPresent = didPresent;
////    //    [target presentViewController:loginVC animated:YES completion:^{
////    //        if (bDidPresent) {
////    //            bDidPresent();
////    //            bDidPresent = NULL;
////    //        }
////    //    }];
////    //
////    //    return YES;
////    //return NO;
////#elif defined(JXEnableAppAKDoctor)
////    if (error) {
////        if (JXErrorCodeTokenInvalid != error.code) {
////            return YES;
////        }
////        
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            JXHUDError(error.localizedDescription, YES);
////        });
////        // [Util handleLogout]; // YJX_LIB
////    }else {
////        if (/*gUser.isLogined*/YES) {
////            if (finish) {
////                finish();
////            }
////            return YES;
////        }
////    }
////#endif
////    return NO;
//}

//- (void)handleSuccessForTableView:(UITableView *)tableView
//                             mode:(JXWebMode)mode
//                             page:(JXPage *)page
//                            items:(NSMutableArray *)items
//                          results:(NSArray *)results
//                            image:(UIImage *)image
//                          message:(NSString *)message
//                        functitle:(NSString *)functitle
//                         callback:(JXWebResultCallback)callback {
//    // 数据
//    if (mode == JXWebModeSilent || mode == JXWebModeLoad || mode == JXWebModeRefresh) {
//        [items removeAllObjects];
//        [items addObjectsFromArray:results];
//    }else {
//        [items exInsertObjects:results atIndex:items.count unduplicated:YES];
//    }
//    [tableView reloadData];
//
//
//    // 刷新
//    if (mode == JXWebModeRefresh) {
//        [tableView.mj_header endRefreshing];
//        if (results.count == page.size) {
//            [tableView.mj_footer resetNoMoreData];
//        }
//    }
//
//    if (mode == JXWebModeSilent) {
//        if (results.count < page.size) {
//            [tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//    }
//
//    // 更多
//    if (results.count == 0) {
//        if (page.index == kJXPageBegin || !page) {
//            if (mode == JXWebModeSilent || mode == JXWebModeLoad || mode == JXWebModeRefresh) {
//                [JXLoadView showResultAddedTo:tableView image:image message:message functitle:functitle callback:callback];
//            }else {
//                JXHUDError(message, YES);
//            }
//        }else {
//            if (mode == JXWebModeMore) {
//                [tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
//    }else {
//        if (page) {
//            if (JXWebModeLoad == mode || JXWebModeRefresh == mode) {
//                page.index = kJXPageBegin + 1;
//            }else if (JXWebModeMore == mode) {
//                page.index += 1;
//            }
//        }
//
//        [JXLoadView hideForView:tableView];
//        if (mode == JXWebModeMore) {
//            [tableView.mj_footer endRefreshing];
//        }
//    }
//}
//
//- (void)handleFailureWithView:(UIView *)view mode:(JXWebMode)mode way:(JXWebWay)way error:(NSError *)error callback:(JXWebResultCallback)callback {
//    if (!error) {
//        return;
//    }
//
//    switch (mode) {
//        case JXWebModeSilent: {
//
//        }
//            break;
//        case JXWebModeLoad: {
//            [JXLoadView hideForView:view];
//        }
//            break;
//        case JXWebModeHUD: {
//            if (JXWebWayPrompt != way) {
//                [JXDialog hideHUD];
//            }
//        }
//            break;
//        case JXWebModeRefresh: {
//            if ([view isKindOfClass:[UITableView class]]) {
//                [[(UITableView *)view mj_header] endRefreshing];
//            }
//        }
//            break;
//        case JXWebModeMore: {
//            if ([view isKindOfClass:[UITableView class]]) {
//                [[(UITableView *)view mj_footer] endRefreshing];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//
//    //[JXDialog hideHUD];
//#ifdef JXEnableFucCheckLogin
//    [[LoginViewController sharedInstance] showLoginIfNeedWithTarget:self error:error finish:NULL checkPass:^{
//        switch (way) {
//            case JXWebWaySilent: {
//
//            }
//                break;
//            case JXWebWayShow: {
//                [JXLoadView showResultAddedTo:view error:error callback:callback];
//            }
//                break;
//            case JXWebWayPrompt: {
//                JXHUDInfo(error.localizedDescription, YES);
//            }
//                break;
//            default:
//                break;
//        }
//    } willPresent:NULL didPresent:^{
//        switch (way) {
//            case JXWebWaySilent: {
//
//            }
//                break;
//            case JXWebWayShow: {
//                [JXLoadView showResultAddedTo:view error:error callback:callback];
//            }
//                break;
//            case JXWebWayPrompt: {
//                JXHUDInfo(error.localizedDescription, YES);
//            }
//                break;
//            default:
//                break;
//        }
//    } willCancel:NULL didCancel:NULL willRelogin:NULL didRelogin:^{
//        if (callback) {
//            callback();
//        }
//    }];
//#endif
//}

#ifdef JXEnableFucCheckLogin
- (void)showLoginIfNotWithFinish:(JXLoginFinishBlock)finish {
    [[LoginViewController sharedInstance] showLoginIfNeedWithTarget:self error:nil finish:finish checkPass:NULL willPresent:NULL didPresent:NULL willCancel:NULL didCancel:NULL willRelogin:NULL didRelogin:NULL];
}

- (BOOL)showAuthidWithFinish:(JXVoidBlock)finish cancel:(JXVoidBlock)cancel {
    //    [[LoginViewController sharedInstance] showLoginIfNeedWithTarget:self error:nil finish:finish checkPass:NULL willPresent:NULL didPresent:NULL willCancel:NULL didCancel:NULL willRelogin:NULL didRelogin:NULL];
    
    return [[[RealnameViewController alloc] init] showWithTarget:self finish:finish cancel:cancel];
}
#endif

@end
