//
//  MPMSettingTimeModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMSettingTimeModel : MPMBaseModel

//@property (nonatomic, copy) NSString *crossDay;/** 是否跨天：0或者nil为否 1为跨天 */
//@property (nonatomic, copy) NSString *noonBreak;/** 是否间休：0是 1否 */
//@property (nonatomic, copy) NSString *noonBreakEndTime;
//@property (nonatomic, copy) NSString *noonBreakStartTime;

@property (nonatomic, copy) NSString *corssReturnDay;   /** 签退是否跨天：0否 1是 */
@property (nonatomic, copy) NSString *corssStartDay;    /** 签到是否跨天：0否 1是 */

@property (nonatomic, copy) NSString *signTime;         /** 签到时间 */
@property (nonatomic, copy) NSString *returnTime;       /** 签退时间 */
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, copy) NSString *signTimeAfter;
@property (nonatomic, copy) NSString *signTimeBefore;
@property (nonatomic, copy) NSString *timeSlotId;
@property (nonatomic, copy) NSString *valid;
/** 00:00 ~ 23:59 */
@property (nonatomic, copy) NSString *signTimeString;
@property (nonatomic, copy) NSString *returnTimeString;
@property (nonatomic, copy) NSString *noonBreakStartTimeString;
@property (nonatomic, copy) NSString *noonBreakEndTimeString;

@end
