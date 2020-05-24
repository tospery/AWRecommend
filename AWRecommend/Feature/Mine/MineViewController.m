//
//  MineViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "SettingViewController.h"
#import "FavoriteViewController.h"
#import "FeedbackViewController.h"
#import "ScanRecordViewController.h"
#import "ChatViewController.h"
#import "ShareViewController.h"
#import "MessageCenterViewController.h"
#import "MessageListViewController.h"
#import "ReputeViewController.h"

@interface MineViewController ()
@property (nonatomic, strong) MineHeaderView *headerView;
@property (nonatomic, strong) UILabel *messageUnreadLabel;

// @property (nonatomic, weak) IBOutlet JXButton *orderUnpayButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *realHeightConstraint;
@property (nonatomic, strong) IBOutletCollection(JXButton) NSArray *orderButtons;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *orderUnreadLabels;
@property (nonatomic, strong) IBOutletCollection(JXButton) NSArray *funcButtons;

@property (nonatomic, strong) RACCommand *infoCommand;
@property (nonatomic, strong) RACCommand *doctorCommand;
@property (nonatomic, strong) RACCommand *orderCommand;
@property (nonatomic, strong) RACCommand *msgCountCommand;

@end

@implementation MineViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
    }
    return self;
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (JXiOSVersionGreaterThanOrEqual(@"11")) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else {
        [self.navigationController.navigationBar jx_transparet];
    }
    
    if (gUser.isLogined) {
        [self.infoCommand execute:nil];
        [self.orderCommand execute:nil];
        //[self.msgCountCommand execute:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (JXiOSVersionGreaterThanOrEqual(@"11")) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }else {
        [self.navigationController.navigationBar jx_reset];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.messageUnreadLabel jx_circleWithColor:[UIColor clearColor] border:0.0f];
    for (UILabel *label in self.orderUnreadLabels) {
        [label jx_circleWithColor:[UIColor clearColor] border:0.0f];
    }
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupView {
    [self.navigationController.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: [UIColor whiteColor], kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleFont: JXFont(16.0)}];
    
//    self.navigationItem.title = @"设置";
//    
//    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    
    //self.navigationItem.title = @"个人中心";
    
    if (JXiOSVersionGreaterThanOrEqual(@"11")) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else {
        [self.navigationController.navigationBar jx_transparet];
    }
    
//    UIBarButtonItem *settingBarItem = [[UIBarButtonItem alloc] initWithImage:JXImageWithName(@"ic_UserCenter_messager") style:UIBarButtonItemStylePlain target:self action:@selector(settingBarItemClicked:)];
//    UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithImage:JXImageWithName(@"ic_UserCenter_setting") style:UIBarButtonItemStylePlain target:self action:@selector(messageBarItemClicked:)];
//    self.navigationItem.rightBarButtonItems = @[settingBarItem, messageBarItem];
    
    CGFloat slide = 30.0f;
    UIView *settingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, slide, slide)];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:JXImageWithName(@"ic_UserCenter_setting") forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [settingView addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(settingView);
//        make.width.equalTo(@22);
//        make.height.equalTo(@22);
    }];
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, slide, slide)];
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:JXImageWithName(@"ic_UserCenter_messager") forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:messageButton];
    self.messageUnreadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageUnreadLabel.backgroundColor = JXColorHex(0xB21D27); // [UIColor redColor];
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
//        make.width.equalTo(@22);
//        make.height.equalTo(@22);
    }];
    
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, slide * 2, slide)];
//    rightView.backgroundColor = [UIColor redColor];
//    [rightView addSubview:settingView];
//    settingView.frame = CGRectMake(0, 0, slide, slide);
//    [rightView addSubview:messageView];
//    messageView.frame = CGRectMake(slide, 0, slide, slide);
//
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *settingBarItem = [[UIBarButtonItem alloc] initWithCustomView:settingView];
    UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithCustomView:messageView];
    //self.navigationItem.rightBarButtonItems = @[messageBarItem, settingBarItem];
    
    if (JXiOSVersionGreaterThanOrEqual(@"11")) {
    }else {
        self.navigationItem.rightBarButtonItems = @[messageBarItem, settingBarItem];
    }
    
//    self.navigationItem.leftBarButtonItem = messageBarItem;
//    self.navigationItem.rightBarButtonItem = settingBarItem;
    
    for (JXButton *btn in self.orderButtons) {
        JXAdaptButton(btn, nil);
        btn.style = JXButtonStyleBottom;
        btn.distance = 4.0f;
        [btn setNeedsLayout];
    }
    [(UILabel *)self.orderUnreadLabels[self.orderUnreadLabels.count - 1] setHidden:YES];
    
    for (JXButton *btn in self.funcButtons) {
        JXAdaptButton(btn, nil);
        btn.style = JXButtonStyleBottom;
        btn.distance = 4.0f;
        [btn setNeedsLayout];
    }
    
    self.scrollView.parallaxHeader.view = self.headerView;
    self.scrollView.parallaxHeader.height = self.headerView.jx_height;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = self.headerView.jx_height;
    
    self.realHeightConstraint.constant += self.headerView.jx_height * -1;
    NSLog(@"%.2f", self.realHeightConstraint.constant);
    
    self.contentView.backgroundColor = JXColorHex(0xF4F5F6);
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
//    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
//    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
//    RAC(self, dataSource) = [[[fetchLocalDataSignal merge:requestRemoteDataSignal] deliverOnMainThread] map:^id _Nullable(id result) {
//        return JXArrTable(result);
//    }];
}

