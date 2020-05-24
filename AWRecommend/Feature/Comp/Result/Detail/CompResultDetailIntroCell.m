//
//  CompResultDetailIntroCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultDetailIntroCell.h"

@interface CompResultDetailIntroCell ()
@property (nonatomic, weak) IBOutlet UILabel *myTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *myContentLabel;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@end

@implementation CompResultDetailIntroCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setData:(RACTuple *)t {
    [super setData:t];
    NSString *title = t.first;
    NSString *content = t.second;
    NSNumber *row = t.third;
    if (row.integerValue % 2 != 0) {
        self.bgView.backgroundColor = JXColorHex(0xF0FBF5);
    }else {
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    self.myTitleLabel.text = JXStrWithDft(title, @"");
    self.myContentLabel.text = JXStrWithDft(content, @"暂无");
}

+ (CGFloat)heightWithData:(RACTuple *)t {
    NSString *content = t.second;
    
    CGSize size = [content jx_sizeWithFont:[UIFont systemFontOfSize:14] width:(JXScreenWidth / 100 * 75 - 8 * 2)];
    CGFloat height = JXScreenScale(40) - 16;
    if (size.height < height) {
        return JXScreenScale(40);
    }
    
    return 16 + size.height + 8;
}

@end
