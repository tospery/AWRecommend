//
//  ScanResult.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/8.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanResult.h"

@implementation ScanResult

@end

@implementation ScanResultDesc
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"drugBandDtoList": [ScanResultDescBrand class]};
}

@end

@implementation ScanResultDescBrand

@end

@implementation ScanResultBrand

@end
