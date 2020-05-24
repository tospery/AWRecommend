//
//  WebViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/8.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "WebViewController.h"
#import "NiceViewController.h"
#import "NiceDetailViewController.h"
#import "WXPayRequest.h"
#import "JXPayManager.h"


@interface WebViewController () <JXPayManagerDelegate>
@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, strong) WebInteraction *wi;
@property (nonatomic, strong) PayReq *req;

@end

@implementation WebViewController
#pragma mark - Override
#pragma mark init
#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationController.navigationBar.hidden = YES;
    
    [self syncUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.onceToken) {
        [self syncUser];
    }else {
        self.onceToken = YES;
    }
}

#pragma mark empty
#pragma mark - Accessor
#pragma mark - Private
- (void)syncUser {
    WebInteraction *wi = [WebInteraction new];
    wi.code = 1;
    wi.data = [WebInteractionData new];
    wi.data.platform = 2;
    wi.data.token = JXStrWithDft(gUser.token, @"");
    
    NSString *jsonString = [wi mj_JSONString];
    NSLog(@"同步用户...");
    [self.bridge callHandler:self.jsCallbackIdentifier data:jsonString responseCallback:^(id responseData) {
        int a = 0;
        NSLog(@"同步完成！");
    }];
    
//    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
//        int a = 0;
//    } error:NULL];
}

#pragma mark - Public
- (void)nativeResponse:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    self.wi = [WebInteraction mj_objectWithKeyValues:data];
    switch (self.wi.code) {
        case 101:
        case 102: {
            [TMInstance removeObjectForKey:kTMTestList];
            [gUser logout];
            [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            } error:NULL];
            break;
        }
        case 110: {
            WebInteraction *wi = [WebInteraction new];
            wi.code = 1;
            wi.data = [WebInteractionData new];
            wi.data.platform = 2;
            wi.data.token = JXStrWithDft(gUser.token, @"");
            
            NSString *jsonString = [wi mj_JSONString];
            responseCallback(jsonString);
            return;
            break;
        }
        case 180: {
            // 在线支付
            [JXPayManager sharedInstance].delegate = self;
            JXHUDProcessing(nil);
            [[HRInstance orderPay:self.wi.data.orderId cash:self.wi.data.price type:1] subscribeNext:^(id  _Nullable x) {
                WXPayRequest *info = [WXPayRequest mj_objectWithKeyValues:x];
                self.req = [[PayReq alloc] init];
                self.req.partnerId = info.partnerid;
                self.req.prepayId = info.prepayid;
                self.req.nonceStr = info.noncestr;
                self.req.timeStamp = (UInt32)info.timestamp;
                self.req.package = info.packages;
                self.req.sign = info.sign;
                [WXApi sendReq:self.req];
                JXHUDHide();
            } error:^(NSError * _Nullable error) {
                JXHUDInfo(error.localizedDescription, YES);
            }];

            break;
        }
        case 201: {
            // 良品列表
            NiceViewController *vc = [[NiceViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 202: {
            NiceDetailViewController *vc = [[NiceDetailViewController alloc] init];
            vc.navItemColor = JXColorHex(0x333333);
            vc.niceID = self.wi.data.niceId.integerValue;
            vc.hidesBottomBarWhenPushed = YES;
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    
    responseCallback(@"Response from testObjcCallback");
}

- (void)openAgain:(NSString *)target {
    WebViewController *vc = [[WebViewController alloc] initWithLink:target];
    vc.hidesBottomBarWhenPushed = YES;
    vc.canNew = YES;
    //vc.navItemColor = JXColorHex(0x333333);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
#pragma mark - Notification
#pragma mark - Delegate
- (void)managerDidRecvPayResp:(PayResp *)resp {
    switch (resp.errCode) {
        case WXSuccess: {
            JXHUDInfo(@"微信支付成功", NO);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
            break;
        case WXErrCodeUserCancel: {
            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"未完成支付，是否继续支付？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (1 == buttonIndex) {
                    [WXApi sendReq:self.req];
                }else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            break;
        }
        default: {
            JXHUDInfo(@"微信支付支付失败呃", NO);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
            break;
    }
}

#pragma mark - Class


@end





