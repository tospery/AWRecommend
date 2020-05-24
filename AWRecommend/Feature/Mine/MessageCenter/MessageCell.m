//
//  MessageCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *subjectLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@end

@implementation MessageCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.font = [UIFont jx_systemFontOfSize:10];
    self.subjectLabel.font = [UIFont jx_boldSystemFontOfSize:14];
    self.contentLabel.font = [UIFont jx_systemFontOfSize:12];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineSpacing = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.timeLabel jx_borderWithColor:[UIColor clearColor] width:0.0 radius:2.0];
    [self.bgView jx_borderWithColor:JXColorHex(0xE7E7E7) width:1.0 radius:4.0];
}

- (void)setData:(Message *)m {
    _data = m;
    
   // self.separatorImageView.hidden = YES;
    
    self.timeLabel.text = m.parseTime;
    self.subjectLabel.text = m.title;
    // self.contentLabel.text = m.content;
    
    if (m.isRead == 1) {
        self.subjectLabel.textColor = JXColorHex(0x333333);
        self.contentLabel.textColor = JXColorHex(0x333333);
    }else {
        self.subjectLabel.textColor = JXColorHex(0x999999);
        self.contentLabel.textColor = JXColorHex(0x999999);
    }
    self.contentLabel.text = m.content;
}

+ (CGFloat)height {
    return JXAdaptScreen(85.0f);
}

+ (NSString *)identifier {
    return JXStrWithFmt(@"%@Identifier", NSStringFromClass([self class]));
}

+ (CGFloat)heightWithData:(Message *)m {
    CGFloat height = JXAdaptScreen(85.0f);
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont jx_systemFontOfSize:12];
    label.numberOfLines = 0;
    label.lineSpacing = 2.0;
    label.text = m.content;
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:label.attributedText withConstraints:CGSizeMake(JXScreenWidth - 44.0, CGFLOAT_MAX) limitedToNumberOfLines:UINT32_MAX];
    height += (size.height + 8.0);
    
    return height;
}
@end




