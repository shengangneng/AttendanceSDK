//
//  MPMAuthoritySettingViewController.m
//  MPMAtendence
//  权限设置
//  Created by shengangneng on 2018/6/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAuthoritySettingViewController.h"
#import "MPMButton.h"
#import "MPMAuthorityTableViewCell.h"
#import "MPMCommomGetPeopleViewController.h"
#import "MPMGetPeopleModel.h"
#import "MPMShareUser.h"
#import "MPMHTTPSessionManager.h"
#import "MPMAuthorityModel.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMDepartEmployeeHelper.h"
#import "AFNetworking.h"

#define kAuthorityTableViewHeight 60
@interface MPMAuthoritySettingViewController () <UITableViewDelegate, UITableViewDataSource>
// Views
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomNextOrSaveButton;
// Data
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) BOOL respondorNeedFold;   /** 负责人是否需要折叠：默认为YES */
@property (nonatomic, assign) BOOL statistorNeedFold;   /** 统计员是否需要折叠：默认为YES */
@property (nonatomic, copy) NSArray<MPMAuthorityModel *> *responderArray;/** 负责人 */
@property (nonatomic, copy) NSArray<MPMAuthorityModel *> *statictorArray;/** 统计员 */

@property (nonatomic, copy) NSArray<MPMAuthorityModel *> *originalRespinderArray;/** 第一次进来的负责人 */
@property (nonatomic, copy) NSArray<MPMAuthorityModel *> *originalStatictorArray;/** 第一次进来的统计员 */

@end

@implementation MPMAuthoritySettingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
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
    [[MPMDepartEmployeeHelper shareInstance] clearData];
}

