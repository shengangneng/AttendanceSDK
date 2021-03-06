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
#import "MPMSessionManager.h"
#import "MPMAuthorityModel.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMDepartEmployeeHelper.h"
#import "MPMNetworking.h"
#import "MPMOauthUser.h"
#import "MPMAuthorityRoleModel.h"

#define kAuthorityTableViewHeight 60
#define kRoleIdResponder @"kaoqin_admin"    // 考勤负责人roleId
#define kRoleIdStatictor @"kaoqin_stat"     // 考情统计员roleId


@interface MPMAuthoritySettingViewController () <UITableViewDelegate, UITableViewDataSource>
// Views
@property (nonatomic, strong) UITableView *tableView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    __weak typeof(self) weakself = self;
    [self addNetworkMonitoringWithGoodNetworkBlock:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself setupSubViews];
        [strongself setupConstraints];
        [strongself getData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[MPMDepartEmployeeHelper shareInstance] clearData];
}

- (void)getData {
    // 获取角色列表
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_ROLE_LIST];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *arr = response[kResponseObjectKey];
            NSMutableArray *roleArray = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *roleDic = arr[i];
                MPMAuthorityRoleModel *role = [[MPMAuthorityRoleModel alloc] initWithDictionary:roleDic];
                [roleArray addObject:role];
            }
            if (roleArray.count > 0) {
                [self getAuthorityListWithRoleArray:roleArray.copy];
            }
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (void)getAuthorityListWithRoleArray:(NSArray *)roleArr {
    dispatch_group_t group = dispatch_group_create();
    BOOL needRequest = NO;
    for (MPMAuthorityRoleModel *role in roleArr) {
        if ([role.mpm_id isEqualToString:kRoleIdResponder]) {
            needRequest = YES;
            dispatch_group_enter(group);
            dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
                NSString *url = [NSString stringWithFormat:@"%@%@?roleId=%@&companyId=%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_ROLE_AUTHORIZE,role.mpm_id,[MPMOauthUser shareOauthUser].company_id];
                [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
                    DLog(@"%@",response);
                    if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                        NSArray *arr = response[kResponseObjectKey];
                        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
                        for (int i = 0; i < arr.count; i++) {
                            NSDictionary *authorityDic = arr[i];
                            MPMAuthorityModel *role = [[MPMAuthorityModel alloc] initWithDictionary:authorityDic];
                            [temp addObject:role];
                        }
                        self.responderArray = temp.copy;
                        self.originalRespinderArray = temp.copy;
                    }
                    dispatch_group_leave(group);
                } failure:^(NSString *error) {
                    DLog(@"%@",error);
                    dispatch_group_leave(group);
                }];
            });
        } else if ([role.mpm_id isEqualToString:kRoleIdStatictor]) {
            needRequest = YES;
            dispatch_group_enter(group);
            dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
                NSString *url = [NSString stringWithFormat:@"%@%@?roleId=%@&companyId=%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_ROLE_AUTHORIZE,role.mpm_id,[MPMOauthUser shareOauthUser].company_id];
                [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
                    DLog(@"%@",response);
                    if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                        NSArray *arr = response[kResponseObjectKey];
                        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
                        for (int i = 0; i < arr.count; i++) {
                            NSDictionary *authorityDic = arr[i];
                            MPMAuthorityModel *role = [[MPMAuthorityModel alloc] initWithDictionary:authorityDic];
                            [temp addObject:role];
                        }
                        self.statictorArray = temp.copy;
                        self.originalStatictorArray = temp.copy;
                    }
                    dispatch_group_leave(group);
                } failure:^(NSString *error) {
                    DLog(@"%@",error);
                    dispatch_group_leave(group);
                }];
            });
        }
    }
    if (needRequest) {
        dispatch_group_notify(group, kMainQueue, ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 添加人员、点击人员删除 */
- (void)saveWithRolesArray:(NSArray *)rolesArray roleId:(NSString *)roleId {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_ROLE_AUTHORIZE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] = [MPMOauthUser shareOauthUser].company_id;
    params[@"roleId"] = roleId;
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:self.statictorArray.count];
    for (MPMAuthorityModel *model in rolesArray) {
        [users addObject:@{@"id":kSafeString(model.mpm_id),@"name":kSafeString(model.name)}];
    }
    params[@"users"] = users;
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在操作" success:^(id response) {
        if (((NSString *)response[kResponseDataKey][kCode]).integerValue == 200) {
            [self getData];
        } else {
            [self showAlertControllerToLogoutWithMessage:@"操作失败" sureAction:nil needCancleButton:NO];
        }
    } failure:^(NSString *error) {
        [self showAlertControllerToLogoutWithMessage:error sureAction:nil needCancleButton:NO];
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
        if (indexPath.row == 0) {
            [[MPMDepartEmployeeHelper shareInstance].employees removeAllObjects];
            for (int i = 0; i < strongself.responderArray.count; i++) {
                MPMAuthorityModel *model = strongself.responderArray[i];
                MPMDepartment *emp = [[MPMDepartment alloc] init];
                emp.mpm_id = model.mpm_id;
                emp.isHuman = YES;
                emp.name = model.name;
                [[MPMDepartEmployeeHelper shareInstance].employees addObject:emp];
            }
        } else {
            [[MPMDepartEmployeeHelper shareInstance].employees removeAllObjects];
            for (int i = 0; i < strongself.statictorArray.count; i++) {
                MPMAuthorityModel *model = strongself.statictorArray[i];
                MPMDepartment *emp = [[MPMDepartment alloc] init];
                emp.mpm_id = model.mpm_id;
                emp.isHuman = YES;
                emp.name = model.name;
                [[MPMDepartEmployeeHelper shareInstance].employees addObject:emp];
            }
        }
        // 跳入多选人员页面（只能选择人员）
        MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:kIsNilString([MPMOauthUser shareOauthUser].shortName) ? @"部门" : [MPMOauthUser shareOauthUser].shortName] selectionType:kSelectionTypeOnlyEmployee comfirmBlock:nil];
        
        __weak typeof(strongself) wweakself = strongself;
        depart.sureSelectBlock = ^(NSArray<MPMDepartment *> *departments, NSArray<MPMDepartment *> *employees) {
            // 这里只回传人员数据
            __strong typeof(wweakself) sstrongself = wweakself;
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:employees.count];
            for (int i = 0; i < employees.count; i++) {
                MPMAuthorityModel *model = [[MPMAuthorityModel alloc] init];
                model.mpm_id = employees[i].mpm_id;
                model.name = employees[i].name;
                [temp addObject:model];
            }
            if (indexPath.row == 0) {
                // 保存到负责人
                [sstrongself saveWithRolesArray:temp.copy roleId:kRoleIdResponder];
            } else {
                // 保存到统计员
                [sstrongself saveWithRolesArray:temp.copy roleId:kRoleIdStatictor];
            }
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
        NSArray *saveArray;
        MPMAuthorityModel *model;
        NSString *roleId;
        // 相应的管理人或统计员需要删除数据并刷新页面
        if (indexPath.row == 0) {
            model = strongself.responderArray[index - Tag];
            roleId = kRoleIdResponder;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:strongself.responderArray];
            [temp removeObjectAtIndex:index - Tag];
            saveArray = temp.copy;
        } else {
            model = strongself.statictorArray[index - Tag];
            roleId = kRoleIdStatictor;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:strongself.statictorArray];
            [temp removeObjectAtIndex:index - Tag];
            saveArray = temp.copy;
        }
        __strong typeof(strongself) wweakself = strongself;
        [strongself showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"确定要移除(%@)对应的权限吗？",model.name] sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(wweakself) sstrongself = wweakself;
            [sstrongself saveWithRolesArray:saveArray roleId:roleId];
        } needCancleButton:YES];
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
    self.titleArray = @[@{@"title":@"考勤负责人",@"detail":@"负责用户授权、考勤参数配置及人员排班设置"},@{@"title":@"考勤统计员",@"detail":@"查看公司全体员工每日考勤，监督考勤审批"}];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.view);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
