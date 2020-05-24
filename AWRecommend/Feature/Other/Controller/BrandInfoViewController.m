//
//  BrandInfoViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "BrandInfoViewController.h"

@interface BrandInfoViewController ()
//@property (nonatomic, weak) IBOutlet UIButton *securityButton;
//@property (nonatomic, weak) IBOutlet UIButton *stabilityButton;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *infoLabel;

@end

@implementation BrandInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.securityButton setTitle:self.security forState:UIControlStateNormal];
//    [self.stabilityButton setTitle:self.stability forState:UIControlStateNormal];
    
    self.view.backgroundColor = SMInstance.mainColor;
    
//    self.securityButton.titleLabel.font = [UIFont jx_systemFontOfSize:13];
//    self.stabilityButton.titleLabel.font = [UIFont jx_systemFontOfSize:13];
    
    self.infoLabel.font = [UIFont jx_systemFontOfSize:13];
    self.infoLabel.text = JXStrWithFmt(@"%@\n%@", self.security, self.stability);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
}

@end
