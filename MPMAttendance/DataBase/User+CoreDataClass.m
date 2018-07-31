//
//  User+CoreDataClass.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import "User+CoreDataClass.h"
#import "MPMCoreDataManager.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>

@implementation User

+ (instancetype)insertWithShareUser:(MPMShareUser *)user {
    NSString *modelName = NSStringFromClass([self class]);
    User *us = [self activeUser];
    if (!us) {
        us = [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:[MPMCoreDataManager shareManager].mainManagedObjectContext];
    }
    us.companyId = user.companyId;
    us.departmentId = user.departmentId;
    us.departmentName = user.departmentName;
    us.employeeId = user.employeeId;
    us.employeeName = user.employeeName;
    us.token = user.token;
    us.perimissionArray = user.perimissionArray;
    us.username = user.username;
    us.password = user.password;
    us.companyName = user.companyName;
    [[MPMCoreDataManager shareManager] saveToMainContext];
    return us;
}

+ (void)deleteWithShareUser:(MPMShareUser *)user {
    NSString *modelName = NSStringFromClass([self class]);
    User *us = [self activeUser];
    if (!us) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:modelName];
        NSError *error;
        NSArray<User *> *userArray = [[MPMCoreDataManager shareManager].mainManagedObjectContext executeFetchRequest:request error:&error];
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

+ (User *)activeUser {
    NSString *modelName = NSStringFromClass([self class]);
    NSManagedObjectContext *context = [MPMCoreDataManager shareManager].mainManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:modelName];
    NSError *error;
    NSArray<User *> *userArray = [context executeFetchRequest:request error:&error];
    if (error) {
        DLog(@"%@",error.localizedDescription);
        return nil;
    }
    return userArray.firstObject;
}

/*
+ (NSArray *)allUsers {
    NSString *modelName = NSStringFromClass([self class]);
    Class modelClass =  NSClassFromString(modelName);
    NSManagedObjectContext *context = [MPMCoreDataManager shareManager].mainManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:modelName
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *enityArray = [context executeFetchRequest:request error:&error];
    
    const char * createDate = [@"createDate" UTF8String];
    objc_property_t property = class_getProperty(modelClass, createDate);
    
    if (property != NULL && property !=nil) {
        NSSortDescriptor *createDate = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
        enityArray = [enityArray sortedArrayUsingDescriptors:@[createDate]];
    }
    
    return enityArray;
}
*/


@end
