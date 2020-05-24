//
//  BindViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/2.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "BindViewController.h"

@interface BindViewController ()
@property (nonatomic, weak) IBOutlet JXCaptchaButton *captchaButton;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *termButton;

@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *captchaField;

@property (nonatomic, strong) NSString *openid;

@property (nonatomic, strong) RACCommand *captchaCommand;
@property (nonatomic, strong) RACCommand *loginCommand;

@end

@implementation BindViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        //        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        //        self.shouldPullToRefresh = YES;
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
            self.phoneField.text = [text substringToIndex:6];
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
    self.navigationItem.title = @"绑定手机";
    
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
            GenderType g = GenderTypeFemale;
            if ([self.wxRsp.gender isEqualToString:@"m"]) {
                g = GenderTypeMale;
            }
            return [HRInstance wxLogin:self.wxRsp.iconurl code:self.captchaField.text isWeChatBind:1 mobile:self.phoneField.text nickName:self.wxRsp.name sex:g weChatOpenid:self.wxRsp.openid];
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
                    if (self.didPassBlock) {
                        self.didPassBlock();
                    }
                }];
                [JXDialog hideHUD];
            } error:^(NSError * _Nullable error) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.didPassBlock) {
                        self.didPassBlock();
                    }
                }];
                [JXDialog hideHUD];
            }];
        }];
    }
    return _loginCommand;
}



#pragma mark - Action methods
- (IBAction)termButtonPressed:(UIButton *)button {
    button.selected = !button.selected;
}

- (IBAction)loginButtonPressed:(id)sender {
    NSString *result = [self verifyInput];
    if (0 != result.length) {
        [JXDialog showPopup:result];
        return;
    }
    
    [self.loginCommand execute:nil];
}


#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods

@end






