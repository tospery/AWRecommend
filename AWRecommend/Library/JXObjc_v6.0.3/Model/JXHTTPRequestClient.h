//
//  JXHTTPRequestClient.h
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "JXHTTPRequestParam.h"

@interface JXHTTPRequestClient : AFHTTPSessionManager
- (RACSignal *)requestWithPath:(NSString *)path param:(JXHTTPRequestParam *)param schema:(JXHTTPSchema *)schema class:(Class)cls;

//- (RACSignal *)requestWithPath:(NSString *)path isArr:(BOOL)isArr;
//- (RACSignal *)requestWithPath:(NSString *)path tag:(NSInteger)tag isArr:(BOOL)isArr;
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param;
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param tag:(NSInteger)tag;
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema;
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema tag:(NSInteger)tag;
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param class:(Class)cls;
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param class:(Class)cls tag:(NSInteger)tag;
//
//- (RACSignal *)requestWithPath:(NSString *)path class:(Class)cls;
//- (RACSignal *)requestWithPath:(NSString *)path class:(Class)cls tag:(NSInteger)tag;
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema class:(Class)cls;
// - (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema class:(Class)cls;

//- (RACSignal *)uploadWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema class:(Class)cls;

//- (NSDictionary *)commonHeaders;
//- (NSDictionary *)commonQueries;

@end






