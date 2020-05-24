//
//  NiceChannelView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceChannelView.h"

@interface NiceChannelView ()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *hConstraint;
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@end

@implementation NiceChannelView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, JXAdaptScreenHeight(), JXAdaptScreenWidth(), JXAdaptScreenHeight());
}

- (IBAction)topButtonPressed:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(nil);
    }
}

- (void)setPlatforms:(NSArray *)platforms {
    _platforms = platforms;
    
    CGFloat height = JXAdaptScreen(40);
    self.hConstraint.constant = platforms.count * height + 8.0 * 2;
    for (NSInteger i = 0; i < platforms.count; ++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = JXFont(14);
        label.textColor = JXColorHex(0x333333);
        label.text = [(NiceBuy *)platforms[i] name];
        [self.bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomView).offset(10);
            make.top.equalTo(self.bottomView).offset(height * i + 8.0);
            make.height.equalTo(@(height));
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.jxIdentifier = [(NiceBuy *)platforms[i] url];
        button.titleLabel.font = JXFont(12);
        [button setBackgroundImage:JXImageWithName(@"bg_btn_bug_greenS") forState:UIControlStateNormal];
        [button setTitle:@"直达链接" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(linkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bottomView).offset(-10);
            make.centerY.equalTo(label);
            make.width.equalTo(@(JXAdaptScreen(74)));
            make.height.equalTo(@(JXAdaptScreen(22)));
        }];
    }
}

- (void)linkButtonPressed:(UIButton *)btn {
    NSString *link = btn.jxIdentifier;
    if (self.clickBlock) {
        self.clickBlock(link);
    }
}

@end
