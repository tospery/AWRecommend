//
//  BrandCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "BrandCell1.h"

@interface BrandCell1 ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *factoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *xlButton;
@property (nonatomic, weak) IBOutlet UIButton *hpButton;

@end

@implementation BrandCell1
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = JXFont(14);
    self.factoryLabel.font = JXFont(10);
    self.priceLabel.font = JXFont(12);
    JXAdaptButton(self.xlButton, JXFont(10));
    JXAdaptButton(self.hpButton, JXFont(10));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CompResultBrand *)b {
    [super setData:b];
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(b.brandImg) placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", b.brandName, b.drugName);
    self.factoryLabel.text = b.factory;
    
    [self.xlButton setTitle:JXStrWithFmt(@" %ld", (long)b.monthAmount) forState:UIControlStateNormal];
    [self.hpButton setTitle:JXStrWithFmt(@" %ld%%", (long)b.satisfaceionRate) forState:UIControlStateNormal];
    
    self.priceLabel.text = JXStrWithFmt(@"¥%.2f起", b.price);
}

+ (CGFloat)height {
    return JXScreenScale(80);
}

@end






