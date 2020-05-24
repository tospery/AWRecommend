//
//  ResultOutlineCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/6.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultOutlineCell : JXTableViewCell <UIExpandingTableViewCell>
@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;

@property (nonatomic, copy) JXVoidBlock_id zyBlock;
@property (nonatomic, copy) JXVoidBlock_id xyBlock;

@property (nonatomic, assign) BOOL isPrecised;

- (void)configHide:(BOOL)hide;

@end
