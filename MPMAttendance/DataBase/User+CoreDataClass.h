//
//  User+CoreDataClass.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MPMShareUser.h"

@class NSObject;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

/** 登录之后更新登录用户信息 */
+ (instancetype)insertWithShareUser:(MPMShareUser *)user;
/** 登出之后删除用户信息 */
+ (void)deleteWithShareUser:(MPMShareUser *)user;

+ (User *)activeUser;
//+ (NSArray *)allUsers;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
