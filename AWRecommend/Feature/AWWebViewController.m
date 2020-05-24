//
//  AWWebViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "AWWebViewController.h"
#import "NiceViewController.h"
#import "NiceDetailViewController.h"
#import "WXPayRequest.h"
#import "JXPayManager.h"
#import "ShortcutView.h"
#import "MessageListViewController.h"
#import "ReputeViewController.h"

@interface AWWebViewController () <JXPayManagerDelegate, JXAliPayManagerDelegate>
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *finishItem;

@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, strong) WebInteraction *wi;
@property (nonatomic, strong) PayReq *req;

@property (nonatomic, strong) RACCommand *doctorCommand;
@property (nonatomic, strong) RACCommand *cartCountCommand;

@property (nonatomic, strong) ShortcutView *shortcutView;

@property (nonatomic, strong) UILabel *messageUnreadLabel;
@property (nonatomic, strong) RACCommand *orderCommand;

@property (nonatomic, strong) NSString *alipayOrderid;

@end

@implementation AWWebViewController
#pragma mark - Override
#pragma mark init
- (void)viewDidLoad {
    // self.progressColor = [UIColor blueColor];
    [super viewDidLoad];
    [self syncUser:YES];
    [self syncCart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.onceToken) {
        [self syncUser:NO];
        [self syncCart];
    }else {
        self.onceToken = YES;
    }
    
    if ([self.webURL.absoluteString containsString:@"page/shopCar.html"]) {
        if (self.navigationItem.rightBarButtonItem) {
            self.navigationItem.rightBarButtonItem = self.editItem;
        }
    }
    
    if (gUser.isLogined) {
        [self.orderCommand execute:nil];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.messageUnreadLabel) {
        [self.messageUnreadLabel jx_circleWithColor:[UIColor clearColor] border:0.0f];
    }
}

- (void)returnItemPressed:(id)sender {
    if ([self.webURL.absoluteString containsString:@"wechatPay.html"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确认离开？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:NULL];
        
        return;
    }
    [super returnItemPressed:sender];
}

- (UIBarButtonItem *)editItem {
    if (!_editItem) {
        _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItemPressed:)];
        [_editItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: JXColorHex(0x999999), kJXKeyTitleFont: JXFont(14)}];
    }
    return _editItem;
}

- (UIBarButtonItem *)finishItem {
    if (!_finishItem) {
        _finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishItemPressed:)];
        [_finishItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: JXColorHex(0x999999), kJXKeyTitleFont: JXFont(14)}];
    }
    return _finishItem;
}

- (void)editItemPressed:(id)sender {
    self.navigationItem.rightBarButtonItem = self.finishItem;
    
    WebInteraction *wi = [WebInteraction new];
    wi.code = 5;
    wi.data = [WebInteractionData new];
    wi.data.platform = 2;
    wi.data.token = JXStrWithDft(gUser.token, @"");
    
    NSString *jsonString = [wi mj_JSONString];
    [self.bridge callHandler:kJXWebJSCallback data:jsonString responseCallback:^(id responseData) {
        [self responseFromJSData:responseData];
    }];
}

- (void)finishItemPressed:(id)sender {
    self.navigationItem.rightBarButtonItem = self.editItem;
    
    WebInteraction *wi = [WebInteraction new];
    wi.code = 6;
    wi.data = [WebInteractionData new];
    wi.data.platform = 2;
    wi.data.token = JXStrWithDft(gUser.token, @"");
    
    NSString *jsonString = [wi mj_JSONString];
    [self.bridge callHandler:kJXWebJSCallback data:jsonString responseCallback:^(id responseData) {
        [self responseFromJSData:responseData];
    }];
}

- (void)syncUser:(BOOL)isLoad {
    WebInteraction *wi = [WebInteraction new];
    wi.code = 1;
    wi.data = [WebInteractionData new];
    wi.data.platform = 2;
    wi.data.token = JXStrWithDft(gUser.token, @"");
    
    if ([self.webURL.absoluteString containsString:@"page/orderClass.html"]) {
        //        NSString *link = self.webURL.absoluteString;
        //        NSString *index = [link substringFromIndex:(link.length - 1)];
        //        wi.data.orderType = [index integerValue];
        wi.data.isFirstLoad = isLoad;
    }else {
        wi.data.isFirstLoad = YES;
    }
    
    NSString *jsonString = [wi mj_JSONString];
    JXLogInfo(@"同步用户: %@", jsonString);
    @weakify(self)
    [self.bridge callHandler:kJXWebJSCallback data:jsonString responseCallback:^(id responseData) {
        @strongify(self)
        [self responseFromJSData:responseData];
    }];
}

