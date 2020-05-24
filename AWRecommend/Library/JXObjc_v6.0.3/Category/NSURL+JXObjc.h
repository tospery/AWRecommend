//
//  NSURL+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JXObjc)
/**
 *  基于主机网址和服务路径构建一个URL
 *
 *  @param base 主机网址
 *  @param path 服务路径
 *
 *  @return 访问地址URL
 */
+ (NSURL *)jx_URLWithBase:(NSString *)base path:(NSString *)path;

+ (instancetype)jx_URLWithString:(NSString *)URLString;

@end
