//
//  MPMSettingClassListModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
@class MPMSettingClassScheduleModel;

@interface MPMSettingClassListModel : MPMBaseModel

@property (nonatomic, copy) NSString *companyId;      
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *departments;
@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSString *isUsed;           /** 是否已被使用：0否 1是 */
@property (nonatomic, strong) MPMSettingClassScheduleModel *schedule;         /** 时间段 */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userNumber;
@property (nonatomic, copy) NSString *workSchedule;

@end

@interface MPMSettingClassScheduleModel : MPMBaseModel

@property (nonatomic, copy) NSDictionary *freeTimeSection;  /** end、start */
@property (nonatomic, copy) NSString *hour;                 /** 时长 */
@property (nonatomic, copy) NSString *name;                 /** 班次名称 */
@property (nonatomic, copy) NSArray *signTimeSections;      /** 班次打卡时间 */


@end




