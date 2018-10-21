//
//  OauthUser+CoreDataClass.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import "OauthUser+CoreDataClass.h"
#import "MPMCoreDataManager.h"
#import <objc/runtime.h>

@implementation OauthUser

+ (instancetype)insertWithShareUser:(MPMOauthUser *)user {
    NSString *modelName = NSStringFromClass([self class]);
    OauthUser *us = [self activeUser];
    if (!us) {
        us = [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:[MPMCoreDataManager shareManager].mainManagedObjectContext];
    }
    us.access_token = user.access_token;
    us.company_code = user.company_code;
    us.company_id = user.company_id;
    us.department_id = user.department_id;
    us.department_name = user.department_name;
    us.department_ids = user.department_ids;
    us.emp_num = user.emp_num;
    us.employee_id = user.employee_id;
    us.expires_in = user.expires_in;
    us.login_name = user.login_name;
    us.name_cn = user.name_cn;
    us.refresh_token = user.refresh_token;
    us.scope = user.scope;
    us.token_type = user.token_type;
    us.user_id = user.user_id;
    us.username = user.username;
    us.password = user.password;
    us.companycode = user.companycode;
    us.perimissionArray = user.perimissionArray;
    [[MPMCoreDataManager shareManager] saveToMainContext];
    return us;
}

+ (void)deleteWithShareUser:(MPMOauthUser *)user {
    NSString *modelName = NSStringFromClass([self class]);
    OauthUser *us = [self activeUser];
    if (!us) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:modelName];
        NSError *error;
        NSArray<OauthUser *> *userArray = [[MPMCoreDataManager shareManager].mainManagedObjectContext executeFetchRequest:request error:&error];
        if (error) {
            DLog(@"%@",error.localizedDescription);
        }
        us = userArray.firstObject;
    }
    if (us) {
        [[MPMCoreDataManager shareManager].mainManagedObjectContext deleteObject:us];
        [[MPMCoreDataManager shareManager] saveToMainContext];
    }
}

+ (OauthUser *)activeUser {
    NSString *modelName = NSStringFromClass([self class]);
    NSManagedObjectContext *context = [MPMCoreDataManager shareManager].mainManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:modelName];
    NSError *error;
    NSArray<OauthUser *> *userArray = [context executeFetchRequest:request error:&error];
    if (error) {
        DLog(@"%@",error.localizedDescription);
        return nil;
    }
    return userArray.firstObject;
}

@end
