//
//  MPMProcessSettingCommomViewController.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessSettingCommomViewController.h"
#import "MPMButton.h"
#import "MPMHTTPSessionManager.h"
#import "MPMProcessDef.h"
#import "MPMOauthUser.h"
#import "MPMProcessSettingTableViewCell.h"
#import "MPMProcessTaskModel.h"
#import "MPMTaskEditView.h"
#import "MPMProcessHeaderView.h"
#import "MPMBaseDealingViewController.h"

#define kCellIdentifier @"TableViewCell"

#define kProcessTableHeaderHeight   160
#define kProcessTableViewHeight     117

@interface MPMProcessSettingCommomViewController () <UITableViewDelegate, UITableViewDataSource, MPMProcessHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MPMProcessHeaderView *headerView;
@property (nonatomic, strong) MPMTaskEditView *taskView;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSaveButton;
// data
@property (nonatomic, strong) MPMProcessDef *model;
@property (nonatomic, strong) NSMutableArray<MPMProcessTaskModel *> *tasksArray;

@end

@implementation MPMProcessSettingCommomViewController

- (instancetype)initWithModel:(MPMProcessDef *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    __weak typeof(self) weakself = self;
    [self addNetworkMonitoringWithGoodNetworkBlock:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself setupSubViews];
        [strongself setupConstraints];
        if (strongself.goodNetworkToLoadBlock) {
            strongself.goodNetworkToLoadBlock();
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self) weakself = self;
    self.goodNetworkToLoadBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        [strongself getData];
    };
    [self getData];
}

