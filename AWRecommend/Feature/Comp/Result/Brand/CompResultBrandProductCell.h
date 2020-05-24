//
//  CompResultBrandProductCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompResultBrandProductCell : JXTableViewCell
@property (nonatomic, copy) JXVoidBlock_id safeDidPressBlock;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingConstraint;

@end
