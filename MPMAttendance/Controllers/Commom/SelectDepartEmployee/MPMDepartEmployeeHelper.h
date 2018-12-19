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
// 现在不能选择某些人
@property (nonatomic, assign) NSInteger limitEmployeeCount;                 /** 限制选择人数 */
@property (nonatomic, copy) NSArray<MPMDepartment *> *limitEmployees;       /** 限制不能选的人 */
@property (nonatomic, copy) NSString *limitEmployeeMessage;                 /** 限制不能选择人时候的提示 */

@property (nonatomic, assign) BOOL classNeedCheckTransfer;                  /** 需要检查排班是否做人员迁移 */
@property (nonatomic, copy) NSString *classId;                              /** 排班id：选择人员的时候，如果有排班id，需要调用接口看是否转移 */

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
