//
//  MedicineToolView.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MedicineToolView.h"

@implementation MedicineToolView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(50));
}

- (IBAction)shareButtonPressed:(UIButton *)btn {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (IBAction)favoriteButtonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.favoriteBlock) {
        self.favoriteBlock(btn.selected);
    }
}

@end
