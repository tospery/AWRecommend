//
//  NSDate+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSDate+JXObjc.h"

#define kJXDateWeekdayStyle1Val1            (@"周日")
#define kJXDateWeekdayStyle1Val2            (@"周一")
#define kJXDateWeekdayStyle1Val3            (@"周二")
#define kJXDateWeekdayStyle1Val4            (@"周三")
#define kJXDateWeekdayStyle1Val5            (@"周四")
#define kJXDateWeekdayStyle1Val6            (@"周五")
#define kJXDateWeekdayStyle1Val7            (@"周六")

@implementation NSDate (JXObjc)
//- (NSString *)descriptionWithLocale:(id)locale {
//    return [self jx_stringWithFormat:kJXFormatDatetimeStyle3];
//}

- (NSInteger)jx_year {
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:self];
        return (NSInteger)[components year];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
        return (NSInteger)[components year];
#pragma clang diagnostic pop
    }
}


- (NSInteger)jx_month {
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitMonth fromDate:self];
        return (NSInteger)[components month];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:self];
        return (NSInteger)[components month];
#pragma clang diagnostic pop
    }
}

- (NSInteger)jx_day {
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitDay fromDate:self];
        return (NSInteger)[components day];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:self];
        return (NSInteger)[components day];
#pragma clang diagnostic pop
    }
}

- (NSString *)jx_stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    // [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}


+ (NSDate *)jx_dateFromString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}

// 备份

- (NSString *)exWeekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday)
                                               fromDate:self];
    
    NSString *result;
    switch (components.weekday) {
        case 1:
            result = kJXDateWeekdayStyle1Val1;
            break;
        case 2:
            result = kJXDateWeekdayStyle1Val2;
            break;
        case 3:
            result = kJXDateWeekdayStyle1Val3;
            break;
        case 4:
            result = kJXDateWeekdayStyle1Val4;
            break;
        case 5:
            result = kJXDateWeekdayStyle1Val5;
            break;
        case 6:
            result = kJXDateWeekdayStyle1Val6;
            break;
        case 7:
            result = kJXDateWeekdayStyle1Val7;
            break;
        default:
            result = nil;
            break;
    }
    return result;
}


+ (NSArray *)exDatesFromDate:(NSDate *)date ToDay:(NSInteger)day {
    if (!date || day < 0) {
        return nil;
    }
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:day];
    [results addObject:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    for (int i = 1; i < 7; ++i) {
        [components setHour:24 * i];
        [components setMinute:0];
        [components setSecond:0];
        NSDate *cur = [calendar dateByAddingComponents:components toDate:date options:0];
        [results addObject:cur];
    }
    
    return results;
}

- (NSString *)exGMTString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss ‘GMT‘"];
    return [dateFormatter stringFromDate:self];
}


- (NSString *)exTimestampString {
    return [NSString stringWithFormat:@"%lld", (long long)([self timeIntervalSince1970] * 1000)];
}

