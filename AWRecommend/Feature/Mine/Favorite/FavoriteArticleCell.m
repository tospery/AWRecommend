//
//  FavoriteArticleCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/26.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FavoriteArticleCell.h"

@interface FavoriteArticleCell ()
@property (nonatomic, weak) IBOutlet UILabel *articleTitleLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *activityNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *shopTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *likeLabel;
@property (nonatomic, weak) IBOutlet UILabel *lookLabel;
@property (nonatomic, weak) IBOutlet UIImageView *hotImageView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *expiredImageView;
@property (nonatomic, weak) IBOutlet UIView *tagsBgView;

@end

@implementation FavoriteArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(FavoriteArticle *)d {
    _data = d;
    
    self.articleTitleLabel.text = d.classify;
    self.hotImageView.hidden = !d.top;
    self.expiredImageView.hidden = d.expired;
    
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(d.tileImage) placeholderImage:kJXImagePHSquare];
    self.activityNameLabel.text = d.articleTitle;
    self.priceLabel.text = JXStrWithFmt(@"%@ %@", d.price, JXStrWithDft(d.priceRemark, @""));
    self.shopTimeLabel.text = JXStrWithFmt(@"%@|%@", d.source, d.publishTime);
    self.likeLabel.text = JXStrWithFmt(@"赞%ld", (long)d.praiseNum);
    self.lookLabel.text = JXStrWithInt(d.scanNum);
    
    //d.tags = @[@"中医", @"上门针灸"];
    [self.tagsBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat tagX = 8.0f;
    for (NSString *tag in d.tags) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = JXColorHex(0x999999);
        label.font = JXFont(9);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = tag;
        [label sizeToFit];
        label.frame = CGRectMake(tagX, (JXAdaptScreen(30) - label.jx_height - 6.0) / 2.0, label.jx_width + 10.0, label.jx_height + 6.0);
        [label jx_borderWithColor:JXColorHex(0xE1E1E1) width:1.0 radius:2.0];
        [self.tagsBgView addSubview:label];
        
        tagX += (label.jx_width + 8.0);
    }
}

+ (NSString *)identifier {
    return JXStrWithFmt(@"%@Identifier", NSStringFromClass([self class]));
}

+ (CGFloat)height{
    return JXScreenScale(156.0f);
}

@end
