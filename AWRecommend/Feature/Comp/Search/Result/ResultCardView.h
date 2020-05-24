//
//  ResultCardView.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultCardView : UIView
@property (nonatomic, strong) CompResultList *list;
@property (nonatomic, copy) JXVoidBlock_id moreBlock;
@property (nonatomic, copy) JXVoidBlock_id itemBlock;
@property (nonatomic, copy) JXVoidBlock_int matchBlock;
@property (nonatomic, copy) JXVoidBlock_id zyBlock;
@property (nonatomic, copy) JXVoidBlock_id xyBlock;

@end
