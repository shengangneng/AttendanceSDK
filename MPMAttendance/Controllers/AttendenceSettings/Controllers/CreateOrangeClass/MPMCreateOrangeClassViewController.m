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
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "MPMAttendenceSettingModel.h"
#import "MPMSchedulingDepartmentsModel.h"
#import "MPMSchedulingEmplyoeeModel.h"
#import "MPMSlotTimeDtosModel.h"
#import "MPMClassSettingViewController.h"
#import "MPMDepartEmployeeHelper.h"/** 使用一个单例来传递部门和员工 */
#import "MPMBaseTableViewCell.h"

@interface MPMCreateOrangeClassViewController () <UITableViewDelegate, UITableViewDataSource, MPMSelectDepartmentViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomNextOrSaveButton;
// data
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, assign) DulingType dulingType;
@property (nonatomic, strong) MPMAttendenceSettingModel *model;
@property (nonatomic, copy) NSArray *departments;
@property (nonatomic, copy) NSArray *employees;

@end

@implementation MPMCreateOrangeClassViewController

- (instancetype)initWithSchedulingId:(NSString *)schedulingId settingType:(DulingType)dulingType {
    self = [super init];
    if (self) {
        self.schedulingId = schedulingId;
        self.dulingType = dulingType;
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
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

- (void)getData {
    if (self.dulingType == kDulingTypeCreate) {
        if (!self.model) {
            self.model = [[MPMAttendenceSettingModel alloc] init];
        }
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@schedulingSetting/getSchedulingById?schedulingId=%@&token=%@",MPMHost,self.schedulingId,[MPMShareUser shareUser].token];
    [[MPMSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
        NSDictionary *dic = response[@"dataObj"];
        self.model = [[MPMAttendenceSettingModel alloc] initWithDictionary:dic];
        NSArray *schedulingDepartments = [dic[@"schedulingDepartments"] isKindOfClass:[NSArray class]] ? dic[@"schedulingDepartments"] : @[];
        NSMutableArray *temp1 = [NSMutableArray arrayWithCapacity:schedulingDepartments.count];
        for (int i = 0;i < schedulingDepartments.count; i++) {
            NSDictionary *tempDic = schedulingDepartments[i];
            MPMSchedulingDepartmentsModel *dep = [[MPMSchedulingDepartmentsModel alloc] initWithDictionary:tempDic];
            [temp1 addObject:dep];
        }
        self.model.schedulingDepartments = temp1.copy;
        
        NSArray *schedulingEmployees = [dic[@"schedulingEmplyoees"] isKindOfClass:[NSArray class]] ? dic[@"schedulingEmplyoees"] : @[];
        NSMutableArray *temp2 = [NSMutableArray arrayWithCapacity:schedulingEmployees.count];
        for (int i = 0;i < schedulingEmployees.count; i++) {
            NSDictionary *tempDic = schedulingEmployees[i];
            MPMSchedulingEmplyoeeModel *emp = [[MPMSchedulingEmplyoeeModel alloc] initWithDictionary:tempDic];
            [temp2 addObject:emp];
        }
        self.model.schedulingEmplyoees = temp2.copy;
        
        NSArray *slotTime = [dic[@"slotTimeDtos"] isKindOfClass:[NSArray class]] ? dic[@"slotTimeDtos"] : @[];
        NSMutableArray *temp3 = [NSMutableArray arrayWithCapacity:slotTime.count];
        for (int i = 0;i < slotTime.count; i++) {
            NSDictionary *tempDic = slotTime[i];
            MPMSlotTimeDtosModel *slt = [[MPMSlotTimeDtosModel alloc] initWithDictionary:tempDic];
            [temp3 addObject:slt];
        }
        self.model.slotTimeDtos = temp3.copy;
        
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - Target Action

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextOrSave:(UIButton *)sender {
    [self saveWithTransfer:0];
}

/** transfer：0为false，1为true（代表是否转移） */
- (void)saveWithTransfer:(NSInteger)transfer {
    if (kIsNilString(self.model.schedulingName)) {
        [self showAlertControllerToLogoutWithMessage:@"请输入排班名称" sureAction:nil needCancleButton:NO];
        return;
    }
    if (self.model.schedulingEmplyoees.count == 0 && self.model.schedulingDepartments.count == 0) {
        [self showAlertControllerToLogoutWithMessage:@"请选择参与人员" sureAction:nil needCancleButton:NO];
        return;
    }
    // 下一步
    NSString *url = [NSString stringWithFormat:@"%@schedulingSetting/saveScheduling?token=%@",MPMHost,[MPMShareUser shareUser].token];
    // 需要根据回传的model里面的如果是Human，则加入employees字典。如果是部门，则加入departments字典
    NSMutableArray *employees = [NSMutableArray array];
    NSMutableArray *departments = [NSMutableArray array];
    for (MPMSchedulingEmplyoeeModel *model in self.model.schedulingEmplyoees) {
        NSDictionary *dic = @{@"employeeId":model.employeeId,@"employeeName":model.employeeName,@"parentsId":model.parentsId};
        [employees addObject:dic];
    }
    for (MPMSchedulingDepartmentsModel *model in self.model.schedulingDepartments) {
        NSDictionary *dic = @{@"departmentId":model.departmentId,@"departmentName":model.departmentName,@"parentsId":model.parentsId};
        [departments addObject:dic];
    }
    NSString *companyId = [MPMShareUser shareUser].companyId;
    NSString *schedulingId = self.schedulingId;
    NSString *schedulingName = self.model.schedulingName;
    NSDictionary *params;
    if (self.dulingType == kDulingTypeSetting) {
        params = @{@"companyId":companyId,@"schedulingId":kSafeString(schedulingId),@"schedulingName":schedulingName,@"employees":
                       employees,@"departments":departments,@"transfer":@(transfer)};
    } else {
        params = @{@"companyId":companyId,@"schedulingName":schedulingName,@"employees":
                       employees,@"departments":departments,@"transfer":@(transfer)};
    }
    [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
        if ([response[@"message"] isKindOfClass:[NSString class]] && [((NSString *)response[@"message"]) containsString:@"迁移"]) {
            [self showAlertControllerToLogoutWithMessage:response[@"message"] sureAction:^(UIAlertAction * _Nonnull action) {
                [self saveWithTransfer:1];
            } needCancleButton:YES];
            return;
        }
        // 如果创建排班成功，把状态修改为kDulingTypeSetting，并设置self.schedulingId，否则从班次设置返回，需要迁移人员
        self.schedulingId = response[@"dataObj"][@"schedulingId"];
        self.dulingType = kDulingTypeSetting;
        MPMClassSettingViewController *classSetting = [[MPMClassSettingViewController alloc] initWithSchedulingId:self.schedulingId settingType:kDulingTypeCreate];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classSetting animated:YES];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - MPMSelectDepartmentViewControllerDelegate
- (void)departCompleteSelectWithDepartments:(NSArray<MPMSchedulingDepartmentsModel *> *)departments employees:(NSArray<MPMSchedulingEmplyoeeModel *> *)employees {
    MPMBaseTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.model.schedulingDepartments = departments.copy;
    self.model.schedulingEmplyoees = employees.copy;
    if (self.model.schedulingDepartments.count != 0 && self.model.schedulingEmplyoees.count != 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"部门%ld个,员工%ld人",[MPMDepartEmployeeHelper shareInstance].departments.count,self.model.schedulingEmplyoees.count];
    } else if (self.model.schedulingDepartments.count == 0 && self.model.schedulingEmplyoees.count != 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"员工%ld人",self.model.schedulingEmplyoees.count];
    } else if (self.model.schedulingDepartments.count != 0 && self.model.schedulingEmplyoees.count == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"部门%ld个",self.model.schedulingDepartments.count];
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
        cell.classNameLabel.text = kIsNilString(self.model.schedulingName) ? @"" : self.model.schedulingName;
        __weak typeof(self)weakself = self;
        cell.textFieldChangeBlock = ^(NSString *text) {
            __strong typeof(weakself) strongself = weakself;
            strongself.model.schedulingName = text;
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
        if (self.model.schedulingDepartments.count != 0 && self.model.schedulingEmplyoees.count != 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"部门%ld个,员工%ld人",self.model.schedulingDepartments.count,self.model.schedulingEmplyoees.count];
        } else if (self.model.schedulingDepartments.count == 0 && self.model.schedulingEmplyoees.count != 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"员工%ld人",self.model.schedulingEmplyoees.count];
        } else if (self.model.schedulingDepartments.count != 0 && self.model.schedulingEmplyoees.count == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"部门%ld个",self.model.schedulingDepartments.count];
        } else {
            cell.detailTextLabel.text = @"请选择";
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
            MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:@"部门"] allStringData:@"" selectionType:forSelectionTypeBoth selectCheckBlock:nil];
            [MPMDepartEmployeeHelper shareInstance].departments = [NSMutableArray arrayWithArray:self.model.schedulingDepartments];
            [MPMDepartEmployeeHelper shareInstance].employees = [NSMutableArray arrayWithArray:self.model.schedulingEmplyoees];
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
