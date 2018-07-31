//
//  MPMAttendenceSettingTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
@class MPMAttendenceSettingModel;

typedef void(^CellDeleteBlock)(UIButton *sender);
typedef void(^CellSettingRageClassBlock)(UIButton *sender);
typedef void(^CellSettingClassBlock)(UIButton *sender);
typedef void(^CellSettingTimeBlock)(UIButton *sender);
typedef void(^CellSettingCardBlock)(UIButton *sender);

@interface MPMAttendenceSettingTableViewCell : MPMBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) MPMAttendenceSettingModel *model;

@property (nonatomic, copy) CellDeleteBlock deleteBlock;
@property (nonatomic, copy) CellSettingRageClassBlock settingRageClassBlock;
@property (nonatomic, copy) CellSettingClassBlock settingClassBlock;
@property (nonatomic, copy) CellSettingTimeBlock settingTimeBlock;
@property (nonatomic, copy) CellSettingCardBlock settingCardBlock;

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIButton *headerDeleteButton;
@property (nonatomic, strong) UIView *line;
// 范围
@property (nonatomic, strong) UIView *workScopeView;
@property (nonatomic, strong) UIImageView *workScopeIcon;
@property (nonatomic, strong) UILabel *workScopeLabel;
// 班次
@property (nonatomic, strong) UIView *classView;
@property (nonatomic, strong) UIImageView *classIcon;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *classLabel2;
// 考勤日期
@property (nonatomic, strong) UIView *workDateView;
@property (nonatomic, strong) UIImageView *workDateIcon;
@property (nonatomic, strong) UILabel *workDateLabel;
// 地点
@property (nonatomic, strong) UIView *workLocationView;
@property (nonatomic, strong) UIImageView *workLocationIcon;
@property (nonatomic, strong) UILabel *workLocationLabel;
// 考勤有效期
@property (nonatomic, strong) UIView *workEffectDateView;
@property (nonatomic, strong) UIImageView *workEffectDateIcon;
@property (nonatomic, strong) UILabel *workEffectDateLabel;
// wifi名称
@property (nonatomic, strong) UIView *workWifiView;
@property (nonatomic, strong) UIImageView *workWifiIcon;
@property (nonatomic, strong) UILabel *workWifiLabel;
// 底部按钮
@property (nonatomic, strong) UIButton *settingRageClassButton;
@property (nonatomic, strong) UIButton *settingClassButton;
@property (nonatomic, strong) UIButton *settingTimeButton;
@property (nonatomic, strong) UIButton *settingCardButton;


@end
