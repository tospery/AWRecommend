//
//  NiceCommentCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceCommentCell.h"

@interface NiceCommentCell ()
@property (nonatomic, weak) IBOutlet UIButton *avatarButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *contentLabel;

@end

@implementation NiceCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorImageView.backgroundColor = JXColorHex(0xE1E1E1);
    
    self.contentLabel.font = [UIFont jx_systemFontOfSize:13];
    self.contentLabel.lineSpacing = 1.0f;
    self.contentLabel.numberOfLines = 0;
   //  self.contentLabel.text = data.articleCommentsContext;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.avatarButton jx_circleWithColor:[UIColor clearColor] border:0.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NiceComment *)data {
    [super setData:data];
    
    if (0 != data.user.avatar.length) {
        [self.avatarButton sd_setBackgroundImageWithURL:JXURLWithStr(data.user.avatar) forState:UIControlStateNormal placeholderImage:JXImageWithName(@"img_UserCenter_default")];
    }
    self.nameLabel.text = [data.user displayName];
    
    NSDate *curDate = [NSDate date];
    NSDate *cmtDate = [NSDate jx_dateFromString:data.articleCommentsTime format:kJXFormatDatetimeStyle1];
    NSTimeInterval interval = [curDate timeIntervalSinceDate:cmtDate];
    NSString *time = [data.articleCommentsTime substringToIndex:10];
    if (interval <= 60) {
        time = @"刚刚";
    }else if (interval > 60 && interval <= 60 * 60) {
        time = JXStrWithFmt(@"%ld分钟前", (long)interval / 60);
    }else if (interval > 60 * 60 && interval <= 60 * 60 * 24) {
        time = JXStrWithFmt(@"%ld小时前", (long)interval / 60 / 60);
    }else if (interval > 60 * 60 * 24 && interval <= 60 * 60 * 24 * 3) {
        time = JXStrWithFmt(@"%ld天前", (long)interval / 60 / 60 / 24);
    }
    self.timeLabel.text = time; //data.articleCommentsTime;
    
    
    self.numberLabel.text = JXStrWithFmt(@"%ld楼", (long)data.lc);
    
    if (data.deleteTag) {
        self.contentLabel.text = @"评论已删除";
    }else {
        self.contentLabel.text = data.articleCommentsContext;
    }
}

+ (CGFloat)heightWithData:(NiceComment *)data {
    CGFloat height = JXScreenScale(50.0f);
    static TTTAttributedLabel *label = nil;
    if (!label) {
        label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.font = [UIFont jx_systemFontOfSize:13];
        label.lineSpacing = 1.0f;
    }
    label.text = data.deleteTag ? @"评论已删除" : data.articleCommentsContext;
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:label.attributedText withConstraints:CGSizeMake(JXAdaptScreenWidth() - (10 + 32 + 8 + 10) , CGFLOAT_MAX) limitedToNumberOfLines:UINT32_MAX];
    height += (size.height + 8.0f);
    
    return height;
}

@end
