//
//  SearchResultCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/16.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : JXTableViewCell
@property (nonatomic, copy) JXVoidBlock_int itemDidPressBlock;
@property (nonatomic, copy) JXVoidBlock_string moreDidPressBlock;

@end
