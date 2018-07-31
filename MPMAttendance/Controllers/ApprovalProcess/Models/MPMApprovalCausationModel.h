//
//  MPMApprovalCausationModel.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMApprovalCausationModel : MPMBaseModel

@property (nonatomic, copy) NSString *applicantDate;
@property (nonatomic, copy) NSString *applicantTime;
@property (nonatomic, copy) NSString *approveDate;
@property (nonatomic, copy) NSString *approveId;
@property (nonatomic, copy) NSString *approveName;
@property (nonatomic, copy) NSString *attendanceDate;/** 手动修改后的打卡时间 */
@property (nonatomic, copy) NSString *attendanceTime;/** 原来的打卡时间戳 */
@property (nonatomic, copy) NSString *causationtypeNo;
@property (nonatomic, copy) NSString *mpm_copyName;
@property (nonatomic, copy) NSString *mpm_copyNameId;
@property (nonatomic, copy) NSString *exchangeId;
@property (nonatomic, copy) NSString *isValid;
@property (nonatomic, copy) NSString *nextApprove;
@property (nonatomic, copy) NSString *nextApproveId;
@property (nonatomic, copy) NSString *nowApprove;
@property (nonatomic, copy) NSString *nowApproveId;
@property (nonatomic, copy) NSString *applpreviouApproveicantTime;
@property (nonatomic, copy) NSString *previouApproveId;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *rejectReason;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *schedulingDate;/** 考勤节点时间 */
@end
