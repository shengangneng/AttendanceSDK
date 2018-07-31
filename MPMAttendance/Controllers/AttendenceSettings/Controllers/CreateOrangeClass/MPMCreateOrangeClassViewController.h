//
//  MPMCreateOrangeClassViewController.h
//  MPMAtendence
//  创建排班、排班设置
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMAttendenceSettingViewController.h"

@interface MPMCreateOrangeClassViewController : MPMBaseViewController

- (instancetype)initWithSchedulingId:(NSString *)schedulingId settingType:(DulingType)dulingType;

@end
