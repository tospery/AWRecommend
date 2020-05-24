//
//  OrderPendingAmount.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@interface OrderPendingAmount : JXObject
@property (nonatomic, assign) NSInteger prepayNum;
@property (nonatomic, assign) NSInteger dispatchNum;
@property (nonatomic, assign) NSInteger receivingNum;
@property (nonatomic, assign) NSInteger sysNum;

@end
