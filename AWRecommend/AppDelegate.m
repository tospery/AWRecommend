//
//  AppDelegate.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "AppDelegate.h"
#import "FavoriteViewController.h"
#import "AboutViewController.h"
#import "LaunchView.h"
#import "ScanViewController.h"
#import "DataHelper.h"
#import "ScanPopupViewController.h"
#import "HomeViewController.h"
#import "JXPayManager.h"
#import <UserNotifications/UserNotifications.h>
#import "CartViewController.h"
#import "ShopViewController.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, WXApiDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [VMInstance setupIQKeyboardManager];
    [VMInstance setupAFNetworking];
    [VMInstance setupJSPatch];
    [VMInstance setupPgy];
    
    [self customJXObjc];
    [self customAppearance];
    [self initData];
    [self setupPlatform:launchOptions];
    
    LaunchView *adView = [[[NSBundle mainBundle] loadNibNamed:@"LaunchView" owner:nil options:nil] firstObject];
    //@weakify(self)
    [adView startAnimWithCompletion:^{
        //@strongify(self)
        //        [self initWeixin];
        //        [self initBPushWithOptions:launchOptions]; // 百度推送
        //        //[self initUMessageWithOption:launchOptions]; // 友盟推送
        //        [self checkUpdate];
        // [DataHelper updateUserData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self syncCartNum];
        });
    }];
    
    [self acquirePermission];
    
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self test];
    });
    
    return YES;
}

- (void)syncCartNum {
    if (!gUser.isLogined) {
        return;
    }
    
    @weakify(self)
    [[HRInstance getCartGoodsNum] subscribeNext:^(NSNumber *count) {
        @strongify(self)
        gMisc.cartCount = count.integerValue;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            @strongify(self)
            [self syncCartNum];
        } error:error];
    }];
}

//@property (nonatomic, strong) RACCommand *infoCommand;
//- (RACCommand *)infoCommand {
//    if (!_infoCommand) {
//        _infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            return [HRInstance requestYjqxFuncItems];
//        }];
//        
//        [_infoCommand.executing subscribe:self.executing];
//        [_infoCommand.errors subscribe:self.errors];
//        
//        @weakify(self)
//        [_infoCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
//            @strongify(self)
//        }];
//    }
//    return _infoCommand;
//}


- (void)test {
//    {
//        "list": [
//                 {
//                     "content": "xxxxxx",
//                     "goodId":2,
//                     "stars":1,
//                     "tagId":"1,2",
//                     "tagName": "很好,非常"
//                 }
//                 ],
//        "orderId": 10006
//    }
//    NSDictionary *input = @{@"orderId": @(10016),
//                            @"list": @[@{@"content": @"abcd1234",
//                                         @"goodId": @"2",
//                                         @"stars": @"1",
//                                         @"tagId": @"1,2",
//                                         @"tagName": @"很好,非常"}]};
//
////    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
////    param.header = [param commonHeader];
////    param.data = input;
//
//    [[HRInstance addCommentsForMac:input] subscribeNext:^(id  _Nullable x) {
//        int a = 0;
//    } error:^(NSError * _Nullable error) {
//        int b = 0;
//    }];
//
//    NSURL *baseURL = JXURLWithStr(@"http://ivhome-test.appvworks.com/appvworks.ihealth.portal");;
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:baseURL.absoluteString forHTTPHeaderField:@"Referer"];
//    manager.requestSerializer.timeoutInterval = 30;
//
//    [manager.requestSerializer setValue:gUser.token forHTTPHeaderField:@"token"];
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"text/xml", nil];
//    [manager POST:@"v1/shop/comment/addCommentsForMac" parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        int a = 0;
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        int b = 0;
//    }];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"all_citys" ofType:@"json"];
//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    AddrCollect *ac = [AddrCollect mj_objectWithKeyValues:str];
    
