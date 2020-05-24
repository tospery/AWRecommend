//
//  CompResultBrandDescHeader.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultBrandDescHeader.h"
#import "CompResultBrandDescButton.h"

@interface CompResultBrandDescHeader ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *fromLabel;

@property (nonatomic, weak) IBOutlet UIButton *safeButton;
@property (nonatomic, weak) IBOutlet UIButton *stabButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *centerXConstraint;

@end

@implementation CompResultBrandDescHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(70));
    
    self.typeLabel.backgroundColor = SMInstance.mainColor;
    self.fromLabel.backgroundColor = SMInstance.mainColor;
    self.typeLabel.textColor = [UIColor whiteColor];
    self.fromLabel.textColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.typeLabel jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8];
    [self.fromLabel jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8];
}

- (void)setItem:(CompResultItem *)item {
    _item = item;
    
    self.nameLabel.text = item.drugName;
    self.typeLabel.text = [Util stringWithNatureType:item.natureType];
    self.fromLabel.text = item.durgPrescription;
    
    self.safeButton.hidden = NO;
    self.stabButton.hidden = NO;
    
    UIButton *stabButton = self.stabButton;
    
    NSString *safe = [Util securityWithValue:item.dSafety];
    
    CGFloat offset = 0;
    if (0 != safe.length) {
        [self.safeButton setImage:JXAdaptImage(JXImageWithName(@"ic_warning_1")) forState:UIControlStateNormal];
        [self.safeButton setTitle:JXStrWithFmt(@" %@", safe) forState:UIControlStateNormal];
        //self.centerXConstraint.constant += 2;
        offset += 2;
    }else {
        stabButton = self.safeButton;
        self.stabButton.hidden = YES;
    }
    
    NSString *stab = [Util stabilityWithValue:item.dStability];
    if (0 != stab.length) {
        [stabButton setImage:JXAdaptImage(JXImageWithName(@"ic_warning_2")) forState:UIControlStateNormal];
        [stabButton setTitle:JXStrWithFmt(@" %@", stab) forState:UIControlStateNormal];
        //self.centerXConstraint.constant += 2;
        offset += 2;
    }
    
    self.centerXConstraint.constant = offset;
    
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//    [self layoutIfNeeded];
}

@end





