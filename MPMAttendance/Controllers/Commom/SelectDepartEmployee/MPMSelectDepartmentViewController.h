//
//  MPMSelectDepartmentViewController.h
//  MPMAtendence
//  选择部门-员工
//  Created by gangneng shen on 2018/4/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseViewController.h"
#import "MPMDepartment.h"

typedef void(^ComfirmBlock)(SelectedStatus selectedStatus);

/** 点击底部的“确定”按钮，回传选中的部门和人员信息：Block和Delegate两种方式 */
typedef void(^SureSelectBlock)(NSArray<MPMDepartment *> *departments, NSArray<MPMDepartment *> *employees);
typedef NS_ENUM(NSInteger, SelectionType) {
    kSelectionTypeBoth,           /** 可以选择人员和部门 */
    kSelectionTypeOnlyDepartment, /** 只可以选中部门 */
    kSelectionTypeOnlyEmployee    /** 只可以选择人员 */
};

@protocol MPMSelectDepartmentViewControllerDelegate<NSObject>

/** 点击底部“确定”按钮，回传选中的部门和人员信息：Block和Delegate两种方式 */
- (void)departCompleteSelectWithDepartments:(NSArray<MPMDepartment *> *)departments employees:(NSArray<MPMDepartment *> *)employees;

@end

@interface MPMSelectDepartmentViewController : MPMBaseViewController

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UISearchBar *headerSearchBar;
@property (nonatomic, weak) id<MPMSelectDepartmentViewControllerDelegate> delegate;
@property (nonatomic, copy) SureSelectBlock sureSelectBlock;

/**
 * @param model         第一次跳入传nil，之后每次跳入下一个都带入当前的model
 * @param headerTitles  第一次跳入带入[NSMutableArray arrayWithObject:@"部门"]，之后每次跳入叠加name
 * @param block         选中某一行的时候把数据告诉前一个页面，第一次跳入传nil。
 */
- (instancetype)initWithModel:(MPMDepartment *)model headerButtonTitles:(NSMutableArray *)headerTitles selectionType:(SelectionType)selectionType comfirmBlock:(ComfirmBlock)block;

@end
