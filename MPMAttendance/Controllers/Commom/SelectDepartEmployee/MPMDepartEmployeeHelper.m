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
        shareHelper.allStringData = [NSMutableArray array];
        shareHelper.allArrayData = [NSMutableArray array];
    });
    return shareHelper;
}

- (void)dealingAllStringData {
    [shareHelper.allArrayData removeAllObjects];
    for (int i = 0; i < shareHelper.allStringData.count; i++) {
        if ([shareHelper.allStringData[i] hasPrefix:@"-1,"]) {
            shareHelper.allStringData[i] = [shareHelper.allStringData[i] substringFromIndex:3];
        }
        NSArray *arr = [shareHelper.allStringData[i] componentsSeparatedByString:@","];
        [shareHelper.allArrayData addObject:arr];
    }
}

- (void)allStringDataRemoveSubOfId:(NSString *)string {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:shareHelper.allStringData.copy];
    [shareHelper.allStringData removeAllObjects];
    for (NSString *str in temp) {
        if (![str hasPrefix:string]) {
            [shareHelper.allStringData addObject:str];
        }
    }
}

/** 部门的增加操作 */
- (void)departmentArrayAddDepartModel:(MPMDepartment *)dep {
    MPMSchedulingDepartmentsModel *depart = [[MPMSchedulingDepartmentsModel alloc] init];
    depart.departmentId = dep.mpm_id;
    depart.departmentName = dep.name;
    depart.parentsId = dep.parent_ids;
    [shareHelper.departments addObject:depart];
}
/** 部门的删除操作-（需要移出下面的部门和员工） */
- (void)departmentArrayRemoveSub:(MPMDepartment *)dep {
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSArray *arr in shareHelper.allArrayData) {
        if ([arr containsObject:dep.mpm_id]) {
            [temp addObject:arr.lastObject];
        }
    }
    
    // 当前部门和部门下的子部门都需要取消选中
    NSMutableArray *newDepart = [NSMutableArray arrayWithArray:shareHelper.departments.copy];
    [shareHelper.departments removeAllObjects];
    for (MPMSchedulingDepartmentsModel *mo in newDepart) {
        BOOL canDelete = NO;
        if ([dep.mpm_id isEqualToString:mo.departmentId] || [[mo.parentsId componentsSeparatedByString:@","] containsObject:dep.mpm_id]) {
            canDelete = YES;
        }
        if (!canDelete) {
            [shareHelper.departments addObject:mo];
        }
    }
    
    NSMutableArray *newEmp = [NSMutableArray arrayWithArray:shareHelper.employees.copy];
    [shareHelper.employees removeAllObjects];
    for (MPMSchedulingEmplyoeeModel *mo in newEmp) {
        BOOL canDelete = NO;
        if ([[mo.parentsId componentsSeparatedByString:@","] containsObject:dep.mpm_id]) {
            canDelete = YES;
        }
        if (!canDelete) {
            [shareHelper.employees addObject:mo];
        }
    }
}

/** 员工的增加操作 */
- (void)employeeArrayAddDepartModel:(MPMDepartment *)dep {
    MPMSchedulingEmplyoeeModel *emp = [[MPMSchedulingEmplyoeeModel alloc] init];
    emp.employeeId = dep.mpm_id;
    emp.employeeName = dep.name;
    emp.parentsId = dep.parent_ids;
    [shareHelper.employees addObject:emp];
}
/** 员工的删除操作 */
- (void)employeeArrayRemoveDepartModel:(MPMDepartment *)dep {
    [shareHelper.employees enumerateObjectsUsingBlock:^(MPMSchedulingEmplyoeeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.employeeId isEqualToString:dep.mpm_id]) {
            [shareHelper.employees removeObject:obj];
        }
    }];
}

- (void)clearData {
    [shareHelper.departments removeAllObjects];
    [shareHelper.employees removeAllObjects];
    [shareHelper.allStringData removeAllObjects];
    [shareHelper.allArrayData removeAllObjects];
}

@end
