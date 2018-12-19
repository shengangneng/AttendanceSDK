//
//  MPMDepartEmployeeHelper.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDepartEmployeeHelper.h"

static MPMDepartEmployeeHelper *shareHelper;
@implementation MPMDepartEmployeeHelper

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareHelper = [[MPMDepartEmployeeHelper alloc] init];
        shareHelper.departments = [NSMutableArray array];
        shareHelper.employees = [NSMutableArray array];
        shareHelper.classNeedCheckTransfer = NO;
    });
    return shareHelper;
}

#pragma mark - Getter
- (NSMutableArray<MPMDepartment *> *)employees {
    if (!_employees) {
        _employees = [NSMutableArray array];
    }
    return _employees;
}

- (NSMutableArray<MPMDepartment *> *)departments {
    if (!_departments) {
        _departments = [NSMutableArray array];
    }
    return _departments;
}

/** 部门的增加操作 */
- (void)departmentArrayAddDepartModel:(MPMDepartment *)dep {
    [shareHelper.departments addObject:dep];
}
/** 部门的删除操作-（需要移出下面的部门和员工） */
- (void)departmentArrayRemoveSub:(MPMDepartment *)dep {
    
    // 查找当前部门或者部门底下的部门并移除
    NSMutableArray *newDepart = [NSMutableArray arrayWithArray:shareHelper.departments.copy];
    [shareHelper.departments removeAllObjects];
    for (MPMDepartment *mo in newDepart) {
        BOOL canDelete = NO;
        if ([dep.mpm_id isEqualToString:mo.mpm_id] || [[mo.parentIds componentsSeparatedByString:@","] containsObject:dep.mpm_id]) {
            canDelete = YES;
        }
        if (!canDelete) {
            [shareHelper.departments addObject:mo];
        }
    }
    
    // 查找部门地下的员工并移除
    NSMutableArray *newEmp = [NSMutableArray arrayWithArray:shareHelper.employees.copy];
    [shareHelper.employees removeAllObjects];
    for (MPMDepartment *mo in newEmp) {
        BOOL canDelete = NO;
        // 如果员工的parentIds中包含这个部门的id，说明员工是这个部门里面的，需要删除这个员工
        // 有的人，没有parentIds！所以需要判断如果员工的parentId等于当前部门的id，需要删除这个员工
        if ([[mo.parentIds componentsSeparatedByString:@","] containsObject:dep.mpm_id] ||
            [mo.parentId isEqualToString:dep.mpm_id]) {
            canDelete = YES;
        }
        if (!canDelete) {
            [shareHelper.employees addObject:mo];
        }
    }
}

/** 员工的增加操作 */
- (void)employeeArrayAddDepartModel:(MPMDepartment *)dep {
    [shareHelper.employees addObject:dep];
}
/** 员工的删除操作 */
- (void)employeeArrayRemoveDepartModel:(MPMDepartment *)dep {
    [shareHelper.employees enumerateObjectsUsingBlock:^(MPMDepartment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.mpm_id isEqualToString:dep.mpm_id]) {
            [shareHelper.employees removeObject:obj];
        }
    }];
}

- (void)clearData {
    [shareHelper.departments removeAllObjects];
    [shareHelper.employees removeAllObjects];
    shareHelper.limitEmployeeCount = 0;
    shareHelper.limitEmployees = nil;
    shareHelper.limitEmployeeMessage = nil;
    shareHelper.classNeedCheckTransfer = NO;
    shareHelper.classId = nil;
}

@end
