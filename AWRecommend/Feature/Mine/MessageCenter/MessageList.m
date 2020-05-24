//
//  MessageList.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MessageList.h"

@implementation MessageList
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"currPage": @"currentPage",
             @"totalPage": @"totalPages",
             @"totalSize": @"totalRows",
             @"datas": @"data"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [Message class]};
}

@end

@implementation Message

@end
