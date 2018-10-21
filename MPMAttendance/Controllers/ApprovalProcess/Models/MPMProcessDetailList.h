//
//  MPMProcessDetailList.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/17.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
@class MPMDetailDtoList;

@interface MPMProcessDetailList : MPMBaseModel

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSArray<MPMDetailDtoList *> *detailDtoList;
@property (nonatomic, copy) NSString *reason;           /** 申请原因 */
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *totalDay;
@property (nonatomic, copy) NSString *totalHour;
@property (nonatomic, copy) NSString *totalScore;
@property (nonatomic, copy) NSString *totalExpectCost;
@property (nonatomic, copy) NSString *type;             /** 补签、改签、请假、出差、加班、外出 */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

@end


@interface MPMDetailDtoList : MPMBaseModel

@property (nonatomic, copy) NSString *aScore;
@property (nonatomic, copy) NSString *bScore;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *dayAccount;
@property (nonatomic, copy) NSString *hourAccount;
@property (nonatomic, copy) NSString *type;         /** 请假类型 */
@property (nonatomic, copy) NSString *address;      /** 地址 */
@property (nonatomic, copy) NSString *expectCost;   /** 费用 */
@property (nonatomic, copy) NSString *traffic;      /** 交通工具 */
@property (nonatomic, copy) NSString *redress;      /** 1无 2调休 3加班费 */
// 补签
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *detailId;
@property (nonatomic, copy) NSString *fillupTime;   /** 漏卡时间 */
@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *signTime;     /** 打卡时间、漏签 */
// 改签
@property (nonatomic, copy) NSString *attendanceTime;   /** 考勤时间 */
@property (nonatomic, copy) NSString *reviseSignTime;   /** 改签 */

@end
