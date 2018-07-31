//
//  MPMCausationDetailModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMCausationDetailModel : MPMBaseModel

@property (nonatomic, copy) NSString *address;          /** 签到地址 */
@property (nonatomic, copy) NSString *attendenceId;     /** 选中的补签处理类型id */
@property (nonatomic, copy) NSString *startLongDate;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endLongDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *days;

- (void)clearData;
- (void)copyWithOtherModel:(MPMCausationDetailModel *)model;

@end
