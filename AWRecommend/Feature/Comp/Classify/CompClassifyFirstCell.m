//
//  CompClassifyFirstCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompClassifyFirstCell.h"

@interface CompClassifyFirstCell ()
@property (nonatomic, weak) IBOutlet UILabel *myTitleLabel;

@end

@implementation CompClassifyFirstCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.myTitleLabel.font = JXFont(13.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CompClassify *)c {
    [super setData:c];
    self.myTitleLabel.text = c.drugCategoryName;
}

@end
