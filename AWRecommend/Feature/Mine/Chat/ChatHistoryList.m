//
//  ChatHistoryList.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/18.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ChatHistoryList.h"

////"totalRows": 0,
////"pageSize": 20,
////"currentPage": 1,
////"totalPages": 0,
////"data": [
//
//@interface HTTPResponseList : JXArchiveObject
//@property (nonatomic, assign) NSInteger currPage;
//@property (nonatomic, assign) NSInteger pageSize;
//@property (nonatomic, assign) NSInteger totalPage;
//@property (nonatomic, assign) NSInteger totalSize;
//@property (nonatomic, strong) NSArray *datas;
//
//@end

@implementation ChatHistoryList
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"currPage": @"currentPage",
             @"totalPage": @"totalPages",
             @"totalSize": @"totalRows",
             @"datas": @"data"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [ChatHistory class]};
}

@end