- (void)syncCart {
    if (!gUser.isLogined) {
        return;
    }
    
    [self.cartCountCommand execute:nil];
}

- (RACCommand *)cartCountCommand {
    if (!_cartCountCommand) {
        _cartCountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getCartGoodsNum];
        }];
        [_cartCountCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *count) {
            gMisc.cartCount = count.integerValue;
        }];
    }
    return _cartCountCommand;
}


- (RACCommand *)doctorCommand {
    if (!_doctorCommand) {
        _doctorCommand = EntryChat(self);
    }
    return _doctorCommand;
}

- (void)requestFromJSData:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    self.wi = [WebInteraction mj_objectWithKeyValues:data];
    switch (self.wi.code) {
        case 1: {       // 同步用户token
            break;
        }
        case 101:       // 用户未登录
        case 102: {     // 用户登录过期
            [TMInstance removeObjectForKey:kTMTestList];
            [gUser logout];
            [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            } error:NULL];
            break;
        }
        case 103: {     // 操作-成功提示（添加地址）
            [JXDialog showPopup:self.wi.msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            break;
        }
        case 104: {     // 操作-失败提示
            [JXDialog showPopup:self.wi.msg];
            break;
        }
        case 105: {     // 购物车加减数量
            gMisc.cartCount = self.wi.data.cartCount;
            break;
        }
        case 106: {     // 加入购物车
            // self.wi.data.cartCount;
            // [JXDialog showPopup:self.wi.msg];
            // JXHUDSuccess(self.wi.msg, NO);
            [JXDialog showPopup:self.wi.msg];
            gMisc.cartCount += 1;
            break;
        }
        case 107: {     // 跳转至领券中心
            AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(kYhqCenterLink) title:@"领券中心"];
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 110: {     // Web端的用户同步请求（弃用）
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
        case 120: {     // 商品分享
            if (![WXApi isWXAppInstalled]) {
                [JXDialog showPopup:@"请先安装微信客户端"];
                return;
            }
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
            if ([WXApi isWXAppInstalled]) {
                [arr addObject:@(UMSocialPlatformType_WechatSession)];
                [arr addObject:@(UMSocialPlatformType_WechatTimeLine)];
            }
            //[arr addObject:@(UMSocialPlatformType_QQ)];
            
            [UMSocialUIManager setPreDefinePlatforms:arr];
            [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
            [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                NSString *title = JXStrWithDft(self.wi.data.title, @"");
                NSString *desc = JXStrWithDft(self.wi.data.desc, @"");
//                id icon = (self.wi.data.imgUrl.length != 0 ? self.wi.data.imgUrl : JXImageWithName(@"my_appicon"));
                
                if (self.wi.data.imgUrl.length != 0) {
                    [[SDWebImageManager sharedManager] downloadImageWithURL:JXURLWithStr(self.wi.data.imgUrl) options:0 progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            id icon = image ? image : JXImageWithName(@"my_appicon");
                            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:icon];
                            shareObject.webpageUrl = JXStrWithFmt(kGoodsLink, self.wi.data.id);
                            
                            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                            messageObject.shareObject = shareObject;
                            
                            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                                //            if (error) {
                                //                JXHUDError(error.localizedDescription, YES);
                                //            }
                            }];
                    }];
                }else {
                    id icon = JXImageWithName(@"my_appicon");
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:icon];
                    shareObject.webpageUrl = JXStrWithFmt(kGoodsLink, self.wi.data.id);
                    
                    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                    messageObject.shareObject = shareObject;
                    
                    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                        //            if (error) {
                        //                JXHUDError(error.localizedDescription, YES);
                        //            }
                    }];
                }
            }];
            break;
        }
        case 121: {     // 药师咨询
            [gUser checkLoginWithFinish:^(BOOL relogined) {
                [self.doctorCommand execute:nil];
            } error:nil];
            break;
        }
        case 122: {
            [JXDialog showPopup:self.wi.msg];
            break;
        }
        case 180: {     // 在线支付
            [JXPayManager sharedInstance].delegate = self;
            JXHUDProcessing(nil);
            // self.wi.data.type = 2;
            [[HRInstance orderPay:self.wi.data.orderId cash:self.wi.data.price type:self.wi.data.type] subscribeNext:^(id  _Nullable x) {
                if (self.wi.data.type == 1) {
                    WXPayRequest *info = [WXPayRequest mj_objectWithKeyValues:x];
                    self.req = [[PayReq alloc] init];
                    self.req.partnerId = info.partnerid;
                    self.req.prepayId = info.prepayid;
                    self.req.nonceStr = info.noncestr;
                    self.req.timeStamp = (UInt32)info.timestamp;
                    self.req.package = info.packages;
                    self.req.sign = info.sign;
                    [WXApi sendReq:self.req];
                }else {
                    self.alipayOrderid = x;
                    [self alipayWithOrderid:self.alipayOrderid schemaName:@"appvworks-recommend"];
                }
                
                JXHUDHide();
            } error:^(NSError * _Nullable error) {
                JXHUDInfo(error.localizedDescription, YES);
            }];
            
            break;
        }
        case 201: {     // 良品列表
            NiceViewController *vc = [[NiceViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 202: {     // 好价详情
            NiceDetailViewController *vc = [[NiceDetailViewController alloc] init];
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            vc.niceID = self.wi.data.niceId.integerValue;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 203: {     // 订单详情加载完成
            break;
        }
        case 204: {     // 商品详情加载完成
            break;
        }
        case 220: {     // 切换收货地址
            [JXDialog showPopup:self.wi.msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            break;
        }
        case 210:       // 取消订单
        case 211: {     // 确认收货
//            NSInteger index = 4;
//            NSString *link = JXStrWithFmt(kOrderLink, index);
//            AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
//            vc.jxIdentifier = @"我的订单";
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.navItemColor = JXColorHex(0x333333);
//            vc.statusBarStyle = JXStatusBarStyleDefault;
//            [self.navigationController pushViewController:vc animated:YES];
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSArray *arr = self.navigationController.viewControllers;
//                NSMutableArray *ma = [NSMutableArray array];
//                [ma addObject:arr.firstObject];
//                [ma addObject:arr.lastObject];
//                self.navigationController.viewControllers = ma;
//            });
            
            ReputeViewController *vc = [[ReputeViewController alloc] init];
            vc.param = self.wi.data.orderId;
            vc.hidesReturnBarItem = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 212: {     // 点击添加收货地址
            AddrAddViewController *vc = [[AddrAddViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 213: {     // 点击添加收货地址【确认订单】
            AddrAddViewController *vc = [[AddrAddViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 214: {     // 修改收货地址
            AddrAddViewController *vc = [[AddrAddViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            vc.param = self.wi.data;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
    
    [super requestFromJSData:data responseCallback:responseCallback];
}

- (void)responseFromJSData:(id)data {
    [super responseFromJSData:data];
}

- (void)didLoadURL:(NSURL *)url {
    [super didLoadURL:url];
    NSString *link = url.absoluteString;
    if ([link containsString:@"page/orderInfo.html"]
        || [link containsString:@"page/goodsDetails.html"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:JXAdaptImage(JXImageWithName(@"detail_more")) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(orderItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }else if([link containsString:@"page/shopCar.html"]) {
        self.navigationItem.rightBarButtonItem = self.editItem;
    }else if([link containsString:@"page/goodsList.html"]) {
        [self.view addSubview:self.shortcutView];
        [self.shortcutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-80);
        }];
        
        CGFloat slide = 30.0f;
        UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, slide, slide)];
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setImage:JXImageWithName(@"ic_black_messager") forState:UIControlStateNormal];
        [messageButton addTarget:self action:@selector(messageBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [messageView addSubview:messageButton];
        self.messageUnreadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.messageUnreadLabel.backgroundColor = [UIColor redColor];
        self.messageUnreadLabel.hidden = YES;
        [messageView addSubview:self.messageUnreadLabel];
        [self.messageUnreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(messageView).offset(2);
            make.trailing.equalTo(messageView).offset(-2);
            make.width.equalTo(@4);
            make.height.equalTo(@4);
        }];
        [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(messageView);
        }];
        [self.view setNeedsDisplay];
        UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithCustomView:messageView];
        self.navigationItem.rightBarButtonItem = messageBarItem;
        if (gUser.isLogined) {
            [self.orderCommand execute:nil];
        }
    }else if ([link containsString:@"page/savecenter.html"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem jx_barItemWithImage:JXImageWithName(@"ic_buy_share") size:CGSizeMake(22, 22) target:self action:@selector(shareItemPressed:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didRefresh {
    [super didRefresh];
    [self syncUser:YES];
    [self syncCart];
}

- (void)messageBarItemClicked:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL relogined) {
        MessageListViewController *vc = [[MessageListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navItemColor = JXColorHex(0x333333);
        vc.statusBarStyle = JXStatusBarStyleDefault;
        [self.navigationController pushViewController:vc animated:YES];
    } error:nil];
}

- (RACCommand *)orderCommand {
    if (!_orderCommand) {
        _orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getOrderStateNumber];
        }];
        
        @weakify(self)
        [_orderCommand.executionSignals.switchToLatest subscribeNext:^(OrderPendingAmount *amount) {
            @strongify(self)
            if (self.messageUnreadLabel) {
                self.messageUnreadLabel.hidden = (amount.sysNum == 0);
            }
        }];
    }
    return _orderCommand;
}

- (void)orderItemPressed:(UIButton *)btn {
    // [btn setImage:JXAdaptImage(JXImageWithName(@"ic_arrow_slod_up")) forState:UIControlStateNormal];
    
    [KxMenu setTintColor:[UIColor whiteColor]];
    [KxMenu setTitleFont:JXFont(13.0f)];
    [KxMenu setDisableGradient:YES];
    [KxMenu configHightlightColor:[UIColor whiteColor]];
    [KxMenu setupWillDismissBlock:^{
        // [btn setImage:JXAdaptImage(JXImageWithName(@"ic_arrow_slod_down")) forState:UIControlStateNormal];
    }];
    
    KxMenuItem *item1 = [KxMenuItem menuItem:@" 良品 " image:JXAdaptImage(JXImageWithName(@"ic_pop_backToLiangpin")) target:self action:@selector(orderShopClicked:)];
    item1.foreColor = JXColorHex(0x333333);
    item1.alignment = NSTextAlignmentCenter;
    KxMenuItem *item2 = [KxMenuItem menuItem:@" 购物车" image:JXAdaptImage(JXImageWithName(@"ic_pop_backToCart")) target:self action:@selector(orderCartClicked:)];
    item2.foreColor = JXColorHex(0x333333);
    item2.alignment = NSTextAlignmentCenter;
    KxMenuItem *item3 = [KxMenuItem menuItem:@" 我的 " image:JXAdaptImage(JXImageWithName(@"ic_pop_backToUser")) target:self action:@selector(orderMineClicked:)];
    item3.foreColor = JXColorHex(0x333333);
    item3.alignment = NSTextAlignmentCenter;
    
    CGRect rect = CGRectMake(btn.center.x, btn.jx_y + btn.jx_height + 20.0f + 4.0f, 0, 0);
    if (JXiOSVersionGreaterThanOrEqual(@"11")) {
        rect = CGRectMake(JXAdaptScreenWidth() - 28, 56, 0, 0);
    }
    [KxMenu showMenuInView:JXAppWindow fromRect:rect menuItems:@[item1, item2, item3]];
}

- (void)orderShopClicked:(id)sender {
    JXViewController *rootVC = self.navigationController.viewControllers.firstObject;
    if ([rootVC isKindOfClass:[MineViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        UITabBarController *mainVC = [JXAppDelegate mainTbController];
        [mainVC setSelectedIndex:1];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)orderCartClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    UITabBarController *mainVC = [JXAppDelegate mainTbController];
    [mainVC setSelectedIndex:2];
}

- (void)orderMineClicked:(id)sender {
    JXViewController *rootVC = self.navigationController.viewControllers.firstObject;
    if ([rootVC isKindOfClass:[MineViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popToRootViewControllerAnimated:NO];
        UITabBarController *mainVC = [JXAppDelegate mainTbController];
        [mainVC setSelectedIndex:3];
    }
}

- (ShortcutView *)shortcutView {
    if (!_shortcutView) {
        _shortcutView = [[[NSBundle mainBundle] loadNibNamed:@"ShortcutView" owner:self options:nil] firstObject];
        @weakify(self)
        _shortcutView.doctorBlock = ^{
            @strongify(self)
            [gUser checkLoginWithFinish:^(BOOL relogined) {
                @strongify(self)
                [self.doctorCommand execute:nil];
            } error:nil];
        };
        _shortcutView.cartBlock = ^{
            @strongify(self)
            AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(kCartLink) title:@"购物车"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _shortcutView;
}

- (void)didRecvPayResp:(NSDictionary *)response {
    [JXPayManager sharedInstance].aliDelegate = nil;
    
    NSInteger from = 0;
    NSArray *vcs = self.navigationController.viewControllers;
    JXViewController *vc = vcs.firstObject;
    if ([vc isKindOfClass:[MineViewController class]]) {
        from = 2;
    }else {
        from = 1;
    }
    
    NSString *status = [response objectForKey:@"resultStatus"];
    if ([status isEqualToString:@"9000"]) {
        JXHUDInfo(@"支付宝支付成功", NO);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (1 == from) {
                // [self.navigationController popToRootViewControllerAnimated:YES];
                NSInteger index = 2;
                NSString *link = JXStrWithFmt(kOrderLink, index);
                AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
                vc.jxIdentifier = @"我的订单";
                vc.hidesBottomBarWhenPushed = YES;
                vc.navItemColor = JXColorHex(0x333333);
                vc.statusBarStyle = JXStatusBarStyleDefault;
                [self.navigationController pushViewController:vc animated:YES];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSArray *arr = self.navigationController.viewControllers;
                    NSMutableArray *ma = [NSMutableArray array];
                    [ma addObject:arr.firstObject];
                    [ma addObject:arr.lastObject];
                    self.navigationController.viewControllers = ma;
                });
            }else {
                NSInteger index = 2;
                NSString *link = JXStrWithFmt(kOrderLink, index);
                AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
                vc.jxIdentifier = @"我的订单";
                vc.hidesBottomBarWhenPushed = YES;
                vc.navItemColor = JXColorHex(0x333333);
                vc.statusBarStyle = JXStatusBarStyleDefault;
                [self.navigationController pushViewController:vc animated:YES];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSArray *arr = self.navigationController.viewControllers;
                    NSMutableArray *ma = [NSMutableArray array];
                    [ma addObject:arr.firstObject];
                    [ma addObject:arr.lastObject];
                    self.navigationController.viewControllers = ma;
                });
            }
        });
    }else if ([status isEqualToString:@"6001"] || [status isEqualToString:@"4000"]) {
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"未完成支付，是否继续支付？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (1 == buttonIndex) {
                // [WXApi sendReq:self.req];
                [self alipayWithOrderid:self.alipayOrderid schemaName:@"appvworks-recommend"];
            }else {
                if (1 == from) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }else {
        JXHUDInfo(@"支付宝支付失败呃", NO);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (1 == from) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }
}

- (void)alipayWithOrderid:(NSString *)orderid schemaName:(NSString *)schemaName {
    [JXPayManager sharedInstance].aliDelegate = self;
    [[AlipaySDK defaultService] payOrder:orderid fromScheme:schemaName callback:^(NSDictionary *resultDic) {
        [self didRecvPayResp:resultDic];
    }];
}

- (void)shareItemPressed:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [JXDialog showPopup:@"请先安装微信客户端"];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    if ([WXApi isWXAppInstalled]) {
        [arr addObject:@(UMSocialPlatformType_WechatSession)];
        [arr addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }

    [UMSocialUIManager setPreDefinePlatforms:arr];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSString *title = @"还是我懂你，这里是你最想要的！";
        NSString *desc = @"皇上，领券后请您详细阅读优惠券的使用期限，品类和范围，小的给您跪安了";
        id icon = JXImageWithName(@"my_appicon");
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:icon];
        shareObject.webpageUrl = kYhqCenterLink;
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        }];
    }];
}

#pragma mark - Delegate
- (void)paysusccessByZfb {
    NSInteger from = 0;
    NSArray *vcs = self.navigationController.viewControllers;
    JXViewController *vc = vcs.firstObject;
    //    if ([vc.webURL.absoluteString containsString:@"page/shopCar.html"]) {
    //        from = 1;
    //    }
    
    if ([vc isKindOfClass:[MineViewController class]]) {
        from = 2;
    }else {
        from = 1;
    }
    
    JXHUDInfo(@"微信支付成功", NO);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (1 == from) {
            // [self.navigationController popToRootViewControllerAnimated:YES];
            NSInteger index = 2;
            NSString *link = JXStrWithFmt(kOrderLink, index);
            AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
            vc.jxIdentifier = @"我的订单";
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *arr = self.navigationController.viewControllers;
                NSMutableArray *ma = [NSMutableArray array];
                [ma addObject:arr.firstObject];
                [ma addObject:arr.lastObject];
                self.navigationController.viewControllers = ma;
            });
        }else {
            NSInteger index = 2;
            NSString *link = JXStrWithFmt(kOrderLink, index);
            AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
            vc.jxIdentifier = @"我的订单";
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *arr = self.navigationController.viewControllers;
                NSMutableArray *ma = [NSMutableArray array];
                [ma addObject:arr.firstObject];
                [ma addObject:arr.lastObject];
                self.navigationController.viewControllers = ma;
            });
        }
    });
}

