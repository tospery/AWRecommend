//
//  JXHTTPSchema.h
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXHTTPSchema : NSObject
@property (nonatomic, assign) JXHTTPRequestMethodType methodType;        // 请求方法
@property (nonatomic, assign) JXHTTPRequestParamType paramType;      // 请求数据的类型
@property (nonatomic, assign) JXHTTPResponseDataType dataType;    // 响应数据的类型

+ (instancetype)schemaGet;  // Query -> JSON
+ (instancetype)schemaPost; // FormURLEncoded -> JSON

+ (instancetype)schemaGetJSON;
+ (instancetype)schemaPostFormURLEncoded2JSON;
+ (instancetype)schemaPostRawJSON2JSON;
+ (instancetype)schemaPostFormData2JSON;

@end
