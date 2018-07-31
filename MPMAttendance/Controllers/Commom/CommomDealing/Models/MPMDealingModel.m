//
//  MPMDealingModel.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDealingModel.h"
#import "MPMCausationDetailModel.h"
#import "NSMutableArray+MPMExtention.h"

@implementation MPMDealingModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.causationDetail = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            MPMCausationDetailModel *model = [[MPMCausationDetailModel alloc] init];
            [self.causationDetail addObject:model];
        }
    }
    return self;
}

- (void)clearData {
    self.mpm_copyName = nil;     /** 抄送人 */
    self.mpm_copyNameId = nil;   /** 抄送人id */
    self.approvalName = nil;     /** 审批人 */
    self.approvalId = nil;       /** 审批人id */
    self.nowApproval = nil;      /** 审批人 */
    self.nowApprovalId = nil;    /** 审批人id */
    self.status = nil;           /** 打卡状态：0正常、1异常 */
    self.type = nil;             /** 考勤状态：0考勤、1会议 */
    self.remark = nil;           /** 备注、处理理由 */
    self.attendence = nil;   /** 签到信息 */
    self.address = nil;          /** 签到地址 */
    self.attendenceId = nil;     /** 选中的补签处理类型id */
    self.brushDate = nil;        /** 签到日期 */
    self.brushTime = nil;        /** 签到时间 */
    self.attendenceDate = nil;   /** 处理签到时间-新 */
    self.checkCode = nil;        /** 校验码 */
    self.mpm_newClassName = nil; /** 班次：新-早中晚班 */
    self.originalClassName = nil;/** 班次：原-早中晚班 */
    self.createTime = nil;       /** 创建时间 */
    self.shiftName = nil;        /** 班次：选择上下班 */
    self.signType = nil;         /** 签到类型： */
    self.source = nil;           /** 来源：0安卓、1iOS、2pc、3考勤机 */
    self.early = nil;         /** 是否早到：0否、1是 */
    [self.causationDetail clearData];
    // 调班
    self.mpm_newDate = nil;
    self.originalDate = nil;
    self.oriAttendenceDate = nil;
}

@end
