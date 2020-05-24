//
//  JXHTTPSchema.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXHTTPSchema.h"

@interface JXHTTPSchema ()
//@property (nonatomic, assign, readwrite) JXHTTPRequestMethodType requestMethodType;        // 请求方法
//@property (nonatomic, assign, readwrite) JXHTTPRequestContentType requestContentType;      // 请求数据的类型
//@property (nonatomic, assign, readwrite) JXHTTPResponseContentType responseContentType;    // 响应数据的类型

@end

@implementation JXHTTPSchema
+ (instancetype)schemaGet {
    JXHTTPSchema *schema = [[JXHTTPSchema alloc] init];
    schema.methodType = JXHTTPRequestMethodTypeGet;
    schema.paramType = JXHTTPRequestParamTypeQuery;
    schema.dataType = JXHTTPResponseDataTypeJSON;
    return schema;
}

+ (instancetype)schemaPost {
    JXHTTPSchema *schema = [[JXHTTPSchema alloc] init];
    schema.methodType = JXHTTPRequestMethodTypePost;
    schema.paramType = JXHTTPRequestParamTypeFormURLEncoded;
    schema.dataType = JXHTTPResponseDataTypeJSON;
    return schema;
}

+ (instancetype)schemaGetJSON {
    JXHTTPSchema *schema = [[JXHTTPSchema alloc] init];
    schema.methodType = JXHTTPRequestMethodTypeGet;
    schema.paramType = JXHTTPRequestParamTypeQuery;
    schema.dataType = JXHTTPResponseDataTypeJSON;
    return schema;
}

+ (instancetype)schemaPostFormURLEncoded2JSON {
    JXHTTPSchema *schema = [[JXHTTPSchema alloc] init];
    schema.methodType = JXHTTPRequestMethodTypePost;
    schema.paramType = JXHTTPRequestParamTypeFormURLEncoded;
    schema.dataType = JXHTTPResponseDataTypeJSON;
    return schema;
}

+ (instancetype)schemaPostRawJSON2JSON {
    JXHTTPSchema *schema = [[JXHTTPSchema alloc] init];
    schema.methodType = JXHTTPRequestMethodTypePost;
    schema.paramType = JXHTTPRequestParamTypeRawJSON;
    schema.dataType = JXHTTPResponseDataTypeJSON;
    return schema;
}

+ (instancetype)schemaPostFormData2JSON {
    JXHTTPSchema *schema = [[JXHTTPSchema alloc] init];
    schema.methodType = JXHTTPRequestMethodTypePost;
    schema.paramType = JXHTTPRequestParamTypeFormData;
    schema.dataType = JXHTTPResponseDataTypeJSON;
    return schema;
}


@end
