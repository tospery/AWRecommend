//
//  ChatHistoryCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/12.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ChatHistoryCell.h"

@interface ChatHistoryCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *messageLabel;

@end

@implementation ChatHistoryCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = [UIFont jx_systemFontOfSize:14];
    self.timeLabel.font = [UIFont jx_systemFontOfSize:14];
    self.messageLabel.font = [UIFont jx_systemFontOfSize:13];
    self.messageLabel.textColor = JXColorHex(0x333333);
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineSpacing = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ChatHistory *)data {
    [super setData:data];
    
    NSString *myid = JXStrWithFmt(@"A%@", gUser.jxID);
    if ([myid isEqualToString:data.fromAccount] ||
        [gUser.nickName isEqualToString:data.fromAccount]) {
        self.nameLabel.textColor = JXColorHex(0x7db9e7);
    }else {
        self.nameLabel.textColor = SMInstance.mainColor;
    }
    
    NSString *name = data.userName;
    if (0 == name.length) {
        name = data.mobile;
    }
    if (0 == name.length) {
        name = data.fromAccount;
    }
    self.nameLabel.text = name;
    self.timeLabel.text = data.receiveTime;
    self.messageLabel.text = data.context;
}

+ (CGFloat)heightWithData:(ChatHistory *)data {
    CGFloat height = JXAdaptScreen(30);
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont jx_systemFontOfSize:13];
    label.textColor = JXColorHex(0x333333);
    label.lineSpacing = 2.0f;
    label.numberOfLines = 0;
    label.text = data.context;
    
    NSAttributedString *as = label.attributedText;
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:as withConstraints:CGSizeMake(JXScreenWidth - 32.0, CGFLOAT_MAX) limitedToNumberOfLines:UINT32_MAX];
    height += (size.height + 8.0);
    
    return height;
}

@end




