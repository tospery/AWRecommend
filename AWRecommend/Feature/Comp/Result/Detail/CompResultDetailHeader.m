//
//  CompResultDetailHeader.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultDetailHeader.h"

@interface CompResultDetailHeader ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *specLabel;

@end

@implementation CompResultDetailHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(80));
}

- (void)setPrice:(CompResultDetailPrice *)price {
    _price = price;
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(price.imgUrl) placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", price.brandName, price.drugName);
    self.specLabel.text = price.spec;
}

@end
