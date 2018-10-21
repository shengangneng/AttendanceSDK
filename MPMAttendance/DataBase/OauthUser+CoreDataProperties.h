//
//  OauthUser+CoreDataProperties.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import "OauthUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OauthUser (CoreDataProperties)

+ (NSFetchRequest<OauthUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *access_token;
@property (nullable, nonatomic, copy) NSString *company_code;
@property (nullable, nonatomic, copy) NSString *company_id;
@property (nullable, nonatomic, copy) NSString *companycode;
@property (nullable, nonatomic, copy) NSString *department_id;
@property (nullable, nonatomic, copy) NSString *department_ids;
@property (nullable, nonatomic, copy) NSString *emp_num;
@property (nullable, nonatomic, copy) NSString *employee_id;
@property (nullable, nonatomic, copy) NSString *expires_in;
@property (nullable, nonatomic, copy) NSString *login_name;
@property (nullable, nonatomic, copy) NSString *name_cn;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSArray *perimissionArray;
@property (nullable, nonatomic, copy) NSString *refresh_token;
@property (nullable, nonatomic, copy) NSString *scope;
@property (nullable, nonatomic, copy) NSString *token_type;
@property (nullable, nonatomic, copy) NSString *user_id;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *department_name;

@end

NS_ASSUME_NONNULL_END
