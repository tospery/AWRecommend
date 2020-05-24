//
//  BrandCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "BrandCell.h"

@interface BrandCell ()
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *factoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *dddpButton;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end

@implementation BrandCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //    UIImage *image = JXImageWithName(@"ic_caution");
    //    CGFloat slide = JXFontSize(12.0);
    //    image = [image jx_scaleWithWidth:slide height:slide];
    //    [self.dddpButton setImage:image forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(CompResultBrand *)b {
    [super setData:b];
    
    //    @property (nonatomic, assign) CGFloat price;
    //    @property (nonatomic, assign) NSInteger brandId;
    //    @property (nonatomic, assign) NSInteger monthAmount;
    //    @property (nonatomic, assign) NSInteger satisfaceionRate;
    //    @property (nonatomic, copy) NSString *factory;
    //    @property (nonatomic, copy) NSString *brandName;
    //    @property (nonatomic, copy) NSString *brandImg;
    //    @property (nonatomic, copy) NSString *drugName;
    //    @property (nonatomic, copy) NSString *safety;
    //    @property (nonatomic, strong) NSArray *dbspecDtoList;
    //
    //    @property (nonatomic, copy) NSString *chMedTag; // 保护
    //    @property (nonatomic, copy) NSString *baseMedTag; // 基
    //    @property (nonatomic, copy) NSString *patentRightTag; // 专
    //    @property (nonatomic, assign) CGFloat ddd;
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(b.brandImg) placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", b.brandName, b.drugName);
    self.factoryLabel.text = b.factory;
    self.priceLabel.text = JXStrWithFmt(@"¥%.2f起", b.price);
    
    if (b.dddp == 0) {
        self.dddpButton.hidden = YES;
    }else {
        self.dddpButton.hidden = NO;
        [self.dddpButton setTitle:JXStrWithFmt(@" DDDP:%.2f元/天", b.dddp) forState:UIControlStateNormal];
    }
    
    
    CGFloat trailing = -8.0f;
    UIButton *btn = nil;
    
    NSString *has = @"是";
    UIFont *font = [UIFont systemFontOfSize:9];
    CGFloat width = 20;
    CGFloat height = 14;
    
    if ([b.chMedTag isEqualToString:has]) {
        UIColor *color = JXColorHex(0xFF9F42);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = MedicineTagProtect;
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:JXImageWithColor(color) forState:UIControlStateNormal];
        [btn setTitle:@"保" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.trailing.equalTo(self.bgView).offset(trailing);
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
        }];
        [btn jx_borderWithColor:color width:1.0 radius:2.0];
        
        trailing -= (width + 4.0);
    }
    if ([b.patentRightTag isEqualToString:has]) {
        UIColor *color = JXColorHex(0x67B0ED);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = MedicineTagPatent;
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:JXImageWithColor(color) forState:UIControlStateNormal];
        [btn setTitle:@"专" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.trailing.equalTo(self.bgView).offset(trailing);
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
        }];
        [btn jx_borderWithColor:color width:1.0 radius:2.0];
        
        trailing -= (width + 4.0);
    }
    if ([b.baseMedTag isEqualToString:has]) {
        UIColor *color = JXColorHex(0x62cdbf);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = MedicineTagBasic;
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:JXImageWithColor(color) forState:UIControlStateNormal];
        [btn setTitle:@"基" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.trailing.equalTo(self.bgView).offset(trailing);
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
        }];
        [btn jx_borderWithColor:color width:1.0 radius:2.0];
        
        trailing -= (width + 4.0);
    }
    
    if (btn) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(btn.mas_leading).offset(4);
        }];
    }
}

- (IBAction)dddpButtonPressed:(id)sender {
    if (self.dddpBlock) {
        self.dddpBlock();
    }
}

- (void)tagButtonPressed:(UIButton *)btn {
    if (self.tagBlock) {
        self.tagBlock(btn);
    }
}

+ (CGFloat)height {
    return JXScreenScale(70);
}

@end








