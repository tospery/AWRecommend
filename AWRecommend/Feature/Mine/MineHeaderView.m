//
//  MineHeaderView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *avatarConstraint;

@end

@implementation MineHeaderView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.messageUnreadLabel.backgroundColor = JXColorHex(0xB21D27);
    
    @weakify(self)
    [[RACObserve(gUser, isLogined) distinctUntilChanged] subscribeNext:^(NSNumber *isLogined) {
        @strongify(self)
        if (isLogined.boolValue) {
            if (0 == gUser.avatar.length) {
                self.avatarImageView.image = JXImageWithName(@"img_UserCenter_default");
            }else {
                [self.avatarImageView sd_setImageWithURL:JXURLWithStr(gUser.avatar) placeholderImage:JXImageWithName(@"img_UserCenter_default")];
            }
            
            NSString *name = gUser.nickName;
            if (0 == name.length) {
                name = gUser.mobile;
            }
            if (0 == name.length) {
                name = @"暂无昵称";
            }
            self.nameLabel.text = name;
        }else {
            self.avatarImageView.image = JXImageWithName(@"img_UserCenter_default");
            self.nameLabel.text = @"点击登录";
        }
    }];
    
    [RACObserve(gUser, avatar) subscribeNext:^(NSString *avatar) {
        @strongify(self)
        if (gUser.isLogined && avatar.length != 0) {
            [self.avatarImageView sd_setImageWithURL:JXURLWithStr(gUser.avatar) placeholderImage:JXImageWithName(@"img_UserCenter_default")];
        }else {
            self.avatarImageView.image = JXImageWithName(@"img_UserCenter_default");
        }
    }];
    
    
    [RACObserve(gUser, nickName) subscribeNext:^(NSString *nickName) {
        @strongify(self)
        if (gUser.isLogined) {
            NSString *name = nickName;
            if (0 == name.length) {
                name = @"请完善您的信息";
            }
            self.nameLabel.text = name;
        }else {
            self.nameLabel.text = @"点击登录";
        }
    }];
    
    if (JXiOSVersionGreaterThanOrEqual(@"11")) {
        self.frame = CGRectMake(0, 0, JXScreenWidth, JXAdaptScreen(200.0f));
    }else {
        self.frame = CGRectMake(0, 0, JXScreenWidth, JXAdaptScreen(180.0f));
        self.avatarConstraint.constant = -10.0f;
        self.settingButton.hidden = YES;
        self.messageButton.hidden = YES;
        self.messageUnreadLabel.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.messageUnreadLabel jx_circleWithColor:[UIColor clearColor] border:0.0f];
    [self.avatarImageView jx_circleWithColor:[UIColor whiteColor] border:JXScreenScale(2.0)];
}

- (IBAction)userButtonPressed:(id)sender {
    if (self.loginDidPress) {
        self.loginDidPress();
    }
}

- (IBAction)messageButtonPressed:(id)sender {
    if (self.msgDidPress) {
        self.msgDidPress();
    }
}

- (IBAction)settingButtonPressed:(id)sender {
    if (self.setDidPress) {
        self.setDidPress();
    }
}

@end
