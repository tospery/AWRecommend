//
//  CompResultList.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultList.h"

@implementation CompResultList
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [CompResultItem class]};
}

@end


@implementation CompResultItem
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"drugBandDtoList": [CompResultBrand class]};
}

@end


@implementation CompResultBrand
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dbspecDtoList": [CompResultSpec class]};
}

@end


@implementation CompResultSpec

@end
