//
//  JXPage.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXPage.h"

@implementation JXPage
- (instancetype)init {
    if (self = [super init]) {
        _index = JXInstance.pageIndex;
        _size = JXInstance.pageSize;
    }
    return self;
}
@end
