//
//  MPMBaseDealingViewController.h
//  MPMAtendence
//  通用的处理页面（很多个处理页面都类似，所以使用一个通用页面）
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMCausationTypeData.h"
#import "MPMDealingModel.h"

// 跳入的类型
typedef NS_ENUM(NSInteger, DealingFromType) {
    kDealingFromTypeChangeRepair,   // 从打卡页面的例外申请、改卡、补卡进入
    kDealingFromTypeApply,          // 从Tabbar第二项“例外申请模块”进入
    kDealingFromTypeEditing,        // 从流程审批详情的“编辑”进入(需要调用相应的接口获取对应id单的数据）
    kDealingFromTypePreview,        // 从流程设置预览申请模板进入
    
};

typedef NS_ENUM(NSInteger, FastCalculateType) {
    kFastCalculateTypeNone = -1,// 不用快速便捷方式
    kFastCalculateTypeAM = 0,   // 上午 0
    kFastCalculateTypePM,       // 下午 1
    kFastCalculateTypeTomorrow, // 明天 2
    kFastCalculateTypeTwoDays,  // 两天 3
    kFastCalculateTypeThreeDays,// 三天 4
    kFastCalculateTypeOneHour,  // 一小时 5
    kFastCalculateTypeTwoHour,  // 两小时 6
    kFastCalculateTypeThreeHour,// 三小时 7
};

@interface MPMBaseDealingViewController : MPMBaseViewController

/**
 * @param type 类型（请假、出差、加班、外出等）
 * @param fromType 进入类型（从例外申请进入、从考勤打卡页面进入、从编辑进入等）
 * @param dealingModel 如果是从打卡页面补卡改卡进入，需要传入dealingModel
 * @param bizorderId 如果是编辑进入，需要传入
 * @param taskInstId 如果是编辑进入，需要传入
 * @param fastCalculateType 如果是例外申请快捷方式进入，需要传入
 */
- (instancetype)initWithDealType:(CausationType)type dealingModel:(MPMDealingModel *)dealingModel dealingFromType:(DealingFromType)fromType bizorderId:(NSString *)bizorderId taskInstId:(NSString *)taskInstId fastCalculate:(FastCalculateType)fastCalculateType;

@end
