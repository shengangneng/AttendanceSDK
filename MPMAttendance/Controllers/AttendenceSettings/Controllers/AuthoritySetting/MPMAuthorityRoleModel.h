//
//  MPMAuthorityRoleModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/9.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMAuthorityRoleModel : MPMBaseModel

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *mpm_id;   /** roleId:目前是写死的，kaoqin_admin为考勤管理人，kaoqin_stat为考勤统计员 */
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *name;

@end
