//
//  NSDictionary+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSDictionary+JXObjc.h"

@implementation NSDictionary (JXObjc)
- (NSString *)descriptionWithLocale:(id)locale {
//    NSMutableString *string = [NSMutableString string];
//    
//    // 开头有个{
//    [string appendString:@"{"];
//    
//    // 遍历所有的键值对
//    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [string appendFormat:@"%@:%@,", key, obj];
//    }];
//    
//    // 结尾有个}
//    [string appendString:@"}"];
//    
//    // 查找最后一个逗号
//    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
//    if (range.location != NSNotFound)
//        [string deleteCharactersInRange:range];
//    
//    return string;

    
    NSMutableString *string = [NSMutableString string];
    
    // 开头有个{
    [string appendString:@"{\n"];
    
    // 遍历所有的键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"\t\t%@: %@,\n", key, obj];
    }];
    
    // 结尾有个}
    [string appendString:@"\t}"];
    
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
    
//    return [self mj_JSONString];
}

- (NSDictionary *)jx_ignoreEmptyObject {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSNull class]]) {
            continue;
        }else if([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)obj;
            if (num.integerValue == 0 ||
                num.floatValue == 0) {
                continue;
            }else {
                [result setObject:obj forKey:key];
            }
        }else if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)obj;
            if (str.length == 0) {
                continue;
            }else {
                [result setObject:obj forKey:key];
            }
        }else {
            [result setObject:obj forKey:key];
        }
    }
    return result;
}

// 备份
+ (instancetype)exInitWithExpressions:(NSString *)expressions {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *findString = expressions;
    NSRange range;
    while (YES) {
        range = [findString rangeOfString:@"<"];
        if (NSNotFound == range.location) {
            break;
        }
        NSString *key = [findString substringToIndex:range.location];
        findString = [findString substringFromIndex:(range.location + 1)];
        
        range = [findString rangeOfString:@">"];
        if (NSNotFound == range.location) {
            break;
        }
        NSString *value = [findString substringToIndex:range.location];
        findString = [findString substringFromIndex:(range.location + 1)];
        
        [result setObject:value forKey:key];
    }
    
    return result;
}

@end
