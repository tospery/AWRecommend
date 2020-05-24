//
//  CompResultDetail.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultDetail.h"

@implementation CompResultDetail
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"drugPriceList": [CompResultDetailPrice class]};
}

@end


@implementation CompResultDetailIntro

@end

@implementation CompResultDetailPrice
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dbSpecBuyList": [CompResultDetailBrand class]};
}

@end

@implementation CompResultDetailBrand
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"pfShopList": [CompResultDetailShop class]};
}

@end

@implementation CompResultDetailShop

@end
