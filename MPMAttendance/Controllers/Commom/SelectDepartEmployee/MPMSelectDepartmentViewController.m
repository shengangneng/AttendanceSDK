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
#import "MPMDepartment.h"
#import "MPMShareUser.h"
#import "MPMSelectDepartmentTableViewCell.h"
#import "MPMDepartEmployeeHelper.h"
#import "MPMSchedulingDepartmentsModel.h"
#import "MPMSchedulingEmplyoeeModel.h"
#import "MPMHiddenTableViewDataSourceDelegate.h"
#import "MPMGetPeopleModel.h"
#import "MPMSearchDepartViewController.h"
#import "MPMSearchPushAnimate.h"

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
@property (nonatomic, copy) SelectCheckBlock selectCheckBlock;          /** 确定按钮 */
@property (nonatomic, copy) NSString *allStringData;                    /** 从子到父类的链条id逗号分隔字符串 */
@property (nonatomic, assign) forSelectionType selectionType;           /** 限制可以选择部门人员、部门only、人员only */
@property (nonatomic, strong) MPMHiddenTableViewDataSourceDelegate *dataSourceDelegate;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;            /** 每次跳入下一层级，记录当前点击的indexPath */

@end

@implementation MPMSelectDepartmentViewController

- (instancetype)initWithModel:(MPMDepartment *)model headerButtonTitles:(NSMutableArray *)headerTitles allStringData:(NSString *)allStringData selectionType:(forSelectionType)selectionType selectCheckBlock:(SelectCheckBlock)block {
    self = [super init];
    if (self) {
        self.allStringData = allStringData;
        self.selectionType = selectionType;
        self.selectCheckBlock = block;
        self.model = model;
        self.headerButtonTitlesArray = [NSMutableArray arrayWithArray:headerTitles.copy];
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.delegate = self;
    [self calculateSelect];
    self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"部门:%ld个  人员:%ld人",[MPMDepartEmployeeHelper shareInstance].departments.count,[MPMDepartEmployeeHelper shareInstance].employees.count];
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
    [self getData];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.view.backgroundColor = kTableViewBGColor;
    if (self.selectionType == forSelectionTypeOnlyEmployee) {
        self.navigationItem.title = @"选择人员";
        self.headerSearchBar.placeholder = @"搜索人员";
    } else if (self.selectionType == forSelectionTypeOnlyDepartment) {
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
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.equalTo(@(52));
    }];
    
    [self.headerSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView.mas_leading);
        make.trailing.equalTo(self.headerView.mas_trailing);
        make.bottom.equalTo(self.headerView.mas_bottom);
        make.top.equalTo(self.headerView.mas_top);
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
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headerPeopleScrollView.mas_centerY);
                make.leading.equalTo(self.headerPeopleScrollView.mas_leading).offset(10);
            }];
        } else if (i == self.headerButtonTitlesArray.count - 1) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headerPeopleScrollView.mas_centerY);
                make.leading.equalTo(preBtn.mas_trailing).offset(5);
                make.trailing.equalTo(self.headerPeopleScrollView.mas_trailing).offset(-10);
            }];
        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headerPeopleScrollView.mas_centerY);
                make.leading.equalTo(preBtn.mas_trailing).offset(5);
            }];
        }
        preBtn = btn;
    }
    [self.headerPeopleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.equalTo(@40);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerPeopleScrollView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomTotalSelectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        make.leading.equalTo(self.bottomView.mas_leading).offset(15);
        make.trailing.equalTo(self.bottomSureButton.mas_leading).offset(-15);
    }];
    [self.bottomSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bottomView.mas_trailing).offset(-15);
        make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        make.width.equalTo(@(88.5));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
    }];
    
    [self.bottomUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.height.equalTo(@(34));
        make.width.equalTo(@(86));
    }];
    [self.bottomHiddenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.bottomUpButton.mas_bottom);
        make.height.equalTo(@300);
    }];
    [self.headerHiddenMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(kScreenHeight - 300));
        make.bottom.equalTo(self.view.mas_top).offset(-kNavigationHeight);
    }];
    [self.bottomHiddenTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomHiddenView);
    }];
}

