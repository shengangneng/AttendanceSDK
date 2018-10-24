//
//  MPMMainTabBarViewController.h
//  MPMAtendence
//  主页控制器
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *const UnreadCountNotification = @"UnreadCountNotification";

@interface MPMMainTabBarViewController : UITabBarController

/** 获取流程审批待办未读信息 */
- (void)updateApprovalUnreadCount;

@end
