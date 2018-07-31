//
//  NSDate+MPMExtention.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MPMExtention)

/** 格式化日期，保持与前端一直（Java后台接口的日期与我们的日期相差8小时，需要格式化一下 */
+ (NSDate *)changeToFitJavaDate:(NSDate *)date;

@end
