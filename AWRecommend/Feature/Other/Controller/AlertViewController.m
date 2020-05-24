//
//  AlertViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation AlertViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.messageLabel.font = JXFont(14);
    self.messageLabel.text = self.message;
    for (UIButton *btn in self.buttons) {
        if (btn.tag) {
            [SMInstance configButtonStyle2:btn];
        }else {
            [SMInstance configButtonStyle3:btn];
        }
    }
    self.view.frame = CGRectMake(0, 0, JXScreenScale(230), JXScreenScale(210));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
}

- (IBAction)buttonPressed:(UIButton *)btn {
    if (self.didOkBlock) {
        self.didOkBlock(btn.tag);
    }
}

@end
