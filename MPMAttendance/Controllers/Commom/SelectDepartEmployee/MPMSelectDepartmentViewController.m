//
//  MPMSelectDepartmentViewController.m
//  MPMAtendence
//  选择部门-员工
//  Created by gangneng shen on 2018/4/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSelectDepartmentViewController.h"
#import "MPMButton.h"
#import "MPMHTTPSessionManager.h"
#import "MPMShareUser.h"
#import "MPMSelectDepartmentTableViewCell.h"
#import "MPMDepartEmployeeHelper.h"
#import "MPMHiddenTableViewDataSourceDelegate.h"
#import "MPMGetPeopleModel.h"
#import "MPMSearchDepartViewController.h"
#import "MPMSearchPushAnimate.h"
#import "MPMOauthUser.h"

#define MagicNumber 999

@interface MPMSelectDepartmentViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MPMHiddenTabelViewDelegate, UINavigationControllerDelegate>
// header
@property (nonatomic, strong) UIScrollView *headerPeopleScrollView;
// middle
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *tableHeaderIcon;
@property (nonatomic, strong) UILabel *tableHeaderLabel;
@property (nonatomic, strong) UITableView *tableView;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *bottomTotalSelectedLabel;
@property (nonatomic, strong) UIButton *bottomSureButton;
// 当点击底部的弹出按钮时，顶部也会弹下一个遮盖视图
@property (nonatomic, strong) UIView *headerHiddenMaskView;
@property (nonatomic, strong) UIButton *bottomUpButton;
@property (nonatomic, strong) UIView *bottomHiddenView;
@property (nonatomic, strong) UITableView *bottomHiddenTableView;
// data
@property (nonatomic, copy) NSArray<MPMDepartment *> *departsArray;     /** 从接口获取到的所有的部门和人员列表 */
@property (nonatomic, strong) MPMDepartment *model;                     /** 记录从上一层传入的model */
@property (nonatomic, strong) NSMutableArray *headerButtonTitlesArray;  /** 上一层传入的顶部按钮 */
@property (nonatomic, strong) NSMutableArray *allSelectedIndexArray;    /** 记录全部选中的indexPath */
@property (nonatomic, strong) NSMutableArray *partSelectedIndexArray;   /** 记录部分选中的indexPath */
@property (nonatomic, copy) ComfirmBlock comfirmBlock;                  /** 确定按钮 */
@property (nonatomic, assign) SelectionType selectionType;              /** 限制可以选择部门人员、部门only、人员only */
@property (nonatomic, strong) MPMHiddenTableViewDataSourceDelegate *dataSourceDelegate;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;            /** 每次跳入下一层级，记录当前点击的indexPath */

@end

@implementation MPMSelectDepartmentViewController

