//
//  NSDateFormatter+MPMExtention.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "NSDateFormatter+MPMExtention.h"
#import "NSString+MPMAttention.h"
#import "MPMAttendanceHeader.h"

@implementation NSDateFormatter (MPMExtention)

/** 快速格式化日期，使用已经写好的格式 */
+ (NSString *)formatterDate:(NSDate *)date withDefineFormatterType:(MPMDateFormatType)type {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatterType = nil;
    switch (type) {
        case forDateFormatTypeAll:                   { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
        case forDateFormatTypeAllWithoutSeconds:     { formatterType = @"yyyy-MM-dd HH:mm"; }break;
        case forDateFormatTypeYearMonthDaySlash:     { formatterType = @"yyyy/MM/dd"; }break;
        case forDateFormatTypeYearMonthDayHourMinite:{ formatterType = @"MM月dd日HH:mm"; }break;
        case forDateFormatTypeShortYearMonthDaySlash:{ formatterType = @"yy/MM/dd"; }break;
        case forDateFormatTypeYearMonthDayBar:       { formatterType = @"yyyy-MM-dd"; }break;
        case forDateFormatTypeYearMonthBar:          { formatterType = @"yyyy-MM"; }break;
        case forDateFormatTypeShortYearMonthDayBar:  { formatterType = @"yy-MM-dd"; }break;
        case forDateFormatTypeYearMonthDomDay:       { formatterType = @"yyyy年MM月,dd"; }break;
        case forDateFormatTypeYearMonth:             { formatterType = @"yyyy年MM月"; }break;
        case forDateFormatTypeHourMinute:            { formatterType = @"HH:mm"; }break;
        case forDateFormatTypeHourMinuteSeconds:     { formatterType = @"HH:mm:ss"; }break;
        case forDateFormatTypeMonthYearDayWeek:      { formatterType = @"M月,yyyy年,d,EEE"; }break;
        case forDateFormatTypeMonthYearDayWeek2:     { formatterType = @"yyyy-MM-dd EEE"; }break;
        case forDateFormatTypeSpecial:               { formatterType = @"yyyy-MM-dd'T'HH:mm:ss.000'Z'"; }break;
        default:                                     { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
    }
    [formatter setDateFormat:formatterType];
    return [formatter stringFromDate:date];
}

/** 快速格式化日期，使用已经写好的格式 */
- (NSString *)formatterDate:(NSDate *)date withDefineFormatterType:(MPMDateFormatType)type {
    NSString *formatterType = nil;
    switch (type) {
        case forDateFormatTypeAll:                   { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
        case forDateFormatTypeAllWithoutSeconds:     { formatterType = @"yyyy-MM-dd HH:mm"; }break;
        case forDateFormatTypeYearMonthDaySlash:     { formatterType = @"yyyy/MM/dd"; }break;
        case forDateFormatTypeShortYearMonthDaySlash:{ formatterType = @"yy/MM/dd"; }break;
        case forDateFormatTypeYearMonthDayHourMinite:{ formatterType = @"MM月dd日HH:mm"; }break;
        case forDateFormatTypeYearMonthDayBar:       { formatterType = @"yyyy-MM-dd"; }break;
        case forDateFormatTypeYearMonthBar:          { formatterType = @"yyyy-MM"; }break;
        case forDateFormatTypeShortYearMonthDayBar:  { formatterType = @"yy-MM-dd"; }break;
        case forDateFormatTypeYearMonthDomDay:       { formatterType = @"yyyy年MM月,dd"; }break;
        case forDateFormatTypeYearMonth:             { formatterType = @"yyyy年MM月"; }break;
        case forDateFormatTypeHourMinute:            { formatterType = @"HH:mm"; }break;
        case forDateFormatTypeHourMinuteSeconds:     { formatterType = @"HH:mm:ss"; }break;
        case forDateFormatTypeMonthYearDayWeek:      { formatterType = @"M月,yyyy年,d,EEE"; }break;
        case forDateFormatTypeMonthYearDayWeek2:     { formatterType = @"yyyy-MM-dd EEE"; }break;
        case forDateFormatTypeSpecial:               { formatterType = @"yyyy-MM-dd'T'HH:mm:ss.000'Z'"; }break;
        default:                                     { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
    }
    [self setDateFormat:formatterType];
    return [self stringFromDate:date];
}

/** 快速格式化日期，自定义格式 */
- (NSString *)formatterDate:(NSDate *)date withCustomFormatterType:(NSString *)type {
    if (kIsNilString(type)) return @"";
    [self setDateFormat:type];
    return [self stringFromDate:date];
}

/** 获取当前日期0点的时间戳 */
+ (double)getZeroWithTimeInterverl:(NSTimeInterval)timeInterval {
    NSDate *originalDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFomater = [[NSDateFormatter alloc]init];
    dateFomater.dateFormat = @"yyyy年MM月dd日";
    NSString *original = [dateFomater stringFromDate:originalDate];
    NSDate *ZeroDate = [dateFomater dateFromString:original];
    return [ZeroDate timeIntervalSince1970];
}

/** 通过Java后台返回的时分秒组装成年月日时分秒 */
+ (NSDate *)getDateFromJaveTime:(NSTimeInterval)inter {
    NSTimeInterval nowInter = [[NSDate date] timeIntervalSince1970];
    // 8小时时差
    double nowZero = [self getZeroWithTimeInterverl:nowInter] + 28800;
    NSTimeInterval realInterval = nowZero + inter / 1000;
    return [NSDate dateWithTimeIntervalSince1970:realInterval];
}

/** 比较date2是否在date1后 */
+ (BOOL)isDate1:(NSDate *)date1 equalToDate2:(NSDate *)date2 {
    if (!date1 || !date2) {
        return NO;
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"MM:dd";
    double dayString1 = [formater stringFromDate:date1].timeValue;
    double dayString2 = [formater stringFromDate:date2].timeValue;
    if (dayString1 == dayString2) {
        return YES;
    } else {
        return NO;
    }
}

@end
