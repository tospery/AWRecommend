//
//  JXTableViewCell.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXTableViewCell.h"

@implementation JXTableViewCell
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
//    if (!UIEdgeInsetsEqualToEdgeInsets(self.splitterInsets, UIEdgeInsetsZero)) {
//        [self addSubview:self.splitter];
//        [self.splitter mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self).offset(self.splitterInsets.left);
//            make.trailing.equalTo(self).offset(-self.splitterInsets.right);
//            make.bottom.equalTo(self);
//            make.height.equalTo(@(1 - self.splitterInsets.top));
//        }];
//    }
}

//- (UIImageView *)splitter {
//    if (!_splitter) {
//        _splitter = [[UIImageView alloc] init];
//        _splitter.backgroundColor = JXColorHex(0xe7e7e7);
//    }
//    return _splitter;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifier {
    return JXStrWithFmt(@"%@Identifier", NSStringFromClass([self class]));
}

+ (CGFloat)height{
    return JXScreenScale(40.0f);
}

+ (CGFloat)heightWithData:(id)data {
    return JXScreenScale(40.0f);
}

@end
