//
//  MPMSettingSwitchTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/24.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
@protocol MPMSettingSwitchTableViewCellSwitchDelegate<NSObject>

- (void)settingSwithChange:(UISwitch *)sw;

@end

@interface MPMSettingSwitchTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UISwitch *startNonSwitch;
@property (nonatomic, weak) id<MPMSettingSwitchTableViewCellSwitchDelegate> switchDelegate;

@end