- (instancetype)initWithModel:(MPMDepartment *)model headerButtonTitles:(NSMutableArray *)headerTitles selectionType:(SelectionType)selectionType comfirmBlock:(ComfirmBlock)block {
    self = [super init];
    if (self) {
        self.selectionType = selectionType;
        self.comfirmBlock = block;
        self.model = model;
        self.headerButtonTitlesArray = [NSMutableArray arrayWithArray:headerTitles.copy];
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
        if (1 == headerTitles.count) {
            [self firstInToCalculateParentIds];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.delegate = self;
    [self calculateSelect];
    self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"已选 (%ld) ",[MPMDepartEmployeeHelper shareInstance].employees.count+[MPMDepartEmployeeHelper shareInstance].departments.count];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (self.navigationController.delegate == self) {
//        self.navigationController.delegate = nil;
//    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[MPMSearchDepartViewController class]]) {
        return [[MPMSearchPushAnimate alloc] init];
    } else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataV2];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.view.backgroundColor = kTableViewBGColor;
    if (self.selectionType == kSelectionTypeOnlyEmployee) {
        self.navigationItem.title = @"选择人员";
        self.headerSearchBar.placeholder = @"搜索人员";
    } else if (self.selectionType == kSelectionTypeOnlyDepartment) {
        self.navigationItem.title = @"选择部门";
        self.headerSearchBar.placeholder = @"搜索部门";
    } else {
        self.navigationItem.title = @"选择部门或人员";
        self.headerSearchBar.placeholder = @"搜索部门或人员";
    }
    self.allSelectedIndexArray = [NSMutableArray array];
    self.partSelectedIndexArray = [NSMutableArray array];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.headerHiddenMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)]];
    [self.bottomUpButton addTarget:self action:@selector(popUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomSureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.headerSearchBar];
    [self.view addSubview:self.headerPeopleScrollView];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomHiddenView];
    [self.bottomHiddenView addSubview:self.bottomHiddenTableView];
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.headerHiddenMaskView];
    [self.view addSubview:self.bottomUpButton];
    [self.bottomView addSubview:self.bottomSureButton];
    [self.bottomView addSubview:self.bottomTotalSelectedLabel];
    [self.bottomView addSubview:self.bottomLine];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    [self.headerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.view.mpm_leading);
        make.top.equalTo(self.view.mpm_top);
        make.trailing.equalTo(self.view.mpm_trailing);
        make.height.equalTo(@(52));
    }];
    
    [self.headerSearchBar mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerView.mpm_leading);
        make.trailing.equalTo(self.headerView.mpm_trailing);
        make.bottom.equalTo(self.headerView.mpm_bottom);
        make.top.equalTo(self.headerView.mpm_top);
    }];
    
    // 创建ScrollView和里面的按钮，并设置约束
    UIButton *preBtn;
    
    for (int i = 0; i < self.headerButtonTitlesArray.count; i++) {
        NSString *title;
        UIColor *titleColor;
        if (i == self.headerButtonTitlesArray.count - 1) {
            title = self.headerButtonTitlesArray[i];
            titleColor = kMainLightGray;
        } else {
            title = [NSString stringWithFormat:@"%@ >",self.headerButtonTitlesArray[i]];
            titleColor = kMainBlueColor;
        }
        UIButton *btn = [MPMButton normalButtonWithTitle:title titleColor:titleColor bgcolor:kTableViewBGColor];
        btn.titleLabel.font = SystemFont(15);
        btn.tag = i + MagicNumber;
        [btn sizeToFit];
        [btn addTarget:self action:@selector(popToPreVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerPeopleScrollView addSubview:btn];
        if (i == 0) {
            [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.centerY.equalTo(self.headerPeopleScrollView.mpm_centerY);
                make.leading.equalTo(self.headerPeopleScrollView.mpm_leading).offset(10);
            }];
        } else if (i == self.headerButtonTitlesArray.count - 1) {
            [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.centerY.equalTo(self.headerPeopleScrollView.mpm_centerY);
                make.leading.equalTo(preBtn.mpm_trailing).offset(5);
                make.trailing.equalTo(self.headerPeopleScrollView.mpm_trailing).offset(-10);
            }];
        } else {
            [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.centerY.equalTo(self.headerPeopleScrollView.mpm_centerY);
                make.leading.equalTo(preBtn.mpm_trailing).offset(5);
            }];
        }
        preBtn = btn;
    }
    [self.headerPeopleScrollView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.view.mpm_leading);
        make.trailing.equalTo(self.view.mpm_trailing);
        make.height.equalTo(@40);
        make.top.equalTo(self.headerView.mpm_bottom);
    }];
    
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerPeopleScrollView.mpm_bottom);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomTotalSelectedLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
        make.leading.equalTo(self.bottomView.mpm_leading).offset(15);
        make.trailing.equalTo(self.bottomSureButton.mpm_leading).offset(-15);
    }];
    [self.bottomSureButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-15);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
        make.width.equalTo(@(88.5));
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
    }];
    
    [self.bottomUpButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mpm_top);
        make.centerX.equalTo(self.bottomView.mpm_centerX);
        make.height.equalTo(@(34));
        make.width.equalTo(@(86));
    }];
    [self.bottomHiddenView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.bottomUpButton.mpm_bottom);
        make.height.equalTo(@300);
    }];
    [self.headerHiddenMaskView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(kScreenHeight - 300));
        make.bottom.equalTo(self.view.mpm_top).offset(-kNavigationHeight);
    }];
    [self.bottomHiddenTableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.bottomHiddenView);
    }];
}