- (NSDictionary *)exIntervalWithFormat:(NSString *)format {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond )
                                               fromDate:self];
    
    // 今天
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [calendar dateByAddingComponents:components toDate:self options:0];
    
    // 昨天
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [calendar dateByAddingComponents:components toDate: today options:0];
    
    // 明天
    [components setHour:24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *tomorrow = [calendar dateByAddingComponents:components toDate: today options:0];
    
    // 上周的今天
    components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                             fromDate:self];
    [components setDay:(components.day - 7)];
    NSDate *todayOfLastWeek  = [calendar dateFromComponents:components];
    
    // 下周的今天
    [components setDay:(components.day + 7 * 2)];
    NSDate *todayOfNextWeek  = [calendar dateFromComponents:components];
    
    // 本周第一天
    [components setDay:(components.day - 7 - (components.weekday - 1))];
    NSDate *firstDayOfThisWeek  = [calendar dateFromComponents:components];
    
    // 本周最后一天
    [components setDay:(components.day + 6)];
    NSDate *finalDayOfThisWeek  = [calendar dateFromComponents:components];
    
    // 上周第一天
    [components setDay:(components.day - 7 * 2 + 1)];
    NSDate *firstDayOfLastWeek  = [calendar dateFromComponents:components];
    
    // 上周最后一天
    [components setDay:(components.day + 6)];
    NSDate *finalDayOfLastWeek  = [calendar dateFromComponents:components];
    
    // 下周第一天
    [components setDay:(components.day + 7 + 1)];
    NSDate *firstDayOfNextWeek  = [calendar dateFromComponents:components];
    
    // 下周最后一天
    [components setDay:(components.day + 6)];
    NSDate *finalDayOfNextWeek  = [calendar dateFromComponents:components];
    
    // 上月的今天
    components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                             fromDate:self];
    [components setMonth:(components.month - 1)];
    NSDate *todayOfLastMonth  = [calendar dateFromComponents:components];
    
    // 下月的今天
    [components setMonth:(components.month + 1 * 2)];
    NSDate *todayOfNextMonth  = [calendar dateFromComponents:components];
    
    // 本月第一天
    [components setMonth:(components.month - 1)];
    [components setDay:1];
    NSDate *firstDayOfThisMonth  = [calendar dateFromComponents:components];
    
    // 本月最后一天
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayOfThisMonth];
    components.day = range.length;
    NSDate *finalDayOfThisMonth  = [calendar dateFromComponents:components];
    
    // 上月第一天
    components.month = components.month - 1;
    components.day = 1;
    NSDate *firstDayOfLastMonth  = [calendar dateFromComponents:components];
    
    // 上月最后一天
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayOfLastMonth];
    components.day = range.length;
    NSDate *finalDayOfLastMonth  = [calendar dateFromComponents:components];
    
    // 下月第一天
    components.month = components.month + 1 * 2;
    components.day = 1;
    NSDate *firstDayOfNextMonth  = [calendar dateFromComponents:components];
    
    // 下月最后一天
    range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayOfNextMonth];
    components.day = range.length;
    NSDate *finalDayOfNextMonth  = [calendar dateFromComponents:components];
    
    NSDictionary *result = @{kJXDateToday: [today jx_stringWithFormat:format],
                             kJXDateYesterday: [yesterday jx_stringWithFormat:format],
                             kJXDateTomorrow: [tomorrow jx_stringWithFormat:format],
                             kJXDateTodayOfLastWeek: [todayOfLastWeek jx_stringWithFormat:format],
                             kJXDateTodayOfNextWeek: [todayOfNextWeek jx_stringWithFormat:format],
                             kJXDateFirstDayOfThisWeek: [firstDayOfThisWeek jx_stringWithFormat:format],
                             kJXDateFinalDayOfThisWeek: [finalDayOfThisWeek jx_stringWithFormat:format],
                             kJXDateFirstDayOfLastWeek: [firstDayOfLastWeek jx_stringWithFormat:format],
                             kJXDateFinalDayOfLastWeek: [finalDayOfLastWeek jx_stringWithFormat:format],
                             kJXDateFirstDayOfNextWeek: [firstDayOfNextWeek jx_stringWithFormat:format],
                             kJXDateFinalDayOfNextWeek: [finalDayOfNextWeek jx_stringWithFormat:format],
                             kJXDateTodayOfLastMonth: [todayOfLastMonth jx_stringWithFormat:format],
                             kJXDateTodayOfNextMonth: [todayOfNextMonth jx_stringWithFormat:format],
                             kJXDateFirstDayOfThisMonth: [firstDayOfThisMonth jx_stringWithFormat:format],
                             kJXDateFinalDayOfThisMonth: [finalDayOfThisMonth jx_stringWithFormat:format],
                             kJXDateFirstDayOfLastMonth: [firstDayOfLastMonth jx_stringWithFormat:format],
                             kJXDateFinalDayOfLastMonth: [finalDayOfLastMonth jx_stringWithFormat:format],
                             kJXDateFirstDayOfNextMonth: [firstDayOfNextMonth jx_stringWithFormat:format],
                             kJXDateFinalDayOfNextMonth: [finalDayOfNextMonth jx_stringWithFormat:format]};
    
    return result;
}

//// 日期转字符串
//- (NSString *)exStringWithFormat:(NSString *)format locale:(NSString *)locale {
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:self];
//    NSDate *adjustDate = [self dateByAddingTimeInterval:(interval * -1)];
//
//    return [[NSDateFormatter exInstanceWithFormat:format locale:locale] stringFromDate:adjustDate];
//}
//
//// 日期转字符串
//- (NSString *)exStringWithFormat:(NSString *)format {
//    return [[NSDateFormatter exInstanceWithFormat:format] stringFromDate:self];
//}

// 备注
//- (NSString *)exYear {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond )
//                                               fromDate:self];
//    return [NSString stringWithFormat:@"%ld", (long)components.year];
//}
//
//- (NSString *)exMonth {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond )
//                                               fromDate:self];
//    return [NSString stringWithFormat:@"%ld", (long)components.month];
//}
//
//- (NSString *)exDay {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond )
//                                               fromDate:self];
//    return [NSString stringWithFormat:@"%ld", (long)components.day];
//}
//
//// @"YYYY-MM-dd HH:mm:ss"
//- (NSString *)exYYYYMMdd {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond )
//                                               fromDate:self];
//    return [NSString stringWithFormat:@"%ld", (long)components.day];
//}

@end
