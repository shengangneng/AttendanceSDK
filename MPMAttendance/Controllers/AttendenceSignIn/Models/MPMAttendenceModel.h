//
//  MPMAttendenceModel.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMAttendenceModel : MPMBaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *attendanceId; /** 查找第一个为空的，就显示为’等待打卡中~~‘，如果不为空的话说明是有数据的 */
@property (nonatomic, copy) NSString *brushDate;
@property (nonatomic, copy) NSString *brushTime;
@property (nonatomic, copy) NSString *fillCardTime;
@property (nonatomic, copy) NSString *signType;
@property (nonatomic, copy) NSString *status;       /** 0正常 1迟到 2早退 3漏卡 4早到 5正常 6加班 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *integral;     /** 加减分 */
@property (nonatomic, assign) BOOL isNeedFirstBrush;/** 自定义字段，是否是下一段需要打卡 */
@property (nonatomic, copy) NSString *classType;    /** 上班、下班 */

@property (nonatomic, copy) NSString *fillCardDate;
@property (nonatomic, copy) NSString *early;                    /** 是否早退，二次判断。默认false，true才可以早退打卡 */
@property (nonatomic, copy) NSString *schedulingEmployeeId;     /** 班次Id，有的话可以打 */
@property (nonatomic, copy) NSString *schedulingEmployeeType;   /** 0固定排班 1自由排班 2自由打卡 */

@end
