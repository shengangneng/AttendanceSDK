//
//  MPMAttendenceSettingModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMAttendenceSettingModel : MPMBaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cardSettingId;
@property (nonatomic, copy) NSString *classSettingId;
@property (nonatomic, copy) NSString *classSettingName;
@property (nonatomic, copy) NSString *cycle;                /** 考勤日期 */
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *endDate;              /** 有效日期 */
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *isAll;
@property (nonatomic, copy) NSArray *schedulingDepartments; /** 部门数组 */
@property (nonatomic, copy) NSArray *schedulingEmplyoees;   /** 人员数组 */
@property (nonatomic, copy) NSString *schedulingId;         /** 排班id*/
@property (nonatomic, copy) NSString *schedulingName;       /** 排班名称 */
@property (nonatomic, copy) NSArray *slotTimeDtos;          /** 班次 */
@property (nonatomic, copy) NSString *startDate;            /** 有效日期 */
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *timeSlotId;
@property (nonatomic, copy) NSString *wifiName;
@property (nonatomic, copy) NSString *cnCycle;              /** 中文考勤日期 */

/** 把2,3,4,5,6等转为周一、周二、周三等 */
- (void)translateCycle;

@end
