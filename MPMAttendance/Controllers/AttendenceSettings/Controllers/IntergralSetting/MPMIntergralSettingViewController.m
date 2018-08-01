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
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "MPMIntergralModel.h"
#import "MPMIntergralDefaultData.h"

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

@property (nonatomic, strong) NSMutableArray<MPMIntergralModel *> *allAttenData;/** 从接口获取到的考勤打卡数据 */
@property (nonatomic, strong) NSMutableArray<MPMIntergralModel *> *allExtraData;/** 从接口获取到的例外申请数据 */

@property (nonatomic, copy) NSArray<MPMIntergralModel *> *originalAttenData;/** 从接口获取到的考勤打卡数据 */
@property (nonatomic, copy) NSArray<MPMIntergralModel *> *originalExtraData;/** 从接口获取到的例外申请数据 */

@end

@implementation MPMIntergralSettingViewController

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

/** integralType：0考勤打卡、1例外申请 */
- (void)getData {
    dispatch_group_t group = dispatch_group_create();
    NSString *url = [NSString stringWithFormat:@"%@JiFenController/getJiFenConfigList?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSDictionary *params = @{@"token":[MPMShareUser shareUser].token,@"companyId":kSafeString([MPMShareUser shareUser].companyId),@"integralType":@(0)};
    
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
            if ([response[@"dataObj"] isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < ((NSArray *)response[@"dataObj"]).count; i++) {
                    NSDictionary *dic = response[@"dataObj"][i];
                    MPMIntergralModel *model = [[MPMIntergralModel alloc] initWithDictionary:dic];
                    [self.allAttenData addObject:model];
                    for (int j = 0; j < self.originalAttenData.count; j++) {
                        if ([model.mpm_id isEqualToString:((MPMIntergralModel *)self.originalAttenData[j]).mpm_id]) {
                            ((MPMIntergralModel *)self.originalAttenData[j]).conditions = model.conditions;
                            ((MPMIntergralModel *)self.originalAttenData[j]).integralType = model.integralType;
                            ((MPMIntergralModel *)self.originalAttenData[j]).integralValue = model.integralValue;
                            ((MPMIntergralModel *)self.originalAttenData[j]).isTick = model.isTick;
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
    
    params = @{@"token":[MPMShareUser shareUser].token,@"companyId":kSafeString([MPMShareUser shareUser].companyId),@"integralType":@(1)};
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在加载" success:^(id response) {
            if ([response[@"dataObj"] isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < ((NSArray *)response[@"dataObj"]).count; i++) {
                    NSDictionary *dic = response[@"dataObj"][i];
                    MPMIntergralModel *model = [[MPMIntergralModel alloc] initWithDictionary:dic];
                    [self.allExtraData addObject:model];
                    for (int j = 0; j < self.originalExtraData.count; j++) {
                        if ([model.mpm_id isEqualToString:((MPMIntergralModel *)self.originalExtraData[j]).mpm_id]) {
                            ((MPMIntergralModel *)self.originalExtraData[j]).conditions = model.conditions;
                            ((MPMIntergralModel *)self.originalExtraData[j]).integralType = model.integralType;
                            ((MPMIntergralModel *)self.originalExtraData[j]).integralValue = model.integralValue;
                            ((MPMIntergralModel *)self.originalExtraData[j]).isTick = model.isTick;
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
    if (self.segmentControl.selectedSegmentIndex == 0) {
        for (int i = 0; i < self.originalAttenData.count; i++) {
            MPMIntergralModel *model = self.originalAttenData[i];
            self.originalAttenData[i].needCondiction = kJiFenType0NeedCondictionFromId[model.mpm_id];
            self.originalAttenData[i].conditions = kJiFenType0NeedCondictionsDefaultValueFromId[model.mpm_id];
            self.originalAttenData[i].integralValue = kJiFenType0IntergralValueFromId[model.mpm_id];
            self.originalAttenData[i].isTick = kJiFenType0IsTickFromId[model.mpm_id];
            self.originalAttenData[i].isChange = @"1";
        }
    } else {
        for (int i = 0; i < self.originalExtraData.count; i++) {
            MPMIntergralModel *model = self.originalExtraData[i];
            self.originalExtraData[i].needCondiction = kJiFenType1NeedCondictionFromId[model.mpm_id];
            self.originalExtraData[i].conditions = kJiFenType1NeedCondictionsDefaultValueFromId[model.mpm_id];
            self.originalExtraData[i].integralValue = kJiFenType1IntergralValueFromId[model.mpm_id];
            self.originalExtraData[i].isTick = kJiFenType1IsTickFromId[model.mpm_id];
            self.originalExtraData[i].isChange = @"1";
        }
    }
    [self.tableView reloadData];
}

- (void)save:(UIButton *)sender {
    DLog(@"保存");
    NSString *url = [NSString stringWithFormat:@"%@JiFenController/addJiFenConfig?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSArray *allArray = self.segmentControl.selectedSegmentIndex == 0 ? self.allAttenData.copy : self.allExtraData.copy;
    NSArray *arr = self.segmentControl.selectedSegmentIndex == 0 ? self.originalAttenData : self.originalExtraData;
    NSMutableArray *params = [NSMutableArray array];
    for (int i = 0; i < allArray.count; i++) {
        BOOL needRefresh = NO;
        MPMIntergralModel *temp;
        MPMIntergralModel *model = allArray[i];
        for (int j = 0; j < arr.count; j++) {
            MPMIntergralModel *newModel = arr[j];
            if ([model.mpm_id isEqualToString:newModel.mpm_id]) {
                needRefresh = YES;
                temp = newModel;
                continue;
            }
        }
        if (needRefresh) {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
            tempDic[@"companyId"] = [MPMShareUser shareUser].companyId;
            tempDic[@"conditions"] = temp.conditions;
            tempDic[@"id"] = temp.mpm_id;
            tempDic[@"integralType"] = temp.integralType;
            tempDic[@"integralValue"] = temp.integralValue;
            tempDic[@"isTick"] = temp.isTick;
            [params addObject:tempDic];
        } else {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
            tempDic[@"companyId"] = [MPMShareUser shareUser].companyId;
            tempDic[@"conditions"] = model.conditions;
            tempDic[@"id"] = model.mpm_id;
            tempDic[@"integralType"] = model.integralType;
            tempDic[@"integralValue"] = model.integralValue;
            tempDic[@"isTick"] = model.isTick;
            [params addObject:tempDic];
        }
    }
//    for (int i = 0; i < arr.count; i++) {
//        MPMIntergralModel *model = arr[i];
//        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
//        tempDic[@"companyId"] = [MPMShareUser shareUser].companyId;
//        tempDic[@"conditions"] = model.conditions;
//        tempDic[@"id"] = model.mpm_id;
//        tempDic[@"integralType"] = model.integralType;
//        tempDic[@"integralValue"] = model.integralValue;
//        tempDic[@"isTick"] = model.isTick;
//        [params addObject:tempDic];
//    }
    [[MPMSessionManager shareManager] postRequestWithURL:url params:@{@"kqJifenConfig":params} loadingMessage:@"正在保存" success:^(id response) {
        [self showAlertControllerToLogoutWithMessage:@"保存成功" sureAction:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        } needCancleButton:NO];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        return self.originalAttenData.count;
    } else {
        return self.originalExtraData.count;
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
    NSArray<MPMIntergralModel *> *arr = self.segmentControl.selectedSegmentIndex == 0 ? self.originalAttenData : self.originalExtraData;
    MPMIntergralModel *model = arr[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.subTitleLabel.text = model.subTitle;
    cell.selectionButton.hidden = (model.needCondiction.integerValue == 0);
    NSArray *defaultCondictionValues = self.segmentControl.selectedSegmentIndex == 0 ? kJiFenType0CondictionAllValueFromId[model.mpm_id] : kJiFenType1CondictionAllValueFromId[model.mpm_id];
    if (defaultCondictionValues.count > 0) {
        [cell.selectionButton setTitle:defaultCondictionValues[model.conditions.integerValue] forState:UIControlStateNormal];
    }
    if (model.integralValue.integerValue >= 0) {
        cell.intergralView.textLabel.text = @"+B";
    } else {
        cell.intergralView.textLabel.text = @"-B";
    }
    cell.intergralView.textfield.text = [NSString stringWithFormat:@"%d",abs(model.integralValue.intValue)];
    cell.ticketButton.selected = (model.isTick.integerValue == 1);
    // 修改B分的图片
    cell.intergralView.state = model.integralValue.integerValue >= 0 ? 0 : 1;// 0加号，1减号
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
    self.allAttenData = [NSMutableArray array];
    self.allExtraData = [NSMutableArray array];
    self.originalAttenData = [MPMIntergralDefaultData getIntergralDefaultDataOfIntergralType:0];
    self.originalExtraData = [MPMIntergralDefaultData getIntergralDefaultDataOfIntergralType:1];
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
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"考勤打卡",@"例外申请"]];
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