//    NSArray *arr = [Addr mj_objectArrayWithKeyValuesArray:str];
//    NSMutableArray *cities = [NSMutableArray arrayWithCapacity:50];
//    for (Addr *a in arr) {
//        NSString *name = a.name;
//        if ([name containsString:@"台湾"]) {
//            continue;
//        }
//        
//        if (0 == a.child.count) {
//            [cities addObject:a];
//        }
//        
//        if ([name containsString:@"北京"] ||
//            [name containsString:@"天津"] ||
//            [name containsString:@"上海"] ||
//            [name containsString:@"重庆"] ||
//            [name containsString:@"香港"] ||
//            [name containsString:@"澳门"]) {
//            [cities addObject:a];
//            continue;
//        }
//        
//        if (0 != a.child.count) {
//            [cities addObjectsFromArray:a.child];
//        }
//    }
//    int a = 0;
//    NSArray *items =  _mainTbController.tabBar.items;
//    UITabBarItem *i = items[2];
//    i.badgeValue = @"9"; // JXStrWithInt(999);
//    i.badgeColor = SMInstance.mainColor;
    
    // [[tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",number]];
//    [JXDialog showPopup:@"您长期未使用，请重新登录！"];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [JXDialog showPopup:@"登录成功"];
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [JXDialog showPopup:@"父亲是部队军人，做政治工作的，父母对他的教育，印象最深的就是诚实，父母的一言一行都深刻影响着崔永元，父母的榜样，使崔永元养成了善待他人、坦诚处世的好性格，父母是对崔永元的一生最具有影响力的爱，他把这份爱比喻成父爱就像日出，那样光明磊落，真挚情深，母爱就像月亮，那样温柔无私，慈爱无边。"];
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [JXDialog showPopup:@"退出成功"];
//    });
    
//    if (0 == base.length) {
//        return nil;
//    }
//    
//    if (0 == path.length) {
//        return [NSURL URLWithString:base];
//    }
//    
//    NSURL *baseURL = [NSURL URLWithString:base];
//    if (baseURL.path.length > 0 && ![baseURL.absoluteString hasSuffix:@"/"]) {
//        baseURL = [baseURL URLByAppendingPathComponent:@""];
//    }
//    
//    return [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:baseURL];
    
//    NSString *baseString = @"https://ivhome-test.appvworks.com/appvworks.ihealth.portal";
//    NSString *pathString = @"/v1/drugindex/getKnowledgeLibInfo";
//    
//    if (![baseString hasSuffix:@"/"]) {
//        baseString = JXStrWithFmt(@"%@/", baseString);
//    }
//    if ([pathString hasPrefix:@"/"]) {
//        pathString = [pathString substringFromIndex:1];
//    }
//    
//    NSURL *baseURL = [NSURL jx_URLWithString:baseString];
//    
//    
////    NSURL *baseURL = [NSURL jx_URLWithString:baseString];
////    if ([baseString isEqualToString:baseURL.absoluteString]) {
////        NSLog(@"相等");
////    }
////    
//    NSURL *b1 = [NSURL URLWithString:[pathString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:baseURL];
//    NSString *c1 = b1.absoluteString;
//    int a = 0;
//
//    if (![baseURL.absoluteString hasSuffix:@"/"]) {
//        baseURL = [baseURL URLByAppendingPathComponent:@"/"];
//    }
//    
//    NSString *a1 = baseURL.absoluteString;
//    int ccccc = 0;
    
    
//    NSDate *curDate = [NSDate jx_dateFromString:@"2017-06-22 14:23:20" format:kJXFormatDatetimeStyle1];
//    NSDate *cmtDate = [NSDate jx_dateFromString:@"2017-06-22 14:23:00" format:kJXFormatDatetimeStyle1];
//    NSTimeInterval interval = [curDate timeIntervalSinceDate:cmtDate];
//    int a = 0;
    
//    NSObject *o = [NSObject new];
//    NSUInteger h = o.hash;
//    int a = 0;
//    NSArray *arr = @[@"aaa", @"bbb", @"ccc"];
////    BOOL ret = [arr containsObject:@"bbb"];
//    int a = 0;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        for(NSString *fontfamilyname in [UIFont familyNames])
//        {
//            NSLog(@"family:'%@'",fontfamilyname);
//            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//            {
//                NSLog(@"\tfont:'%@'",fontName);
//            }
//            NSLog(@"-------------");
//        }
//    });
    
