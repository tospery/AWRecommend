//
//  JXServerViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXServerViewController.h"

@interface JXServerViewController ()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation JXServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"环境设置";
    
    if ([gMisc.baseURLString isEqualToString:[JXInstance.serverEnvs.first first]]) {
        self.currentIndex = 0;
    }else if ([gMisc.baseURLString isEqualToString:[JXInstance.serverEnvs.second first]]) {
        self.currentIndex = 1;
    }else {
        self.currentIndex = 2;
    }
    
    self.segmentedControl.selectedSegmentIndex = self.currentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButtonPressed:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == self.currentIndex) {
        return;
    }
    
    RACTuple *t = nil;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        t = JXInstance.serverEnvs.first;
    }else if (self.segmentedControl.selectedSegmentIndex == 1) {
        t = JXInstance.serverEnvs.second;
    }else {
        t = JXInstance.serverEnvs.third;
    }
    gMisc.baseURLString = t.first;
    gMisc.pathURLString = t.second;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyServerDidChange object:nil];
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"设置成功！！！" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end



