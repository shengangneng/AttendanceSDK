//
//  MPMDepartment.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMBaseModel.h"

@interface MPMDepartment : MPMBaseModel

@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parent_ids;
@property (nonatomic, copy) NSString *isHuman;/** 有值或者为1就是human */
/** 选中状态：0或空或nil为未选中、1为全选中、2为部分选中 */
@property (nonatomic, copy) NSString *selectedStatus;

@end
