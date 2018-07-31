//
//  NSDate+MPMExtention.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "NSDate+MPMExtention.h"

@implementation NSDate (MPMExtention)

+ (NSDate *)changeToFitJavaDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    return [cal dateFromComponents:comp];
}

@end
