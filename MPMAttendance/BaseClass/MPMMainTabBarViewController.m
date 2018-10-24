//
//  MPMMainTabBarViewController.m
//  MPMAtendence
//  主页控制器
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMMainTabBarViewController.h"
#import "MPMBaseNavigationController.h"
#import "MPMOauthUser.h"
#import "MPMSessionManager.h"
// 五个TabBar
#import "MPMAttendenceSigninViewController.h"       // 考勤打卡
#import "MPMApplyAdditionViewController.h"          // 例外申请
#import "MPMApprovalProcessViewController.h"        // 流程审批
#import "MPMAttendenceStatisticViewController.h"    // 考勤统计
//#import "MPMAttendenceSettingViewController.h"      // 考勤设置
#import "MPMAttendenceBaseSettingViewController.h"  // V1.1版本考勤设置

@interface MPMMainTabBarViewController ()

@end

@implementation MPMMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupChildVC];
    [self updateApprovalUnreadCount];
}

// 获取"流程审批"未读消息数
- (void)updateApprovalUnreadCount {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_MYNEWS];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        if ([response[kResponseObjectKey] isKindOfClass:[NSNumber class]]) {
            NSNumber *unreadCount = response[kResponseObjectKey];
            for (UIViewController *vc in self.viewControllers) {
                if ([vc isKindOfClass:[MPMBaseNavigationController class]] && [((MPMBaseNavigationController *)vc).viewControllers.firstObject isKindOfClass:[MPMApprovalProcessViewController class]]) {
                    if (0 == unreadCount.doubleValue) {
                        ((MPMApprovalProcessViewController *)((MPMBaseNavigationController *)vc).viewControllers.firstObject).tabBarItem.badgeValue = nil;
                    } else {
                        ((MPMApprovalProcessViewController *)((MPMBaseNavigationController *)vc).viewControllers.firstObject).tabBarItem.badgeValue = unreadCount.stringValue;
                    }
                    // 以发通知的方式发出未读消息数
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadCountNotification object:unreadCount];
                }
            }
        }
    } failure:^(NSString *error) {
        DLog(@"获取流程审批未读消息失败");
    }];
}

- (void)setupAttributes {
    // 设置tabBar为不透明（默认模式是半透明的）
    self.tabBar.translucent = NO;
}

- (void)setupChildVC {
    NSArray *arr = [MPMOauthUser shareOauthUser].perimissionArray;
    if (arr && arr.count > 0) {
        for (int i = 0; i < arr.count; i++) {
            NSString *perimissionId = arr[i][@"id"];
            NSString *perimissionName = arr[i][@"name"];
            NSString *vcName_imageName = [kTarBarControllerDicV2 objectForKey:perimissionId];
            if (kIsNilString(vcName_imageName)) continue;
            NSString *vcName = [vcName_imageName componentsSeparatedByString:@","].firstObject;
            NSString *imageName = [vcName_imageName componentsSeparatedByString:@","].lastObject;
            [self setChildVC:[[NSClassFromString(vcName) alloc] init] title:perimissionName image:[NSString stringWithFormat:@"%@nomal",imageName] selectedImage:[NSString stringWithFormat:@"%@select",imageName] nav:YES];
        }
    } else {
        MPMAttendenceSigninViewController *signin = [[MPMAttendenceSigninViewController alloc] init];
        [self setChildVC:signin title:@"考勤签到" image:@"tab_punchingtimecard_nomal" selectedImage:@"tab_punchingtimecard_select" nav:YES];
        MPMApplyAdditionViewController *apply = [[MPMApplyAdditionViewController alloc] init];
        [self setChildVC:apply title:@"例外申请" image:@"tab_exceptionsapply_nomal" selectedImage:@"tab_exceptionsapply_select" nav:YES];
        MPMApprovalProcessViewController *statis = [[MPMApprovalProcessViewController alloc] init];
        [self setChildVC:statis title:@"流程审批" image:@"tab_approval_nomal" selectedImage:@"tab_approval_select" nav:YES];
        MPMAttendenceStatisticViewController *couting = [[MPMAttendenceStatisticViewController alloc] init];
        [self setChildVC:couting title:@"考勤统计" image:@"tab_attendancestatistics_nomal" selectedImage:@"tab_attendancestatistics_select" nav:YES];
        MPMAttendenceBaseSettingViewController *setting = [[MPMAttendenceBaseSettingViewController alloc] init];
        [self setChildVC:setting title:@"考勤设置" image:@"tab_attendance_nomal" selectedImage:@"tab_attendance_select" nav:YES];
    }
}

- (void)setChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage nav:(BOOL)nav {
    
    childVC.tabBarItem.title = title;
    // 设置normal模式下tabbar
    NSMutableDictionary *ndict = [NSMutableDictionary dictionary];
    ndict[NSForegroundColorAttributeName] = kBorderLineColor;
    ndict[NSFontAttributeName] = SystemFont(12);
    [childVC.tabBarItem setTitleTextAttributes:ndict forState:UIControlStateNormal];
    // 设置select模式下tabbar
    NSMutableDictionary *sdict = [NSMutableDictionary dictionary];
    sdict[NSForegroundColorAttributeName] = kMainBlueColor;
    sdict[NSFontAttributeName] = SystemFont(12);
    [childVC.tabBarItem setTitleTextAttributes:sdict forState:UIControlStateSelected];
    childVC.tabBarItem.image = [ImageName(image) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVC.tabBarItem setImageInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
    [childVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    childVC.tabBarItem.selectedImage = [ImageName(selectedImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MPMBaseNavigationController *navVC = [[MPMBaseNavigationController alloc] initWithRootViewController:childVC];
    if (nav) {
        [self addChildViewController:navVC];
    } else {
        [self addChildViewController:childVC];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self updateApprovalUnreadCount];
    [self animationWithIndex:index];
}

- (void)animationWithIndex:(NSInteger)index {
    
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.8];
    pulse.toValue = [NSNumber numberWithFloat:1.2];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    DLog(@"%@ dealloc",self);
}

@end
