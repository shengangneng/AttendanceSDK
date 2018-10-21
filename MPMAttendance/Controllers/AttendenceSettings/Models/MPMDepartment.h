//
//  MPMDepartment.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMBaseModel.h"
#import "MPMObjListModel.h"

typedef NS_ENUM(NSInteger, SelectedStatus) {
    kSelectedStatusUnselected,  /** 未选中 */
    kSelectedStatusPartSelected,/** 部分选中 */
    kSelectedStatusAllSelected  /** 全选中 */
};

// 人员type和部门type
#define kUserType   @"user"
#define kOrgType    @"org"

@interface MPMDepartment : MPMBaseModel
// 自定义类型：isHuman用来把type转为isHuman
@property (nonatomic, assign) BOOL isHuman;
@property (nonatomic, assign) SelectedStatus selectedStatus;/** 选中状态 */

@property (nonatomic, copy) NSString *mpm_id;       /** 部门和人员都是用这个参数 */
@property (nonatomic, copy) NSString *employeeId;   /** 目前这个参数没有什么用 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *parentIds;    /** 长的字符串 */
@property (nonatomic, copy) NSString *type;         /** 部门为org，人员为user */

/** 自身的数据转为MPMObjListModel数据 */
- (MPMObjListModel *)translateToObjectList;

@end
