//
//  MPMCreateOrangeClassViewController.m
//  MPMAtendence
//  创建排班、排班设置
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCreateOrangeClassViewController.h"
#import "MPMButton.h"
#import "MPMTableHeaderView.h"
#import "MPMCreateOrangeTableViewCell.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMHTTPSessionManager.h"
#import "MPMShareUser.h"
#import "MPMAttendanceSettingModel.h"
#import "MPMSlotTimeDtosModel.h"
#import "MPMClassSettingViewController.h"
#import "MPMDepartEmployeeHelper.h"/** 使用一个单例来传递部门和员工 */
#import "MPMBaseTableViewCell.h"
#import "MPMOauthUser.h"

#define kClassNameLimitLength 10

@interface MPMCreateOrangeClassViewController () <UITableViewDelegate, UITableViewDataSource, MPMSelectDepartmentViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomNextOrSaveButton;
// data
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, assign) DulingType dulingType;
@property (nonatomic, strong) MPMAttendanceSettingModel *model; /** 用一个全局的model进行排班设置数据的传递 */
@property (nonatomic, copy) NSArray *departments;
@property (nonatomic, copy) NSArray *employees;

@end

@implementation MPMCreateOrangeClassViewController

- (instancetype)initWithModel:(MPMAttendanceSettingModel *)model settingType:(DulingType)dulingType {
    self = [super init];
    if (self) {
        self.dulingType = dulingType;
        self.model = model ? model : [[MPMAttendanceSettingModel alloc] init];
        if (!self.model.fixedTimeWorkSchedule) {
            self.model.fixedTimeWorkSchedule = [NSMutableDictionary dictionary];
        }
        if (!self.model.flexibleTimeWorkSchedule) {
            self.model.flexibleTimeWorkSchedule = [NSMutableDictionary dictionary];
        }
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 清空单例中的数据
    [[MPMDepartEmployeeHelper shareInstance] clearData];
}

- (void)setupAttributes {
    [super setupAttributes];
    if (self.dulingType == kDulingTypeCreate) {
        self.navigationItem.title = @"创建排班";
    } else {
        self.navigationItem.title = @"排班设置";
    }
    [self.bottomNextOrSaveButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.bottomNextOrSaveButton setTitle:@"下一步" forState:UIControlStateHighlighted];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.bottomNextOrSaveButton addTarget:self action:@selector(nextOrSave:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomNextOrSaveButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@1);
    }];
    [self.bottomNextOrSaveButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(12);
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
}

#pragma mark - Target Action

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextOrSave:(UIButton *)sender {
    if (kIsNilString(self.model.name)) {
        [self showAlertControllerToLogoutWithMessage:@"请输入排班名称" sureAction:nil needCancleButton:NO];
        return;
    } else if (self.model.name.length > kClassNameLimitLength) {
        [self showAlertControllerToLogoutWithMessage:@"排班名称最多不能超过10个字，请重新输入" sureAction:nil needCancleButton:NO];
        return;
    } else if (self.model.objList.count == 0) {
        [self showAlertControllerToLogoutWithMessage:@"请选择参与人员" sureAction:nil needCancleButton:NO];
        return;
    }
    MPMClassSettingViewController *classSetting = [[MPMClassSettingViewController alloc] initWithModel:self.model settingType:self.dulingType];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classSetting animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - MPMSelectDepartmentViewControllerDelegate
- (void)departCompleteSelectWithDepartments:(NSArray<MPMDepartment *> *)departments employees:(NSArray<MPMDepartment *> *)employees {
    MPMBaseTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSMutableArray *tempList = [NSMutableArray array];
    for (MPMDepartment *depart in departments) {
        MPMObjListModel *list = [depart translateToObjectList];
        [tempList addObject:list];
    }
    for (MPMDepartment *emp in employees) {
        MPMObjListModel *list = [emp translateToObjectList];
        [tempList addObject:list];
    }
    self.model.objList = tempList.copy;
    
    if (departments.count != 0 && employees.count != 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"人员%ld人(部门%ld个)",employees.count,departments.count];
    } else if (departments.count == 0 && employees.count != 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"人员%ld人",employees.count];
    } else if (departments.count != 0 && employees.count == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"部门%ld个",departments.count];
    } else {
        cell.detailTextLabel.text = @"请选择";
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MPMTableHeaderView *footer = [[MPMTableHeaderView alloc] init];
    footer.headerTextLabel.text = @"协助管理人员管理考勤组的排班及统计";
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"textFieldCell";
        MPMCreateOrangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMCreateOrangeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = @"排班名称";
        cell.classNameLabel.text = kIsNilString(self.model.name) ? @"" : self.model.name;
        __weak typeof(self)weakself = self;
        cell.textFieldChangeBlock = ^(NSString *text) {
            __strong typeof(weakself) strongself = weakself;
            // 修改排班名称之后，保存到全局的model中
            strongself.model.name = text;
        };
        return cell;
    } else {
        static NSString *cellIdentifier = @"cellIdentifier";
        MPMBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        cell.textLabel.text = @"参与人员";
        
        // 范围：部门数量、员工数量
        NSMutableArray *departCount = [NSMutableArray array];
        NSMutableArray *peopleCount = [NSMutableArray array];
        for (MPMObjListModel *obj in self.model.objList) {
            if (obj.type.integerValue == 1) {
                [departCount addObject:obj];
            } else {
                [peopleCount addObject:obj];
            }
        }
        if (departCount.count > 0 && peopleCount.count > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"人员%ld人(部门%ld个)",peopleCount.count,departCount.count];
        } else if (peopleCount.count > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"人员%ld人",peopleCount.count];
        } else if (departCount.count > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"部门%ld个",departCount.count];
        } else {
            cell.detailTextLabel.text = nil;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
        }break;
        case 1:{
            NSMutableArray *departCount = [NSMutableArray array];
            NSMutableArray *peopleCount = [NSMutableArray array];
            for (MPMObjListModel *obj in self.model.objList) {
                if (obj.type.integerValue == 1) {
                    MPMDepartment *de = [[MPMDepartment alloc] init];
                    de.mpm_id = obj.objId;
                    de.name = obj.name;
                    de.isHuman = NO;
                    de.parentIds = obj.orgIdIndex;
                    [departCount addObject:de];
                } else {
                    MPMDepartment *emp = [[MPMDepartment alloc] init];
                    emp.mpm_id = obj.objId;
                    emp.name = obj.name;
                    emp.isHuman = YES;
                    emp.parentIds = obj.orgIdIndex;
                    [peopleCount addObject:emp];
                }
            }
            
            [MPMDepartEmployeeHelper shareInstance].departments = [NSMutableArray arrayWithArray:departCount];
            [MPMDepartEmployeeHelper shareInstance].employees = [NSMutableArray arrayWithArray:peopleCount];
            MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:kIsNilString([MPMOauthUser shareOauthUser].shortName) ? @"部门" : [MPMOauthUser shareOauthUser].shortName] selectionType:kSelectionTypeBoth comfirmBlock:nil];
            
            depart.delegate = self;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:depart animated:YES];
        }break;
        default:
            break;
    }
}

#pragma mark - Lazy Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.backgroundColor = kTableViewBGColor;
    }
    return _tableView;
}

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

- (UIButton *)bottomNextOrSaveButton {
    if (!_bottomNextOrSaveButton) {
        _bottomNextOrSaveButton = [MPMButton titleButtonWithTitle:@"下一步" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomNextOrSaveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
