//
//  MPMStatisticModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/9.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMStatisticModel : MPMBaseModel

// 2.0
@property (nonatomic, copy) NSString *actualAttendance;
@property (nonatomic, copy) NSString *awardCount;
@property (nonatomic, copy) NSString *buckleCount;
@property (nonatomic, copy) NSString *shouldAttendance;
@property (nonatomic, copy) NSArray *countList; // @{@"count":@"",@"name":@"",@"sumScore":@""}

@end

@interface MPMStatisticCountList : MPMBaseModel

@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sumScore;

@end
