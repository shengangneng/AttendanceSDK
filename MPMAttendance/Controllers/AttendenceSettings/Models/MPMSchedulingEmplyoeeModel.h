//
//  MPMSchedulingEmplyoeeModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMSchedulingEmplyoeeModel : MPMBaseModel

@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, copy) NSString *valid;
@property (nonatomic, copy) NSString *parentsId;

@end
