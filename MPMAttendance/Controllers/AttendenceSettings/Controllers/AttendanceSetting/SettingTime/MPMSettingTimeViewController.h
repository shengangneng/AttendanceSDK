//
//  MPMSettingTimeViewController.h
//  MPMAtendence
//  设置时间段
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMAttendenceSettingViewController.h"
@class MPMSettingClassListModel;

@interface MPMSettingTimeViewController : MPMBaseViewController

/** classTimeId：如果班次有被使用，需要传入classTimeId，如果是新创建的或者是班次没被使用的，就不需要传入 */
- (instancetype)initWithModel:(MPMSettingClassListModel *)model dulingType:(DulingType)dulingType classTimeId:(NSString *)classTimeId;

@end
