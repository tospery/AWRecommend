//
//  ResultOutlineCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/6.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultOutlineCell.h"

@interface ResultOutlineCell ()
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@property (nonatomic, weak) IBOutlet UILabel *chineseTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *chineseCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *westernTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *westernCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *chineseFgButton;
@property (nonatomic, weak) IBOutlet UIButton *westernFgButton;

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@end

@implementation ResultOutlineCell

- (void)configHide:(BOOL)hide {
    self.nameLabel.textColor = hide ? JXColorHex(0x999999) : JXColorHex(0x333333);
    
    self.chineseTitleLabel.hidden = hide;
    self.chineseCountLabel.hidden = hide;
    self.westernTitleLabel.hidden = hide;
    self.westernCountLabel.hidden = hide;
    self.chineseFgButton.hidden = hide;
    self.westernFgButton.hidden = hide;
    
    if (hide) {
        self.bgImageView.image = JXImageWithName(@"box_x");
    }else {
        self.bgImageView.image = JXImageWithName(@"box_x3");
        
        CompResultList *list = self.data;
        [self.chineseCountLabel jx_animateCountWithDuration:1.0 count:list.chineseDrugCount isInt:YES format:@"%ld"];
        [self.westernCountLabel jx_animateCountWithDuration:1.0 count:list.westernDrugCount isInt:YES format:@"%ld"];
    }
    
//    if (!hide) {
//        CompResultList *list = self.data;
//        [self.chineseCountLabel jx_animateCountWithDuration:1.0 count:list.chineseDrugCount isInt:YES format:@"%ld"];
//        [self.westernCountLabel jx_animateCountWithDuration:1.0 count:list.westernDrugCount isInt:YES format:@"%ld"];
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = [UIFont jx_deviceBoldFontOfSize:15];
    self.countLabel.font = JXFont(11);
    
    self.chineseTitleLabel.font = JXFont(11);
    self.westernTitleLabel.font = JXFont(11);
    self.chineseCountLabel.font = JXFont(24);
    self.westernCountLabel.font = JXFont(24);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //[self jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(CompResultList *)list {
    [super setData:list];
    
    [self.avatarImageView sd_setImageWithURL:JXURLWithStr(list.avatar) placeholderImage:JXImageWithName(@"img_head_default")];
    self.nameLabel.text = JXStrWithFmt(@"%@药品", list.groupValue);
    self.countLabel.text = JXStrWithFmt(@"搜索结果：%ld", (long)list.totalSize);
    
    [self.chineseCountLabel jx_animateCountWithDuration:1.0 count:list.chineseDrugCount isInt:YES format:@"%ld"];
    [self.westernCountLabel jx_animateCountWithDuration:1.0 count:list.westernDrugCount isInt:YES format:@"%ld"];
    
    [self configHide:!list.cellShow];
}

- (NSString *)accessibilityLabel {
    return self.textLabel.text;
}

- (void)setLoading:(BOOL)loading {
    if (loading != _loading) {
        _loading = loading;
        [self _updateDetailTextLabel];
    }
}

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated {
    if (expansionStyle != _expansionStyle) {
        _expansionStyle = expansionStyle;
        [self _updateDetailTextLabel];
    }
}

- (void)_updateDetailTextLabel {
    //    if (self.isLoading) {
    //        self.detailTextLabel.text = @"加载中";
    //    } else {
    //        switch (self.expansionStyle) {
    //            case UIExpansionStyleExpanded:
    //                self.detailTextLabel.text = @"折叠";
    //                break;
    //            case UIExpansionStyleCollapsed:
    //                self.detailTextLabel.text = @"展开";
    //                break;
    //        }
    //    }
}

- (void)setIsPrecised:(BOOL)isPrecised {
    _isPrecised = isPrecised;
}

- (IBAction)zyButtonPressed:(id)sender {
    CompResultList *list = self.data;
    if (self.zyBlock) {
        self.zyBlock(RACTuplePack(list.keyword, list.groupValue));
    }
}

- (IBAction)xyButtonPressed:(id)sender {
    CompResultList *list = self.data;
    if (self.xyBlock) {
        self.xyBlock(RACTuplePack(list.keyword, list.groupValue));
    }
}

+ (CGFloat)height{
    return JXScreenScale(80.0f);
}

@end






