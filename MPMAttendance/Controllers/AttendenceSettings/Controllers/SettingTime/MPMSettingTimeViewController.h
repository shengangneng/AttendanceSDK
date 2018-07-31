//
//  MPMSettingTimeViewController.h
//  MPMAtendence
//  设置时间段
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMAttendenceSettingViewController.h"

@interface MPMSettingTimeViewController : MPMBaseViewController

- (instancetype)initWithSchedulingId:(NSString *)schedulingId dulingType:(DulingType)dulingType resetTime:(NSString *)resetTime;

@end
