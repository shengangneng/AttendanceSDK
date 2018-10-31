//
//  MPMUser.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

// 不使用MPMBaseModel，自己使用NSObject的分类调用字典转模型
@interface MPMShareUser : NSObject

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSArray *perimissionArray;
@property (nonatomic, strong) UIViewController *lastRootViewController;     /** 记录从其他系统条转过来时候的rootViewcontroller */
@property (nonatomic, strong) UIViewController *lastCanPopViewController;   /** 记录最后push到的controller */

+ (instancetype)shareUser;
/** 每次重新登录，将数据保存到数据库 */
- (void)saveOrUpdateUserToCoreData;
/** 每次重新启动，都从数据库看看是否有用户数据，如果有则返回YES，没有则返回NO */
- (BOOL)getUserFromCoreData;
/** 登出的时候，清除数据，并清除数据库用户信息 */
- (void)clearData;

@end
