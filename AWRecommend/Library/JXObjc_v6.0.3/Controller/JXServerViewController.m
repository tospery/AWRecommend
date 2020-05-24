////
////  JXServerViewController.m
////  AWRecommend
////
////  Created by 杨建祥 on 2017/6/28.
////  Copyright © 2017年 杨建祥. All rights reserved.
////
//
//#import "JXServerViewController.h"
//
//@interface JXServerViewController ()
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *tipsLabel;
//@property (nonatomic, strong) UISegmentedControl *serverSegControl;
//@property (nonatomic, strong) UIButton *okButton;
//
//@property (nonatomic, assign) NSInteger currentIndex;
//
//@end
//
//@implementation JXServerViewController
//#pragma mark - Override
//#pragma mark view
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setupVar];
//    [self setupView];
//    [self setupNet];
//}
//
//#pragma mark setup
//- (void)setupVar {
//    if ([gMisc.baseURLString isEqualToString:[(RACTuple *)JXInstance.servers.first first]] &&
//        [gMisc.pathURLString isEqualToString:[(RACTuple *)JXInstance.servers.first second]]) {
//        self.currentIndex = 0;
//    }else if ([gMisc.baseURLString isEqualToString:[(RACTuple *)JXInstance.servers.second first]] &&
//              [gMisc.pathURLString isEqualToString:[(RACTuple *)JXInstance.servers.second second]]) {
//        self.currentIndex = 1;
//    }else {
//        self.currentIndex = 2;
//    }
//}
//
//- (void)setupView {
//    self.navigationItem.title = @"环境配置";
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:self.serverSegControl];
//    [self.serverSegControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.view).multipliedBy(1/3.0f);
//        make.width.equalTo(self.view).multipliedBy(280/320.0f);
//        make.height.equalTo(self.serverSegControl.mas_width).multipliedBy(3/28.0f);
//    }];
//    
//    [self.view addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.serverSegControl);
//        make.bottom.equalTo(self.serverSegControl.mas_top).offset(-8.0f);
//    }];
//    
//    [self.view addSubview:self.tipsLabel];
//    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.serverSegControl);
//        make.top.equalTo(self.serverSegControl.mas_bottom).offset(8.0f);
//    }];
//    
//    [self.view addSubview:self.okButton];
//    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.tipsLabel.mas_bottom).offset(30.0f);
//        make.width.equalTo(@80);
//        make.height.equalTo(@30);
//    }];
//    
//    self.serverSegControl.selectedSegmentIndex = self.currentIndex;
//}
//
//- (void)setupNet {
//    
//}
//
//#pragma mark - Accessor
//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.font = JXFont(15);
//        _titleLabel.textColor = JXColorHex(0x333333);
//        _titleLabel.text = @"服务环境：";
//    }
//    return _titleLabel;
//}
//
//- (UILabel *)tipsLabel {
//    if (!_tipsLabel) {
//        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _tipsLabel.font = JXFont(11);
//        _tipsLabel.textColor = JXColorHex(0x999999);
//        _tipsLabel.text = @"选择服务环境后，点击确定按钮来进行切换";
//    }
//    return _tipsLabel;
//}
//
//- (UIButton *)okButton {
//    if (!_okButton) {
//        _okButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _okButton.titleLabel.font = JXFont(16);
//        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
//        [_okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _okButton;
//}
//
//- (UISegmentedControl *)serverSegControl {
//    if (!_serverSegControl) {
//        _serverSegControl = [[UISegmentedControl alloc] initWithItems:@[@"开发", @"测试", @"正式"]];
//        
//    }
//    return _serverSegControl;
//}
//
//
//#pragma mark - Private
//#pragma mark - Public
//#pragma mark - Action
//- (void)okButtonPressed:(id)sender {
//    if (self.serverSegControl.selectedSegmentIndex == self.currentIndex) {
//        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"后台服务没有进行切换！！！" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:NULL];
//        return;
//    }
//    
////    RACTuple *s = nil;
////    JXEnvType t = 0;
////    if (self.serverSegControl.selectedSegmentIndex == 0) {
////        s = JXInstance.servers.first;
////        t = JXEnvTypeDev;
////    }else if (self.serverSegControl.selectedSegmentIndex == 1) {
////        s = JXInstance.servers.second;
////        t = JXEnvTypeHoc;
////    }else {
////        s = JXInstance.servers.third;
////        t = JXEnvTypeApp;
////    }
////    gMisc.baseURLString = s.first;
////    gMisc.pathURLString = s.second;
////    [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyServerDidChange object:nil];
////    
////    if (self.changeBlock) {
////        self.changeBlock(t);
////    }
//    
//    [gUser logout];
//    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"设置成功，点击确认关闭APP！！！" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        JXExitApplication();
//    }];
//}
//
//#pragma mark - Notification
//#pragma mark - Delegate
//#pragma mark - Class
//
//
//
//@end
