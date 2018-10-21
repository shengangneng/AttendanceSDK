//
//  MPMProcessDetailApprovalNodeView.h
//  MPMAtendence
//  流程审批详情--审批节点
//  Created by shengangneng on 2018/9/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMProcessTaskModel.h"
#import "MPMTaskInstGroups.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPMProcessDetailApprovalNodeView : UIView

@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, strong) UIView *round;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithTaskGroup:(MPMTaskInstGroups *)group;

@end

NS_ASSUME_NONNULL_END
