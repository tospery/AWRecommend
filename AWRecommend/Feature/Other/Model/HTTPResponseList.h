//
//  HTTPResponseList.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXArchiveObject.h"

//"totalRows": 0,
//"pageSize": 20,
//"currentPage": 1,
//"totalPages": 0,
//"data": [

//"totalRows": 0,
//"pageSize": 10,
//"currentPage": 1,
//"totalPages": 0,

@interface HTTPResponseList : JXArchiveObject
@property (nonatomic, assign) NSInteger currPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, strong) NSArray *datas;

@end
