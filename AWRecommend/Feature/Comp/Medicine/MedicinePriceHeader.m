//
//  MedicinePriceHeader.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MedicinePriceHeader.h"

@interface MedicinePriceHeader ()
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *specLabel;

@end

@implementation MedicinePriceHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenWidth - 20, JXScreenScale(80));
    self.nameLabel.font = JXFontBold(13);
    self.specLabel.font = JXFont(12);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //[self.bgView jx_corner:(UIRectCornerTopLeft | UIRectCornerTopRight) radius:8];
}

- (void)setP:(CompResultDetailPrice *)p {
    _p = p;
    
    [self.imageView sd_setImageWithURL:JXURLWithStr(p.imgUrl) placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", p.brandName, p.drugName);
    self.specLabel.text = p.spec;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
