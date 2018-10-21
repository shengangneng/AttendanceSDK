//
//  MPMSearchDepartViewController.h
//  MPMAtendence
//  部门、人员选择中的搜索功能
//  Created by gangneng shen on 2018/7/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMSelectDepartmentViewController.h"

typedef void(^SureSelectBlock)(NSArray<MPMDepartment *> *departments, NSArray<MPMDepartment *> *employees);

@interface MPMSearchDepartViewController : MPMBaseViewController

@property (nonatomic, strong) UISearchBar *headerSearchBar;
@property (nonatomic, strong) UIImageView *headerView;

/**
 * @param selectionType 选择类型：部门+人员、只能部门、只能人员
 */
- (instancetype)initWithDelegate:(id<MPMSelectDepartmentViewControllerDelegate>)delegate sureSelectBlock:(SureSelectBlock)sureBlock selectionType:(SelectionType)selectionType titleArray:(NSMutableArray *)titleArray;

@end
