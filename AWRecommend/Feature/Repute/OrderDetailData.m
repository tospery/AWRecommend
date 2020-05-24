//
//  OrderDetailData.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/11/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "OrderDetailData.h"

@implementation OrderDetail
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"stateData": [OrderStateData class]};
}

@end

@implementation OrderDetailData
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods": [OrderDetailDataGoods class]};
}

@end

@implementation OrderDetailDataGoods

@end

@implementation OrderStateData

@end