//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}
//
//#pragma mark table
//- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [JXCell height];
//}
//
//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [self.tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    JXCell *myCell = (JXCell *)cell;
//    myCell.data = object;
//}

#pragma mark empty
#pragma mark - Accessor
- (MineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:nil options:nil] firstObject];
        @weakify(self)
        _headerView.loginDidPress = ^() {
            @strongify(self)
            if (gUser.isLogined) {
                SettingViewController *vc = [[SettingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.navItemColor = JXColorHex(0x333333);
                vc.statusBarStyle = JXStatusBarStyleDefault;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.navItemColor = JXColorHex(0x333333);
                vc.statusBarStyle = JXStatusBarStyleDefault;
                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
                [self.navigationController presentViewController:nc animated:YES completion:NULL];
            }
        };
        
        if (JXiOSVersionGreaterThanOrEqual(@"11")) {
            _headerView.setDidPress = ^{
                SettingViewController *vc = [[SettingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.navItemColor = JXColorHex(0x333333);
                vc.statusBarStyle = JXStatusBarStyleDefault;
                [self.navigationController pushViewController:vc animated:YES];
            };
            _headerView.msgDidPress = ^{
                [gUser checkLoginWithFinish:^(BOOL relogined) {
                    MessageListViewController *vc = [[MessageListViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navItemColor = JXColorHex(0x333333);
                    vc.statusBarStyle = JXStatusBarStyleDefault;
                    [self.navigationController pushViewController:vc animated:YES];
                } error:nil];
            };
        }
    }
    return _headerView;
}

- (RACCommand *)doctorCommand {
    if (!_doctorCommand) {
        _doctorCommand = EntryChat(self);
    }
    return _doctorCommand;
}

- (RACCommand *)infoCommand {
    if (!_infoCommand) {
        _infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance findWiseAccountDetails];
        }];
        [_infoCommand.errors subscribe:self.errors];
        
        [_infoCommand.executionSignals.switchToLatest subscribeNext:^(User *user) {
            gUser.mobile = user.mobile;
            gUser.nickName = user.nickName;
            gUser.dateOfBirth = user.dateOfBirth;
            gUser.avatar = user.avatar;
            gUser.sex = user.sex;
        }];
    }
    return _infoCommand;
}

- (RACCommand *)orderCommand {
    if (!_orderCommand) {
        _orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getOrderStateNumber];
        }];
        
        @weakify(self)
        [_orderCommand.executionSignals.switchToLatest subscribeNext:^(OrderPendingAmount *amount) {
            @strongify(self)
            [(UILabel *)self.orderUnreadLabels[0] setHidden:(amount.prepayNum == 0)];
            [(UILabel *)self.orderUnreadLabels[1] setHidden:(amount.dispatchNum == 0)];
            [(UILabel *)self.orderUnreadLabels[2] setHidden:(amount.receivingNum == 0)];
            self.messageUnreadLabel.hidden = (amount.sysNum == 0);
            if (JXiOSVersionGreaterThanOrEqual(@"11")) {
                self.headerView.messageUnreadLabel.hidden = (amount.sysNum == 0);
            }
        }];
    }
    return _orderCommand;
}

- (RACCommand *)msgCountCommand {
    if (!_infoCommand) {
        _infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance checkReadInfo];
        }];
        
        [_infoCommand.executing subscribe:self.executing];
        [_infoCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_infoCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *num) {
            @strongify(self)
            self.messageUnreadLabel.hidden = (num.integerValue == 0);
            if (JXiOSVersionGreaterThanOrEqual(@"11")) {
                self.headerView.messageUnreadLabel.hidden = (num.integerValue == 0);
            }
        }];
    }
    return _infoCommand;
}


#pragma mark - Private
#pragma mark - Public
#pragma mark - Action
- (void)settingBarItemClicked:(id)sender {
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navItemColor = JXColorHex(0x333333);
    vc.statusBarStyle = JXStatusBarStyleDefault;
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)orderButtonPressed:(UIButton *)btn {
    [gUser checkLoginWithFinish:^(BOOL relogined) {
        NSString *link = JXStrWithFmt(kOrderLink, (btn.tag + 1));
//        WebViewController *vc = [[WebViewController alloc] initWithLink:link title:@"我的订单"];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.canNew = YES;
//        vc.navItemColor = JXColorHex(0x333333);
        
        AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
        vc.jxIdentifier = @"我的订单";
        vc.hidesBottomBarWhenPushed = YES;
        vc.navItemColor = JXColorHex(0x333333);
        vc.statusBarStyle = JXStatusBarStyleDefault;
        [self.navigationController pushViewController:vc animated:YES];
    } error:nil];
}

