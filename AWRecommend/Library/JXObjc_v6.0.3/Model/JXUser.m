//
//  JXUser.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXUser.h"

JXUser *gUser;

@implementation JXUser
- (void)setupProperties:(id)another {
    NSArray *properties = [[self class] jx_getProperties];
    for (NSString *key in properties) {
        [self setValue:[another valueForKey:key] forKey:key];
    }
}

- (void)resetProperties {
    self.jxID = nil;
    self.jxDescription = nil;
    
    self.isLogined = NO;
    self.token = nil;
}

- (void)checkLoginWithFinish:(JXVoidBlock_bool)finish error:(NSError *)error {
    if (!self.isLogined) {
//        UIViewController *curVC = JXCurrentViewController();
//        if ([curVC isKindOfClass:[JXLoginViewController class]]) {
//            int a = 0;
//        }
//        
//        if (!error) {
//            if (finish) {
//                finish(NO);
//            }
//        }else {
//            Class cls = NSClassFromString(@"LoginViewController");
//            if (cls) {
//                JXLoginViewController *vc = [[cls alloc] init];
//                vc.didLoginBlock = ^{
//                    if (finish) {
//                        finish(YES);
//                    }
//                };
//                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//                
//                UIViewController *currentVC = JXCurrentViewController();
//                [currentVC presentViewController:nc animated:YES completion:NULL];
//            }
//        }
        
//        BOOL isNeed = NO;
//        Class cls = NSClassFromString(@"LoginViewController");
//        
//        if (JXErrorCodeLoginExpired == error.code) {
//        }
        
//        UIViewController *vc = JXCurrentViewController();
//        if ([vc isKindOfClass:cls]) {
//            int a = 0;
//        }

        if (error) {
            [JXDialog showPopup:error.localizedDescription];
        }else {
            UIViewController *curVC = JXCurrentViewController();
            Class cls = NSClassFromString(@"LoginViewController");
            if (cls && ![curVC isKindOfClass:cls]) {
                JXLoginViewController *vc = [[cls alloc] init];
                vc.didLoginBlock = ^{
                    if (finish) {
                        finish(YES);
                    }
                };
                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
                [curVC presentViewController:nc animated:YES completion:NULL];
            }
        }
    }else {
        if (!error) {
            if (finish) {
                finish(NO);
            }
        }else {
            if (JXErrorCodeLoginExpired == error.code) {
                [JXDialog hideHUD];
                
#ifdef JXEnableAppAWKSZhixuan
                [TMInstance removeObjectForKey:kTMTestList];
#endif
                
                [self logout];
                [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyUserDidExpire object:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JXDialog showPopup:error.localizedDescription];
                });
                
                Class cls = NSClassFromString(@"LoginViewController");
                if (cls) {
                    JXLoginViewController *vc = [[cls alloc] init];
                    vc.didLoginBlock = ^{
                        if (finish) {
                            finish(YES);
                        }
                    };
                    JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
                    
                    UIViewController *currentVC = JXCurrentViewController();
                    [currentVC presentViewController:nc animated:YES completion:NULL];
                }
            }else {
                if (finish) {
                    finish(NO);
                }
            }
        }
    }
    
