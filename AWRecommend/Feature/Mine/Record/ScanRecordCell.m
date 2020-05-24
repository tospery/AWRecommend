//
//  ScanRecordCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanRecordCell.h"

@interface ScanRecordCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation ScanRecordCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ScanRecord *)data {
    _data = data;
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(data.imgUrl) placeholderImage:JXImageWithName(@"img_default")];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", data.brandName, data.drugName);
    self.timeLabel.text = [data.createTime substringToIndex:10];
}

+ (NSString *)identifier {
    return JXStrWithFmt(@"%@Identifier", NSStringFromClass([self class]));
}

+ (CGFloat)height{
    return JXScreenScale(70.0f);
}

@end
