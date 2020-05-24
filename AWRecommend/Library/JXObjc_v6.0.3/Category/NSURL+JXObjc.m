//
//  NSURL+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSURL+JXObjc.h"

@implementation NSURL (JXObjc)
+ (instancetype)jx_URLWithString:(NSString *)URLString {
    NSString *link = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:link];
}

+ (NSURL *)jx_URLWithBase:(NSString *)base path:(NSString *)path {
    if (0 == base.length) {
        return nil;
    }
    
    if (0 == path.length) {
        return [NSURL jx_URLWithString:base];
    }
    
    if (![base hasSuffix:@"/"]) {
        base = JXStrWithFmt(@"%@/", base);
    }
    
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    
    NSURL *baseURL = [NSURL jx_URLWithString:base];
    NSString *pathString = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:pathString relativeToURL:baseURL];

    
//    if (0 == base.length) {
//        return nil;
//    }
//    
//    if (0 == path.length) {
//        return [NSURL URLWithString:base];
//    }
//    
//    NSURL *baseURL = [NSURL URLWithString:base];
//    if (baseURL.path.length > 0 && ![baseURL.absoluteString hasSuffix:@"/"]) {
//        baseURL = [baseURL URLByAppendingPathComponent:@""];
//    }
//    
//    return [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:baseURL];
}

@end