//    if (!error) {
//        if (!self.isLogined) {
//            Class cls = NSClassFromString(@"LoginViewController");
//            if (cls) {
//                JXLoginViewController *vc = [[cls alloc] init];
//                // vc.didPassBlock = finish;
//                vc.didPassBlock = ^{
//                    if (finish) {
//                        finish(YES);
//                    }
//                };
//                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//                
//                UIViewController *currentVC = JXCurrentViewController();
//                [currentVC presentViewController:nc animated:YES completion:NULL];
//            }
//        }else {
//            if (finish) {
//                finish(NO);
//            }
//        }
//        
//        return;
//    }
//    
//    if (JXErrorCodeTokenInvalid == error.code) {
//        [self logout];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyUserDidExpire object:nil];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [JXDialog showError:error handler:NULL];
//        });
//        
//        Class cls = NSClassFromString(@"LoginViewController");
//        if (cls) {
//            JXLoginViewController *vc = [[cls alloc] init];
//            vc.didPassBlock = ^{
//                if (finish) {
//                    finish(YES);
//                }
//            };
//            JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//            
//            UIViewController *currentVC = JXCurrentViewController();
//            [currentVC presentViewController:nc animated:YES completion:NULL];
//        }
//    }else {
//        if (finish) {
//            finish(NO);
//        }
//    }
//    
//    
////    BOOL pass = YES;
////    
////    if (!error) {
////        if (!self.isLogined) {
////            pass = NO;
////            
////            Class cls = NSClassFromString(@"LoginViewController");
////            if (cls) {
////                JXLoginViewController *vc = [[cls alloc] init];
////                vc.didPassBlock = finish;
////                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
////                
////                UIViewController *currentVC = JXCurrentViewController();
////                [currentVC presentViewController:nc animated:YES completion:NULL];
////            }
////        }
////        
////        if (pass && finish) {
////            finish();
////        }
////        
////        return pass;
////    }
////    
////    if (JXErrorCodeTokenInvalid == error.code) {
////        pass = NO;
////        
////        [self logout];
////        [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyUserDidExpire object:nil];
////        
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [JXDialog showError:error handler:NULL];
////        });
////        
////        Class cls = NSClassFromString(@"LoginViewController");
////        if (cls) {
////            JXLoginViewController *vc = [[cls alloc] init];
////            vc.didPassBlock = finish;
////            JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
////            
////            UIViewController *currentVC = JXCurrentViewController();
////            [currentVC presentViewController:nc animated:YES completion:NULL];
////        }
////    }else {
////        JXHUDError(error.localizedDescription, YES);
////    }
////    
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        if (pass && finish) {
////            finish();
////        }
////    });
////    
////    return pass;
}

//- (BOOL)checkLoginWithFinish:(JXLoginDidPassBlock)finish error:(NSError *)error {
//    BOOL pass = YES;
//    
//    if (!error) {
//        if (!self.isLogined) {
//            pass = NO;
//            
//            Class cls = NSClassFromString(@"LoginViewController");
//            if (cls) {
//                JXLoginViewController *vc = [[cls alloc] init];
//                vc.didPassBlock = finish;
//                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//                
//                UIViewController *currentVC = JXCurrentViewController();
//                [currentVC presentViewController:nc animated:YES completion:NULL];
//            }
//        }
//        
//        if (pass && finish) {
//            finish();
//        }
//        
//        return pass;
//    }
//    
//    if (JXErrorCodeTokenInvalid == error.code) {
//        pass = NO;
//        
//        [self logout];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyUserDidExpire object:nil];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [JXDialog showError:error handler:NULL];
//        });
//        
//        Class cls = NSClassFromString(@"LoginViewController");
//        if (cls) {
//            JXLoginViewController *vc = [[cls alloc] init];
//            vc.didPassBlock = finish;
//            JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//            
//            UIViewController *currentVC = JXCurrentViewController();
//            [currentVC presentViewController:nc animated:YES completion:NULL];
//        }
//    }else {
//        JXHUDError(error.localizedDescription, YES);
//    }
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (pass && finish) {
//            finish();
//        }
//    });
//    
//    return pass;
//}

- (void)loginWithUser:(JXUser *)user {
    [self setupWithUser:user];
    
    self.isLogined = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyUserDidLogin object:nil];
}

- (void)setupWithUser:(JXUser *)user {
    [self setupProperties:user];
    self.jxID = user.jxID;
    self.token = user.token;
}

- (void)logout {
    [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyUserWillLogout object:nil];
    [self resetProperties];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyUserDidLogout object:nil];
}

@end