- (void)getDataV2 {
    NSString *orgId = self.model ? self.model.mpm_id : @"-1";
    NSString *url = [NSString stringWithFormat:@"%@%@?companyId=%@&companyCode=%@&orgId=%@",MPMINTERFACE_EMDM,MPMINTERFACE_EMDM_MIX_FINDBYORGID,[MPMOauthUser shareOauthUser].company_id,[MPMOauthUser shareOauthUser].company_code,orgId];
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]] && ((NSArray *)response[kResponseObjectKey]).count > 0) {
            NSArray *object = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:object.count];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                MPMDepartment *depart = [[MPMDepartment alloc] initWithDictionary:dic];
                depart.isHuman = [depart.type isEqualToString:kUserType];
                /*
                if (kIsNilString(depart.parentIds) && depart.isHuman && !kIsNilString(depart.employeeId)) {
                    // 如果人员的parentIds为空，则把人员上一级（部门）的parentIds拼上当前员工的employeeId即为员工的parentIds
                    depart.parentIds = [self.model.parentIds stringByAppendingString:[NSString stringWithFormat:@",%@",depart.employeeId]];
                }*/
                [temp addObject:depart];
            }
            self.departsArray = temp.copy;
            [self calculateSelect];
            self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"已选 (%ld) ",[MPMDepartEmployeeHelper shareInstance].employees.count+[MPMDepartEmployeeHelper shareInstance].departments.count];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

/** 第一次进入人员选择器，如果带入了相应的人员或部门，则通过调用接口计算parentIds */
- (void)firstInToCalculateParentIds {
    if (0 == [MPMDepartEmployeeHelper shareInstance].departments.count && 0 == [MPMDepartEmployeeHelper shareInstance].employees.count) {
        return;
    } else {
        dispatch_group_t group = dispatch_group_create();
        // 查询人员的parentIds
        for (int i = 0; i < [MPMDepartEmployeeHelper shareInstance].employees.count; i++) {
            MPMDepartment *emp = [MPMDepartEmployeeHelper shareInstance].employees[i];
            dispatch_group_enter(group);
            dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
                NSString *url = [NSString stringWithFormat:@"%@%@?keyWord=%@&companyCode=%@",MPMINTERFACE_EMDM,MPMINTERFACE_EMDM_MIX_FINDBYKEYWORD,emp.name,[MPMOauthUser shareOauthUser].company_code];
                NSString *encodingUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                [[MPMSessionManager shareManager] postRequestWithURL:encodingUrl setAuth:YES params:nil loadingMessage:@"正在搜索" success:^(id response) {
                    if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                        NSArray *object = response[kResponseObjectKey];
                        for (int i = 0; i < object.count; i++) {
                            NSDictionary *dic = object[i];
                            MPMDepartment *depart = [[MPMDepartment alloc] initWithDictionary:dic];
                            depart.isHuman = [depart.type isEqualToString:kUserType];
                            if ([depart.mpm_id isEqualToString:emp.mpm_id]) {
                                emp.parentIds = depart.parentIds;
                            }
                        }
                    }
                    dispatch_group_leave(group);
                } failure:^(NSString *error) {
                    DLog(@"%@",error);
                    dispatch_group_leave(group);
                }];
            });
        }
        // 查询部门的parentIds
        for (int i = 0; i < [MPMDepartEmployeeHelper shareInstance].departments.count; i++) {
            MPMDepartment *dep = [MPMDepartEmployeeHelper shareInstance].departments[i];
            dispatch_group_enter(group);
            dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
                NSString *url = [NSString stringWithFormat:@"%@%@?keyWord=%@&companyCode=%@",MPMINTERFACE_EMDM,MPMINTERFACE_EMDM_MIX_FINDBYKEYWORD,dep.name,[MPMOauthUser shareOauthUser].company_code];
                NSString *encodingUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                [[MPMSessionManager shareManager] postRequestWithURL:encodingUrl setAuth:YES params:nil loadingMessage:@"正在搜索" success:^(id response) {
                    if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                        NSArray *object = response[kResponseObjectKey];
                        for (int i = 0; i < object.count; i++) {
                            NSDictionary *dic = object[i];
                            MPMDepartment *depart = [[MPMDepartment alloc] initWithDictionary:dic];
                            depart.isHuman = [depart.type isEqualToString:kUserType];
                            if ([depart.mpm_id isEqualToString:dep.mpm_id]) {
                                dep.parentIds = depart.parentIds;
                            }
                        }
                    }
                    dispatch_group_leave(group);
                } failure:^(NSString *error) {
                    DLog(@"%@",error);
                    dispatch_group_leave(group);
                }];
            });
        }
        dispatch_group_notify(group, kMainQueue, ^{
            [self calculateSelect];
        });
    }
}

