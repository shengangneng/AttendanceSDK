//
//  MPMGetPeopleModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMGetPeopleModel : MPMBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSString *isHuman;  /** 0是部门 1是人员 */

@end
