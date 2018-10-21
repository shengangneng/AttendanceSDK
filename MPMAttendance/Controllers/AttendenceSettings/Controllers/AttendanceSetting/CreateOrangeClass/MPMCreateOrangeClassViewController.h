//
//  MPMCreateOrangeClassViewController.h
//  MPMAtendence
//  创建排班、排班设置
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMAttendenceSettingViewController.h"
@class MPMAttendanceSettingModel;

@interface MPMCreateOrangeClassViewController : MPMBaseViewController

- (instancetype)initWithModel:(MPMAttendanceSettingModel *)model settingType:(DulingType)dulingType;

@end
