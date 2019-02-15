//
//  MPMIntergralSettingViewController.m
//  MPMAtendence
//  积分设置
//  Created by shengangneng on 2018/6/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMIntergralSettingViewController.h"
#import "MPMButton.h"
#import "MPMTableHeaderView.h"
#import "MPMIntergralSettingTableViewCell.h"
#import "UIImage+MPMExtention.h"
#import "MPMAttendencePickerView.h"
#import "MPMHTTPSessionManager.h"
#import "MPMShareUser.h"
#import "MPMIntergralModel.h"
#import "MPMIntergralDefaultData.h"
#import "MPMOauthUser.h"

#define kSegmentItems @[@"考勤打卡",@"例外申请"]

@interface MPMIntergralSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIView *segmentShadowView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) MPMAttendencePickerView *pickerView;
// Data
@property (nonatomic, copy) NSArray<MPMIntergralModel *> *allAttenData;/** 从接口获取到的考勤打卡数据 */
@property (nonatomic, copy) NSArray<MPMIntergralModel *> *allExtraData;/** 从接口获取到的例外申请数据 */

@end

@implementation MPMIntergralSettingViewController

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

- (void)getData {
    // 考勤打卡：0
    NSString *url = [NSString stringWithFormat:@"%@%@?scene=%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_INTERGRAL_LIST,@"0"];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
            if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < ((NSArray *)response[kResponseObjectKey]).count; i++) {
                    NSDictionary *dic = response[kResponseObjectKey][i];
                    MPMIntergralModel *data = [[MPMIntergralModel alloc] initWithDictionary:dic];
                    for (int  j = 0; j < self.allAttenData.count; j++) {
                        MPMIntergralModel *model = self.allAttenData[j];
                        if ([model.integralType isEqualToString:data.integralType]) {
                            model.companyId = data.companyId;
                            model.conditions = data.conditions;
                            model.isTick = data.isTick;
                            model.mpm_description = data.mpm_description;
                            model.mpm_id = data.mpm_id;
                            model.integralValue = data.integralValue;
                            model.name = data.name;
                            model.scene = data.scene;
                            continue;
                        }
                    }
                }
            }
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    // 例外申请：1
    url = [NSString stringWithFormat:@"%@%@?scene=%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_INTERGRAL_LIST,@"1"];
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在加载" success:^(id response) {
            if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < ((NSArray *)response[kResponseObjectKey]).count; i++) {
                    NSDictionary *dic = response[kResponseObjectKey][i];
                    MPMIntergralModel *data = [[MPMIntergralModel alloc] initWithDictionary:dic];
                    for (int  j = 0; j < self.allExtraData.count; j++) {
                        MPMIntergralModel *model = self.allExtraData[j];
                        if ([model.integralType isEqualToString:data.integralType]) {
                            model.companyId = data.companyId;
                            model.isTick = data.isTick;
                            model.conditions = data.conditions;
                            model.mpm_description = data.mpm_description;
                            model.mpm_id = data.mpm_id;
                            model.integralValue = data.integralValue;
                            model.name = data.name;
                            model.scene = data.scene;
                            continue;
                        }
                    }
                }
            }
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
            [MPMProgressHUD showErrorWithStatus:error];
        }];
    });
    
    dispatch_group_notify(group, kMainQueue, ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentChange:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (void)reset:(UIButton *)sender {
    DLog(@"重置");
    for (int i = 0; i < self.allAttenData.count; i++) {
        MPMIntergralModel *model = self.allAttenData[i];
        self.allAttenData[i].needCondiction = kJiFenType0NeedCondictionFromId[model.integralType];
        self.allAttenData[i].conditions = kJiFenType0NeedCondictionsDefaultValueFromId[model.integralType];
        self.allAttenData[i].integralValue = kJiFenType0IntergralValueFromId[model.integralType];
        self.allAttenData[i].isTick = kJiFenType0IsTickFromId[model.integralType];
        self.allAttenData[i].typeCanChange = kJiFenType0CanChangeFromId[model.integralType];
        self.allAttenData[i].mpm_description = kJiFenType0DescriptionFromId[model.integralType];
        self.allAttenData[i].isChange = @"1";
    }
    for (int i = 0; i < self.allExtraData.count; i++) {
        MPMIntergralModel *model = self.allExtraData[i];
        self.allExtraData[i].needCondiction = kJiFenType1NeedCondictionFromId[model.integralType];
        self.allExtraData[i].conditions = kJiFenType1NeedCondictionsDefaultValueFromId[model.integralType];
        self.allExtraData[i].integralValue = kJiFenType1IntergralValueFromId[model.integralType];
        self.allExtraData[i].isTick = kJiFenType1IsTickFromId[model.integralType];
        self.allExtraData[i].typeCanChange = kJiFenType1CanChangeFromId[model.integralType];
        self.allExtraData[i].mpm_description = kJiFenType1DescriptionFromId[model.integralType];
        self.allExtraData[i].isChange = @"1";
    }
    [self resetOrSaveIntegral:YES];
}

- (void)save:(UIButton *)sender {
    DLog(@"保存");
    [self resetOrSaveIntegral:NO];
}

/** YES:reset NO:save */
- (void)resetOrSaveIntegral:(BOOL)reset {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_INTERGRAL_SAVE];
    NSMutableArray *allArray = [NSMutableArray arrayWithArray:self.allAttenData];
    [allArray addObjectsFromArray:self.allExtraData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:allArray.count];
    for (int i = 0; i < allArray.count; i++) {
        MPMIntergralModel *model = allArray[i];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        tempDic[@"companyId"] = [MPMOauthUser shareOauthUser].company_id;
        tempDic[@"conditions"] = model.conditions;
        tempDic[@"description"] = model.mpm_description;
        tempDic[@"id"] = model.mpm_id;
        tempDic[@"integralType"] = model.integralType;
        tempDic[@"integralValue"] = model.integralValue;
        tempDic[@"isTick"] = model.isTick;
        tempDic[@"name"] = model.name;
        tempDic[@"scene"] = model.scene;
        if (model.isChange.integerValue == 1) {
            [temp addObject:tempDic];
        }
    }
    [params setObject:temp forKey:@"scoreVo"];
    [MPMSessionManager shareManager].managerV2.requestSerializer = [MPMJSONRequestSerializer serializer];
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在操作" success:^(id response) {
        DLog(@"%@",response);
        __weak typeof(self) weakself = self;
        if (reset) {
            [self showAlertControllerToLogoutWithMessage:@"重置成功" sureAction:nil needCancleButton:NO];
            [self getData];
        } else {
            [self showAlertControllerToLogoutWithMessage:@"保存成功" sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself.navigationController popViewControllerAnimated:YES];
            } needCancleButton:NO];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        return self.allAttenData.count;
    } else {
        return self.allExtraData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MPMTableHeaderView *header = [[MPMTableHeaderView alloc] init];
    header.headerTextLabel.text = @"负责人自行设置奖扣分值";
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"IntegralSettingCell";
    MPMIntergralSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[MPMIntergralSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    NSArray<MPMIntergralModel *> *arr = self.segmentControl.selectedSegmentIndex == 0 ? self.allAttenData : self.allExtraData;
    MPMIntergralModel *model = arr[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.subTitleLabel.text = model.mpm_description;
    cell.selectionButton.hidden = (model.needCondiction.integerValue == 0);
    NSArray *defaultCondictionValues = self.segmentControl.selectedSegmentIndex == 0 ? kJiFenType0CondictionAllValueFromId[model.integralType] : kJiFenType1CondictionAllValueFromId[model.integralType];
    if (defaultCondictionValues.count > 0) {
        [cell.selectionButton setTitle:defaultCondictionValues[model.conditions.integerValue] forState:UIControlStateNormal];
    }
    cell.intergralView.textfield.text = [NSString stringWithFormat:@"%d",abs(model.integralValue.intValue)];
    cell.ticketButton.selected = (model.isTick.integerValue == 1);
    // 修改B分的图片：0加分 1减分
    NSString *defaultValue = self.segmentControl.selectedSegmentIndex == 0 ? kJiFenType0IntergralValueFromId[model.integralType] : kJiFenType1IntergralValueFromId[model.integralType];
    if (model.integralValue.integerValue > 0) {
        cell.intergralView.state = 0;
    } else if (model.integralValue.integerValue < 0) {
        cell.intergralView.state = 1;
    } else {
        if (defaultValue.integerValue >= 0) {
            cell.intergralView.state = 0;
        } else {
            cell.intergralView.state = 1;
        }
    }
    cell.intergralView.type = model.type.integerValue;
    cell.intergralView.imageView.userInteractionEnabled = (model.typeCanChange.integerValue == 1);
    
    __weak typeof(self) weakself = self;
    __weak MPMIntergralSettingTableViewCell *weakcell = cell;
    cell.selectTimePickerBlock = ^(UIButton *sender) {
        // 点击选择频次
        __strong typeof(weakself) strongself = weakself;
        [strongself.view endEditing:YES];
        [strongself.pickerView showInView:kAppDelegate.window withPickerData:defaultCondictionValues selectRow:model.conditions.integerValue];
        strongself.pickerView.completeSelectBlock = ^(NSString *data) {
            __strong MPMIntergralSettingTableViewCell *strongcell = weakcell;
            [strongcell.selectionButton setTitle:data forState:UIControlStateNormal];
            [strongcell.selectionButton setTitle:data forState:UIControlStateHighlighted];
            arr[indexPath.row].conditions = @{@"每次":@"0",@"每分钟":@"1",@"每小时":@"2",@"每半天":@"3",@"全天":@"4"}[data];
            arr[indexPath.row].isChange = @"1";
        };
    };
    cell.tfBecomeResponderBlock = ^(UITextField *textfield) {
        // 积分输入框聚焦的时候，tableView滚动到当前cell
        __strong typeof(weakself) strongself = weakself;
        [strongself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    };
    cell.tfChangeTextBlock = ^(NSString *text) {
        __strong MPMIntergralSettingTableViewCell *strongcell = weakcell;
        // 积分输入框改变了输入
        if (strongcell.intergralView.state == 0) {
            // 正
            arr[indexPath.row].integralValue = [NSString stringWithFormat:@"%d",abs(text.intValue)];
        } else {
            // 负
            arr[indexPath.row].integralValue = [NSString stringWithFormat:@"-%d",abs(text.intValue)];
        }
        arr[indexPath.row].isChange = @"1";
    };
    cell.selectTicketBlock = ^(UIButton *sender) {
        // 点击奖票按钮
        __strong typeof(weakself) strongself = weakself;
        [strongself.view endEditing:YES];
        arr[indexPath.row].isTick = sender.selected ? @"1" : @"0";
        arr[indexPath.row].isChange = @"1";
    };
    cell.changeStateBlock = ^(NSInteger state) {    // state：0加号、1减号
        // 点击加减分图标切换状态
        if (state == 0) {
            // 正
            arr[indexPath.row].integralValue = [NSString stringWithFormat:@"%d",abs(arr[indexPath.row].integralValue.intValue)];
        } else {
            // 负
            arr[indexPath.row].integralValue = [NSString stringWithFormat:@"-%d",abs(arr[indexPath.row].integralValue.intValue)];
        }
        arr[indexPath.row].isChange = @"1";
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Init Setup
- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"积分设置";
    self.view.backgroundColor = kTableViewBGColor;
    // 先获取获取考勤打卡、例外申请 积分设置的默认配置
    self.allAttenData = [MPMIntergralDefaultData getIntergralDefaultDataOfScene:0];
    self.allExtraData = [MPMIntergralDefaultData getIntergralDefaultDataOfScene:1];
    [self.segmentControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.segmentShadowView];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.resetButton];
    [self.bottomView addSubview:self.saveButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.segmentControl mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@38);
        make.width.equalTo(@190);
        make.centerX.equalTo(self.view.mpm_centerX);
        make.top.equalTo(self.view.mpm_top).offset(20);
    }];
    [self.segmentShadowView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.segmentControl);
    }];
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mpm_bottom).offset(20);
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
    [self.resetButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(12);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
    [self.saveButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.resetButton.mpm_trailing).offset(12);
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-12);
        make.width.equalTo(self.resetButton.mpm_width);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
}

