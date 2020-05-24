//
//  ReputeCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/10/30.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ReputeCell.h"

@interface ReputeCell () <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *phLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIView *inputBgView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end

@implementation ReputeCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    for (UIButton *btn in self.tagButtons) {
        [btn setBackgroundImage:JXImageWithColor(JXColorHex(0xC8ECDD)) forState:UIControlStateSelected];
    }
    [(UIButton *)self.tagButtons[0] setSelected:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.inputBgView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0];
    for (UIButton *btn in self.tagButtons) {
        [btn jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0];
    }
}

- (void)setData:(OrderDetailDataGoods *)d {
    [super setData:d];
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(d.goodsImage) placeholderImage:kJXImagePHSquare];
    self.nameLabel.text = d.goodsName;
    
    d.commentStar = @"5";
    d.commentTagIds = [NSMutableArray array];
    [d.commentTagIds addObject:@"1"];
    d.commentTagNames = [NSMutableArray array];
    [d.commentTagNames addObject:@"值得推荐"];
}

- (IBAction)didChangeValue:(HCSStarRatingView *)ratingView {
    NSArray *stars = @[@"差", @"不错", @"一般", @"满意", @"很棒"];
    self.starLabel.text = stars[(NSInteger)ratingView.value - 1];
    
    OrderDetailDataGoods *g = (OrderDetailDataGoods *)self.data;
    g.commentStar = JXStrWithInt(ratingView.value);
}

- (IBAction)tagButtonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    OrderDetailDataGoods *g = (OrderDetailDataGoods *)self.data;
    if (btn.selected) {
        [g.commentTagIds addObject:JXStrWithInt(btn.tag)];
        [g.commentTagNames addObject:[btn titleForState:UIControlStateNormal]];
    }else {
        [g.commentTagIds removeObject:JXStrWithInt(btn.tag)];
        [g.commentTagNames removeObject:[btn titleForState:UIControlStateNormal]];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.phLabel.hidden = (textView.text.length != 0);
    
    OrderDetailDataGoods *g = (OrderDetailDataGoods *)self.data;
    g.commentContent = textView.text;
}

+ (CGFloat)height {
    return JXAdaptScreen(260.0f);
}

@end




