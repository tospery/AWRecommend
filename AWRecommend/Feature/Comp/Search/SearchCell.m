//
//  SearchCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/13.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *elpsLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@property (nonatomic, weak) IBOutlet UIView *opView;
@property (nonatomic, weak) IBOutlet UIView *apView;
@property (nonatomic, weak) IBOutlet UIView *btView;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *opButtons;

@end

@implementation SearchCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = JXFont(15);
    self.elpsLabel.font = JXFont(28);
    for (UIButton *btn in self.opButtons) {
        btn.titleLabel.font = JXFont(13);
        
        btn.backgroundColor = [UIColor clearColor];
        
        UIColor *titleColor = [UIColor whiteColor];
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitleColor:[titleColor colorWithAlphaComponent:0.8]  forState:UIControlStateHighlighted];
        
        UIColor *bgColor = SMInstance.mainColor;
        [btn setBackgroundImage:[UIImage jx_imageWithColor:bgColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage jx_imageWithColor:[bgColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    [self.opView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    
    for (UIButton *btn in self.opButtons) {
        CGFloat radius = JXAdaptScreen(13);
        [btn jx_borderWithColor:[UIColor clearColor] width:0.0 radius:radius];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(SearchClassify *)c {
    [super setData:c];
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(c.avatar) placeholderImage:JXImageWithName(@"img_head_default")];
    self.nameLabel.text = JXStrWithFmt(@"查询%@药品或症状", JXStrWithDft(c.categoryName, @""));
    
    if (c.selected && self.opView.hidden) {
//        self.opView.hidden = NO;
//        self.apView.backgroundColor = [UIColor clearColor];
//        self.btView.alpha = 0.0;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.apView.backgroundColor = [UIColor blackColor];
//            self.btView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//
//        }];
        self.opView.hidden = NO;
        self.btView.alpha = 0.0;
        
        CGRect frame = self.apView.frame;
        self.apView.frame = CGRectMake(self.apView.center.x, 0, 0, frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            self.apView.frame = frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.btView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }else if (!c.selected && !self.opView.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.apView.backgroundColor = [UIColor clearColor];
            self.btView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.opView.hidden = YES;
            self.apView.backgroundColor = [UIColor blackColor];
            self.btView.alpha = 1.0;
        }];
    }
}

- (IBAction)opButtonPressed:(UIButton *)btn {
    if (self.pressBlock) {
        self.pressBlock(RACTuplePack(self.data, @(btn.tag)));
    }
}

+ (CGFloat)height{
    return JXScreenScale(100.0f);
}

@end




