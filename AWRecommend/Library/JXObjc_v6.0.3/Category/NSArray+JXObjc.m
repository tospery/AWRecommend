//
//  NSArray+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSArray+JXObjc.h"

@implementation NSArray (JXObjc)
- (NSString *)descriptionWithLocale:(id)locale {
//    NSMutableString *string = [NSMutableString string];
//    
//    // 开头有个[
//    [string appendString:@"["];
//    
//    // 遍历所有的元素
//    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [string appendFormat:@"%@,", obj];
//    }];
//    
//    // 结尾有个]
//    [string appendString:@"]"];
//    
//    // 查找最后一个逗号
//    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
//    if (range.location != NSNotFound)
//        [string deleteCharactersInRange:range];
//    
//    return string;

    
    NSMutableString *string = [NSMutableString string];
    
    // 开头有个[
    [string appendString:@"[\n"];
    
    // 遍历所有的元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    
    // 结尾有个]
    [string appendString:@"\t]"];
    
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
    
//    return [self mj_JSONString];
}

- (NSString *)exStringValue {
    NSMutableString *result = [NSMutableString string];
    for (id value in self) {
        if ([value isKindOfClass:[NSString class]]) {
            [result appendString:value];
        }else if ([value isKindOfClass:[NSValue class]]) {
            [result appendString:[value stringValue]];
        }else {
            [result appendString:[value description]];
        }
    }
    return result;
}

- (BOOL)exContainsValue:(id)value {
    for (id obj in self) {
        if (obj == value) {
            return YES;
        }
    }
    return NO;
}

@end




