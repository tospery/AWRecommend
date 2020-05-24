//
//  BrandDetailCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "BrandDetailCell.h"

@interface BrandDetailCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;

@end

@implementation BrandDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.descLabel.textColor = JXColorHex(0x333333);
    self.descLabel.font = [UIFont jx_systemFontOfSize:13];// JXFont(14);
    self.descLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(RACTuple *)t {
    [super setData:t];
    self.nameLabel.text = t.first;
    self.descLabel.text = t.second;
}

+ (CGFloat)heightWithData:(RACTuple *)t {
    CGFloat height = JXScreenScale(20);
    NSString *text = t.second;
    
    CGFloat width = (JXScreenWidth - 12 - 76 - 12) - 6;
//    
//    TTTAttributedLabel *l = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
//    l.lineSpacing = 2;
//    l.font = JXFont(14);
//    l.numberOfLines = 0;
//    l.attributedText = [[NSAttributedString alloc] initWithString:text];
//    
//    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:l.attributedText withConstraints:CGSizeMake(width, CGFLOAT_MAX) limitedToNumberOfLines:0];
    
    CGSize size = [text jx_sizeWithFont:[UIFont jx_systemFontOfSize:13] width:width];
    
    height += size.height;
    return height;
}

@end










