//
//  MPMApprovalProcessViewController.h
//  MPMAtendence
//  流程审批
//  Created by gangneng shen on 2018/4/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseViewController.h"
typedef NS_ENUM(NSInteger, ProgcessFirstSectionType) {
    kMyMatterType = 0,  /** 我的事项 */
    kMyApplyType = 1,   /** 我的申请 */
    kCCToMeType = 2,    /** 抄送给我 */
};

@interface MPMApprovalProcessViewController : MPMBaseViewController

@end
