//
//  SettingCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/25.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()
@property (nonatomic, weak) IBOutlet UILabel *myKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *myValueLabel;
@property (nonatomic, weak) IBOutlet UIButton *avatarButton;

@end

@implementation SettingCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.myKeyLabel.font = JXFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint center = self.avatarButton.center;
    CGFloat slide = self.jx_height / 60.0 * 44.0;
    self.avatarButton.jx_width = slide;
    self.avatarButton.jx_height = slide;
    self.avatarButton.center = center;
    
    [self.avatarButton jx_circleWithColor:[UIColor whiteColor] border:1.0];
}

- (void)setData:(NSString *)data {
    [super setData:data];
    
    self.myKeyLabel.text = data;
    
    BOOL isAvatar = NO;
    if ([data isEqualToString:@"头像"]) {
        isAvatar = YES;
        [self.avatarButton sd_setImageWithURL:JXURLWithStr(gUser.avatar) forState:UIControlStateNormal placeholderImage:JXImageWithName(@"img_UserCenter_default")];
    }else if ([data isEqualToString:@"昵称"]) {
        self.myValueLabel.text = JXStrWithDft(gUser.nickName, @"暂无");
    }else if ([data isEqualToString:@"性别"]) {
        //self.myValueLabel.text = JXStrWithDft(gUser.nickName, @"未设置");
        self.myValueLabel.text = GenderTypeString(gUser.sex);
    }else if ([data isEqualToString:@"生日"]) {
        self.myValueLabel.text = JXStrWithDft(gUser.dateOfBirth, @"暂无");
    }else {
        
    }
    
    self.avatarButton.hidden = !isAvatar;
    self.myValueLabel.hidden = isAvatar;
}

+ (CGFloat)heightWithData:(NSString *)data {
    if ([data isEqualToString:@"头像"]) {
        return JXScreenScale(60);
    }
    return JXScreenScale(40);
}

@end
