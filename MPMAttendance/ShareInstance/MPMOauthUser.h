//
//  MPMOauthUser.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/7.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
#import <CoreLocation/CoreLocation.h>

@interface MPMOauthUser : MPMBaseModel

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *company_code;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *department_ids;
@property (nonatomic, copy) NSString *department_name;
@property (nonatomic, copy) NSString *emp_num;
@property (nonatomic, copy) NSString *employee_id;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *login_name;
@property (nonatomic, copy) NSString *name_cn;
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *token_type;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *username;
// username接口已经传过来，password和companycode需要自己赋值
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *companycode;
@property (nonatomic, copy) NSArray *perimissionArray;
// 用于临时保存打卡地址信息，不写进数据库
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *address;
// 以下是自定义字段
@property (nonatomic, copy) NSString *expiresIn;                            /** 原始的，不需要加上当前时间 */
@property (nonatomic, strong) UIViewController *lastRootViewController;     /** 记录从其他系统条转过来时候的rootViewcontroller */
@property (nonatomic, strong) UIViewController *lastCanPopViewController;   /** 记录最后push到的controller */
@property (nonatomic, assign) UIStatusBarStyle lastStatusBarStyle;          /** 记录之前的StatusBarStyle，跳回的时候再赋值回去 */

+ (instancetype)shareOauthUser;

/** 每次重新登录，将数据保存到数据库 */
- (void)saveOrUpdateUserToCoreData;
/** 每次重新启动，都从数据库看看是否有用户数据，如果有则返回YES，没有则返回NO */
- (BOOL)getUserFromCoreData;
/** 登出的时候，清除数据，并清除数据库用户信息 */
- (void)clearData;

@end