// 通过[MPMDepartEmployeeHelper shareInstance].allArrayData数组来决定哪些已选中和哪些未选中
- (void)calculateSelect {
    // 查找全选和部分选中
    [self.allSelectedIndexArray removeAllObjects];
    [self.partSelectedIndexArray removeAllObjects];
    for (int i = 0; i < self.departsArray.count;i++) {
        MPMDepartment *model = self.departsArray[i];
        BOOL allSelect = NO;
        BOOL partSelect = NO;
        for (MPMDepartment *eee in [MPMDepartEmployeeHelper shareInstance].employees) {
            if (model.isHuman) {
                if ([eee.mpm_id isEqualToString:model.mpm_id]) {
                    allSelect = YES;
                }
            } else {
                if ([[eee.parentIds componentsSeparatedByString:@","] containsObject:model.mpm_id] || [eee.parentId isEqualToString:model.mpm_id]) {
                    partSelect = YES;
                }
            }
        }
        for (MPMDepartment *ddd in [MPMDepartEmployeeHelper shareInstance].departments) {
            if ([ddd.mpm_id isEqualToString:model.mpm_id]) {
                allSelect = YES;
            }
            if ([[ddd.parentIds componentsSeparatedByString:@","] containsObject:model.mpm_id]) {
                partSelect = YES;
            }
        }
        if (allSelect) {
            self.departsArray[i].selectedStatus = kSelectedStatusAllSelected;
            [self.allSelectedIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        } else if (partSelect) {
            self.departsArray[i].selectedStatus = kSelectedStatusPartSelected;
            [self.partSelectedIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        } else {
            self.departsArray[i].selectedStatus = kSelectedStatusUnselected;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure:(UIButton *)sender {
    // 拿到需要的数据，跳回最初的页面
    if ([MPMDepartEmployeeHelper shareInstance].departments.count == 0 && [MPMDepartEmployeeHelper shareInstance].employees.count == 0) {
        [self showAlertControllerToLogoutWithMessage:@"请选择部门或员工" sureAction:nil needCancleButton:NO];
        return;
    }
    if ([MPMDepartEmployeeHelper shareInstance].employees.count > 0 && [MPMDepartEmployeeHelper shareInstance].limitEmployeeCount > 0 && [MPMDepartEmployeeHelper shareInstance].employees.count > [MPMDepartEmployeeHelper shareInstance].limitEmployeeCount) {
        [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"最多只能选择%ld人",[MPMDepartEmployeeHelper shareInstance].limitEmployeeCount] sureAction:nil needCancleButton:NO];
        return;
    }
    // 使用Delegate的方式回传数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(departCompleteSelectWithDepartments:employees:)]) {
        [self.delegate departCompleteSelectWithDepartments:[MPMDepartEmployeeHelper shareInstance].departments.copy employees:[MPMDepartEmployeeHelper shareInstance].employees.copy];
    }
    // 使用Block的方式回传数据
    if (self.sureSelectBlock) {
        self.sureSelectBlock([MPMDepartEmployeeHelper shareInstance].departments.copy, [MPMDepartEmployeeHelper shareInstance].employees.copy);
    }
    [[MPMDepartEmployeeHelper shareInstance] clearData];
    // 跳回第一个进入选择部门的页面。
    UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1-self.headerButtonTitlesArray.count];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)popToPreVC:(UIButton *)sender {
    // 跳回指定页面
    NSInteger btnIndex = self.headerButtonTitlesArray.count - (sender.tag - MagicNumber);
    NSInteger index = self.navigationController.viewControllers.count - btnIndex;
    UIViewController *vc = self.navigationController.viewControllers[index];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)popUp:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSMutableArray *temp = [NSMutableArray array];
    for (MPMDepartment *dep in [MPMDepartEmployeeHelper shareInstance].departments) {
        MPMGetPeopleModel *model = [[MPMGetPeopleModel alloc] init];
        model.name = dep.name;
        model.mpm_id = dep.mpm_id;
        model.isHuman = @"0";
        [temp addObject:model];
    }
    for (MPMDepartment *emp in [MPMDepartEmployeeHelper shareInstance].employees) {
        MPMGetPeopleModel *model = [[MPMGetPeopleModel alloc] init];
        model.name = emp.name;
        model.mpm_id = emp.mpm_id;
        model.isHuman = @"1";
        [temp addObject:model];
    }
    self.dataSourceDelegate.peoplesArray = temp;
    [self.bottomHiddenTableView reloadData];
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomUpButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.bottom.equalTo(self.bottomView.mpm_top).offset(-300);
                make.centerX.equalTo(self.bottomView.mpm_centerX);
                make.height.equalTo(@(34));
                make.width.equalTo(@(86));
            }];
            [self.headerHiddenMaskView mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@(kScreenHeight - 300));
                make.bottom.equalTo(self.view.mpm_top).offset(kScreenHeight - 300 - kNavigationHeight - BottomViewHeight);
            }];
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomUpButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.bottom.equalTo(self.bottomView.mpm_top);
                make.centerX.equalTo(self.bottomView.mpm_centerX);
                make.height.equalTo(@(34));
                make.width.equalTo(@(86));
            }];
            [self.headerHiddenMaskView mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@(kScreenHeight - 300));
                make.bottom.equalTo(self.view.mpm_top).offset(-kNavigationHeight);
            }];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)hide:(UITapGestureRecognizer *)gesture {
    self.bottomUpButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomUpButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mpm_top);
            make.centerX.equalTo(self.bottomView.mpm_centerX);
            make.height.equalTo(@(34));
            make.width.equalTo(@(86));
        }];
        [self.headerHiddenMaskView mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@(kScreenHeight - 300));
            make.bottom.equalTo(self.view.mpm_top).offset(-kNavigationHeight);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)selectAll:(UITapGestureRecognizer *)gesture {
    // 全选功能
    [self showAlertControllerToLogoutWithMessage:@"全选功能还在完善中" sureAction:nil needCancleButton:NO];
}

