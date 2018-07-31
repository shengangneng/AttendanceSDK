//
//  MPMDetailTimeMessageView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMApprovalCausationModel.h"
#import "MPMApprovalCausationDetailModel.h"

@interface MPMDetailTimeMessageView : UIView

/** typeName：处理类型 */
- (instancetype)initWithFrame:(CGRect)frame typeName:(NSString *)name model:(MPMApprovalCausationModel *)model detail:(MPMApprovalCausationDetailModel *)detailModel;

@property (nonatomic, strong) UIImageView *contentTimeLeftBar;
// 处理类型
@property (nonatomic, strong) UILabel *contentTimeLeaveTypeLabel;
@property (nonatomic, strong) UILabel *contentTimeLeaveTypeMessage;
// 行程
@property (nonatomic, strong) UILabel *contentAddressLabel;
@property (nonatomic, strong) UILabel *contentAddressMessageLabel;
// 时间
@property (nonatomic, strong) UILabel *contentTimeBeginTimeLabel;
@property (nonatomic, strong) UILabel *contentTimeBeginTimeMessage;
@property (nonatomic, strong) UILabel *contentTimeendTimeLabel;
@property (nonatomic, strong) UILabel *contentTimeendTimeMessage;
@property (nonatomic, strong) UILabel *contentTimeIntervalLabel;
@property (nonatomic, strong) UILabel *contentTimeIntervalMessage;

@end