- (void)managerDidRecvPayResp:(PayResp *)resp {
    NSInteger from = 0;
    NSArray *vcs = self.navigationController.viewControllers;
    JXViewController *vc = vcs.firstObject;
    //    if ([vc.webURL.absoluteString containsString:@"page/shopCar.html"]) {
    //        from = 1;
    //    }
    
    if ([vc isKindOfClass:[MineViewController class]]) {
        from = 2;
    }else {
        from = 1;
    }
    
    switch (resp.errCode) {
        case WXSuccess: {
            JXHUDInfo(@"微信支付成功", NO);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (1 == from) {
                    // [self.navigationController popToRootViewControllerAnimated:YES];
                    NSInteger index = 2;
                    NSString *link = JXStrWithFmt(kOrderLink, index);
                    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
                    vc.jxIdentifier = @"我的订单";
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navItemColor = JXColorHex(0x333333);
                    vc.statusBarStyle = JXStatusBarStyleDefault;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSArray *arr = self.navigationController.viewControllers;
                        NSMutableArray *ma = [NSMutableArray array];
                        [ma addObject:arr.firstObject];
                        [ma addObject:arr.lastObject];
                        self.navigationController.viewControllers = ma;
                    });
                }else {
                    NSInteger index = 2;
                    NSString *link = JXStrWithFmt(kOrderLink, index);
                    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
                    vc.jxIdentifier = @"我的订单";
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navItemColor = JXColorHex(0x333333);
                    vc.statusBarStyle = JXStatusBarStyleDefault;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSArray *arr = self.navigationController.viewControllers;
                        NSMutableArray *ma = [NSMutableArray array];
                        [ma addObject:arr.firstObject];
                        [ma addObject:arr.lastObject];
                        self.navigationController.viewControllers = ma;
                    });
                }
            });
        }
            break;
        case WXErrCodeUserCancel: {
            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"未完成支付，是否继续支付？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (1 == buttonIndex) {
                    [WXApi sendReq:self.req];
                }else {
                    if (1 == from) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
            break;
        }
        default: {
            JXHUDInfo(@"微信支付支付失败呃", NO);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (1 == from) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }
            break;
    }
}

+ (NSArray *)canRefreshLinks {
    return @[kShopLink, kCartLink];
}

+ (NSArray *)canNewLinks {
    return @[kShopLink, kCartLink];
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
//
////    NSString *identifier = self.jxIdentifier;
////    if ([identifier isEqualToString:@"良品"]
////        || [identifier isEqualToString:@"购物车"]
////        || [identifier isEqualToString:@"我的订单"]
////        || [identifier isEqualToString:@"地址管理"]
////        || [identifier isEqualToString:@"会员福利"]) {
////        decisionHandler(WKNavigationActionPolicyAllow);
////        return;
////    }
//
//    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:navigationAction.request.URL];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    decisionHandler(WKNavigationActionPolicyCancel);
//}

@end





