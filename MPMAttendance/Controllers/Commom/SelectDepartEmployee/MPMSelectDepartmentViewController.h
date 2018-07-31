//
//  MPMSelectDepartmentViewController.h
//  MPMAtendence
//  选择部门-员工
//  Created by gangneng shen on 2018/4/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseViewController.h"
@class MPMDepartment;
@class MPMSchedulingDepartmentsModel;
@class MPMSchedulingEmplyoeeModel;

typedef void(^SelectCheckBlock)(NSString *status);
/** 点击底部的“确定”按钮，回传选中的部门和人员信息：Block和Delegate两种方式 */
typedef void(^SureSelectBlock)(NSArray<MPMSchedulingDepartmentsModel *> *departments, NSArray<MPMSchedulingEmplyoeeModel *> *employees);
typedef NS_ENUM(NSInteger, forSelectionType) {
    forSelectionTypeBoth,
    forSelectionTypeOnlyDepartment,
    forSelectionTypeOnlyEmployee
};

@protocol MPMSelectDepartmentViewControllerDelegate<NSObject>

/** 点击底部“确定”按钮，回传选中的部门和人员信息：Block和Delegate两种方式 */
- (void)departCompleteSelectWithDepartments:(NSArray<MPMSchedulingDepartmentsModel *> *)departments employees:(NSArray<MPMSchedulingEmplyoeeModel *> *)employees;

@end

@interface MPMSelectDepartmentViewController : MPMBaseViewController

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UISearchBar *headerSearchBar;
@property (nonatomic, weak) id<MPMSelectDepartmentViewControllerDelegate> delegate;
@property (nonatomic, copy) SureSelectBlock sureSelectBlock;

/**
 * model:第一次跳入传nil，之后每次跳入下一个都带入当前的model
 * headerTitles:第一次跳入带入[NSMutableArray arrayWithObject:@"部门"]，之后每次跳入叠加name
 * allStringData:从子到父类的链条id逗号分隔字符串，第一次跳入传@“”
 * block:选中某一行的时候把数据告诉前一个页面，第一次跳入传nil。
 */
- (instancetype)initWithModel:(MPMDepartment *)model headerButtonTitles:(NSMutableArray *)headerTitles allStringData:(NSString *)allStringData selectionType:(forSelectionType)selectionType selectCheckBlock:(SelectCheckBlock)block;

@end
