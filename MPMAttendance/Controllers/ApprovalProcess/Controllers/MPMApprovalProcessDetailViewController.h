//
//  MPMApprovalProcessDetailViewController.h
//  MPMAtendence
//  流程审批-信息详情
//  Created by gangneng shen on 2018/4/25.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMProcessMyMetterModel.h"
#import "MPMApprovalProcessViewController.h"

@interface MPMApprovalProcessDetailViewController : MPMBaseViewController


/**
 @param selectIndexPath section0我的事项（row0待办 row1已办）section1我的申请 section2抄送给我 section3考勤打卡节点跳入
 */
- (instancetype)initWithModel:(MPMProcessMyMetterModel *)model selectedIndexPath:(NSIndexPath *)selectIndexPath;

@end
