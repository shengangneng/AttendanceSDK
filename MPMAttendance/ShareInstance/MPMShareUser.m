//
//  MPMUser.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMShareUser.h"
#import "User+CoreDataClass.h"

static MPMShareUser *user;
@implementation MPMShareUser

+ (instancetype)shareUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[MPMShareUser alloc] init];
    });
    return user;
}

/** 每次重新登录，将数据保存到数据库 */
- (void)saveOrUpdateUserToCoreData {
    [User insertWithShareUser:user];
}

/** 每次重新启动，都从数据库看看是否有用户数据，如果有则返回YES，没有则返回NO */
- (BOOL)getUserFromCoreData {
    User *us = [User activeUser];
    if (!us) {
        return NO;
    }
    user.companyId = us.companyId;
    user.departmentId = us.departmentId;
    user.departmentName = us.departmentName;
    user.employeeId = us.employeeId;
    user.employeeName = us.employeeName;
    user.token = us.token;
    user.perimissionArray = us.perimissionArray;
    user.username = us.username;
    user.password = us.password;
    user.companyName = us.companyName;
    return YES;
}

- (void)clearData {
    [User deleteWithShareUser:self];
    self.companyId = nil;
    self.departmentId = nil;
    self.departmentName = nil;
    self.employeeId = nil;
    self.employeeName = nil;
    self.token = nil;
    self.address = nil;
    self.location = nil;
    self.perimissionArray = nil;
    self.username = nil;
    self.password = nil;
    self.companyName = nil;
    self.lastRootViewController = nil;
    self.lastCanPopViewController = nil;
}

@end
