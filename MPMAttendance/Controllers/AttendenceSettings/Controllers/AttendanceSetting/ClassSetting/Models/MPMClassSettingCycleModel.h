//
//  MPMClassSettingCycleModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMClassSettingCycleModel : MPMBaseModel

@property (nonatomic, copy) NSString *classSettingId;
@property (nonatomic, copy) NSString *classSettingName;
@property (nonatomic, copy) NSString *classSettingType; /** 排班方式? */
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *cycle;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *resetTime;        /** 每天开始打卡时间 */
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *valid;
@property (nonatomic, copy) NSString *automaticPunchCard;/** 启动下班无需打卡：0不开启 1开启 */

@property (nonatomic, copy) NSString *cnCycle;          /** 自定义字段，记录考勤周期 */
@property (nonatomic, copy) NSString *duration;         /** 自定义字段，记录考勤时长 */

/** 把“2，3，4，5，6等转为中文考勤周期 */
- (void)translateCycle;

@end
