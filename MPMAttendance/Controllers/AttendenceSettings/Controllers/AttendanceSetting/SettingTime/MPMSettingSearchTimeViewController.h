//
//  MPMSettingSearchTimeViewController.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMSettingClassListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPMSettingSearchTimeViewController : MPMBaseViewController

- (instancetype)initWithSaveDelegate:(id<MPMSettingClassTimeDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
