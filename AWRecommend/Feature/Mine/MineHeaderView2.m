//
//  MineHeaderView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MineHeaderView2.h"

@interface MineHeaderView2 ()
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

@implementation MineHeaderView2
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(200.0f));
    
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
                // name = gUser.mobile;
                name = @"请完善您的信息";
            }
//            if (0 == name.length) {
//                name = @"暂无昵称";
//            }
            self.nameLabel.text = name;
        }else {
            self.nameLabel.text = @"点击登录";
        }
    }];
    
//    [[RACSignal merge:@[RACObserve(gUser, isLogined), RACObserve(gUser, avatar)]] subscribeNext:^(id value) {
//        int a = 0;
//        if (value isKindOfClass:<#(__unsafe_unretained Class)#>) {
//            <#statements#>
//        }
//    }];
    
    
    
//    self.avatarButton.style = JXButtonStyleBottom;
//    self.avatarButton.distance = JXScreenScale(8);
//    self.avatarButton.titleLabel.textColor = JXColorHex(0x333333);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.avatarImageView jx_circleWithColor:[UIColor whiteColor] border:JXScreenScale(2.0)];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
//    if (gUser.isLogined) {
//        return;
//    }
    
    if (self.loginDidPress) {
        self.loginDidPress();
    }
}

@end







