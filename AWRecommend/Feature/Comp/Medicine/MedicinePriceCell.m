//
//  MedicinePriceCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MedicinePriceCell.h"

@interface MedicinePriceCell ()
@property (nonatomic, weak) IBOutlet UIView *bgTopView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *specLabel;

@property (nonatomic, weak) IBOutlet UIView *bgView;

@end

@implementation MedicinePriceCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = [UIFont jx_boldSystemFontOfSize:13];  // JXFontBold(13);
    self.specLabel.font = JXFont(12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //[self.bgView jx_corner:(UIRectCornerBottomLeft | UIRectCornerBottomRight) radius:8];
}

- (void)setData:(CompResultDetailPrice *)p {
    [super setData:p];
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(p.imgUrl) placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = p.spec; // JXStrWithFmt(@"【%@】%@", p.brandName, p.drugName);
    self.specLabel.text = nil; // p.spec;
    
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat topOffset = 0;
    CGFloat heightBase = JXScreenScale(32);
    
    UIImageView *splitImageView = nil;
    for (NSInteger i = 0; i < p.dbSpecBuyList.count; ++i) {
        CompResultDetailBrand *b = p.dbSpecBuyList[i];
        
        UIView *view = [[UIView alloc] init];
        [self.bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgView);
            make.trailing.equalTo(self.bgView);
            make.top.equalTo(self.bgView).offset(topOffset);
            make.height.equalTo(@(heightBase));
        }];
        
        //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 16, 0, 0)];
        //        label.backgroundColor = SMInstance.mainColor;
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.text = b.platformName;
        //        label.textColor = [UIColor whiteColor];
        //        label.font = JXFont(10);
        //        [view addSubview:label];
        //        [label sizeToFit];
        //        label.frame = CGRectMake(label.jx_x, label.jx_y, label.jx_width + 10, label.jx_height + 4);
        //        [label jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
        
        UIImageView *scSplitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 3, 20)];
        scSplitImageView.backgroundColor = SMInstance.mainColor;
        [view addSubview:scSplitImageView];
        
        UILabel *scNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, 0, 0)];
        scNameLabel.text = b.platformName;
        scNameLabel.textColor = kColorGreenDark;
        scNameLabel.font = JXFont(13);
        [scNameLabel sizeToFit];
        [view addSubview:scNameLabel];
        
        
        topOffset += heightBase;
        for (NSInteger j = 0; j < b.pfShopList.count; ++j) {
            CompResultDetailShop *s = b.pfShopList[j];
            
            UIView *view = [[UIView alloc] init];
            [self.bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.bgView);
                make.trailing.equalTo(self.bgView);
                make.top.equalTo(self.bgView).offset(topOffset);
                make.height.equalTo(@(heightBase));
            }];
            
            splitImageView = [[UIImageView alloc] init];
            //splitImageView.backgroundColor = JXColorHex(0xE7E7E7);
            splitImageView.image = JXImageWithName(@"line_gray");
            [view addSubview:splitImageView];
            [splitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(view).offset(8.0);
                make.trailing.equalTo(view).offset(-8.0);
                make.bottom.equalTo(view);
                make.height.equalTo(@1);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 2;
            label.font = JXFont(11);
            label.textColor = JXColorHex(0x333333);
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(view).offset(8);
                make.centerY.equalTo(view);
                make.trailing.equalTo(view).offset(-1 * JXAdaptScreen(68));
            }];
            // NSString *text = JXStrWithFmt(@"%@   ¥%.2f", s.platfromShop, s.platformPrice);
            NSString *text = JXStrWithFmt(@"%@ DDDP:¥%.2f元/天", s.platfromShop, s.dddp);
            if (p.dddp == 0) {
                text = JXStrWithFmt(@"%@", s.platfromShop);
            }
            
            NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:text color:JXColorHex(0x333333) font:JXFont(11)];
            
            if (p.dddp != 0) {
                NSInteger len = s.platfromShop.length + 1;
                NSRange rag = NSMakeRange(len, text.length - len);
                [mas jx_addAttributeWithColor:SMInstance.mainColor font:JXFont(11) range:rag];
                
                [mas addAttribute:(NSString *)NSBackgroundColorAttributeName value:[UIColor clearColor] range:(NSRange)rag];
                [mas addAttribute:(NSString *)NSBackgroundColorAttributeName value:JXColorHex(0xe0f7ed) range:(NSRange)rag];
            }
            
            label.attributedText = mas;
            
            //            UIImageView *cart = [[UIImageView alloc] initWithImage:JXAdaptImage(JXImageWithName(@"ic_shoppingcart"))];
            //            [view addSubview:cart];
            //            [cart mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.centerY.equalTo(view);
            //                make.trailing.equalTo(view).offset(-8);
            //            }];
            
            JXButton *cart = [JXButton buttonWithType:UIButtonTypeCustom];
            [cart setImage:JXAdaptImage(JXImageWithName(@"ic_shoppingcart")) forState:UIControlStateNormal];
            [cart addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cart.obj = s.buyUrl;
            [view addSubview:cart];
            [cart mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.trailing.equalTo(view).offset(-8);
            }];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            priceLabel.text = JXStrWithFmt(@"¥%.2f", s.platformPrice);
            priceLabel.textColor = JXColorHex(0x333333);
            priceLabel.font = JXFont(10);
            [view addSubview:priceLabel];
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cart);
                make.trailing.equalTo(cart.mas_leading).offset(-4);
            }];
            
            topOffset += heightBase;
        }
    }
    
    splitImageView.hidden = YES;
}

- (void)buyButtonPressed:(JXButton *)btn {
    if (self.buyBlock) {
        self.buyBlock(btn.obj);
    }
}

+ (CGFloat)heightWithData:(CompResultDetailPrice *)p {
    CGFloat height = JXScreenScale(80) + 10;
    
    for (NSInteger i = 0; i < p.dbSpecBuyList.count; ++i) {
        height += JXScreenScale(32);
        CompResultDetailBrand *b = p.dbSpecBuyList[i];
        for (NSInteger j = 0; j < b.pfShopList.count; ++j) {
            height += JXScreenScale(32);
        }
    }
    return height;
}

@end











