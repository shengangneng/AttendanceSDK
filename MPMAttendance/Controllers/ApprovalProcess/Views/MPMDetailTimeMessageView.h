//
//  MPMDetailTimeMessageView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMCausationTypeData.h"
#import "MPMProcessDetailList.h"

@interface MPMDetailTimeMessageView : UIView

/**
 * @param type 申请类型：请假、出差、外出、加班、补签、改签
 * @param withTypeLabel 是否需要显示申请类型Label
 * @param detailDto 详情信息
 */
- (instancetype)initWithCausationType:(CausationType)type withTypeLabel:(BOOL)withTypeLabel detailDto:(MPMDetailDtoList *)detailDto;

@property (nonatomic, assign) CausationType type;
@property (nonatomic, assign) BOOL withTypeLabel;

@property (nonatomic, strong) UIImageView *contentTimeLeftBar;      /** 蓝色视图 */
// 处理类型
@property (nonatomic, strong) UILabel *contentTimeLeaveTypeLabel;
@property (nonatomic, strong) UILabel *contentTimeLeaveTypeMessage;
// 出差地点
@property (nonatomic, strong) UILabel *contentAddressLabel;
@property (nonatomic, strong) UILabel *contentAddressMessage;
// 时间
@property (nonatomic, strong) UILabel *contentTimeBeginTimeLabel;   /** 开始时间、漏签时间、考勤时间 */
@property (nonatomic, strong) UILabel *contentTimeBeginTimeMessage; /** 开始时间、漏签时间、考勤时间 */
@property (nonatomic, strong) UILabel *contentTimeendTimeLabel;     /** 补签时间、签到时间、结束时间 */
@property (nonatomic, strong) UILabel *contentTimeendTimeMessage;   /** 补签时间、签到时间、结束时间 */
@property (nonatomic, strong) UILabel *contentTimeIntervalLabel;    /** 改签时间、时长 */
@property (nonatomic, strong) UILabel *contentTimeIntervalMessage;  /** 改签时间、时长 */
// 交通工具
@property (nonatomic, strong) UILabel *contentTrafficLabel;
@property (nonatomic, strong) UILabel *contentTrafficMessage;
// 预计费用、加班补偿
@property (nonatomic, strong) UILabel *contentCostMoneyLabel;
@property (nonatomic, strong) UILabel *contentCostMoneyMessage;
// 积分
@property (nonatomic, strong) UILabel *contentIntegralLabel;
@property (nonatomic, strong) UILabel *contentIntegralMessage;

@end
