//
//  JXServerViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIButton *okButton;

@end

@implementation ServerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"后台服务环境配置";
    
    if ([gMisc.baseURLString isEqualToString:[self.servers.first first]]) {
        self.currentIndex = 0;
    }else if ([gMisc.baseURLString isEqualToString:[self.servers.second first]]) {
        self.currentIndex = 1;
    }else {
        self.currentIndex = 2;
    }
    
    self.segmentedControl.selectedSegmentIndex = self.currentIndex;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [SMInstance configButtonStyle1:self.okButton fontSize:16 borderRadius:4.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButtonPressed:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == self.currentIndex) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"后台服务没有进行切换！！！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL]];
        [self presentViewController:alert animated:YES completion:NULL];
        
        return;
    }
    
    [TMInstance removeObjectForKey:kTMTestList];
    [gUser logout];
    
    RACTuple *t = nil;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        t = self.servers.first;
        gMisc.kIMAppId = @"1400016498";
    }else if (self.segmentedControl.selectedSegmentIndex == 1) {
        t = self.servers.second;
        gMisc.kIMAppId = @"1400016498";
    }else {
        t = self.servers.third;
        gMisc.kIMAppId = @"1400016593";
    }
    gMisc.baseURLString = t.first;
    gMisc.pathURLString = t.second;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyServerDidChange object:nil];
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"设置成功，点击确认关闭APP！！！" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        JXExitApplication();
    }];
}

@end



