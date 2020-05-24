//
//  CompResultBrandOutlineCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultBrandOutlineCell.h"

@implementation CompResultBrandOutlineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

@end