//    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//    SDImageCache *cache = [SDImageCache sharedImageCache];
//    for (LaunchImageInfo *info in infos) {
//        [downloader downloadImageWithURL:JXURLWithStr(info.url) options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//            if (image && finished) {
//                [cache storeImage:image forKey:info.name];
//            }
//        }];
//    }
    
//    NSArray *links = @[@"http://appvworks-img.oss-cn-hangzhou.aliyuncs.com/img_list_kid@3x.png",
//                       @"http://appvworks-img.oss-cn-hangzhou.aliyuncs.com/img_list_female@3x.png",
//                       @"http://appvworks-img.oss-cn-hangzhou.aliyuncs.com/img_list_older@3x.png" ];
//    
//    SDImageCache *cache = [SDImageCache sharedImageCache];
//    UIImage *image = [cache imageFromDiskCacheForKey:links[0]];
//    if (image == nil) {
//        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//        for (NSString *link in links) {
//            [downloader downloadImageWithURL:JXURLWithStr(link) options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                if (image && finished) {
//                    [cache storeImage:image forKey:link];
//                }
//            }];
//        }
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [TMInstance setObject:gUser forKey:kJXTMUser];
    [TMInstance setObject:gMisc forKey:kJXTMMisc];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    static BOOL onceToken = NO;
    if (!onceToken) {
        onceToken = YES;
    }else {
        [self syncCartNum];
        [DataHelper updateUserData];
    }
    
    JXLogInfo(@"disk = %@", NSHomeDirectory());
    JXLogInfo(@"token = %@", gUser.token);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [TMInstance setObject:gUser forKey:kJXTMUser];
    [TMInstance setObject:gMisc forKey:kJXTMMisc];
    
    if (gUser.isLogined) {
        [[TIMManager sharedInstance] logout:^() {
            JXLogDebug(@"退出IM成功");
        } fail:^(int code, NSString *err) {
            JXLogDebug(@"退出IM失败：%@", err);
        }];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
    JXLogInfo(@"deviceToken = %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[JXPayManager sharedInstance]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        if([sourceApplication isEqualToString:@"com.tencent.xin"]) {
//            if ([url.host isEqualToString:@"pay"]) {
//                return [WXApi handleOpenURL:url delegate:[JXPayManager sharedInstance]];
//            }
//        }
//    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[JXPayManager sharedInstance] handleAlipay:resultDic];
        }];
        return YES;
    }
    
    if([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[JXPayManager sharedInstance]];
        }
    }
    
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[JXPayManager sharedInstance] handleAlipay:resultDic];
        }];
        return YES;
    }
    
    if([url.host isEqualToString:@"com.tencent.xin"]) {
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[JXPayManager sharedInstance]];
        }
    }
    
    
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

