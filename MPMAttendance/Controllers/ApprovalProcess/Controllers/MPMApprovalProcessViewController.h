//
//  MPMApprovalProcessViewController.h
//  MPMAtendence
//  流程审批
//  Created by gangneng shen on 2018/4/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseViewController.h"
typedef NS_ENUM(NSInteger, FirstSectionType) {
    forMyApplyType = 1,
    forMyApprovalType = 2,
    forCCListType = 3,
};

@interface MPMApprovalProcessViewController : MPMBaseViewController

@end
