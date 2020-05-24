//
//  AboutCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/26.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "AboutCell.h"

@interface AboutCell ()
@property (nonatomic, weak) IBOutlet UILabel *myFirstLabel;
@property (nonatomic, weak) IBOutlet UILabel *mySecondLabel;

@end

@implementation AboutCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(RACTuple *)data {
    [super setData:data];
    self.myFirstLabel.text = data.first;
    self.mySecondLabel.text = data.second;
    
    self.separatorImageView.hidden = YES;
}

@end