#pragma mark - Custom
#pragma mark Accessor
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (MainViewController *)mainTbController {
    if (!_mainTbController) {
//        NSArray *controllers = @[[[HomeViewController alloc] init], [[NiceViewController alloc] init], [[MineViewController alloc] init]/*, [[AboutViewController alloc] init]*/];
//        NSArray *titles = @[@"药品比选", @"药品收藏", @"关于我们"];
//        NSArray *imagesNormal = @[JXImageWithName(@"nav_drug"), JXImageWithName(@"nav_collect"), JXImageWithName(@"nav_user")];
//        NSArray *imagesSelected = @[JXImageWithName(@"nav_drugCur"), JXImageWithName(@"nav_collectCur"), JXImageWithName(@"nav_userCur")];
//
//        NSMutableArray *navControllers = [NSMutableArray arrayWithCapacity:controllers.count];
//        for (NSInteger i = 0; i < controllers.count; ++i) {
//            JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:controllers[i]];
//            [nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: JXFont(16.0) }];
////            [nc.tabBarItem jx_configWithParam:@{kJXKeyTitleText: titles[i], kJXKeyTitleColor:[UIColor blackColor], kJXKeyTitleColorSelected: SMInstance.mainColor, kJXKeyImage: imagesNormal[i], kJXKeyImageSelected: imagesSelected[i]}];
//            [navControllers addObject:nc];
//        }
//
//        _mainTbController = [[UITabBarController alloc] init];
//        _mainTbController.viewControllers = navControllers;
//        //_mainTbController.selectedIndex = 1;
//        
//        
//        
//        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
//        
//        self.tabBar = [[LLTabBar alloc] initWithFrame:_mainTbController.tabBar.bounds];
//        self.tabBar.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle : @"药品比选", kLLTabBarItemAttributeNormalImageName : @"nav_drug", kLLTabBarItemAttributeSelectedImageName : @"nav_drugCur", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
//                                             @{kLLTabBarItemAttributeTitle : @"好价", kLLTabBarItemAttributeNormalImageName : @"nav_product", kLLTabBarItemAttributeSelectedImageName : @"nav_productCur", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
//                                        @{kLLTabBarItemAttributeTitle : @"扫码找药", kLLTabBarItemAttributeNormalImageName : @"nav_scan", kLLTabBarItemAttributeSelectedImageName : @"nav_scan", kLLTabBarItemAttributeType : @(LLTabBarItemRise)},
//                                        @{kLLTabBarItemAttributeTitle : @"个人中心", kLLTabBarItemAttributeNormalImageName : @"nav_user", kLLTabBarItemAttributeSelectedImageName : @"nav_userCur", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
//        self.tabBar.delegate = self;
//        [_mainTbController.tabBar addSubview:self.tabBar];
        
//        WebViewController *cartVC = [[WebViewController alloc] initWithLink:kCartLink title:@"购物车"];
//        cartVC.canNew = YES;
//        cartVC.newBlock = ^(RACTuple *t) {
//            WebViewController *vc = [[WebViewController alloc] initWithLink:t.second];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.canNew = NO;
//            [(UINavigationController *)t.first pushViewController:vc animated:YES];
//        };
//        cartVC.navItemColor = SMInstance.mainColor;
        
        AWWebViewController *cartVC = [[AWWebViewController alloc] initWithURL:JXURLWithStr(kCartLink) title:@"购物车"];
        cartVC.jxIdentifier = @"购物车";
        cartVC.navItemColor = JXColorHex(0x333333);
        cartVC.canRefresh = YES;
        cartVC.statusBarStyle = JXStatusBarStyleDefault;
        
//        cartVC.canNew = YES;
//        cartVC.newBlock = ^(RACTuple *t) {
//            WebViewController *vc = [[WebViewController alloc] initWithLink:t.second];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.canNew = YES;
//            [(UINavigationController *)t.first pushViewController:vc animated:YES];
//        };
        //cartVC.navItemColor = JXColorHex(0x333333);
        
        AWWebViewController *shopVC = [[AWWebViewController alloc] initWithURL:JXURLWithStr(kShopLink) title:@"良品"];
        shopVC.jxIdentifier = @"良品";
        shopVC.navItemColor = JXColorHex(0x333333);
        shopVC.canRefresh = YES;
        shopVC.statusBarStyle = JXStatusBarStyleDefault;
        
        NiceViewController *niceVC = [[NiceViewController alloc] init];
        niceVC.navItemColor = JXColorHex(0x333333);
        niceVC.statusBarStyle = JXStatusBarStyleDefault;
        
        MineViewController *mineVC = [[MineViewController alloc] init];
        mineVC.statusBarStyle = JXStatusBarStyleLightContent;
        
        MytestViewController *testVC = [[MytestViewController alloc] init];
        testVC.navItemColor = JXColorHex(0x333333);
        testVC.statusBarStyle = JXStatusBarStyleDefault;
        
        // statusBarStyle
        NSArray *controllers = @[shopVC, testVC, cartVC, mineVC];
        
        NSArray *titles = @[@"良品", @"自测体质", @"购物车", @"我的"];
        NSArray *imagesNormal = @[JXImageWithName(@"nav_good"), JXImageWithName(@"nav_test"), JXImageWithName(@"nav_cart"), JXImageWithName(@"nav_user")];
        NSArray *imagesSelected = @[JXImageWithName(@"nav_goodCur"), JXImageWithName(@"nav_testCur"), JXImageWithName(@"nav_cartCur"), JXImageWithName(@"nav_userCenterCur")];
        
        NSMutableArray *navControllers = [NSMutableArray arrayWithCapacity:controllers.count];
        for (NSInteger i = 0; i < controllers.count; ++i) {
            JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:controllers[i]];
            [nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: JXFont(16.0)}];
            [nc.tabBarItem jx_configWithParam:@{kJXKeyTitleText: titles[i], kJXKeyTitleColor:[UIColor blackColor], kJXKeyTitleColorSelected: SMInstance.mainColor, kJXKeyImage: imagesNormal[i], kJXKeyImageSelected: imagesSelected[i]}];
            [navControllers addObject:nc];
            
            if (3 != i) {
                [nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleFont: JXFont(16.0)}];
            }
        }

        _mainTbController = [[MainViewController alloc] init];
        _mainTbController.viewControllers = navControllers;
        
        if (JXiOSVersionGreaterThanOrEqual(@"10.0")) {
            _mainTbController.tabBar.items[2].badgeColor = SMInstance.mainColor;
        }
        self.window.rootViewController = _mainTbController;
    }
    return _mainTbController;
}

