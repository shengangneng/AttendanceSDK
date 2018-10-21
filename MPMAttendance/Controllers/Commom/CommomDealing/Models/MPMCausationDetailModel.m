//
//  MPMCausationDetailModel.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCausationDetailModel.h"

@implementation MPMCausationDetailModel

- (void)clearData {
    if (kCausationTypeevecation == self.causationType.integerValue ||
        kCausationTypeOverTime == self.causationType.integerValue ||
        kCausationTypeOut == self.causationType.integerValue ||
        kCausationTypeRepairSign == self.causationType.integerValue ||
        kCausationTypeChangeSign == self.causationType.integerValue
        ) {
        // 出差、加班、外出、补签、改签:self.causationType是固定的
    } else {
        self.causationType = nil;// 请假：可以清空self.causationType
    }
    // 通用属性
    self.dayAccount = nil;
    self.startTime = nil;
    self.endTime = nil;
    self.hourAccount = nil;
    // 出差
    self.expectCost = nil;
    self.address = nil;
    self.isShareRoom = nil;
    self.traffic = nil;
    // 请假
    self.type = nil;
    // 补签
    self.detailId = nil;
    self.fillupTime = nil;
    self.signTime = nil;
    self.mpm_id = nil;
    // 改签
    self.attendanceTime = nil;
    self.reviseSignTime = nil;
    // 交通工具是否需要折叠
    self.trafficNeedFold = YES;
}

- (void)copyWithOtherModel:(MPMCausationDetailModel *)model {
    self.causationType = model.causationType;
    // 通用属性
    self.dayAccount = model.dayAccount;
    self.startTime = model.startTime;
    self.endTime = model.endTime;
    self.hourAccount = model.hourAccount;
    // 出差
    self.expectCost = model.expectCost;
    self.address = model.address;
    self.isShareRoom = model.isShareRoom;
    self.traffic = model.traffic;
    // 请假
    self.type = model.type;
    // 补签
    self.detailId = model.detailId;
    self.fillupTime = model.fillupTime;
    self.signTime = model.signTime;
    self.mpm_id = model.mpm_id;
    // 改签
    self.attendanceTime = model.attendanceTime;
    self.reviseSignTime = model.reviseSignTime;
    // 交通工具是否需要折叠
    self.trafficNeedFold = model.trafficNeedFold;
}

@end
