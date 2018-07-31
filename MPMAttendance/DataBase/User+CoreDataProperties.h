//
//  User+CoreDataProperties.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *companyId;
@property (nullable, nonatomic, copy) NSString *departmentId;
@property (nullable, nonatomic, copy) NSString *departmentName;
@property (nullable, nonatomic, copy) NSString *employeeId;
@property (nullable, nonatomic, copy) NSString *employeeName;
@property (nullable, nonatomic, copy) NSArray *perimissionArray;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *companyName;

@end

NS_ASSUME_NONNULL_END
