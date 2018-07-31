//
//  MPMApprovalCausationDetailModel.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMApprovalCausationDetailModel : MPMBaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *causationId;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *startTime;
@end
