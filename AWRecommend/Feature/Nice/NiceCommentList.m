//
//  NiceCommentList.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceCommentList.h"

@implementation NiceCommentList
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"currPage": @"currentPage",
             @"totalPage": @"totalPages",
             @"totalSize": @"totalRows",
             @"datas": @"data"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [NiceComment class]};
}


@end