#pragma mark Assist
- (void)entryLogin {
    
}

- (void)entryMain {
    self.window.rootViewController = self.mainTbController;
    [self.window makeKeyAndVisible];
}

- (void)customJXObjc {
    JXInstance.statusBarStyle = JXStatusBarStyleDefault;
    JXInstance.mainColor = SMInstance.mainColor;
    JXInstance.viewBgColor = SMInstance.viewBgColor;
    JXInstance.navItemColor = SMInstance.navItemColor;
    JXInstance.scanLib = JXScanLibNative;
    
//    // serverEnvs
//    RACTuple *dev = RACTuplePack(@"http://183.220.1.29:10001", @"appvworks.ihealth.portal");
//    RACTuple *hoc = RACTuplePack(@"https://ivhome-test.appvworks.com", @"appvworks.ihealth.portal");
//    RACTuple *app = RACTuplePack(@"https://api.appvworks.com", nil);
//    JXInstance.serverEnvs = RACTuplePack(dev, hoc, app);
    
    RACTuple *dev = RACTuplePack(@"http://183.220.1.29:10001", @"appvworks.ihealth.portal");
    RACTuple *hoc = RACTuplePack(@"http://ivhome-test.appvworks.com", @"appvworks.ihealth.portal");
    //RACTuple *hoc = RACTuplePack(@"http://b2b8aa12.ngrok.io", @"appvworks.ihealth.portal");
    RACTuple *app = RACTuplePack(@"https://api.appvworks.com", nil);
    JXInstance.servers = RACTuplePack(dev, hoc, app);
}

- (void)initData {
    //get the original user-agent of webview
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *info = JXStrWithFmt(@" appvworks/app/appvios/%@_v%@", [JXApp name], [JXApp version]);
    NSString *newAgent = [oldAgent stringByAppendingString:info];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    // 获取本地基础数据
    gUser = [TMInstance objectForKey:kJXTMUser];
    if (!gUser) {
        gUser = [User new];
    }
    //gUser.isLogined = YES;
    
    gMisc = [TMInstance objectForKey:kJXTMMisc];
    if (!gMisc) {
        gMisc = [Misc new];
    }
    
#ifdef JXEnableEnvDev
    gMisc.baseURLString = [(RACTuple *)JXInstance.servers.first first];
    gMisc.pathURLString = [(RACTuple *)JXInstance.servers.first second];
    gMisc.kIMAppId = @"1400016498";
    gMisc.kUMessageAppKey = @"5875ea31677baa13d6000133";
    gMisc.kUMessageAppSecret = @"shzxkx8kr4onj1vqgt1425t5khqse9dt";
#elif defined(JXEnableEnvHoc)
    gMisc.baseURLString = [(RACTuple *)JXInstance.servers.second first];
    gMisc.pathURLString = [(RACTuple *)JXInstance.servers.second second];
    gMisc.kIMAppId = @"1400016498";
    gMisc.kUMessageAppKey = @"5875ea31677baa13d6000133";
    gMisc.kUMessageAppSecret = @"shzxkx8kr4onj1vqgt1425t5khqse9dt";
#else
    gMisc.baseURLString = [(RACTuple *)JXInstance.servers.third first];
    gMisc.pathURLString = [(RACTuple *)JXInstance.servers.third second];
    gMisc.kIMAppId = @"1400016593";
    gMisc.kUMessageAppKey = @"5875ea31677baa13d6000133";
    gMisc.kUMessageAppSecret = @"shzxkx8kr4onj1vqgt1425t5khqse9dt";
#endif
    
    // 数据绑定
    [[RACObserve(gUser, isLogined) distinctUntilChanged] subscribeNext:^(NSNumber *isLogined) {
        if (JXInstance.mustLogin) {
            if (!isLogined.boolValue) {
                [self entryLogin];
            }else {
                [self entryMain];
            }
        }else {
            [self entryMain];
        }
    }];
    
    if (gUser.isLogined) {
        TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
        login_param.accountType = kIMAccountType;
        login_param.identifier = JXStrWithFmt(@"A%@", gUser.jxID);
        login_param.userSig = gUser.sig;
        login_param.appidAt3rd = gMisc.kIMAppId;
        login_param.sdkAppId = (int)[gMisc.kIMAppId integerValue];
        
        [[TIMManager sharedInstance] login:login_param succ:^(){
            JXLogDebug(@"IM登录成功");
        } fail:^(int code, NSString * err) {
            // JXHUDError(@"IM登录失败", YES);
            [JXDialog showPopup:@"IM登录失败"];
        }];
    }
    
    [RACObserve(gMisc, cartCount) subscribeNext:^(NSNumber *number) {
        NSInteger count = number.integerValue;
        if (gUser.isLogined) {
            self.mainTbController.tabBar.items[2].badgeValue = (count >= 10 ? @"9+" : JXStrWithInt(count));
            if (count == 0) {
                self.mainTbController.tabBar.items[2].badgeValue = nil;
            }
        }else {
            self.mainTbController.tabBar.items[2].badgeValue = nil;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserWillLogout:) name:kJXNotifyUserWillLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserDidLogin:) name:kJXNotifyUserDidLogin object:nil];
}

