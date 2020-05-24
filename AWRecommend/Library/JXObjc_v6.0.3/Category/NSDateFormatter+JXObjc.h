//
//  NSDateFormatter+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (JXObjc)
/**
 *  实例化特定的格式化器
 *
 *  @param format 格式化符
 *  @param locale 时区
 *
 *  @return 格式化器
 */
+ (NSDateFormatter *)exDateFormatterWithFormat:(NSString *)format locale:(NSString *)locale;

/**
 *  实例化格式化器
 *
 *  @param format 格式化符
 *
 *  @return 格式化器
 */
+ (NSDateFormatter *)exDateFormatterWithFormat:(NSString *)format;

@end