#pragma mark - Lazy Init
- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:kSegmentItems];
        _segmentControl.tintColor = kClearColor;
        [_segmentControl setDividerImage:[UIImage getImageFromColor:kMainBlueColor] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentControl setDividerImage:[UIImage getImageFromColor:kMainBlueColor] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [_segmentControl setDividerImage:[UIImage getImageFromColor:kMainBlueColor] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        _segmentControl.layer.masksToBounds = YES;
        _segmentControl.layer.cornerRadius = 5;
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:SystemFont(17),NSForegroundColorAttributeName:kMainBlueColor} forState:UIControlStateNormal];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:SystemFont(17),NSForegroundColorAttributeName:kWhiteColor} forState:UIControlStateSelected];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:SystemFont(17),NSForegroundColorAttributeName:kMainBlueColor} forState:UIControlStateHighlighted];
        [_segmentControl setSelectedSegmentIndex:0];
        [_segmentControl setBackgroundImage:[UIImage getImageFromColor:kWhiteColor] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentControl setBackgroundImage:[UIImage getImageFromColor:kMainBlueColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [_segmentControl setBackgroundImage:[UIImage getImageFromColor:kWhiteColor] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
    return _segmentControl;
}

- (UIView *)segmentShadowView {
    if (!_segmentShadowView) {
        _segmentShadowView = [[UIView alloc] init];
        _segmentShadowView.layer.cornerRadius = 5;
        _segmentShadowView.layer.shadowColor = kMainBlueColor.CGColor;
        _segmentShadowView.layer.shadowOffset = CGSizeMake(0.5, 1);
        _segmentShadowView.layer.shadowOpacity = 0.5;
        _segmentShadowView.backgroundColor = kTableViewBGColor;
    }
    return _segmentShadowView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController:tvc];
        _tableView = tvc.tableView;
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewBGColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [MPMButton titleButtonWithTitle:@"重置" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _resetButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [MPMButton titleButtonWithTitle:@"保存" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _saveButton;
}

- (MPMAttendencePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MPMAttendencePickerView alloc] init];
    }
    return _pickerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
