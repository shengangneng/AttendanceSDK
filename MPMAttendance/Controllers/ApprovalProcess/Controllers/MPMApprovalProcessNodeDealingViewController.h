//
//  MPMApprovalProcessNodeDealingViewController.h
//  MPMAtendence
//  节点处理-驳回、转交、通过
//  Created by shengangneng on 2018/9/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMProcessTaskModel.h"
#import "MPMProcessMyMetterModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, DetailNodeDealingType) {
    kDetailNodeDealingTypeReject,           /** 驳回 */
    kDetailNodeDealingTypeTransToOthers,    /** 转交 */
    kDetailNodeDealingTypePass              /** 通过 */
};

@interface MPMApprovalProcessNodeDealingViewController : MPMBaseViewController

@property (nonatomic, assign) DetailNodeDealingType detailNodeDealingType;

- (instancetype)initWithDealingNodeType:(DetailNodeDealingType)dealingNodeType taskInstId:(nonnull NSString *)taskInstId model:(MPMProcessMyMetterModel *)model;
@property (nonatomic, strong) MPMProcessTaskConfig *config;

@end

NS_ASSUME_NONNULL_END
