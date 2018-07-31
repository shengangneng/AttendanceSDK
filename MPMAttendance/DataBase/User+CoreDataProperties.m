//
//  User+CoreDataProperties.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic companyId;
@dynamic departmentId;
@dynamic departmentName;
@dynamic employeeId;
@dynamic employeeName;
@dynamic perimissionArray;
@dynamic token;
@dynamic username;
@dynamic password;
@dynamic companyName;

@end
