//
//  CompResultBrandProductCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultBrandProductCell.h"

@interface CompResultBrandProductCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIButton *safeButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *specLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *traingConstraint;

@end

@implementation CompResultBrandProductCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = JXFont(13);
    //self.safeButton.titleLabel.font = JXFont(9);
    self.specLabel.font = JXFont(11);
    self.infoLabel.font = JXFont(8);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //[self.safeButton jx_borderWithColor:JXColorHex(0xff5500) width:1 radius:6];
}

- (void)setData:(CompResultBrand *)brand {
    [super setData:brand];
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(brand.brandImg) placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", brand.brandName, brand.drugName);
    
//    //self.safeButton.hidden = (0 == brand.safety.length);
//    if (self.safeButton.hidden) {
//        self.traingConstraint.constant = -48;
//    }else {
//        self.traingConstraint.constant = 4;
//    }
    
    self.specLabel.text = JXStrWithDft(brand.factory, @"");
    
    if (0 == brand.dbspecDtoList.count) {
        return;
    }
    
    CompResultSpec *spec = brand.dbspecDtoList[0];
    
    NSString *name = JXStrWithDft(spec.spec, @"");
    NSString *str = JXStrWithFmt(@"%@  ¥%.2f元起", name, spec.price);
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:str];
    [as jx_addAttributeWithColor:SMInstance.mainColor font:JXFont(10) range:NSMakeRange(name.length + 1, str.length - name.length - 1 - 1)];
    self.infoLabel.attributedText = as;
    
////    NSString *name = JXStrWithDft(spec.spec, @"");
////    
////    
////    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:@""];
////    
////    NSString *str = JXStrWithFmt(@"规格：%@  参考价格：%.2f元", name, spec.price);
////    NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x999999) font:JXFont(9)];
////    [as jx_addAttributeWithColor:JXColorHex(0x999999) font:[UIFont jx_deviceBoldFontOfSize:9] range:NSMakeRange(0, 3)];
////    [as jx_addAttributeWithColor:JXColorHex(0x999999) font:[UIFont jx_deviceBoldFontOfSize:9] range:NSMakeRange(3 + name.length + 2, 4)];
////    self.specLabel.attributedText = as;
//    
//    
//    NSMutableAttributedString *specAS = [[NSMutableAttributedString alloc] initWithString:@""];
//    NSMutableAttributedString *priceAS = [[NSMutableAttributedString alloc] initWithString:@""];
//    for (NSInteger i = 0; i < brand.dbspecDtoList.count; ++i) {
//        CompResultSpec *spec = brand.dbspecDtoList[i];
////        NSString *name = JXStrWithDft(spec.spec, @"");
////        NSString *str = JXStrWithFmt(@"规格：%@\t\t参考价格：%.2f元\n", name, spec.price);
////        NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x999999) font:JXFont(9)];
////        [as jx_addAttributeWithColor:JXColorHex(0x999999) font:[UIFont jx_deviceBoldFontOfSize:9] range:NSMakeRange(0, 2)];
////        [as jx_addAttributeWithColor:JXColorHex(0x999999) font:[UIFont jx_deviceBoldFontOfSize:9] range:NSMakeRange(3 + name.length + 2, 4)];
////        [sp appendAttributedString:as];
//        NSString *name = JXStrWithDft(spec.spec, @"");
//        NSString *specStr = JXStrWithFmt(@"规格：%@\n", name);
//        NSMutableAttributedString *specMS = [NSMutableAttributedString jx_attributedStringWithString:specStr color:JXColorHex(0x999999) font:JXFont(9)];
//        [specMS jx_addAttributeWithColor:JXColorHex(0x999999) font:[UIFont jx_deviceBoldFontOfSize:9] range:NSMakeRange(0, 2)];
//        [specAS appendAttributedString:specMS];
//        
//        
//        NSString *priceStr = JXStrWithFmt(@"参考价格：%.2f元\n", spec.price);
//        NSMutableAttributedString *priceMS = [NSMutableAttributedString jx_attributedStringWithString:priceStr color:JXColorHex(0x999999) font:JXFont(9)];
//        [priceMS jx_addAttributeWithColor:JXColorHex(0x999999) font:[UIFont jx_deviceBoldFontOfSize:9] range:NSMakeRange(0, 4)];
//        [priceAS appendAttributedString:priceMS];
//    }
//    if (specAS.length != 0) {
//       [specAS deleteCharactersInRange:NSMakeRange(specAS.length - 1, 1)];
//    }
//    if (priceAS.length != 0) {
//        [priceAS deleteCharactersInRange:NSMakeRange(priceAS.length - 1, 1)];
//    }
//    self.specLabel.attributedText = specAS;
//    self.priceLabel.attributedText = priceAS;
}

- (IBAction)safeButtonPressed:(id)sender {
    if (self.safeDidPressBlock) {
        self.safeDidPressBlock(self.data);
    }
}

+ (CGFloat)height{
    return JXScreenScale(70.0f);
}

+ (CGFloat)heightWithData:(CompResultBrand *)brand {
//    if (brand.dbspecDtoList.count <= 2) {
//        return JXScreenScale(60.0f);
//    }
//    
//    return JXScreenScale(60.0f) + JXScreenScale(18) * (brand.dbspecDtoList.count - 2);
    return JXScreenScale(70.0f);
}

@end