- (void)getData {
    // 获取活动定义
    NSString *url = [NSString stringWithFormat:@"%@%@?processDefCode=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_TASKDEFSWA,self.model.code];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            [self.tasksArray removeAllObjects];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                MPMProcessTaskModel *model = [[MPMProcessTaskModel alloc] initWithDictionary:dic];
                if (dic[@"config"] && [dic[@"config"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *config = dic[@"config"];
                    model.config = [[MPMProcessTaskConfig alloc] initWithDictionary:config];
                } else {
                    model.config = nil;
                }
                [self.tasksArray addObject:model];
                if (self.tasksArray.count <= 1) {
                    self.model.canDelete = NO;
                } else {
                    self.model.canDelete = YES;
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.tasksArray = [NSMutableArray array];
    self.navigationItem.title = self.model.name;
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    // 通过model里面的addSignAble属性设置Switch的开关
    [self.headerView.addSignSwitch setOn:(self.model.addSignAble.integerValue == 1)];
    [self setRightBarButtonType:forBarButtonTypeTitle title:@"排序" image:nil action:@selector(edit:)];
    [self.bottomSaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomSaveButton];
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
    [self.bottomSaveButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(12);
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
}

#pragma mark - Private Method

- (void)edit:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tableView.editing = sender.isSelected;
    [self.tableView reloadData];
    NSString *title = sender.isSelected ? @"完成" : @"排序";
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitle:title forState:UIControlStateSelected];
    [sender setTitle:title forState:UIControlStateHighlighted];
}

/** 保存活动节点：1新增点击保存、2节点上移、3拖动改变 都需要先排好序再调用这个接口 */
- (void)saveTaskWithModel:(MPMProcessTaskModel *)model {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_TASKDEF];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] = model.companyId ? model.companyId : self.model.companyId;
    params[@"id"] = kSafeString(model.mpm_id);
    params[@"name"] = kSafeString(model.name);
    // 1、如果有order，说明是修改。2、如果没有order，判断之前如果已经有节点，则取最后一个节点的order再往上叠加，如果没有节点，则直接写1
    if (!kIsNilString(model.order)) {
        params[@"order"] = kSafeString(model.order);
    } else {
        if (self.tasksArray.count == 0) {
            params[@"order"] = @"1";
        } else {
            if (kIsNilString(self.tasksArray.lastObject.order)) {
                params[@"order"] = @"1";
            } else {
                params[@"order"] = [NSString stringWithFormat:@"%ld",self.tasksArray.lastObject.order.integerValue + 1];
            }
        }
    }
    params[@"processDefCode"] = model.processDefCode ? model.processDefCode : self.model.code;
    if (model.config.participants.count > 0) {
        // 选了人，方可以传递config部分
        NSMutableDictionary *config = [NSMutableDictionary dictionary];
        {
            config[@"decision"] = kSafeString(model.config.decision);
            config[@"groupId"] = kSafeString(model.config.groupId);
            NSMutableArray *participants = [NSMutableArray arrayWithCapacity:model.config.participants.count];
            for (int i = 0; i < model.config.participants.count; i++) {
                MPMProcessPeople *people = model.config.participants[i];
                [participants addObject:@{@"userId":people.userId,@"userName":people.userName}];
            }
            config[@"participants"] = participants;
        }
        params[@"config"] = config;
    }
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在保存" success:^(id response) {
        DLog(@"%@",response);
        if (response && kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
            __weak typeof(self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:@"保存成功" sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself.taskView dismiss];
                [strongself getData];
            } needCancleButton:NO];
        } else {
            NSString *message = (NSString *)response[kResponseDataKey][@"message"];
            [self showAlertControllerToLogoutWithMessage:kSafeString(message) sureAction:nil needCancleButton:NO];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

/** 自己先排好序的taskArray，再调用排序接口进行重新排序 */
- (void)orderTaskWithIndexPath:(NSArray *)indexPaths {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_ORDERTASK];
    NSMutableArray *params = [NSMutableArray array];
    for (int i = 0; i < self.tasksArray.count; i++) {
        MPMProcessTaskModel *model = self.tasksArray[i];
        [params addObject:@{@"id":kSafeString(model.mpm_id),@"order":kSafeString(model.order)}];
    }
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在修改" success:^(id response) {
        DLog(@"%@",response);
        // 自己已经排好序并修改好数据，不需要再重新请求
        NSString *url = [NSString stringWithFormat:@"%@%@?processDefCode=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_TASKDEFSWA,self.model.code];
        [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
            DLog(@"%@",response);
            if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                NSArray *object = response[kResponseObjectKey];
                [self.tasksArray removeAllObjects];
                for (int i = 0; i < object.count; i++) {
                    NSDictionary *dic = object[i];
                    MPMProcessTaskModel *model = [[MPMProcessTaskModel alloc] initWithDictionary:dic];
                    if (dic[@"config"] && [dic[@"config"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *config = dic[@"config"];
                        model.config = [[MPMProcessTaskConfig alloc] initWithDictionary:config];
                    } else {
                        model.config = nil;
                    }
                    [self.tasksArray addObject:model];
                    if (self.tasksArray.count <= 1) {
                        self.model.canDelete = NO;
                    } else {
                        self.model.canDelete = YES;
                    }
                }
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

/** 删除节点 */
- (void)deleteTaskWithId:(NSString *)mpm_id {
    NSString *url = [NSString stringWithFormat:@"%@%@?id=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_TASKDEF,mpm_id];
    [[MPMSessionManager shareManager] deleteRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在删除" success:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
                [MPMProgressHUD showSuccessWithStatus:@"删除成功"];
                [self getData];
            } else {
                NSString *message = response[kResponseDataKey][@"message"];
                message = kIsNilString(message) ? @"删除失败" : message;
                [self showAlertControllerToLogoutWithMessage:message sureAction:nil needCancleButton:NO];
            }
        } else {
            [self showAlertControllerToLogoutWithMessage:@"删除失败" sureAction:nil needCancleButton:NO];
        }
    } failure:^(NSString *error) {
        [MPMProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}

#pragma mark - MPMProcessHeaderDelegate
/** 点击预览申请模板 */
- (void)headerSeeTemplate {
    DLog(@"预览申请模板");
    NSString *type = kProcessDefCode_GetTypeFromCode[kSafeString(self.model.code)];
    MPMBaseDealingViewController *dealing = [[MPMBaseDealingViewController alloc] initWithDealType:type.integerValue dealingModel:nil dealingFromType:kDealingFromTypePreview bizorderId:nil taskInstId:nil fastCalculate:kFastCalculateTypeNone];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dealing animated:YES];
}
/** 点击switch */
- (void)headerChangeSwitch:(UISwitch *)sw {
    self.model.addSignAble = sw.isOn ? @"1" : @"0";
}
/** 点击添加节点 */
- (void)headerAddNode {
    __weak typeof(self) weakself = self;
    [self.taskView showWithModel:nil destinyVC:self completeBlock:^(MPMProcessTaskModel *updateModel) {
        __strong typeof(weakself) strongself = weakself;
        [strongself saveTaskWithModel:updateModel];
    }];
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(UIButton *)sender {
    // 这里的保存，保存的是终审加签
    NSString *url = [NSString stringWithFormat:@"%@%@?code=%@&addSignAble=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_ADDSIGN,self.model.code,kSafeString(self.model.addSignAble)];
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在加载" success:^(id response) {
        __weak typeof(self) weakself = self;
        [self showAlertControllerToLogoutWithMessage:@"保存成功" sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakself) strongself = weakself;
            [strongself.navigationController popViewControllerAnimated:YES];
        } needCancleButton:NO];
    } failure:^(NSString *error) {
        [MPMProgressHUD showErrorWithStatus:@"保存失败"];
    }];
}

#pragma mark - ScrollViewDelegate

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasksArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kProcessTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kProcessTableViewHeight;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动完成之后，交换order。然后上传新的排序
    if (sourceIndexPath == destinationIndexPath) {
        // 如果顺序没变，则不需要请求接口
        return;
    }
    NSString *sourceOrder = self.tasksArray[sourceIndexPath.row].order;
    self.tasksArray[sourceIndexPath.row].order = self.tasksArray[destinationIndexPath.row].order;
    if (sourceIndexPath.row < destinationIndexPath.row) {
        // 上面的往下挪：下面的order都往下上挪
        for (NSInteger i = destinationIndexPath.row; i > sourceIndexPath.row; i--) {
            if (sourceIndexPath.row + 1 == i) {
                // 如果是最后一个，则用temp取代
                self.tasksArray[i].order = sourceOrder;
            } else {
                self.tasksArray[i].order = self.tasksArray[i - 1].order;
            }
        }
        
    } else {
        // 下面的往上挪
        for (NSInteger i = destinationIndexPath.row; i < sourceIndexPath.row; i++) {
            if (sourceIndexPath.row - 1 == i) {
                self.tasksArray[i].order = sourceOrder;
            } else {
                self.tasksArray[i].order = self.tasksArray[i+1].order;
            }
        }
    }
    [self orderTaskWithIndexPath:@[sourceIndexPath,destinationIndexPath]];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"hehe");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = kCellIdentifier;
    MPMProcessSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMProcessSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MPMProcessTaskModel *model = self.tasksArray[indexPath.row];
    cell.flagNameLabel.text = [NSString stringWithFormat:@"节点%ld",indexPath.row + 1];
    cell.flagDetailLabel.text = model.name;
    cell.canDelete = self.model.canDelete;
    cell.updateButton.hidden = cell.deleteButton.hidden = tableView.isEditing;
    NSString *name;
    if (model.config && [model.config.participants isKindOfClass:[NSArray class]] && model.config.participants.count > 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:model.config.participants.count];
        for (MPMProcessPeople *people in model.config.participants) {
            [temp addObject:people.userName];
        }
        name = [temp componentsJoinedByString:@"、"];
    }
    cell.applyerNameLabel.text = name;
    __weak typeof(self) weakself = self;
    cell.updateBlock = ^{
        // 编辑
        __strong typeof(weakself) strongself = weakself;
        __weak typeof(strongself) wweakself = strongself;
        [strongself.taskView showWithModel:model destinyVC:strongself completeBlock:^(MPMProcessTaskModel *updateModel) {
            __strong typeof(wweakself) sstrongself = wweakself;
            [sstrongself saveTaskWithModel:updateModel];
        }];
    };
    /*
     cell.moveBlock = ^{
     // 往上移动
     __strong typeof(weakself) strongself = weakself;
     if (indexPath.row == 0) {
     return;
     }
     NSString *tempOrder = strongself.tasksArray[indexPath.row - 1].order;
     strongself.tasksArray[indexPath.row - 1].order = strongself.tasksArray[indexPath.row].order;
     strongself.tasksArray[indexPath.row].order = tempOrder;
     [strongself orderTask];
     };
     */
    cell.deleteBlock = ^{
        // 删除
        __strong typeof(weakself) strongself = weakself;
        NSString *nodeName = model.name;
        NSString *alertMessage = [NSString stringWithFormat:@"确定删除‘%@’吗",nodeName];
        __weak typeof(strongself) wweakself = strongself;
        [strongself showAlertControllerToLogoutWithMessage:alertMessage sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(wweakself) sstrongself = wweakself;
            [sstrongself deleteTaskWithId:model.mpm_id];
        } needCancleButton:YES];
    };
    return cell;
}

#pragma mark - Lazy Init

- (MPMProcessHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MPMProcessHeaderView alloc] init];
        _headerView.backgroundColor = kTableViewBGColor;
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
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

- (UIButton *)bottomSaveButton {
    if (!_bottomSaveButton) {
        _bottomSaveButton = [MPMButton titleButtonWithTitle:@"保存" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomSaveButton;
}

- (MPMTaskEditView *)taskView {
    if (!_taskView) {
        _taskView = [[MPMTaskEditView alloc] initWithFrame:self.view.bounds];
    }
    return _taskView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
