//
//  CompResultBrandDescCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultBrandDescCell.h"

@interface CompResultBrandDescCell ()
@property (nonatomic, weak) IBOutlet UILabel *myTitleLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *myDescLabel;
@property (nonatomic, weak) IBOutlet UIImageView *downImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingConstraint;

@end

@implementation CompResultBrandDescCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.myTitleLabel.font = JXFont(14);
    self.myDescLabel.font = JXFont(13);
    
    self.myDescLabel.textColor = JXColorHex(0x444444);
    self.myDescLabel.lineSpacing = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(RACTuple *)t {
    [super setData:t];
    CompResultItem *item = t.first;
    NSString *title = t.second;
    NSString *desc = t.third;
    
    if ([title isEqualToString:@"适应症"]) {
        self.downImageView.highlighted = item.isExpansion1;
        self.downImageView.hidden = item.cantExpansion1;
        self.leadingConstraint.constant = 20;
    }else if ([title isEqualToString:@"药师指导"]) {
        self.downImageView.highlighted = item.isExpansion2;
        self.downImageView.hidden = item.cantExpansion2;
        self.leadingConstraint.constant = 20;
    }else if ([title isEqualToString:@"药品成分"]) {
        self.downImageView.highlighted = item.isExpansion3;
        self.downImageView.hidden = item.cantExpansion3;
        self.leadingConstraint.constant = 0;
    }
    
    self.myTitleLabel.text = title;
    self.myDescLabel.text = JXStrWithDft(desc, @"暂无");
}

+ (CGFloat)heightWithData:(RACTuple *)t {
    CompResultItem *item = t.first;
    NSString *title = t.second;
    NSString *desc = t.third;
    
    CGFloat height = JXScreenScale(64) - (8 + 20 + 8);
    CGSize size = [desc jx_sizeWithFont:JXFont(13) width:(JXScreenWidth - 16 - 24)];
    size.height += (size.height / 14) * 2;
    BOOL hasMore = size.height > height;

    if (!hasMore) {
        if ([title isEqualToString:@"适应症"]) {
            item.cantExpansion1 = YES;
        }else if ([title isEqualToString:@"药师指导"]) {
            item.cantExpansion2 = YES;
        }else if ([title isEqualToString:@"药品成分"]) {
            item.cantExpansion3 = YES;
        }
    }
    
    BOOL isExpansion = NO;
    if ([title isEqualToString:@"适应症"]) {
        isExpansion = item.isExpansion1;
    }else if ([title isEqualToString:@"药师指导"]) {
        isExpansion = item.isExpansion2;
    }else if ([title isEqualToString:@"药品成分"]) {
        isExpansion = item.isExpansion3;
    }
    
    if (hasMore && isExpansion) {
//        if ([title isEqualToString:@"适应症"]) {
//            item.isExpansion1 = NO;
//        }else if ([title isEqualToString:@"药师指导"]) {
//            item.isExpansion2 = NO;
//        }else if ([title isEqualToString:@"药品成分"]) {
//            item.isExpansion3 = NO;
//        }
        return size.height + (8 + 20 + 8) + 8;
    }
    
    return JXScreenScale(64.0f);
}

@end
