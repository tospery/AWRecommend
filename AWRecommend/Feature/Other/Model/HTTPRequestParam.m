//
//  HTTPRequestParam.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPRequestParam.h"

@implementation HTTPRequestParam
- (NSDictionary *)commonHeader {
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    if (0 != gUser.token) {
        [header setObject:gUser.token forKey:@"token"];
    }
    return header;
}

@end
