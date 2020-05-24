//
//  HTTPRequestClient.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXHTTPRequestClient.h"

#define HRInstance              ([HTTPRequestClient sharedInstance])

@interface HTTPRequestClient : JXHTTPRequestClient
- (RACSignal *)requestWithPath:(NSString *)path param:(JXHTTPRequestParam *)param schema:(JXHTTPSchema *)schema class:(Class)cls tag:(NSInteger)tag isList:(BOOL)isList;

+ (instancetype)sharedInstance;
@end
