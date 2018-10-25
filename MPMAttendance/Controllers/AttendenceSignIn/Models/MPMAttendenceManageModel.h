//
//  MPMAttendenceManageModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
@class MPMAttendenceModel;
@class MPMSettingCardAddressWifiModel;
@class MPMAttendenceOneMonthModel;
@class MPMAttendenceExceptionModel;

#define kFreeSignMaxCount 20

@interface MPMAttendenceManageModel : MPMBaseModel

@property (nonatomic, strong) NSDate *currentMiddleDate;        /** 记录当前打卡页面选中的日期 */
@property (nonatomic, copy) NSString *schedulingEmployeeType;   /** 0固定排班 1自由排班 2高级排班 3自由打卡(最多只能打20次) */
@property (nonatomic, copy) NSArray<MPMAttendenceModel *> *attendenceArray;                     /** 当前的打卡信息 */
@property (nonatomic, copy) NSArray<MPMSettingCardAddressWifiModel *> *attendenceAddressArray;  /** 接口获取到的打卡位置信息 */
@property (nonatomic, copy) NSArray<MPMAttendenceOneMonthModel *> *attendenceThreeWeekArray;    /** 接口获取到的打卡三个星期的信息 */
@property (nonatomic, copy) NSArray<NSArray *> *attendenceExceptionArray;   /** 接口获取打卡节点例外申请信息 */

@end
