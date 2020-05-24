//
//  CompResultDetailCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultDetailCell.h"

@interface CompResultDetailCell ()
@property (nonatomic, weak) IBOutlet UILabel *myNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *myPriceLabel;

@end

@implementation CompResultDetailCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CompResultDetailBrand *)brand {
    [super setData:brand];
    self.myNameLabel.text = brand.platformName;
    self.myPriceLabel.text = JXStrWithFmt(@"¥%.2f", brand.platformPrice);
}

+ (CGFloat)height{
    return JXScreenScale(40.0f);
}

@end
