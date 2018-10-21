//
//  OauthUser+CoreDataClass.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MPMOauthUser.h"

@class NSObject;

NS_ASSUME_NONNULL_BEGIN

@interface OauthUser : NSManagedObject

/** 登录之后更新登录用户信息 */
+ (instancetype)insertWithShareUser:(MPMOauthUser *)user;
/** 登出之后删除用户信息 */
+ (void)deleteWithShareUser:(MPMOauthUser *)user;

+ (OauthUser *)activeUser;

@end

NS_ASSUME_NONNULL_END

#import "OauthUser+CoreDataProperties.h"