- (void)getData {
    NSString *parentId = self.model ? self.model.mpm_id : @"-1";
    NSString *url = [NSString stringWithFormat:@"%@departmentVos?parentId=%@&token=%@&employeeId=%@",MPMHost,parentId,[MPMShareUser shareUser].token,[MPMShareUser shareUser].employeeId];
    [[MPMHTTPSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
        NSMutableArray *temp = [NSMutableArray array];
        NSArray *tempArr = response[@"dataObj"];
        for (int j = 0; j < tempArr.count ; j++) {
            NSDictionary *d = response[@"dataObj"][j];
            MPMDepartment *depart = [[MPMDepartment alloc] initWithDictionary:d];
            [temp addObject:depart];
        }
        if (temp.count > 0) {
            for (int i = 0; i < temp.count; i++) {
                MPMDepartment *depart = temp[i];
                if (depart.isHuman) {
                    // 后台接口的parentId如果是human，是不正确的，于是我自己组成正确的
                    depart.parent_ids = [NSString stringWithFormat:@"-1,%@",self.allStringData];
                }
            }
        }
        
        self.departsArray = temp.copy;
        
        if (self.headerButtonTitlesArray.count == 1) {
            // 第一层的部门选择页面初始化的时候
            [self getParentIds];
        } else {
            // 这时候[MPMDepartEmployeeHelper shareInstance].allArrayData已经有数据了，可以直接筛选全选和部分选中了
            [self calculateSelect];
            self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"部门:%ld个  人员:%ld人",[MPMDepartEmployeeHelper shareInstance].departments.count,[MPMDepartEmployeeHelper shareInstance].employees.count];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
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
        for (MPMSchedulingEmplyoeeModel *eee in [MPMDepartEmployeeHelper shareInstance].employees) {
            if ([eee.employeeId isEqualToString:model.mpm_id]) {
                allSelect = YES;
            }
            if ([[eee.parentsId componentsSeparatedByString:@","] containsObject:model.mpm_id]) {
                partSelect = YES;
            }
        }
        for (MPMSchedulingDepartmentsModel *ddd in [MPMDepartEmployeeHelper shareInstance].departments) {
            if ([ddd.departmentId isEqualToString:model.mpm_id]) {
                allSelect = YES;
            }
            if ([[ddd.parentsId componentsSeparatedByString:@","] containsObject:model.mpm_id]) {
                partSelect = YES;
            }
        }
        if (allSelect) {
            self.departsArray[i].selectedStatus = @"1";
            [self.allSelectedIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        } else if (partSelect) {
            self.departsArray[i].selectedStatus = @"2";
            [self.partSelectedIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        } else {
            self.departsArray[i].selectedStatus = @"0";
        }
    }
    
    [self.tableView reloadData];
}

- (void)getParentIds {
    dispatch_group_t group = dispatch_group_create();
    
    if ([MPMDepartEmployeeHelper shareInstance].employees.count > 0) {
        for (int i = 0; i < [MPMDepartEmployeeHelper shareInstance].employees.count; i++) {
            dispatch_group_enter(group);
            dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
                NSString *employeeId = [MPMDepartEmployeeHelper shareInstance].employees[i].employeeId;
                NSString *url = [NSString stringWithFormat:@"%@getParentIds?employeeId=%@&token=%@&",MPMHost,employeeId,[MPMShareUser shareUser].token];
                [[MPMHTTPSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
                    id emp = response[@"dataObj"];
                    if ([emp isKindOfClass:[NSString class]]) {
                        [[MPMDepartEmployeeHelper shareInstance].allStringData addObject:emp];
                    }
                    dispatch_group_leave(group);
                } failure:^(NSString *error) {
                    DLog(@"%@",error);
                    dispatch_group_leave(group);
                }];
            });
        }
    }
    
    if ([MPMDepartEmployeeHelper shareInstance].departments.count > 0) {
        for (int i = 0; i < [MPMDepartEmployeeHelper shareInstance].departments.count; i++) {
            dispatch_group_enter(group);
            dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
                NSString *departmentId = [MPMDepartEmployeeHelper shareInstance].departments[i].departmentId;
                NSString *url = [NSString stringWithFormat:@"%@getParentIds?departmentId=%@&token=%@&",MPMHost,departmentId,[MPMShareUser shareUser].token];
                [[MPMHTTPSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
                    id dep = response[@"dataObj"];
                    if ([dep isKindOfClass:[NSString class]]) {
                        [[MPMDepartEmployeeHelper shareInstance].allStringData addObject:dep];
                    }
                    dispatch_group_leave(group);
                } failure:^(NSString *error) {
                    DLog(@"%@",error);
                    dispatch_group_leave(group);
                }];
            });
        }
    }
    
    dispatch_group_notify(group, kMainQueue, ^{
        [[MPMDepartEmployeeHelper shareInstance] dealingAllStringData];
        [self calculateSelect];
        self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"部门:%ld个  人员:%ld人",[MPMDepartEmployeeHelper shareInstance].departments.count,[MPMDepartEmployeeHelper shareInstance].employees.count];
    });
    
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
    // 使用Delegate的方式回传数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(departCompleteSelectWithDepartments:employees:)]) {
        [self.delegate departCompleteSelectWithDepartments:[MPMDepartEmployeeHelper shareInstance].departments employees:[MPMDepartEmployeeHelper shareInstance].employees];
    }
    // 使用Block的方式回传数据
    if (self.sureSelectBlock) {
        self.sureSelectBlock([MPMDepartEmployeeHelper shareInstance].departments, [MPMDepartEmployeeHelper shareInstance].employees);
    }
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
    for (MPMSchedulingDepartmentsModel *dep in [MPMDepartEmployeeHelper shareInstance].departments) {
        MPMGetPeopleModel *model = [[MPMGetPeopleModel alloc] init];
        model.name = dep.departmentName;
        model.mpm_id = dep.departmentId;
        [temp addObject:model];
    }
    for (MPMSchedulingEmplyoeeModel *emp in [MPMDepartEmployeeHelper shareInstance].employees) {
        MPMGetPeopleModel *model = [[MPMGetPeopleModel alloc] init];
        model.name = emp.employeeName;
        model.mpm_id = emp.employeeId;
        model.isHuman = @"1";
        [temp addObject:model];
    }
    self.dataSourceDelegate.peoplesArray = temp;
    [self.bottomHiddenTableView reloadData];
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomUpButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottomView.mas_top).offset(-300);
                make.centerX.equalTo(self.bottomView.mas_centerX);
                make.height.equalTo(@(34));
                make.width.equalTo(@(86));
            }];
            [self.headerHiddenMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@(kScreenHeight - 300));
                make.bottom.equalTo(self.view.mas_top).offset(kScreenHeight - 300 - kNavigationHeight - BottomViewHeight);
            }];
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomUpButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottomView.mas_top);
                make.centerX.equalTo(self.bottomView.mas_centerX);
                make.height.equalTo(@(34));
                make.width.equalTo(@(86));
            }];
            [self.headerHiddenMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@(kScreenHeight - 300));
                make.bottom.equalTo(self.view.mas_top).offset(-kNavigationHeight);
            }];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)hide:(UITapGestureRecognizer *)gesture {
    self.bottomUpButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomUpButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top);
            make.centerX.equalTo(self.bottomView.mas_centerX);
            make.height.equalTo(@(34));
            make.width.equalTo(@(86));
        }];
        [self.headerHiddenMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@(kScreenHeight - 300));
            make.bottom.equalTo(self.view.mas_top).offset(-kNavigationHeight);
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
            self.departsArray[i].selectedStatus = @"0";
            [self.allSelectedIndexArray removeObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    // 传递回去上个页面
    if (self.allSelectedIndexArray.count == self.departsArray.count) {
        // 如果已经是全选了-传回status = 1
        if (self.selectCheckBlock) {
            self.selectCheckBlock(@"1");
        }
    } else if (self.allSelectedIndexArray.count == 0 && self.partSelectedIndexArray.count == 0) {
        // 如果一个都没选中-传回status = 0
        if (self.selectCheckBlock) {
            self.selectCheckBlock(@"0");
        }
    } else {
        // 如果部分选中-传回status = 2
        if (self.selectCheckBlock) {
            self.selectCheckBlock(@"2");
        }
    }
    
    // 移除全局对象里面的内容
    [[MPMDepartEmployeeHelper shareInstance].allStringData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:depart.mpm_id]) {
            [[MPMDepartEmployeeHelper shareInstance].allStringData removeObject:obj];
        }
    }];
    [[MPMDepartEmployeeHelper shareInstance] dealingAllStringData];
    
    self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"部门:%ld个  人员:%ld人",[MPMDepartEmployeeHelper shareInstance].departments.count,[MPMDepartEmployeeHelper shareInstance].employees.count];
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
//    if (self.departsArray.count == 0) {
//        return 0;
//    }
//    return kTableViewHeight;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DepartmentCell";
    MPMSelectDepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMSelectDepartmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
