//
//  MPMSettingClassListViewController.h
//  MPMAtendence
//  班次设置
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMAttendanceSettingModel.h"
#import "MPMAttendenceSettingViewController.h"
@class MPMAttendanceSettingModel;
@class MPMSettingClassListModel;

@protocol MPMSettingClassTimeDelegate <NSObject>

- (void)settingClassTimeDidCompleteWithTimeModel:(MPMSettingClassListModel *)model;

@end

@interface MPMSettingClassListViewController : MPMBaseViewController

- (instancetype)initWithModel:(MPMAttendanceSettingModel *)model dulingType:(DulingType)type;
+ (NSString *)getTimeStringWithModel:(MPMSettingClassListModel *)model;

@property (nonatomic, weak) id<MPMSettingClassTimeDelegate> delegate;

@end
