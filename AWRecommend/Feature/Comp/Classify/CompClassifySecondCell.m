//
//  CompClassifySecondCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompClassifySecondCell.h"

@interface CompClassifySecondCell ()
@property (nonatomic, weak) IBOutlet UIView *firstBgView;
@property (nonatomic, weak) IBOutlet UILabel *firstTitleLabel;

@property (nonatomic, weak) IBOutlet UIView *secondBgView;
@property (nonatomic, weak) IBOutlet UILabel *secondTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;

@end

@implementation CompClassifySecondCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstTitleLabel.font = JXFont(13.0);
    self.secondTitleLabel.font = JXFont(13.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)d {
    [super setData:d];
    if ([d isKindOfClass:[CompClassifyData2 class]]) {
        self.firstBgView.hidden = NO;
        self.secondBgView.hidden = YES;
        self.firstTitleLabel.text = [(CompClassifyData2 *)d drugName];
    }else {
        self.firstBgView.hidden = YES;
        self.secondBgView.hidden = NO;
        self.secondTitleLabel.text = [(CompClassifyData1 *)d typeName];
        self.secondImageView.highlighted = [(CompClassifyData1 *)d selected];
    }
}

@end
