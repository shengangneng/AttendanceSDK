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
@property (nonatomic, copy) NSString *attendanceId;          /** 考勤2.0，这个参数已经废弃 */
@property (nonatomic, copy) NSString *brushDate;             /** 查找第一个为空的，并且没有漏卡状态的，就显示为’等待打卡中~~‘，如果不为空的话说明是有数据的 */
@property (nonatomic, copy) NSString *brushTime;
@property (nonatomic, copy) NSString *startDateTime;         /** 允许开始打卡时间日期时间 */
@property (nonatomic, copy) NSString *endDateTime;           /** 截止打卡日期时间 */
@property (nonatomic, copy) NSString *exceptionSignTime;     /** 例外打卡时间 */
@property (nonatomic, copy) NSString *statusException;       /** 例外打卡状态：0改签、1补签、2请假、3出差、4加班、5外出 */
@property (nonatomic, copy) NSString *fillCardTime;          /** 打卡节点时间 */
@property (nonatomic, copy) NSString *signType;              /** 打卡类型：0上班 1下班 2加班 */
@property (nonatomic, copy) NSString *status;                /** 节点状态：0准时 1迟到 2早退 3漏卡 4早到 5下班 6加班 7审核中 */
@property (nonatomic, copy) NSString *type;                  /** 0上班 1下班 */
@property (nonatomic, copy) NSString *integral;              /** 加减分 */
@property (nonatomic, assign) BOOL isNeedFirstBrush;         /** 自定义字段，是否是下一段需要打卡 */
@property (nonatomic, copy) NSString *fillCardDate;
@property (nonatomic, copy) NSString *early;                 /** 是否早退，二次判断。默认false，true才可以早退打卡 */
@property (nonatomic, copy) NSString *schedulingEmployeeId;  /** 班次Id，有的话可以打 */
@property (nonatomic, copy) NSString *schedulingEmployeeType;/** 0固定排班 1自由排班 2高级排班 3自由打卡 */

@end
