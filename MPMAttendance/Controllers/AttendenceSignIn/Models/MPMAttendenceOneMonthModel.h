//
//  MPMAttendenceOneMonthModel.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMAttendenceOneMonthModel : MPMBaseModel

@property (nonatomic, copy) NSString *day;      /** 2018-05-10 */
@property (nonatomic, copy) NSString *isWorkDay;/** @"0休"、@"1班"、@"2自由打卡"、@"3漏卡有感叹号班" */
@property (nonatomic, copy) NSString *status;   /** @"正常"、@"异常"、@"" */
@property (nonatomic, copy) NSString *week;     /** @"星期天一二三四五六" */

@property (nonatomic, assign, getter=isRealCurrentDate) BOOL realCurrentDate;  /** 自定义参数，判断是否是今天 */

@end
