//
//  CompHeaderView.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "CompHeaderView.h"

@interface CompHeaderView ()
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UILabel *searchLabel;
@property (nonatomic, weak) IBOutlet UIButton *tipButton;
@property (nonatomic, weak) IBOutlet JXButton *scanButton;

@property (nonatomic, weak) IBOutlet UILabel *testLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation CompHeaderView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(220.0f));
    
    self.searchLabel.textColor = JXColorHex(0x999999);
    self.searchLabel.font = JXFont(12);
    self.quoteDescLabel.font = JXFont(14);
    self.quoteAuthLabel.font = JXFont(14);
    JXAdaptButton(self.tipButton, JXFont(10));
    
    JXAdaptButton(self.scanButton, JXFont(8));
    self.scanButton.style = JXButtonStyleBottom;
    self.scanButton.distance = 2;
    //self.quoteDescLabel.text = @"自己在选择上的时间成本，帮助用户正确认知健康问题，做出理性的健康消费决策";
    
    self.topConstraint.constant = JXScreenScale(8);
    
    self.testLabel.font = JXFont(30);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.searchView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
}

- (IBAction)searchButtonPressed:(id)sender {
    if (self.didSearchBlock) {
        self.didSearchBlock();
    }
}

- (IBAction)scanButtonPressed:(id)sender {
    if (self.didScanBlock) {
        self.didScanBlock();
    }
}

@end





