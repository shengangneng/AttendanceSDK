//
//  MPMSearchDepartViewController.h
//  MPMAtendence
//  部门、人员选择中的搜索功能
//  Created by gangneng shen on 2018/7/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMSelectDepartmentViewController.h"

typedef void(^SureSelectBlock)(NSArray<MPMSchedulingDepartmentsModel *> *departments, NSArray<MPMSchedulingEmplyoeeModel *> *employees);

@interface MPMSearchDepartViewController : MPMBaseViewController

@property (nonatomic, strong) UISearchBar *headerSearchBar;
@property (nonatomic, strong) UIImageView *headerView;

/** type:选择部门、选择人员、选择部门和人员 */
- (instancetype)initWithDelegate:(id<MPMSelectDepartmentViewControllerDelegate>)delegate sureSelectBlock:(SureSelectBlock)sureBlock selectType:(forSelectionType)type titleArray:(NSMutableArray *)titleArray;

@end