- (void)notifyUserWillLogout:(NSNotification *)notify {
    [[TIMManager sharedInstance] logout:^() {
        JXLogInfo(@"退出IM成功");
    } fail:^(int code, NSString *err) {
        JXLogInfo(@"退出IM失败：%@", err);
    }];
    
    gMisc.cartCount = 0;
    
    [TMInstance removeObjectForKey:kTMTestList];
}

- (void)notifyUserDidLogin:(NSNotification *)notify {
    NSString *aa = gUser.jxID;
    [UMessage addAlias:aa type:@"UserID" response:^(id responseObject, NSError *error) {
    }];
    
    [self toLoginIM:5];
    
    [self syncCartNum];
}

- (void)toLoginIM:(NSInteger)times {
    NSLog(@"尝试登录IM：%ld", (long)times);
    if (--times == 0) {
        return;
    }
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    login_param.accountType = kIMAccountType;
    login_param.identifier = JXStrWithFmt(@"A%@", gUser.jxID);
    login_param.userSig = gUser.sig;
    login_param.appidAt3rd = gMisc.kIMAppId;
    login_param.sdkAppId = (int)[gMisc.kIMAppId integerValue];
    
    [[TIMManager sharedInstance] login:login_param succ:^(){
        NSLog(@"IM登录成功~~~~~~~~");
    } fail:^(int code, NSString * err) {
        // JXAlert(@"提示", @"IM登录失败");
        NSLog(@"IM登录失败！！！！！！, err = %@", err);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self toLoginIM:times];
        });
    }];
}

- (void)customAppearance {
    // [UINavigationBar jx_appearanceWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: JXInstance.navItemColor, kJXKeyTitleFont: [UIFont systemFontOfSize:17.0f]}];

    [UINavigationBar jx_appearanceWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: JXFont(16.0f)}];
    
    [UITabBar jx_appearanceWithParam:@{kJXKeyTranslucent: @NO}];
    [UIBarButtonItem jx_appearanceWithParam:@{kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:14.0]}];
    
    [SMInstance configAlertStyle];
}


- (void)acquirePermission {
   //[JXPermissionManager acquireLocation];
}

