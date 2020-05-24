//
//  LoginViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/25.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "LoginViewController.h"
#import "BindViewController.h"

@interface LoginViewController () <TTTAttributedLabelDelegate>
@property (nonatomic, weak) IBOutlet JXCaptchaButton *captchaButton;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *termButton;
@property (nonatomic, weak) IBOutlet UIButton *weixinButton;
@property (nonatomic, weak) IBOutlet UILabel *weixinLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *termLabel;

@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *captchaField;

@property (nonatomic, strong) NSString *openid;

@property (nonatomic, strong) RACCommand *captchaCommand;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACCommand *openidCommand;
@property (nonatomic, strong) RACCommand *wxloginCommand;

@property (nonatomic, strong) UMSocialUserInfoResponse *wxRsp;

@end

@implementation LoginViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
        self.navItemColor = JXColorHex(0x333333);
        self.statusBarStyle = JXStatusBarStyleDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupData];
    [self setupView];
    [self setupSignal];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar jx_transparet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar jx_reset];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [SMInstance configButtonStyle1:self.loginButton fontSize:15.0 borderRadius:JXScreenScale(20)];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    [self.phoneField.rac_textSignal subscribeNext:^(NSString *text) {
        if (text.length > 11) {
            self.phoneField.text = [text substringToIndex:11];
        }
    }];
    [self.captchaField.rac_textSignal subscribeNext:^(NSString *text) {
        if (text.length > 6) {
            self.captchaField.text = [text substringToIndex:6];
        }
    }];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    [self.navigationController.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: [UIColor whiteColor], kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleFont: JXFont(16.0)}];
    
    [self.navigationController.navigationBar jx_transparet];
    self.navigationItem.title = @"欢迎回来";
    
    self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
    
    [self.captchaButton setupWithEnableTextColor:SMInstance.mainColor enableBgColor:[UIColor clearColor] enableBorderColor:[UIColor clearColor] disableTextColor:JXColorHex(0x999999) disableBgColor:[UIColor clearColor] disableBorderColor:[UIColor clearColor] duration:kCaptchaDuration];
    [self.captchaButton setStartBlock:^BOOL() {
        NSString *result = [JXInputManager verifyPhone:self.phoneField.text original:nil];
        if (0 != result.length) {
            [JXDialog showPopup:result];
            return NO;
        }
        [self.captchaCommand execute:self.phoneField.text];
        
        return YES;
    }];
    
    if (![WXApi isWXAppInstalled]) {
        self.weixinLabel.hidden = YES;
        self.weixinButton.hidden = YES;
    }
    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    
    self.termLabel.delegate = self;
    
    self.termLabel.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName: @YES,
                                      (NSString *)kCTForegroundColorAttributeName: (__bridge id)[JXColorHex(0x333333) CGColor]};
    self.termLabel.activeLinkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName: @YES,
                                            (NSString *)kCTForegroundColorAttributeName: (__bridge id)SMInstance.mainColor.CGColor};
    
    NSString *text = @"同意健康智选用户协议";
    [self.termLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString jx_addAttributeWithColor:JXColorHex(0x999999) font:JXFont(11) range:NSMakeRange(0, text.length)];
        return mutableAttributedString;
    }];
    [self.termLabel addLinkToURL:JXURLWithStr(kTermLink) withRange:NSMakeRange(2, text.length - 2)];
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    JXWebViewController *vc = [[JXWebViewController alloc] initWithURL:url title:@"用户协议"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (NSString *)verifyInput {
    NSString *result = [JXInputManager verifyPhone:self.phoneField.text original:nil];
    if (0 != result.length) {
        return result;
    }
    
    if (!self.termButton.selected) {
        return @"请同意健康智选用户协议";
    }
    
    return [JXInputManager verifyInput:self.captchaField.text least:6 original:nil title:@"验证码"];
}

#pragma mark - Table
//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    DhzyDaibanCell *myCell = (DhzyDaibanCell *)cell;
//    myCell.data = object;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [DhzyDaibanCell height];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:[DhzyDaibanCell identifier] forIndexPath:indexPath];
//}

#pragma mark - Accessor methods
- (RACCommand *)openidCommand {
    if (!_openidCommand) {
        _openidCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance findWiseAccountInfoByOpenId:input];
        }];
        [_openidCommand.executing subscribe:self.executing];
        [_openidCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_openidCommand.executionSignals.switchToLatest subscribeNext:^(User *user) {
            @strongify(self)
            if (user.jxID.length == 0) {
                BindViewController *vc = [[BindViewController alloc] init];
                vc.didPassBlock = self.didLoginBlock;
                vc.wxRsp = self.wxRsp;
                [self.navigationController pushViewController:vc animated:YES];
                // JXHUDHide();
                [JXDialog hideHUD];
            }else {
//                @strongify(self)
//                [gUser loginWithUser:user];
//                [self dismissViewControllerAnimated:YES completion:^{
//                    @strongify(self)
//                    if (self.didPassBlock) {
//                        self.didPassBlock();
//                    }
//                }];
//                JXHUDHide();
                [self.wxloginCommand execute:nil];
            }
        }];
    }
    return _openidCommand;
}