#pragma mark - MPMHiddenTabelViewDelegate
- (void)hiddenTableView:(UITableView *)tableView deleteData:(MPMGetPeopleModel *)people {
    [self.dataSourceDelegate.peoplesArray removeObject:people];
    [self.bottomHiddenTableView reloadData];
    
    MPMDepartment *depart = [[MPMDepartment alloc] init];
    depart.mpm_id = people.mpm_id;
    depart.name = people.name;
    depart.isHuman = people.isHuman;
    if (people.isHuman) {
        [[MPMDepartEmployeeHelper shareInstance] employeeArrayRemoveDepartModel:depart];
    } else {
        [[MPMDepartEmployeeHelper shareInstance] departmentArrayRemoveSub:depart];
    }
    
    // 筛选出哪些是本页取消选中的
    for (int i = 0; i < self.departsArray.count; i++) {
        MPMDepartment *mo = self.departsArray[i];
        if ([mo.mpm_id isEqualToString:people.mpm_id]) {
            self.departsArray[i].selectedStatus = kSelectedStatusUnselected;
            [self.allSelectedIndexArray removeObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    // 传递回去上个页面
    if (self.allSelectedIndexArray.count == self.departsArray.count) {
        // 如果已经是全选了-传回status
        if (self.comfirmBlock) {
            self.comfirmBlock(kSelectedStatusAllSelected);
        }
    } else if (self.allSelectedIndexArray.count == 0 && self.partSelectedIndexArray.count == 0) {
        // 如果一个都没选中-传回status
        if (self.comfirmBlock) {
            self.comfirmBlock(kSelectedStatusUnselected);
        }
    } else {
        // 如果部分选中-传回status
        if (self.comfirmBlock) {
            self.comfirmBlock(kSelectedStatusPartSelected);
        }
    }
    
    self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"已选 (%ld) ",[MPMDepartEmployeeHelper shareInstance].employees.count+[MPMDepartEmployeeHelper shareInstance].departments.count];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.departsArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DepartmentCell";
    MPMSelectDepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMSelectDepartmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier selectionType:self.selectionType];
    }
    MPMDepartment *depart = self.departsArray[indexPath.row];
    cell.isHuman = depart.isHuman;
    if (cell.isHuman) {
        cell.roundPeopleView.nameLabel.text = depart.name.length > 2 ? [depart.name substringFromIndex:depart.name.length-2] : depart.name;
        [cell.roundPeopleView setNeedsDisplay];
    }
    if (depart.selectedStatus == kSelectedStatusAllSelected) {
        cell.checkIconImage.image = ImageName(@"setting_all");
    } else if (depart.selectedStatus == kSelectedStatusPartSelected) {
        cell.checkIconImage.image = ImageName(@"setting_some");
    } else {
        cell.checkIconImage.image = ImageName(@"setting_none");
    }
    
    // 点击了选中按钮（并非全选按钮）
    __weak typeof(self) weakself = self;
    cell.checkImageBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        SelectedStatus preStatus = ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus;// 取出之前的状态
        if (preStatus == kSelectedStatusAllSelected) {
            // 如果之前为全选，则变为不选中
            ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = kSelectedStatusUnselected;
            [strongself.allSelectedIndexArray removeObject:indexPath];
            // 如果是员工，需要移出。如果是部门，需要移除部门内所有内容
            if (depart.isHuman) {
                // 如果是员工，则直接移除
                [[MPMDepartEmployeeHelper shareInstance] employeeArrayRemoveDepartModel:depart];
            } else {
                // 如果是部门，需要移除部门下面的全部内容
                [[MPMDepartEmployeeHelper shareInstance] departmentArrayRemoveSub:depart];
            }
        } else if (preStatus == kSelectedStatusPartSelected) {
            // 如果之前为部分选中，则变为不选中
            ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = kSelectedStatusUnselected;
            [strongself.partSelectedIndexArray removeObject:indexPath];
            if (depart.isHuman) {
                // 不可能是人员
            } else {
                // 如果是部门-其实是删除里面的员工
                [[MPMDepartEmployeeHelper shareInstance] departmentArrayRemoveSub:depart];
            }
        } else if (depart.isHuman && [MPMDepartEmployeeHelper shareInstance].limitEmployees.count > 0) {
            // 如果选中的是员工，有限制选中的员工
            BOOL canPass = YES;
            for (int i = 0; i < [MPMDepartEmployeeHelper shareInstance].limitEmployees.count; i++) {
                MPMDepartment *limE = [MPMDepartEmployeeHelper shareInstance].limitEmployees[i];
                if ([limE.mpm_id isEqualToString:depart.mpm_id]) {
                    canPass = NO;
                    break;
                }
            }
            if (canPass) {
                ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = kSelectedStatusAllSelected;
                [strongself.allSelectedIndexArray addObject:indexPath];
                if (depart.isHuman) {
                    [[MPMDepartEmployeeHelper shareInstance] employeeArrayAddDepartModel:depart];
                } else {
                    [[MPMDepartEmployeeHelper shareInstance] departmentArrayAddDepartModel:depart];
                }
            } else {
                NSString *limitMessage = kIsNilString([MPMDepartEmployeeHelper shareInstance].limitEmployeeMessage) ? @"不允许选择此员工" : [MPMDepartEmployeeHelper shareInstance].limitEmployeeMessage;
                [strongself showAlertControllerToLogoutWithMessage:limitMessage sureAction:nil needCancleButton:NO];
            }
        } else {
            // 如果之前为不选中，则变为全选
            if (strongself.selectionType == kSelectionTypeOnlyEmployee && !depart.isHuman) {
                // 如果是只能选择员工，但是选择了部门
                [strongself showAlertControllerToLogoutWithMessage:@"当前只允许选择员工" sureAction:nil needCancleButton:NO];
            } else if (strongself.selectionType == kSelectionTypeOnlyDepartment && depart.isHuman) {
                // 如果是只能选择部门，但是选择了员工
                [strongself showAlertControllerToLogoutWithMessage:@"当前只允许选择部门" sureAction:nil needCancleButton:NO];
            } else {
                ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = kSelectedStatusAllSelected;
                [strongself.allSelectedIndexArray addObject:indexPath];
                if (depart.isHuman) {
                    [[MPMDepartEmployeeHelper shareInstance] employeeArrayAddDepartModel:depart];
                } else {
                    [[MPMDepartEmployeeHelper shareInstance] departmentArrayAddDepartModel:depart];
                }
            }
        }
        
        if (strongself.allSelectedIndexArray.count == strongself.departsArray.count) {
            // 如果已经是全选了-传回status
            if (strongself.comfirmBlock) {
                strongself.comfirmBlock(kSelectedStatusAllSelected);
            }
        } else if (strongself.allSelectedIndexArray.count == 0 && strongself.partSelectedIndexArray.count == 0) {
            // 如果一个都没选中-传回status
            if (strongself.comfirmBlock) {
                strongself.comfirmBlock(kSelectedStatusUnselected);
            }
        } else {
            // 如果部分选中-传回status
            if (strongself.comfirmBlock) {
                strongself.comfirmBlock(kSelectedStatusPartSelected);
            }
        }
        strongself.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"已选 (%ld) ",[MPMDepartEmployeeHelper shareInstance].employees.count+[MPMDepartEmployeeHelper shareInstance].departments.count];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    cell.txLabel.text = depart.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MPMDepartment *depart = self.departsArray[indexPath.row];
    // 如果是人员，或者已经全选，则不让再跳入
    if (depart.isHuman) {
        MPMSelectDepartmentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.checkImageBlock) {
            cell.checkImageBlock();
        }
        return;
    }
    if (depart.selectedStatus == kSelectedStatusAllSelected) return;
    self.currentIndexPath = indexPath;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.headerButtonTitlesArray.copy];
    [temp addObject:depart.name];
    __weak typeof(self) weakself = self;
    MPMSelectDepartmentViewController *takepart = [[MPMSelectDepartmentViewController alloc] initWithModel:depart headerButtonTitles:temp selectionType:(SelectionType)self.selectionType comfirmBlock:^(SelectedStatus selectedStatus) {
        __strong typeof(weakself) strongself = weakself;
        // 下一层界面回传status回来：改变当前cell的图标，并改变当前的选中数组。（如果还需要传给上一级，则再传）
        ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = selectedStatus;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (selectedStatus == kSelectedStatusAllSelected) {
            // 如果之前是全选-不处理；如果之前是部分选中，则移除并加入全选中;如果之前是没有选中，则加入全选中。
            if ([strongself.allSelectedIndexArray containsObject:indexPath]) {
                
            } else if ([strongself.partSelectedIndexArray containsObject:indexPath]) {
                [strongself.partSelectedIndexArray removeObject:indexPath];
                [strongself.allSelectedIndexArray addObject:indexPath];
            } else {
                [strongself.allSelectedIndexArray addObject:indexPath];
            }
        } else if (selectedStatus == kSelectedStatusPartSelected) {
            // 如果之前是全选，移出全选加入部分选中；如果之前是部分选中-不处理；如果之前是没有选中，加入部分选中。
            if ([strongself.allSelectedIndexArray containsObject:indexPath]) {
                [strongself.allSelectedIndexArray removeObject:indexPath];
                [strongself.partSelectedIndexArray addObject:indexPath];
            } else if ([strongself.partSelectedIndexArray containsObject:indexPath]) {
                
            } else {
                [strongself.partSelectedIndexArray addObject:indexPath];
            }
        } else {
            // 如果之前是全选，移出全选；如果之前是部分选中，移出部分选中;如果之前是没有选中，不处理。
            if ([strongself.allSelectedIndexArray containsObject:indexPath]) {
                [strongself.allSelectedIndexArray removeObject:indexPath];
            } else if ([strongself.partSelectedIndexArray containsObject:indexPath]) {
                [strongself.partSelectedIndexArray removeObject:indexPath];
            }
        }
        
        if (strongself.allSelectedIndexArray.count == strongself.departsArray.count) {
            // 如果已经是全选了-传回status = 1
            if (strongself.comfirmBlock) {
                strongself.comfirmBlock(kSelectedStatusAllSelected);
            }
        } else if (strongself.allSelectedIndexArray.count == 0 && strongself.partSelectedIndexArray.count == 0) {
            // // 如果一个都没选中-传回status = 0
            if (strongself.comfirmBlock) {
                strongself.comfirmBlock(kSelectedStatusUnselected);
            }
        } else {
            // 如果部分选中-传回status = 2
            if (strongself.comfirmBlock) {
                strongself.comfirmBlock(kSelectedStatusPartSelected);
            }
        }
        
        [strongself.tableView reloadData];
        strongself.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"已选 (%ld) ",[MPMDepartEmployeeHelper shareInstance].employees.count+[MPMDepartEmployeeHelper shareInstance].departments.count];
        
    }];
    takepart.delegate = self.delegate;
    takepart.sureSelectBlock = self.sureSelectBlock;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:takepart animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.headerSearchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    DLog(@"%@", searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 点击搜索，收回键盘
    [self.headerSearchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    MPMSearchDepartViewController *controller = [[MPMSearchDepartViewController alloc] initWithDelegate:self.delegate sureSelectBlock:self.sureSelectBlock selectionType:self.selectionType titleArray:self.headerButtonTitlesArray];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
}

#pragma mark - Lazy Init

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.userInteractionEnabled = YES;
        _headerView.image = ImageName(@"statistics_nav");
    }
    return _headerView;
}

