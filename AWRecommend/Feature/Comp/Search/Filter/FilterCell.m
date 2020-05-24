//
//  FilterCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/18.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FilterCell.h"

@interface FilterCell ()
@property (nonatomic, weak) IBOutlet UIView *firstBgView;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *firstTitleLabel;

@property (nonatomic, weak) IBOutlet UIView *secondBgView;
@property (nonatomic, weak) IBOutlet UILabel *secondTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@end

@implementation FilterCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.secondTitleLabel.font = JXFont(13);
    self.secondTitleLabel.textColor = JXColorHex(0x333333);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(RACTuple *)d {
    [super setData:d];
    
//    if ([d isKindOfClass:[CompClassifyData1 class]]) {
//        self.firstBgView.hidden = YES;
//        self.secondBgView.hidden = NO;
//        self.secondTitleLabel.text = [(CompClassifyData1 *)d typeName];
//        self.secondImageView.highlighted = [(CompClassifyData1 *)d selected];
//        
//        BOOL selected = [(CompClassifyData1 *)d selected];
//        if (selected) {
//            self.secondTitleLabel.textColor = SMInstance.mainColor;
//        }else {
//            self.secondTitleLabel.textColor = JXColorHex(0x333333);
//        }
//    }else {
//        self.firstBgView.hidden = NO;
//        self.secondBgView.hidden = YES;
//        self.firstTitleLabel.text = [(CompClassifyData2 *)d drugName];
//    }
    
    BOOL a = [d.first boolValue];
    ShortcutSymptomListDisease *b = d.second;
    BOOL c = [d.third boolValue];
    
    if (a) {
        self.firstBgView.hidden = YES;
        self.secondBgView.hidden = NO;
        self.secondTitleLabel.text = b.tag;
        self.secondImageView.highlighted = c;
        
        if (c) {
            self.secondTitleLabel.textColor = SMInstance.mainColor;
        }else {
            self.secondTitleLabel.textColor = JXColorHex(0x333333);
        }
    }else {
        self.firstBgView.hidden = NO;
        self.secondBgView.hidden = YES;
        self.firstTitleLabel.text = b;
    }

}

@end




