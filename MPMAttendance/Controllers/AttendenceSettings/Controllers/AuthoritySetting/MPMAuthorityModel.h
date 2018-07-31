//
//  MPMAuthorityModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMAuthorityModel : MPMBaseModel

@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *customnote;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userType;

@end
