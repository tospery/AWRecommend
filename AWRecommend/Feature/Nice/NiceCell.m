//
//  NiceCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceCell.h"

@interface NiceCell ()
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

@implementation NiceCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.activityNameLabel.lineSpacing = 0.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//"id": 4,
//"articleTitle": "仅售24.9元，价值28元单人洗吹造型套餐1份，免费WiFi！",
//"classify": "特别优惠",
//"tags": null,
//"tag": "美发",
//"top": 1,
//"expired": 1,
//"tileImage": "http://imge2",
//"price": "24.9",
//"priceRemark": "无需预约，直接消费",
//"source": "美团",
//"publishTime": "2017-06-13",
//"scanNum": 112,
//"praiseNum": 13,
//"classifyImage": null
- (void)setData:(Nice *)d {
    [super setData:d];
    
    self.articleTitleLabel.text = d.classify;
    self.hotImageView.hidden = !d.top;
    self.expiredImageView.hidden = d.expired;
    
    UIImage *dftImage = JXImageWithName(@"img_default2");
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(d.tileImage) placeholderImage:dftImage];
    self.activityNameLabel.text = d.articleTitle;
    self.priceLabel.text = JXStrWithFmt(@"%@ %@", d.price, JXStrWithDft(d.priceRemark, @""));
    self.shopTimeLabel.text = JXStrWithFmt(@"%@|%@", d.source, d.publishTime);
    self.likeLabel.text = JXStrWithFmt(@"赞%ld", (long)d.praiseNum);
    self.lookLabel.text = JXStrWithInt(d.scanNum);
    
    //d.tags = @[@"中医", @"上门针灸"];
    [self.tagsBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat tagX = 8.0f;
    NSInteger count = 0;
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
        ++count;
        if (3 == count) {
            break;
        }
    }
}

+ (CGFloat)height {
    return JXAdaptScreen(156);
}

@end