- (void)setupPlatform:(NSDictionary *)launchOptions {
//    if (0 != gMisc.pgyAppID.length) {
//        [[PgyManager sharedPgyManager] setEnableDebugLog:NO];
//        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
//        [[PgyManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] checkUpdate];
//    }
    
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5875ea31677baa13d6000133"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx6e23d0e0ba2d18fa" appSecret:@"e74b16ee5713c87cb8f26391aaf700dc" redirectURL:@"https://www.appvworks.com"];
    //[[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa2b471da2c9ff688" appSecret:@"f3dc88843c07286a95f70d5a80c47131" redirectURL:@"https://www.appvworks.com"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105865453"/*设置QQ平台的appID*/  appSecret:@"H65Ob55XsfiEhAXD" redirectURL:@"https://www.appvworks.com"];
    
    [WXApi registerApp:@"wx6e23d0e0ba2d18fa" withDescription:@"awrecommend"];
    
    
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:gMisc.kUMessageAppKey launchOptions:launchOptions httpsEnable:YES];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    //[UMessage openDebugMode:YES];
    //[UMessage setLogEnabled:YES];
    
    TIMManager *manager = [TIMManager sharedInstance];
    IMListener *listener = [IMListener sharedInstance];
    [manager setMessageListener:listener];
    [manager setConnListener:listener];
    [manager setUserStatusListener:listener];
    [manager setLogLevel:TIM_LOG_WARN];
    [manager disableCrashReport];
    [manager setLogFunc:^(TIMLogLevel lvl, NSString *msg) {
        //JXLogDebug(@"IM: %@", msg);
    }];
    [manager initSdk:(int)[gMisc.kIMAppId integerValue] accountType:kIMAccountType];
    
    [AMapServices sharedServices].apiKey = kAMapKey;
}

#pragma mark - Override
#pragma mark - Accessor
#pragma mark custom
#pragma mark setup
#pragma mark config
#pragma mark other

#pragma mark - Action

#pragma mark - Delegate
#pragma mark - LLTabBarDelegate

- (void)tabBarDidSelectedRiseButton {
    EntryScan(self.mainTbController.selectedViewController);
    
//    if (gUser.isLogined == NO && gMisc.skipScanPopup == NO) {
//        ScanPopupViewController *vc = [[ScanPopupViewController alloc] init];
//        
//        @weakify(self)
//        vc.didCloseBlock = ^() {
//            @strongify(self)
//            [self.mainTbController.selectedViewController jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
//        };
//        
//        vc.didSkipBlock = ^{
//            @strongify(self)
//            gMisc.skipScanPopup = YES;
//            [self.mainTbController.selectedViewController jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut dismissed:^{
//                @strongify(self)
//                ScanViewController *vc = [[ScanViewController alloc] init];
//                //vc.useBackAsReturn = YES;
//                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//                [nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:17.0]}];
//                
//                [self.mainTbController.selectedViewController presentViewController:nc animated:YES completion:^{
//                    
//                }];
//            }];
//        };
//        
//        vc.didLoginBlock = ^{
//            @strongify(self)
//            [self.mainTbController.selectedViewController jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut dismissed:^{
//                @strongify(self)
//                [gUser checkLoginWithFinish:^{
//                    @strongify(self)
//                    ScanViewController *vc = [[ScanViewController alloc] init];
//                    //vc.useBackAsReturn = YES;
//                    JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//                    [nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:17.0]}];
//                    
//                    [self.mainTbController.selectedViewController presentViewController:nc animated:YES completion:^{
//                        
//                    }];
//                } error:nil];
//            }];
//        };
//        
//        [self.mainTbController.selectedViewController jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
//            
//        }];
//        return;
//    }
//    
//    ScanViewController *vc = [[ScanViewController alloc] init];
//    //vc.useBackAsReturn = YES;
//    JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
//    [nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:17.0]}];
//    
//    [self.mainTbController.selectedViewController presentViewController:nc animated:YES completion:^{
//        
//    }];
}

-(void) onReq:(BaseReq *)req {
    
}

-(void) onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        // NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        //        switch (resp.errCode) {
        //            case WXSuccess:
        //                strMsg = @"支付结果：成功！";
        //                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
        //                break;
        //
        //            default:
        //                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
        //                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
        //                break;
        //        }
        [[NSNotificationCenter defaultCenter]  postNotificationName:kJXNotifyWXpay object:resp userInfo:nil];
    }
}

#pragma mark - Class


@end







