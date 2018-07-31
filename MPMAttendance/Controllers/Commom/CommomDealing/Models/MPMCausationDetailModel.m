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
    self.address = nil;
    self.attendenceId = nil;
    self.startLongDate = nil;
    self.startDate = nil;
    self.startTime = nil;
    self.endLongDate = nil;
    self.endDate = nil;
    self.endTime = nil;
    self.days = nil;
}

- (void)copyWithOtherModel:(MPMCausationDetailModel *)model {
    self.address = model.address;
    self.attendenceId = model.attendenceId;
    self.startLongDate = model.startLongDate;
    self.startDate = model.startDate;
    self.startTime = model.startTime;
    self.endLongDate = model.endLongDate;
    self.endDate = model.endDate;
    self.endTime = model.endTime;
    self.days = model.days;
}

@end