- (IBAction)funcButtonPressed:(UIButton *)btn {
    switch (btn.tag) {
            case 10: {
                // 地址管理
                [gUser checkLoginWithFinish:^(BOOL relogined) {
                    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(kAddrLink) title:@"地址管理"];
                    vc.jxIdentifier = @"地址管理";
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navItemColor = JXColorHex(0x333333);
                    vc.statusBarStyle = JXStatusBarStyleDefault;
                    [self.navigationController pushViewController:vc animated:YES];
                } error:nil];
                
//                AddrCityViewController *vc = [[AddrCityViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                vc.navItemColor = JXColorHex(0x333333);
//                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 11: {
                // 扫码记录
                [gUser checkLoginWithFinish:^(BOOL relogined) {
//                    ScanRecordViewController *vc = [[ScanRecordViewController alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    vc.navItemColor = JXColorHex(0x333333);
//                    vc.statusBarStyle = JXStatusBarStyleDefault;
//                    [self.navigationController pushViewController:vc animated:YES];
                    
//                    ReputeViewController *vc = [[ReputeViewController alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
                    
                    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(kYhqMineLink) title:@"我的优惠券"];
                    vc.navItemColor = JXColorHex(0x333333);
                    vc.statusBarStyle = JXStatusBarStyleDefault;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } error:nil];
                break;
            }
            case 12: {
                // 收藏记录
                [gUser checkLoginWithFinish:^(BOOL relogined) {
                    FavoriteViewController *vc = [[FavoriteViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navItemColor = JXColorHex(0x333333);
                    vc.statusBarStyle = JXStatusBarStyleDefault;
                    [self.navigationController pushViewController:vc animated:YES];
                } error:nil];
                break;
            }
            case 13: {
                // 药师咨询
                [gUser checkLoginWithFinish:^(BOOL relogined) {
                    [self.doctorCommand execute:nil];
                } error:nil];
                break;
            }
        default:
            break;
    }
}

- (IBAction)huiyuanfuliButtonPressed:(id)sender {
    MytestViewController *vc = [[MytestViewController alloc] init];
    vc.isFromMine = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navItemColor = JXColorHex(0x333333);
    vc.statusBarStyle = JXStatusBarStyleDefault;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [gUser checkLoginWithFinish:^(BOOL relogined) {
//        NSString *link = nil;
////#ifdef JXEnableEnvHoc
////        link = JXStrWithFmt(@"http://wechat-test.appvworks.com/appvworks.ihealth.wechat/memberShip/indexForApp.html?phoneNo=%@&flag=1&imgUrl=%@&userName=%@", gUser.mobile, JXStrWithDft(gUser.avatar, @""), JXStrWithDft(gUser.nickName, @""));
////#else
////        link = JXStrWithFmt(@"http://wx.ihealth.appvworks.com/memberShip/indexForApp.html?phoneNo=%@&flag=1&imgUrl=%@&userName=%@", gUser.mobile, JXStrWithDft(gUser.avatar, @""), JXStrWithDft(gUser.nickName, @""));
////#endif
//        link = JXStrWithFmt(@"http://wx.ihealth.appvworks.com/memberShip/indexForApp.html?phoneNo=%@&flag=1&imgUrl=%@&userName=%@", gUser.mobile, JXStrWithDft(gUser.avatar, @""), JXStrWithDft(gUser.nickName, @""));
//
//        AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"会员福利"];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.jxIdentifier = @"会员福利";
//        vc.navItemColor = JXColorHex(0x333333);
//        vc.statusBarStyle = JXStatusBarStyleDefault;
//        //vc.navItemColor = JXColorHex(0x333333);
//        //vc.navItemColor = JXColorHex(0x333333);
//        [self.navigationController pushViewController:vc animated:YES];
//    } error:nil];
}

- (IBAction)haoyoutuijianButtonPressed:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL relogined) {
        ShareViewController *vc = [[ShareViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navItemColor = JXColorHex(0x333333);
        vc.statusBarStyle = JXStatusBarStyleDefault;
        [self.navigationController pushViewController:vc animated:YES];
    } error:nil];
}

- (IBAction)yijianfankuiButtonPressed:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL relogined) {
        FeedbackViewController *vc = [[FeedbackViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navItemColor = JXColorHex(0x333333);
        vc.statusBarStyle = JXStatusBarStyleDefault;
        [self.navigationController pushViewController:vc animated:YES];
    } error:nil];
}

#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class

@end



