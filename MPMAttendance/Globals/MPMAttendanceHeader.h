//
//  MPMAttendanceHeader.h
//  MPMAttendance
//
//  Created by shengangneng on 2018/7/31.
//  Copyright © 2018年 MPMAttendanceSDK. All rights reserved.
//

#ifndef MPMAttendanceHeader_h
#define MPMAttendanceHeader_h

#import "ColorConstant.h"
#import "MPMMasonry.h"
#import "MPMProgressHUD.h"
#import "MPMIntergralConfig.h"
#import "MPMApplyAdditionConfig.h"
#import "MPMInterfaceConst.h"

/************************************************************************************************************************/
// 一个记录是否是第一次登陆的key
#define kHasLoaded      @"AppHasLoadKey"
// 一个字典记录Controller初始化次数的key
#define kControllerInitCountDicKey  @"ControllerInitCountDictionary"
// 获取全局的Delegate对象
#define kAppDelegate    [UIApplication sharedApplication].delegate
// HTTP Authorization Key
#define kAuthKey        @"Authorization"
// 判断是否是iPhone X和XS
#define kIsiPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否是iPhone XR
#define kIsiPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhoneXS MAX
#define kIsiPhoneXSMAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断字符串是否为空
#define kIsNilString(str) (str.length == 0 || [str isEqualToString:@""] || [str stringByRemovingPercentEncoding].length == 0)
#define kSafeString(str) kIsNilString(str) ? @"" : str
#define kNoNullString(obj) [obj isKindOfClass:[NSString class]] ? kSafeString(obj) : @""
#define kNumberSafeString(obj) [obj isKindOfClass:[NSString class]] ? obj : ([obj isKindOfClass:[NSNumber class]] ? ((NSNumber *)obj).stringValue : @"")


#define BottomViewHeight        ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 83 : 60)
#define BottomViewTopMargin     ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 10 : 8)
#define BottomViewBottomMargin  ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 20 : 8)

#define PX_W(padding) (kScreenWidth * padding / 750)
#define PX_H(padding) (kScreenHeight * padding / 1334)
// 导航和TarBar的高度
#define kTableViewHeight    50.0f
#define kNavigationHeight   ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 88 : 64)
#define kTabbarHeight       49
#define kTabTotalHeight     ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? kTabbarHeight+34 : kTabbarHeight)
#define kStatusBarHeight    ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 34 : 20)
// Tabbar的配置项
#define kTarBarControllerDic @{@"4":@"MPMAttendenceSigninViewController,tab_punchingtimecard_",@"5":@"MPMApplyAdditionViewController,tab_exceptionsapply_",@"6":@"MPMApprovalProcessViewController,tab_approval_",@"7":@"MPMAttendenceStatisticViewController,tab_attendancestatistics_",@"8":@"MPMAttendenceBaseSettingViewController,tab_attendance_"}
// 考勤设置-权限配置项
#define kAttendanceSettingPerimissionDic @{@"9":@{@"Controller":@"MPMAuthoritySettingViewController",@"title":@"权限设置",@"image":@"setting_permissions"},@"10":@{@"Controller":@"MPMIntergralSettingViewController",@"title":@"积分设置",@"image":@"setting_integral"}}
#define kClassSettingPerimission @{@"title":@"考勤排班",@"Controller":@"MPMAttendenceSettingViewController",@"image":@"setting_attendancescheduling"}


// 2.0版本配置项
#define kTarBarControllerDicV2 @{@"mobile_sign":@"MPMAttendenceSigninViewController,tab_punchingtimecard_",@"mobile_wf_apply":@"MPMApplyAdditionViewController,tab_exceptionsapply_",@"mobile_wf_approve":@"MPMApprovalProcessViewController,tab_approval_",@"mobile_stat":@"MPMAttendenceStatisticViewController,tab_attendancestatistics_",@"mobile_config":@"MPMAttendenceBaseSettingViewController,tab_attendance_"}
// 2.0版本考勤设置
#define kAttendanceSettingPerimissionDicV2 @{@"mobile_auth_setting":@{@"Controller":@"MPMAuthoritySettingViewController",@"title":@"权限设置",@"image":@"setting_permissions"},@"mobile_score_setting":@{@"Controller":@"MPMIntergralSettingViewController",@"title":@"积分设置",@"image":@"setting_integral"},@"mobile_sched_setting":@{@"title":@"考勤排班",@"Controller":@"MPMAttendenceSettingViewController",@"image":@"setting_globalSettings"},@"mobile_wf_setting":@{@"title":@"流程设置",@"Controller":@"MPMProcessSettingViewController",@"image":@"setting_process"}}

/************************************************************************************************************************/
/***** 格式化log *****/
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

/************************************************************************************************************************/
/***** 常用方法 *****/
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define ImageName(name) [UIImage imageNamed:[@"MPMAttendance.bundle" stringByAppendingPathComponent:name]]
#define ImageContentOfFile(fileName, fileType) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(fileName) ofType:(fileType)]]
// 通过tag获取view
#define ViewWithTag(view, tag)   (id)[view viewWithTag: tag]
// 字体大小（常规/粗体）
#define Font(name, fontSize)     [UIFont fontWithName:(name) size:(fontSize)]
#define SystemFont(fontSize)     [UIFont systemFontOfSize:fontSize]
#define BoldSystemFont(fontSize) [UIFont boldSystemFontOfSize:fontSize]

/************************************************************************************************************************/
/***** GCD *****/
#define kGlobalQueueDEFAULT       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGlobalQueueHIGH          dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define kGlobalQueueLOW           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
#define kGlobalQueueBACKGROUND    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
#define kMainQueue                dispatch_get_main_queue()

/************************************************************************************************************************/
/***** 常用宽度 *****/
#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth    kScreenBounds.size.width
#define kScreenHeight   kScreenBounds.size.height


#endif /* MPMAttendanceHeader_h */
