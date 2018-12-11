//
//  MPMCausationDetailModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
#import "MPMCausationTypeData.h"

@interface MPMCausationDetailModel : MPMBaseModel

@property (nonatomic, copy) NSString *causationType;    /** 记录类型 */
// 通用属性
@property (nonatomic, copy) NSString *startTime;        /** 开始时间 */
@property (nonatomic, copy) NSString *endTime;          /** 结束时间 */
@property (nonatomic, copy) NSString *hourAccount;      /** 时长（小时） */
@property (nonatomic, copy) NSString *info;             /** 时长天数 */
// 出差
@property (nonatomic, copy) NSString *expectCost;       /** 出差预计费用 */
@property (nonatomic, copy) NSString *address;          /** 出差地址 */
@property (nonatomic, copy) NSString *isShareRoom;      /** 出差住宿是否共享 */
@property (nonatomic, copy) NSString *traffic;          /** 出差交通工具 */
// 请假
@property (nonatomic, copy) NSString *type;             /** 请假类型 */
// 补卡、改卡
@property (nonatomic, copy) NSString *detailId;         /** 排班id，有则为修改，无则为新增 */
@property (nonatomic, copy) NSString *fillupTime;       /** 漏卡时间 */
@property (nonatomic, copy) NSString *signTime;         /** 补卡时间、改卡的实际打卡时间 */
@property (nonatomic, copy) NSString *mpm_id;           /** 漏卡处理id */
// 改卡
@property (nonatomic, copy) NSString *attendanceTime;   /** 考勤时间 */
@property (nonatomic, copy) NSString *reviseSignTime;   /** 改卡时间 */
@property (nonatomic, copy) NSString *status;           /** 改卡，之前的迟到早退等状态 */

@property (nonatomic, assign) BOOL trafficNeedFold;     /** "交通工具"控件是否需要折叠：YES需要 NO不需要 */
@property (nonatomic, assign) BOOL calculatingTime;     /** 记录是否正在计算时间，如果正在计算时间，不能增加和删除cell */

- (void)clearData;
- (void)copyWithOtherModel:(MPMCausationDetailModel *)model;

@end
