//
//  MPMOauthUser.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/7.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMOauthUser.h"
#import "OauthUser+CoreDataClass.h"

static MPMOauthUser *oauthUser;

@implementation MPMOauthUser

+ (instancetype)shareOauthUser {
    return [self allocWithZone:NULL];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (oauthUser) {
        return oauthUser;
    }
    @synchronized (self) {
        oauthUser = [super allocWithZone:zone];
        return oauthUser;
    }
}

/** 每次重新登录，将数据保存到数据库 */
- (void)saveOrUpdateUserToCoreData {
    [OauthUser insertWithShareUser:oauthUser];
}

/** 每次重新启动，都从数据库看看是否有用户数据，如果有则返回YES，没有则返回NO */
- (BOOL)getUserFromCoreData {
    OauthUser *us = [OauthUser activeUser];
    if (!us) {
        return NO;
    }
    oauthUser.access_token = us.access_token;
    oauthUser.company_code = us.company_code;
    oauthUser.company_id = us.company_id;
    oauthUser.department_id = us.department_id;
    oauthUser.department_ids = us.department_ids;
    oauthUser.emp_num = us.emp_num;
    oauthUser.employee_id = us.employee_id;
    oauthUser.expires_in = us.expires_in;
    oauthUser.login_name = us.login_name;
    oauthUser.name_cn = us.name_cn;
    oauthUser.refresh_token = us.refresh_token;
    oauthUser.scope = us.scope;
    oauthUser.token_type = us.token_type;
    oauthUser.user_id = us.user_id;
    oauthUser.username = us.username;
    oauthUser.password = us.password;
    oauthUser.companycode = us.companycode;
    oauthUser.department_name = us.department_name;
    oauthUser.perimissionArray = us.perimissionArray;
    return YES;
}

- (void)clearData {
    [OauthUser deleteWithShareUser:self];
    self.access_token = nil;
    self.company_code = nil;
    self.company_id = nil;
    self.department_id = nil;
    self.department_ids = nil;
    self.emp_num = nil;
    self.employee_id = nil;
    self.expires_in = nil;
    self.login_name = nil;
    self.name_cn = nil;
    self.refresh_token = nil;
    self.scope = nil;
    self.token_type = nil;
    self.user_id = nil;
    self.username = nil;
    self.password = nil;
    self.companycode = nil;
    self.perimissionArray = nil;
}

@end