- (UISearchBar *)headerSearchBar {
    if (!_headerSearchBar) {
        _headerSearchBar = [[UISearchBar alloc] init];
        _headerSearchBar.delegate = self;
        _headerSearchBar.barTintColor = kClearColor;
        _headerSearchBar.backgroundImage = [[UIImage alloc] init];
        _headerSearchBar.placeholder = @"搜索部门或人员";
    }
    return _headerSearchBar;
}

- (UIScrollView *)headerPeopleScrollView {
    if (!_headerPeopleScrollView) {
        _headerPeopleScrollView = [[UIScrollView alloc] init];
        _headerPeopleScrollView.backgroundColor = kTableViewBGColor;
    }
    return _headerPeopleScrollView;
}

// middle
#define kShadowOffsetY 1
- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTableViewHeight)];
        _tableHeaderView.backgroundColor = kWhiteColor;
        _tableHeaderView.layer.shadowColor = kLightGrayColor.CGColor;
        // 设置阴影
        _tableHeaderView.layer.shadowRadius = 3;
        _tableHeaderView.layer.shadowOffset = CGSizeZero;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, kTableViewHeight-kShadowOffsetY/2, kScreenWidth, kShadowOffsetY)];
        _tableHeaderView.layer.shadowPath = shadowPath.CGPath;
        _tableHeaderView.layer.masksToBounds = NO;
        _tableHeaderView.layer.shadowOpacity = 1;
        [_tableHeaderView addSubview:self.tableHeaderIcon];
        [_tableHeaderView addSubview:self.tableHeaderLabel];
    }
    return _tableHeaderView;
}
- (UIImageView *)tableHeaderIcon {
    if (!_tableHeaderIcon) {
        _tableHeaderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12.5, 25, 25)];
        _tableHeaderIcon.userInteractionEnabled = YES;
        [_tableHeaderIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAll:)]];
        _tableHeaderIcon.image = ImageName(@"setting_none");
    }
    return _tableHeaderIcon;
}
- (UILabel *)tableHeaderLabel {
    if (!_tableHeaderLabel) {
        _tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, kScreenWidth - 47, kTableViewHeight)];
        _tableHeaderLabel.text = @"全选";
        _tableHeaderLabel.font = SystemFont(17);
        _tableHeaderLabel.textColor = kBlackColor;
    }
    return _tableHeaderLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kTableViewBGColor;
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

