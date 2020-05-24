//
//  NSDate+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kJXDateLengthWhenNoTime         (10)

#define kJXDateToday                    (@"JXDateToday")                // 今天
#define kJXDateYesterday                (@"JXDateYesterday")            // 昨日
#define kJXDateTomorrow                 (@"JXDateTomorrow")             // 明天

#define kJXDateTodayOfLastWeek          (@"JXDateTodayOfLastWeek")
#define kJXDateTodayOfNextWeek          (@"JXDateTodayOfNextWeek")
#define kJXDateFirstDayOfThisWeek       (@"JXDateFirstDayOfThisWeek")
#define kJXDateFinalDayOfThisWeek       (@"JXDateFinalDayOfThisWeek")
#define kJXDateFirstDayOfLastWeek       (@"JXDateFirstDayOfLastWeek")
#define kJXDateFinalDayOfLastWeek       (@"JXDateFinalDayOfLastWeek")
#define kJXDateFirstDayOfNextWeek       (@"JXDateFirstDayOfNextWeek")
#define kJXDateFinalDayOfNextWeek       (@"JXDateFinalDayOfNextWeek")

#define kJXDateTodayOfLastMonth         (@"JXDateTodayOfLastMonth")
#define kJXDateTodayOfNextMonth         (@"JXDateTodayOfNextMonth")
#define kJXDateFirstDayOfThisMonth      (@"JXDateFirstDayOfThisMonth")
#define kJXDateFinalDayOfThisMonth      (@"JXDateFinalDayOfThisMonth")
#define kJXDateFirstDayOfLastMonth      (@"JXDateFirstDayOfLastMonth")
#define kJXDateFinalDayOfLastMonth      (@"JXDateFinalDayOfLastMonth")
#define kJXDateFirstDayOfNextMonth      (@"JXDateFirstDayOfNextMonth")
#define kJXDateFinalDayOfNextMonth      (@"JXDateFinalDayOfNextMonth")

@interface NSDate (JXObjc)
- (NSInteger)jx_year;
- (NSInteger)jx_month;
- (NSInteger)jx_day;
- (NSString *)jx_stringWithFormat:(NSString *)format;
+ (NSDate *)jx_dateFromString:(NSString *)string format:(NSString *)format;

// 备份
#pragma mark - Public methods

/**
 *  获取第几周
 *
 *  @return 周
 */
- (NSString *)exWeekday;

/**
 *  GMT时区的日期字符串
 *
 *  @return 日期字符串
 */
- (NSString *)exGMTString;

/**
 *  时间戳字符串（毫秒）
 *
 *  @return 时间戳字符串
 */
- (NSString *)exTimestampString;

/**
 *  间隔的日期字典
 *
 *  @param format 日期格式
 *
 *  @return 日期字典
 */
- (NSDictionary *)exIntervalWithFormat:(NSString *)format;

#pragma mark - Class methods
/**
 *  日期区间的数组
 *
 *  @param date 起始日期
 *  @param day  结束日期
 *
 *  @return 日期区间的数组
 */
+ (NSArray *)exDatesFromDate:(NSDate *)date ToDay:(NSInteger)day;
@end
