//
//  NSString+MPMAttention.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "NSString+MPMAttention.h"
#import "NSDateFormatter+MPMExtention.h"

@implementation NSString (MPMAttention)

- (double)timeValue {
    NSArray *hour_minute = [self componentsSeparatedByString:@":"];
    double hour = ((NSString *)hour_minute.firstObject).doubleValue;
    double minute = ((NSString *)hour_minute.lastObject).doubleValue;
    return hour * 60 + minute;
}

- (NSString *)hourMinuteToString {
    return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
}

@end
