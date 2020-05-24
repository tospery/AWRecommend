//
//  ExpireViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ExpireViewController.h"

@interface ExpireViewController ()
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *messageLabel;

@end

@implementation ExpireViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, 240, 160);
    
    self.messageLabel.textColor = JXColorHex(0x333333);
    self.messageLabel.font = JXFont(15);
    self.messageLabel.lineSpacing = 2;
    self.messageLabel.text = self.message;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
}


- (IBAction)okButtonPressed:(id)sender {
    if (self.okBlock) {
        self.okBlock();
    }
}

@end
