//
//  CompClassify.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompClassify.h"

@implementation CompClassify
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [CompClassifyData1 class]};
}

@end


@implementation CompClassifyData1
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [CompClassifyData2 class]};
}

@end

@implementation CompClassifyData2

@end
