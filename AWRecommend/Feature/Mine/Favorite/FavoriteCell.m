//
//  FavoriteCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FavoriteCell.h"

@interface FavoriteCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet UIImageView *lpIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *lpNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lpSpecLabel;
@property (nonatomic, weak) IBOutlet UILabel *lpPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *lpYPriceLabel;

@end

@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.lineSpacing = 1.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Favorite *)f {
    _data = f;
    
//    if (0 != detail.drugPriceList.count) {
//        CompResultDetailPrice *p = detail.drugPriceList[0];
//        [self.iconImageView sd_setImageWithURL:JXURLWithStr(p.imgUrl) placeholderImage:kJXImagePHSquare];
//        
//        self.nameLabel.text = JXStrWithFmt(@"【%@】%@", p.brandName, p.drugName);
//    }
//    self.timeLabel.text = detail.fTime;
    
    if ([f isKindOfClass:[FavoriteLP class]]) {
        FavoriteLP *lp = (FavoriteLP *)f;
        [self.lpIconImageView sd_setImageWithURL:JXURLWithStr(lp.goodsImage) placeholderImage:kJXImagePHSquare];
        self.lpNameLabel.text = JXStrWithFmt(@"【%@】%@", lp.brandName, lp.goodsName);
        self.lpSpecLabel.text = JXStrWithFmt(@"规格：%@", lp.specName);
        self.lpPriceLabel.text = JXStrWithFmt(@"¥%@", lp.goodsPrice);
        
        NSDictionary *attr = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSString *yprice = JXStrWithFmt(@"¥%@", lp.goodsMarketPrice);
        self.lpYPriceLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:yprice attributes:attr];
    }else {
        [self.iconImageView sd_setImageWithURL:JXURLWithStr(f.img) placeholderImage:kJXImagePHSquare];
        self.nameLabel.text = JXStrWithFmt(@"【%@】%@", f.brandName, f.drugName);
        self.timeLabel.text = [f.createDate substringToIndex:10];
    }
}

+ (NSString *)identifier {
    return JXStrWithFmt(@"%@Identifier", NSStringFromClass([self class]));
}

+ (CGFloat)height{
    return JXAdaptScreen(100.0f); // JXScreenScale(70.0f);
}

@end
