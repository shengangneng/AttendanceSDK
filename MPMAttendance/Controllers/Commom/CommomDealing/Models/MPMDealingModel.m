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

- (instancetype)initWithCausationType:(CausationType)type addCount:(NSInteger)addCount {
    self = [super init];
    if (self) {
        self.causationType = type;
        self.addCount = addCount;
        self.causationDetail = [[NSMutableArray alloc] init];
        if (kCausationTypeRepairSign == self.causationType) {
            self.addMaxCount = 5;
        } else {
            self.addMaxCount = 3;
        }
        self.participantsCanAdd = YES;
        self.deliversCanAdd = YES;
        for (int i = 0; i < self.addMaxCount; i++) {
            MPMCausationDetailModel *model = [[MPMCausationDetailModel alloc] init];
            model.trafficNeedFold = YES;
            model.causationType = [NSString stringWithFormat:@"%ld",type];
            [self.causationDetail addObject:model];
        }
    }
    return self;
}

- (void)clearData {
    
    self.status = nil;           /** 打卡状态：0正常、1异常 */
    self.type = nil;             /** 考勤状态：0考勤、1会议 */
    self.remark = nil;           /** 备注、处理理由 */
    self.attendence = nil;       /** 打卡信息 */
    self.attendenceId = nil;     /** 选中的补卡处理类型id */
    self.brushDate = nil;        /** 打卡日期 */
    self.brushTime = nil;        /** 打卡时间 */
    self.attendenceDate = nil;   /** 处理打卡时间-新 */
    self.checkCode = nil;        /** 校验码 */
    self.mpm_newClassName = nil; /** 班次：新-早中晚班 */
    self.originalClassName = nil;/** 班次：原-早中晚班 */
    self.createTime = nil;       /** 创建时间 */
    self.shiftName = nil;        /** 班次：选择上下班 */
    self.signType = nil;         /** 打卡类型： */
    self.source = nil;           /** 来源：0安卓、1iOS、2pc、3考勤机 */
    self.early = nil;            /** 是否早到：0否、1是 */
    self.decision = nil;
    self.name = nil;
    [self.causationDetail clearData];
    // 调班
    self.mpm_newDate = nil;
    self.originalDate = nil;
    self.oriAttendenceDate = nil;
}

@end
