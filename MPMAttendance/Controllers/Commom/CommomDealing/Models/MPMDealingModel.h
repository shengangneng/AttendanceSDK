//
//  MPMDealingModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMDealingModel : MPMBaseModel

@property (nonatomic, copy) NSString *mpm_copyName;     /** 抄送人 */
@property (nonatomic, copy) NSString *mpm_copyNameId;   /** 抄送人id */
@property (nonatomic, copy) NSString *approvalName;     /** 审批人 */
@property (nonatomic, copy) NSString *approvalId;       /** 审批人id */
@property (nonatomic, copy) NSString *nowApproval;      /** 审批人 */
@property (nonatomic, copy) NSString *nowApprovalId;    /** 审批人id */
@property (nonatomic, copy) NSString *status;           /** 打卡状态：0正常、1异常 */
@property (nonatomic, copy) NSString *type;             /** 考勤状态：0考勤、1会议 */
@property (nonatomic, copy) NSString *remark;           /** 备注、处理理由 */
@property (nonatomic, copy) NSDictionary *attendence;   /** 签到信息 */
@property (nonatomic, copy) NSString *address;          /** 签到地址 */
@property (nonatomic, copy) NSString *attendenceId;     /** 选中的补签处理类型id */
@property (nonatomic, copy) NSString *brushDate;        /** 签到日期 */
@property (nonatomic, copy) NSString *brushTime;        /** 签到时间 */
@property (nonatomic, copy) NSString *attendenceDate;   /** 处理签到时间-新 */
@property (nonatomic, copy) NSString *checkCode;        /** 校验码 */
@property (nonatomic, copy) NSString *createTime;       /** 创建时间 */
@property (nonatomic, copy) NSString *shiftName;        /** 班次：选择上下班 */
@property (nonatomic, copy) NSString *mpm_newClassName; /** 班次：新-早中晚班 */
@property (nonatomic, copy) NSString *originalClassName;/** 班次：原-早中晚班 */
@property (nonatomic, copy) NSString *signType;         /** 签到类型：0上班 1下班 */
@property (nonatomic, copy) NSString *source;           /** 来源：0安卓、1iOS、2pc、3考勤机 */
@property (nonatomic, copy) NSNumber *early;            /** 是否早到：0否、1是 */
@property (nonatomic, strong) NSMutableArray *causationDetail;  /** address、causationId、days、endDate、endTime、startDate、startTime */
// 调班
@property (nonatomic, copy) NSString *mpm_newDate;  /** 新调班日期 */
@property (nonatomic, copy) NSString *originalDate; /** 原调班日期 */
// 考勤节点时间
@property (nonatomic, copy) NSString *oriAttendenceDate;

- (void)clearData;

@end
