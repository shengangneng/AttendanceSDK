//
//  OauthUser+CoreDataProperties.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//
//

#import "OauthUser+CoreDataProperties.h"

@implementation OauthUser (CoreDataProperties)

+ (NSFetchRequest<OauthUser *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"OauthUser"];
}

@dynamic access_token;
@dynamic company_code;
@dynamic company_id;
@dynamic companycode;
@dynamic department_id;
@dynamic department_ids;
@dynamic emp_num;
@dynamic employee_id;
@dynamic expires_in;
@dynamic login_name;
@dynamic name_cn;
@dynamic password;
@dynamic perimissionArray;
@dynamic refresh_token;
@dynamic scope;
@dynamic token_type;
@dynamic user_id;
@dynamic username;
@dynamic department_name;

@end
