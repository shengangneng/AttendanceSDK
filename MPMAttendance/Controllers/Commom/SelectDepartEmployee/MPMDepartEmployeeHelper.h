//
//  MPMDepartEmployeeHelper.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMDepartment.h"

@interface MPMDepartEmployeeHelper : NSObject


@property (nonatomic, strong) NSMutableArray<MPMDepartment *> *departments; /** 保存选中的部门 */
@property (nonatomic, strong) NSMutableArray<MPMDepartment *> *employees;   /** 保存选中的人员 */
@property (nonatomic, assign) NSInteger limitEmployeeCount;                 /** 限制选中的人员数 */

+ (instancetype)shareInstance;

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
