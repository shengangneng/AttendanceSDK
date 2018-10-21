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
    kDealingFromTypeChangeRepair,   // 从打卡页面的例外申请、改签、补签进入
    kDealingFromTypeApply,          // 从Tabbar第二项“例外申请模块”进入
    kDealingFromTypeEditing,        // 从流程审批详情的“编辑”进入(需要调用相应的接口获取对应id单的数据）
    kDealingFromTypePreview,        // 从流程设置预览申请模板进入
    
};

@interface MPMBaseDealingViewController : MPMBaseViewController

/**
 * @param type 类型
 * @param fromType 进入类型
 */
- (instancetype)initWithDealType:(CausationType)type dealingModel:(MPMDealingModel *)dealingModel dealingFromType:(DealingFromType)fromType bizorderId:(NSString *)bizorderId taskInstId:(NSString *)taskInstId;

@end
