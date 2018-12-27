//
//  NSDateFormatter+MPMExtention.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MPMDateFormatType) {
    forDateFormatTypeAll,                       /** 2018-05-10 21:33:03(yyyy-MM-dd HH:mm:ss) */
    forDateFormatTypeAllWithoutSeconds,         /** 2018-05-10 21:33(yyyy-MM-dd HH:mm) */
    forDateFormatTypeYearMonthDaySlash,         /** 2018/05/04(yyyy/MM/dd) */
    forDateFormatTypeYearMonthDayDom,           /** 2018.05.04(yyyy.MM.dd) */
    forDateFormatTypeYearMonthDayHourMinite,    /** 05月04日21:38(MM月dd日HH:mm) */
    forDateFormatTypeShortYearMonthDaySlash,    /** 18/05/04(yy/MM/dd) */
    forDateFormatTypeYearMonthDayBar,           /** 2018-05-04(yyyy-MM-dd) */
    forDateFormatTypeYearMonthBar,              /** 2018-05(yyyy-MM-dd) */
    forDateFormatTypeShortYearMonthDayBar,      /** 18-05-04(yy-MM-dd) */
    forDateFormatTypeYearMonthDomDay,           /** 2018年05月,10(yyyy年MM月,dd) */
    forDateFormatTypeYearMonth,                 /** 2018年05月(yyyy年MM月) */
    forDateFormatTypeHourMinute,                /** 21:38(HH:mm) */
    forDateFormatTypeHourMinuteSeconds,         /** 21:38:55(HH:mm:ss) */
    forDateFormatTypeMonthYearDayWeek,          /** 4月,2018年,25,周五(MM月,yyyy年,d,EEE) */
    forDateFormatTypeMonthYearDayWeek2,         /** 2018-05-04 星期五(yyyy-MM-dd EEE) */
    forDateFormatTypeSpecial,                   /** 2018-05-10T21:33:03.000Z(yyyy-MM-ddTHH:mm:ss.000Z) */
};


@interface NSDateFormatter (MPMExtention)

/** 快速格式化日期，使用已经写好的格式 */
+ (NSString *)formatterDate:(NSDate *)date withDefineFormatterType:(MPMDateFormatType)type;
/** 快速格式化日期，使用已经写好的格式 */
- (NSString *)formatterDate:(NSDate *)date withDefineFormatterType:(MPMDateFormatType)type;
/** 快速格式化日期，自定义格式 */
- (NSString *)formatterDate:(NSDate *)date withCustomFormatterType:(NSString *)type;

/** 获取当前日期0点的时间戳 */
+ (double)getZeroWithTimeInterverl:(NSTimeInterval)timeInterval;
/** 通过Java后台返回的时分秒组装成年月日时分秒 */
+ (NSDate *)getDateFromJaveTime:(NSTimeInterval)inter;

/** 比较两个日期是否为同一天 */
+ (BOOL)isDate1:(NSDate *)date1 equalToDate2:(NSDate *)date2;

@end
