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

/************************************************************************************************************************/
/***** 环境变量 *****/
/**  测试环境 */
#define MPMHost @"http://attendance.jifenzhi.com:8091/"
/**/

/**  生产环境V1.1 *
 #define MPMHost @"http://47.97.112.161:8091/"
 **/

/**  开发环境  *
 #define MPMHost @"http://47.97.98.80:8090/"
 **/

/**  小伟环境  *
 #define MPMHost @"http://192.168.1.63:8090/"
 **/

/**  桂杰环境  *
 #define MPMHost @"http://192.168.1.73:8090/"
 **/

/**  测试环境2 *
 #define MPMHost @"http://121.43.182.192:8091/"
 **/

/**  生产环境  *
 #define MPMHost @"http://183.95.85.84:8091/"
 **/


/************************************************************************************************************************/
// 一个记录是否是第一次登陆的key
#define kHasLoaded      @"AppHasLoadKey"
// 一个字典记录Controller初始化次数的key
#define kControllerInitCountDicKey  @"ControllerInitCountDictionary"
// 获取全局的Delegate对象
#define kAppDelegate    [UIApplication sharedApplication].delegate
// 判断是否是iPhone X
#define kIsiPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断字符串是否为空
#define kIsNilString(str) (str.length == 0 || [str isEqualToString:@""] || [str stringByRemovingPercentEncoding].length == 0)
#define kSafeString(str) kIsNilString(str) ? @"" : str
#define kNoNullString(obj) [obj isKindOfClass:[NSString class]] ? kSafeString(obj) : @""


#define BottomViewHeight        (kIsiPhoneX ? 83 : 60)
#define BottomViewTopMargin     (kIsiPhoneX ? 10 : 8)
#define BottomViewBottomMargin  (kIsiPhoneX ? 20 : 8)

#define PX_W(padding) (kScreenWidth * padding / 750)
#define PX_H(padding) (kScreenHeight * padding / 1334)
// 导航和TarBar的高度
#define kTableViewHeight    50.0f
#define kNavigationHeight   (kIsiPhoneX ? 88 : 64)
#define kTabbarHeight       49
#define kTabTotalHeight     (kIsiPhoneX ? kTabbarHeight+34 : kTabbarHeight)
#define kStatusBarHeight    (kIsiPhoneX ? 34 : 20)
// Tabbar的配置项
#define kTarBarControllerDic @{@"4":@"MPMAttendenceSigninViewController,tab_punchingtimecard_",@"5":@"MPMApplyAdditionViewController,tab_exceptionsapply_",@"6":@"MPMApprovalProcessViewController,tab_approval_",@"7":@"MPMAttendenceStatisticViewController,tab_attendancestatistics_",@"8":@"MPMAttendenceBaseSettingViewController,tab_attendance_"}
// 考勤设置-权限配置项
#define kAttendanceSettingPerimissionDic @{@"9":@{@"Controller":@"MPMAuthoritySettingViewController",@"title":@"权限设置",@"image":@"setting_permissions"},@"10":@{@"Controller":@"MPMIntergralSettingViewController",@"title":@"积分设置",@"image":@"setting_integral"}}
#define kClassSettingPerimission @{@"title":@"考勤排班",@"Controller":@"MPMAttendenceSettingViewController",@"image":@"setting_attendancescheduling"}

/************************************************************************************************************************/
/***** 格式化log *****/
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

/************************************************************************************************************************/
/***** 常用方法 *****/
#define ImageName(name) [UIImage imageNamed:[@"MPMAttendanceBundle.bundle" stringByAppendingPathComponent:name]]
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