- (void)getData {
    NSString *url = [NSString stringWithFormat:@"%@PermissionController/getRolePeople?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSDictionary *params = @{@"companyId":[MPMShareUser shareUser].companyId};
    
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在加载" success:^(id response) {
        if ([response[@"dataObj"] isKindOfClass:[NSDictionary class]] && [response[@"dataObj"][@"checkList"] isKindOfClass:[NSArray class]]) {
            // 统计员
            NSArray *checkList = response[@"dataObj"][@"checkList"];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:checkList.count];
            for (int i = 0; i < checkList.count; i++) {
                NSDictionary *dic = checkList[i];
                MPMAuthorityModel *model = [[MPMAuthorityModel alloc] initWithDictionary:dic];
                [temp addObject:model];
            }
            self.statictorArray = temp.copy;
            self.originalStatictorArray = temp.copy;
        }
        if ([response[@"dataObj"] isKindOfClass:[NSDictionary class]] && [response[@"dataObj"][@"gmlist"] isKindOfClass:[NSArray class]]) {
            // 负责人
            NSArray *gmlist = response[@"dataObj"][@"gmlist"];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:gmlist.count];
            for (int i = 0; i < gmlist.count; i++) {
                NSDictionary *dic = gmlist[i];
                MPMAuthorityModel *model = [[MPMAuthorityModel alloc] initWithDictionary:dic];
                [temp addObject:model];
            }
            self.responderArray = temp.copy;
            self.originalRespinderArray = temp.copy;
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(UIButton *)sender {
    NSString *url = [NSString stringWithFormat:@"%@PermissionController/addPermission?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSMutableArray *responsor = [NSMutableArray arrayWithCapacity:self.responderArray.count];
    NSMutableArray *statictor = [NSMutableArray arrayWithCapacity:self.statictorArray.count];
    for (MPMAuthorityModel *model in self.responderArray) {
        [responsor addObject:@{@"employeeId":model.employeeId,@"userName":model.userName,@"companyId":[MPMShareUser shareUser].companyId}];
    }
    for (MPMAuthorityModel *model in self.statictorArray) {
        [statictor addObject:@{@"employeeId":model.employeeId,@"userName":model.userName,@"companyId":[MPMShareUser shareUser].companyId}];
    }
    // 对比修改后的统计员和责任人，筛选出需要删除的数据
    NSMutableArray *deleteIds = [NSMutableArray array];
    for (int i = 0; i < self.originalRespinderArray.count; i++) {
        BOOL canDelete = YES;
        MPMAuthorityModel *model = self.originalRespinderArray[i];
        for (int j = 0; j < self.responderArray.count; j++) {
            MPMAuthorityModel *now = self.responderArray[j];
            if ([model.employeeId isEqualToString:now.employeeId]) {
                canDelete = NO;
            }
        }
        if (canDelete) {
            [deleteIds addObject:model.employeeId];
        }
    }
    for (int i = 0; i < self.originalStatictorArray.count; i++) {
        BOOL canDelete = YES;
        MPMAuthorityModel *model = self.originalStatictorArray[i];
        for (int j = 0; j < self.statictorArray.count; j++) {
            MPMAuthorityModel *now = self.statictorArray[j];
            if ([model.employeeId isEqualToString:now.employeeId]) {
                canDelete = NO;
            }
        }
        if (canDelete) {
            [deleteIds addObject:model.employeeId];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (responsor.count > 0) {
        params[@"gmlist"] = responsor;
    }
    if (statictor.count > 0) {
        params[@"checkList"] = statictor;
    }
    if (deleteIds.count > 0) {
        params[@"deleteIds"] = deleteIds;
    }
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:(params.count > 0 ? params : nil) loadingMessage:@"正在保存" success:^(id response) {
        DLog(@"%@",response);
        [self showAlertControllerToLogoutWithMessage:@"保存成功" sureAction:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        } needCancleButton:NO];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.responderArray.count == 0) {
            return kAuthorityTableViewHeight;
        } else {
            if (!self.respondorNeedFold) {
                return kAuthorityTableViewHeight + 70 + (((self.responderArray.count-1)/5) * 56.5);
            } else {
                if (self.responderArray.count > 5) {
                    return kAuthorityTableViewHeight + 70;
                } else {
                    return kAuthorityTableViewHeight + 56.5;
                }
            }
        }
    } else {
        if (self.statictorArray.count == 0) {
            return kAuthorityTableViewHeight;
        } else {
            if (!self.statistorNeedFold) {
                return kAuthorityTableViewHeight + 70 + (((self.statictorArray.count-1)/5) * 56.5);
            } else {
                if (self.statictorArray.count > 5) {
                    return kAuthorityTableViewHeight + 70;
                } else {
                    return kAuthorityTableViewHeight + 56.5;
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AuthorityCell";
    MPMAuthorityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMAuthorityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.txLabel.text = self.titleArray[indexPath.row][@"title"];
    cell.detailTxLabel.text = self.titleArray[indexPath.row][@"detail"];
    if (indexPath.row == 0) {
        [cell setPeopleViewData:self.responderArray fold:self.respondorNeedFold];
    } else {
        [cell setPeopleViewData:self.statictorArray fold:self.statistorNeedFold];
    }
    __weak typeof(self) weakself = self;
    cell.addPeopleBlock = ^(){
        __strong typeof(weakself) strongself = weakself;
        // 跳入多选人员页面（只能选择人员）
        MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:@"部门"] allStringData:@"" selectionType:forSelectionTypeOnlyEmployee selectCheckBlock:nil];
        
        NSString *idString;
        if (indexPath.row == 0) {
            for (int i = 0; i < strongself.responderArray.count; i++) {
                MPMAuthorityModel *model = strongself.responderArray[i];
                if (i == 0) {
                    idString = model.employeeId;
                } else {
                    idString = [idString stringByAppendingString:[NSString stringWithFormat:@",%@",model.employeeId]];
                }
                MPMSchedulingEmplyoeeModel *emp = [[MPMSchedulingEmplyoeeModel alloc] init];
                emp.employeeId = model.employeeId;
                emp.employeeName = model.userName;
                [[MPMDepartEmployeeHelper shareInstance].employees addObject:emp];
            }
        } else {
            for (int i = 0; i < strongself.statictorArray.count; i++) {
                MPMAuthorityModel *model = strongself.statictorArray[i];
                if (i == 0) {
                    idString = model.employeeId;
                } else {
                    idString = [idString stringByAppendingString:[NSString stringWithFormat:@",%@",model.employeeId]];
                }
                MPMSchedulingEmplyoeeModel *emp = [[MPMSchedulingEmplyoeeModel alloc] init];
                emp.employeeId = model.employeeId;
                emp.employeeName = model.userName;
                [[MPMDepartEmployeeHelper shareInstance].employees addObject:emp];
            }
        }
        depart.sureSelectBlock = ^(NSArray<MPMSchedulingDepartmentsModel *> *departments, NSArray<MPMSchedulingEmplyoeeModel *> *employees) {
            // 这里只回传人员数据
            __strong typeof(strongself) sstrongself = strongself;
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:employees.count];
            for (int i = 0; i < employees.count; i++) {
                MPMAuthorityModel *model = [[MPMAuthorityModel alloc] init];
                model.employeeId = employees[i].employeeId;
                model.userName = employees[i].employeeName;
                [temp addObject:model];
            }
            if (indexPath.row == 0) {
                sstrongself.responderArray = temp.copy;
            } else {
                sstrongself.statictorArray = temp.copy;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        strongself.hidesBottomBarWhenPushed = YES;
        [strongself.navigationController pushViewController:depart animated:YES];
    };
    cell.operationBlock = ^(BOOL selected) {
        // 展开收缩
        __strong typeof(weakself) strongself = weakself;
        if (indexPath.row == 0) {
            strongself.respondorNeedFold = !selected;
        } else {
            strongself.statistorNeedFold = !selected;
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    cell.deleteBlock = ^(NSInteger index) {
        __strong typeof(weakself) strongself = weakself;
        // 相应的管理人或统计员需要删除数据并刷新页面
        if (indexPath.row == 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:strongself.responderArray];
            [temp removeObjectAtIndex:index - Tag];
            strongself.responderArray = temp.copy;
        } else {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:strongself.statictorArray];
            [temp removeObjectAtIndex:index - Tag];
            strongself.statictorArray = temp.copy;
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"权限设置";
    self.respondorNeedFold = YES;
    self.statistorNeedFold = YES;
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.bottomNextOrSaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.titleArray = @[@{@"title":@"考勤负责人",@"detail":@"负责用户授权、考勤参数配置及人员排班设置"},@{@"title":@"考勤统计员",@"detail":@"查看公司全体员工每日考勤，监督考勤审批"}];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@1);
    }];
    [self.bottomNextOrSaveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mas_leading).offset(12);
        make.trailing.equalTo(self.bottomView.mas_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
    }];
}

#pragma mark - Lazy Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kTableViewBGColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorColor = kSeperateColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
        _bottomNextOrSaveButton = [MPMButton titleButtonWithTitle:@"保存" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomNextOrSaveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
