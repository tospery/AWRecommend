//
//  CompResultBrandOutlineCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompResultBrandOutlineCell : JXTableViewCell <UIExpandingTableViewCell>
@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;

@end
