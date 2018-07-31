//
//  MPMSettingCardViewController.h
//  MPMAtendence
//  打卡设置
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMAttendenceSettingViewController.h"

@interface MPMSettingCardViewController : MPMBaseViewController

- (instancetype)initWithSchedulingId:(NSString *)schedulingId settingType:(DulingType)dulingType;

@end
