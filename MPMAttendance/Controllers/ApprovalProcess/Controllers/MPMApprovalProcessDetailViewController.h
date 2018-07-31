//
//  MPMApprovalProcessDetailViewController.h
//  MPMAtendence
//  流程审批-信息详情
//  Created by gangneng shen on 2018/4/25.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMApprovalCausationModel.h"
#import "MPMApprovalFetchDetailModel.h"

@interface MPMApprovalProcessDetailViewController : MPMBaseViewController

/** params：ButtonTitles从上一页面传入的底部按钮 */
- (instancetype)initWithCausation:(MPMApprovalCausationModel *)causation CausationDetailArray:(NSArray *)causationDetail operationButtonTitles:(NSArray *)buttons image:(NSString *)image text:(NSString *)text;

@end