// bottom
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kWhiteColor;
    }
    return _bottomView;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kSeperateColor;
    }
    return _bottomLine;
}
- (UILabel *)bottomTotalSelectedLabel {
    if (!_bottomTotalSelectedLabel) {
        _bottomTotalSelectedLabel = [[UILabel alloc] init];
        _bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数(%ld)",self.allSelectedIndexArray.count];
        _bottomTotalSelectedLabel.textColor = kBlackColor;
        _bottomTotalSelectedLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bottomTotalSelectedLabel;
}
- (UIButton *)bottomSureButton {
    if (!_bottomSureButton) {
        _bottomSureButton = [MPMButton titleButtonWithTitle:@"确定" nTitleColor:kWhiteColor hTitleColor:kLightGrayColor nBGImage:ImageName(@"approval_but_determine") hImage:ImageName(@"approval_but_determine")];
    }
    return _bottomSureButton;
}
- (UIView *)bottomHiddenView {
    if (!_bottomHiddenView) {
        _bottomHiddenView = [[UIView alloc] init];
        _bottomHiddenView.backgroundColor = kTableViewBGColor;
    }
    return _bottomHiddenView;
}
- (UIButton *)bottomUpButton {
    if (!_bottomUpButton) {
        _bottomUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomUpButton setImage:ImageName(@"attendence_pullup") forState:UIControlStateNormal];
        [_bottomUpButton setImage:ImageName(@"attendence_pullup") forState:UIControlStateHighlighted];
        [_bottomUpButton setImage:ImageName(@"attendence_pulldown") forState:UIControlStateSelected];
    }
    return _bottomUpButton;
}
- (UITableView *)bottomHiddenTableView {
    if (!_bottomHiddenTableView) {
        _bottomHiddenTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bottomHiddenTableView.delegate = self.dataSourceDelegate;
        _bottomHiddenTableView.dataSource = self.dataSourceDelegate;
        _bottomHiddenTableView.separatorColor = kSeperateColor;
        _bottomHiddenTableView.backgroundColor = kWhiteColor;
        _bottomHiddenTableView.tableFooterView = [[UIView alloc] init];
    }
    return _bottomHiddenTableView;
}
- (MPMHiddenTableViewDataSourceDelegate *)dataSourceDelegate {
    if (!_dataSourceDelegate) {
        _dataSourceDelegate = [[MPMHiddenTableViewDataSourceDelegate alloc] init];
        _dataSourceDelegate.delegate = self;
    }
    return _dataSourceDelegate;
}
- (UIView *)headerHiddenMaskView {
    if (!_headerHiddenMaskView) {
        _headerHiddenMaskView = [[UIView alloc] init];
        _headerHiddenMaskView.backgroundColor = kBlackColor;
        _headerHiddenMaskView.alpha = 0.3;
    }
    return _headerHiddenMaskView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
