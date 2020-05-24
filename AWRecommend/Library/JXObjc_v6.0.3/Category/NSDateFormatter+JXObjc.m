//
//  NSDateFormatter+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSDateFormatter+JXObjc.h"

@implementation NSDateFormatter (JXObjc)
// 实例化特定的格式化器
+ (NSDateFormatter *)exDateFormatterWithFormat:(NSString *)format locale:(NSString *)locale {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
    return dateFormatter;
}

// 实例化特定的格式化器
+ (NSDateFormatter *)exDateFormatterWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return dateFormatter;
}

@end