- (RACCommand *)captchaCommand {
    if (!_captchaCommand) {
        _captchaCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getCode:input];
        }];
        [_captchaCommand.errors subscribe:self.errors];
        
        [_captchaCommand.executionSignals.switchToLatest subscribeNext:^(NSString *captcha) {
            NSLog(@"captcha = %@", captcha);
        }];
    }
    return _captchaCommand;
}

- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
            return [HRInstance login:input.first code:input.second weChatOpenid:input.third];
        }];
        
        [_loginCommand.executing subscribe:self.executing];
        [_loginCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_loginCommand.executionSignals.switchToLatest subscribeNext:^(User *user) {
            @strongify(self)
            [gUser loginWithUser:user];
            
            [[HRInstance listOldEvaluate] subscribeNext:^(id  _Nullable x) {
                [TMInstance setObject:x forKey:kTMTestList];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.didLoginBlock) {
                        self.didLoginBlock();
                    }
                }];
                [JXDialog hideHUD];
            } error:^(NSError * _Nullable error) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.didLoginBlock) {
                        self.didLoginBlock();
                    }
                }];
                [JXDialog hideHUD];
            }];
            
            
//            TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
//            login_param.accountType = kIMAccountType;
//            login_param.identifier = JXStrWithFmt(@"A%@", user.uid);
//            login_param.userSig = user.sig;
//            login_param.appidAt3rd = kIMAppId;
//            login_param.sdkAppId = (int)[kIMAppId integerValue];
//            
//            @weakify(self)
//            [[TIMManager sharedInstance] login:login_param succ:^(){
//                @strongify(self)
//                [gUser loginWithUser:user];
//                
//                
//                if (self.didPassBlock) {
//                    self.didPassBlock();
//                }
//                
//                [self dismissViewControllerAnimated:YES completion:^{
//
//                }];
//                JXHUDHide();
//            } fail:^(int code, NSString * err) {
//                JXHUDError(@"IM登录失败", YES);
//            }];
        }];
    }
    return _loginCommand;
}

- (RACCommand *)wxloginCommand {
    if (!_wxloginCommand) {
        _wxloginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
//            GenderType g = GenderTypeFemale;
//            if ([self.wxRsp.gender isEqualToString:@"m"]) {
//                g = GenderTypeMale;
//            }
//            return [HRInstance wxLogin:self.wxRsp.iconurl code:nil isWeChatBind:2 mobile:nil nickName:self.wxRsp.name sex:g weChatOpenid:self.wxRsp.openid];
            return [HRInstance wxLogin:nil code:nil isWeChatBind:2 mobile:nil nickName:nil sex:0 weChatOpenid:self.wxRsp.openid];
        }];
        [_wxloginCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_wxloginCommand.executionSignals.switchToLatest subscribeNext:^(User *user) {
            @strongify(self)
            
//            TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
//            login_param.accountType = kIMAccountType;
//            login_param.identifier = JXStrWithFmt(@"A%@", user.uid);
//            login_param.userSig = user.sig;
//            login_param.appidAt3rd = kIMAppId;
//            login_param.sdkAppId = (int)[kIMAppId integerValue];
//            
//            @weakify(self)
//            [[TIMManager sharedInstance] login:login_param succ:^(){
//                @strongify(self)
//                [gUser loginWithUser:user];
//                
//                
//                if (self.didPassBlock) {
//                    self.didPassBlock();
//                }
//                
//                [self dismissViewControllerAnimated:YES completion:^{
//                    
//                }];
//                JXHUDHide();
//            } fail:^(int code, NSString * err) {
//                JXHUDError(@"IM登录失败", YES);
//            }];
            
            [gUser loginWithUser:user];
            
            [[HRInstance listOldEvaluate] subscribeNext:^(id  _Nullable x) {
                [TMInstance setObject:x forKey:kTMTestList];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.didLoginBlock) {
                        self.didLoginBlock();
                    }
                }];
                [JXDialog hideHUD];
            } error:^(NSError * _Nullable error) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.didLoginBlock) {
                        self.didLoginBlock();
                    }
                }];
                [JXDialog hideHUD];
            }];
        }];
    }
    return _wxloginCommand;
}


#pragma mark - Action methods
- (void)backItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)termButtonPressed:(UIButton *)button {
    button.selected = !button.selected;
}

- (IBAction)loginButtonPressed:(id)sender {
    NSString *result = [self verifyInput];
    if (0 != result.length) {
        [JXDialog showPopup:result];
        return;
    }
    
    [self.loginCommand execute:RACTuplePack(self.phoneField.text, self.captchaField.text, self.openid)];
}

- (IBAction)wxButtonPressed:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [JXDialog showPopup:@"请先安装微信客户端"];
        return;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [JXDialog showPopup:error.localizedDescription];
        } else {
            self.wxRsp = result;
            [self.openidCommand execute:self.wxRsp.openid];
            
//
//            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.gender);
//            
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end




