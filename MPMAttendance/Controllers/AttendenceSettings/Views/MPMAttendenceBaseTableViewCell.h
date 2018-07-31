//
//  MPMAttendenceBaseTableViewCell.h
//  MPMAtendence
//  V1.1版本考勤设置主页Cell
//  Created by shengangneng on 2018/6/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
/** 点击Switch */
typedef void(^SwitchChangeBlock)(UISwitch *sender);

@interface MPMAttendenceBaseTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UISwitch *signSwitch;

@property (nonatomic, copy) SwitchChangeBlock switchChangeBlock;

@end
