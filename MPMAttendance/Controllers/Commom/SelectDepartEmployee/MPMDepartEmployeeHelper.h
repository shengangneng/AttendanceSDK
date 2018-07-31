//
//  MPMDepartEmployeeHelper.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMSchedulingDepartmentsModel.h"
#import "MPMSchedulingEmplyoeeModel.h"
#import "MPMDepartment.h"

@interface MPMDepartEmployeeHelper : NSObject


@property (nonatomic, strong) NSMutableArray<MPMSchedulingDepartmentsModel *> *departments;
@property (nonatomic, strong) NSMutableArray<MPMSchedulingEmplyoeeModel *> *employees;

@property (nonatomic, strong) NSMutableArray<NSString *> *allStringData;
@property (nonatomic, strong) NSMutableArray<NSArray *> *allArrayData;

+ (instancetype)shareInstance;

/** 去掉allStringData里面数据的'-1,'，并且转成数组存起来 */
- (void)dealingAllStringData;

/** allStringData移出之下的所有对象 */
- (void)allStringDataRemoveSubOfId:(NSString *)string;

/** 部门的增加操作 */
- (void)departmentArrayAddDepartModel:(MPMDepartment *)dep;
/** 部门的删除操作-删除部门和里面的员工 */
- (void)departmentArrayRemoveSub:(MPMDepartment *)dep;

/** 员工的增加操作 */
- (void)employeeArrayAddDepartModel:(MPMDepartment *)dep;
/** 员工的删除操作 */
- (void)employeeArrayRemoveDepartModel:(MPMDepartment *)dep;


/** 清空所有数据 */
- (void)clearData;

@end