//    // 全选
//    if (indexPath.section == 0) {
//        cell.isHuman = nil;
//        cell.checkIconImage.image = ImageName(@"setting_none");
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.txLabel.text = @"全选";
//        __weak typeof(self) weakself = self;
//        cell.checkImageBlock = ^{
//            DLog(@"全选...");
//            __strong typeof(weakself) strongself = weakself;
//            if (strongself.selectionType == forSelectionTypeOnlyEmployee) {
//                // 如果只能选择员工
//                BOOL hasDepart = NO;
//                for (MPMDepartment *model in self.departsArray) {
//                    if (!model.isHuman) {
//                        hasDepart = YES;
//                    }
//                }
//                if (hasDepart) {
//                    [strongself showAlertControllerToLogoutWithMessage:@"当前只允许选择员工" sureAction:nil needCancleButton:NO];
//                } else {
//                    [strongself showAlertControllerToLogoutWithMessage:@"功能还在完善中..." sureAction:nil needCancleButton:NO];
//                }
//            } else if (strongself.selectionType == forSelectionTypeOnlyDepartment) {
//                // 如果只能选择部门
//                BOOL hasEmpoyee = NO;
//                for (MPMDepartment *model in self.departsArray) {
//                    if (model.isHuman && model.isHuman.integerValue == 1) {
//                        hasEmpoyee = YES;
//                    }
//                }
//                if (hasEmpoyee) {
//                    [strongself showAlertControllerToLogoutWithMessage:@"当前只允许选择部门" sureAction:nil needCancleButton:NO];
//                } else {
//                    [strongself showAlertControllerToLogoutWithMessage:@"功能还在完善中..." sureAction:nil needCancleButton:NO];
//                }
//            } else {
//                // 如果部门或者员工都可以选择
//                [strongself showAlertControllerToLogoutWithMessage:@"功能还在完善中..." sureAction:nil needCancleButton:NO];
//            }
//        };
//        return cell;
//    }
    MPMDepartment *depart = self.departsArray[indexPath.row];
    cell.isHuman = depart.isHuman;
    if (depart.selectedStatus.integerValue == 1) {
        cell.checkIconImage.image = ImageName(@"setting_all");
    } else if (depart.selectedStatus.integerValue == 2) {
        cell.checkIconImage.image = ImageName(@"setting_some");
    } else {
        cell.checkIconImage.image = ImageName(@"setting_none");
    }
    
    // 点击了选中按钮（并非全选按钮）
    __weak typeof(self) weakself = self;
    cell.checkImageBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        NSString *preStatus = ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus;// 取出之前的状态
        if (preStatus.integerValue == 1) {
            // 如果之前为全选，则变为不选中
            ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = @"0";
            [strongself.allSelectedIndexArray removeObject:indexPath];
            // 如果是员工，需要移出。如果是部门，需要移除部门内所有内容
            NSString *str = kIsNilString(strongself.allStringData)?strongself.departsArray[indexPath.row].mpm_id:[NSString stringWithFormat:@"%@,%@",strongself.allStringData,strongself.departsArray[indexPath.row].mpm_id];
            if (depart.isHuman) {
                // 如果是员工，则直接移除
                [[MPMDepartEmployeeHelper shareInstance] employeeArrayRemoveDepartModel:depart];
                [[MPMDepartEmployeeHelper shareInstance].allStringData removeObject:str];
            } else {
                // 如果是部门，需要移除部门下面的全部内容
                [[MPMDepartEmployeeHelper shareInstance] departmentArrayRemoveSub:depart];
                [[MPMDepartEmployeeHelper shareInstance] allStringDataRemoveSubOfId:str];
            }
            [[MPMDepartEmployeeHelper shareInstance] dealingAllStringData];
        } else if (preStatus.integerValue == 2) {
            // 如果之前为部分选中，则变为不选中
            ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = @"0";
            [strongself.partSelectedIndexArray removeObject:indexPath];
            if (depart.isHuman) {
                // 不可能是人员
            } else {
                // 如果是部门-其实是删除里面的员工
                [[MPMDepartEmployeeHelper shareInstance] departmentArrayRemoveSub:depart];
            }
            // 由于不可能是员工，所以直接移除部门地下所有的内容
            NSString *str = kIsNilString(strongself.allStringData)?strongself.departsArray[indexPath.row].mpm_id:[NSString stringWithFormat:@"%@,%@",strongself.allStringData,strongself.departsArray[indexPath.row].mpm_id];
            [[MPMDepartEmployeeHelper shareInstance] allStringDataRemoveSubOfId:str];
            [[MPMDepartEmployeeHelper shareInstance] dealingAllStringData];
        } else {
            // 如果之前为不选中，则变为全选
            if (strongself.selectionType == forSelectionTypeOnlyEmployee && !depart.isHuman) {
                // 如果是只能选择员工，但是选择了部门
                [strongself showAlertControllerToLogoutWithMessage:@"当前只允许选择员工" sureAction:nil needCancleButton:NO];
            } else if (strongself.selectionType == forSelectionTypeOnlyDepartment && depart.isHuman) {
                // 如果是只能选择部门，但是选择了员工
                [strongself showAlertControllerToLogoutWithMessage:@"当前只允许选择部门" sureAction:nil needCancleButton:NO];
            } else {
                ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = @"1";
                [strongself.allSelectedIndexArray addObject:indexPath];
                if (depart.isHuman) {
                    [[MPMDepartEmployeeHelper shareInstance] employeeArrayAddDepartModel:depart];
                } else {
                    [[MPMDepartEmployeeHelper shareInstance] departmentArrayAddDepartModel:depart];
                }
                NSString *str = kIsNilString(strongself.allStringData)?strongself.departsArray[indexPath.row].mpm_id:[NSString stringWithFormat:@"%@,%@",strongself.allStringData,strongself.departsArray[indexPath.row].mpm_id];
                [[MPMDepartEmployeeHelper shareInstance].allStringData addObject:str];
                [[MPMDepartEmployeeHelper shareInstance] dealingAllStringData];
            }
        }
        
        if (strongself.allSelectedIndexArray.count == strongself.departsArray.count) {
            // 如果已经是全选了-传回status = 1
            if (strongself.selectCheckBlock) {
                strongself.selectCheckBlock(@"1");
            }
        } else if (strongself.allSelectedIndexArray.count == 0 && strongself.partSelectedIndexArray.count == 0) {
            // 如果一个都没选中-传回status = 0
            if (strongself.selectCheckBlock) {
                strongself.selectCheckBlock(@"0");
            }
        } else {
            // 如果部分选中-传回status = 2
            if (strongself.selectCheckBlock) {
                strongself.selectCheckBlock(@"2");
            }
        }
        strongself.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"部门:%ld个  人员:%ld人",[MPMDepartEmployeeHelper shareInstance].departments.count,[MPMDepartEmployeeHelper shareInstance].employees.count];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    cell.txLabel.text = depart.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MPMDepartment *depart = self.departsArray[indexPath.row];
    // 如果是人员，或者已经全选，则不让再跳入
    if (depart.isHuman || depart.selectedStatus.integerValue == 1) return;
    self.currentIndexPath = indexPath;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.headerButtonTitlesArray.copy];
    [temp addObject:depart.name];
    NSString *nextString = kIsNilString(self.allStringData)?depart.mpm_id:[NSString stringWithFormat:@"%@,%@",self.allStringData,depart.mpm_id];
    __weak typeof(self) weakself = self;
    MPMSelectDepartmentViewController *takepart = [[MPMSelectDepartmentViewController alloc] initWithModel:depart headerButtonTitles:temp allStringData:nextString selectionType:(forSelectionType)self.selectionType selectCheckBlock:^(NSString *status) {
        __strong typeof(weakself) strongself = weakself;
        // 下一层界面回传status回来：改变当前cell的图标，并改变当前的选中数组。（如果还需要传给上一级，则再传）
        ((MPMDepartment *)strongself.departsArray[indexPath.row]).selectedStatus = status;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (status.integerValue == 1) {
            // 如果之前是全选-不处理；如果之前是部分选中，则移除并加入全选中;如果之前是没有选中，则加入全选中。
            if ([strongself.allSelectedIndexArray containsObject:indexPath]) {
                
            } else if ([strongself.partSelectedIndexArray containsObject:indexPath]) {
                [strongself.partSelectedIndexArray removeObject:indexPath];
                [strongself.allSelectedIndexArray addObject:indexPath];
            } else {
                [strongself.allSelectedIndexArray addObject:indexPath];
            }
        } else if (status.integerValue == 2) {
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
            if (strongself.selectCheckBlock) {
                strongself.selectCheckBlock(@"1");
            }
        } else if (strongself.allSelectedIndexArray.count == 0 && strongself.partSelectedIndexArray.count == 0) {
            // // 如果一个都没选中-传回status = 0
            if (strongself.selectCheckBlock) {
                strongself.selectCheckBlock(@"0");
            }
        } else {
            // 如果部分选中-传回status = 2
            if (strongself.selectCheckBlock) {
                strongself.selectCheckBlock(@"2");
            }
        }
        
        [strongself.tableView reloadData];
        strongself.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"部门:%ld个  人员:%ld人",[MPMDepartEmployeeHelper shareInstance].departments.count,[MPMDepartEmployeeHelper shareInstance].employees.count];
        
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
    MPMSearchDepartViewController *controller = [[MPMSearchDepartViewController alloc] initWithDelegate:self.delegate sureSelectBlock:self.sureSelectBlock selectType:self.selectionType titleArray:self.headerButtonTitlesArray];
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
