//
//  MPMClassSettingViewController.m
//  MPMAtendence
//  班次设置
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMClassSettingViewController.h"
#import "MPMButton.h"
#import "MPMShareUser.h"
#import "MPMHTTPSessionManager.h"
#import "MPMCustomDatePickerView.h"
#import "MPMTableHeaderView.h"
#import "MPMClassSettingTableViewCell.h"
#import "MPMClassSettingImageTableViewCell.h"
#import "MPMClassSettingCycleModel.h"
#import "MPMSettingTimeModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMClassSettingSelectWeekView.h"
#import "MPMSettingTimeViewController.h"
#import "MPMSettingCardViewController.h"
#import "MPMSettingSwitchTableViewCell.h"
#import "MPMBaseTableViewCell.h"

@interface MPMClassSettingViewController () <UITableViewDelegate, UITableViewDataSource, MPMSettingSwitchTableViewCellSwitchDelegate>

@property (nonatomic, strong) UITableView *tableView;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomNextOrSaveButton;
// picker
@property (nonatomic, strong) MPMCustomDatePickerView *customDatePickerView;
@property (nonatomic, strong) MPMClassSettingSelectWeekView *weekView;
// data
@property (nonatomic, copy) NSArray *titlesArray;
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, assign) DulingType dulingType;
@property (nonatomic, strong) MPMClassSettingCycleModel *cycleModel;
@property (nonatomic, copy) NSArray *settingTimeArray;

@end

@implementation MPMClassSettingViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 从考勤设置时间回来，需要再获取一下数据
    [self getData];
}

- (void)setupAttributes {
    [super setupAttributes];
    [self.bottomNextOrSaveButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.bottomNextOrSaveButton setTitle:@"下一步" forState:UIControlStateHighlighted];
    self.navigationItem.title = @"班次设置";
    self.titlesArray = @[@[@"排班方式",@"每天开始签到时间",@"考勤日期",@"考勤时间"],
                         @[@"启动下班无需打卡"]
                         ];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
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

- (void)getData {
    
    dispatch_group_t group = dispatch_group_create();
    // 获取“考勤周期”和”新的一天开始签到时间“和“排班方式”
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@classSettingController/getClassSettingBySchedulingId?schedulingId=%@&token=%@",MPMHost,self.schedulingId,[MPMShareUser shareUser].token];
        NSDictionary *params;
        [[MPMHTTPSessionManager shareManager] getRequestWithURL:url params:params success:^(id response) {
            DLog(@"%@",response);
            NSDictionary *dic = response[@"dataObj"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                MPMClassSettingCycleModel *model = [[MPMClassSettingCycleModel alloc] initWithDictionary:dic];
                if (self.cycleModel) {
                    model.resetTime = self.cycleModel.resetTime;
                    model.cycle = self.cycleModel.cycle;
                    model.cnCycle = self.cycleModel.cnCycle;
                    model.classSettingType = self.cycleModel.classSettingType;
                    model.automaticPunchCard = self.cycleModel.automaticPunchCard;
                    self.cycleModel = model;
                } else {
                    self.cycleModel = model;
                    self.cycleModel.classSettingType = @"0";
                }
            } else {
                MPMClassSettingCycleModel *model = [[MPMClassSettingCycleModel alloc] init];
                if (self.cycleModel) {
                    model.resetTime = self.cycleModel.resetTime;
                    model.cycle = self.cycleModel.cycle;
                    model.cnCycle = self.cycleModel.cnCycle;
                    model.classSettingType = self.cycleModel.classSettingType;
                    model.automaticPunchCard = self.cycleModel.automaticPunchCard;
                    self.cycleModel = model;
                } else {
                    self.cycleModel = model;
                    self.cycleModel.classSettingType = @"0";
                }
            }
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    
    // 获取“考勤时间“和间休
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@timeSlotController/getTimeSlotBySchedulingId?schedulingId=%@&token=%@",MPMHost,self.schedulingId,[MPMShareUser shareUser].token];
        NSDictionary *params;
        [[MPMHTTPSessionManager shareManager] getRequestWithURL:url params:params success:^(id response) {
            DLog(@"%@",response);
            NSArray *arr = response[@"dataObj"];
            if ([arr isKindOfClass:[NSArray class]]) {
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
                for (NSDictionary *dic in arr) {
                    MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] initWithDictionary:dic];
                    [temp addObject:model];
                }
                self.settingTimeArray = temp.copy;
            }
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, kMainQueue, ^{
        // 更新界面
        [self.cycleModel translateCycle];
        // 计算考勤时间
        double duration = 0;
        if (self.settingTimeArray.count == 1) {
            MPMSettingTimeModel *model = self.settingTimeArray[0];
            duration += (model.returnTime.doubleValue - model.signTime.doubleValue + model.noonBreakStartTime.doubleValue - model.noonBreakEndTime.doubleValue);
        } else {
            for (int i = 0; i < self.settingTimeArray.count; i++) {
                MPMSettingTimeModel *model = self.settingTimeArray[i];
                duration += model.returnTime.doubleValue - model.signTime.doubleValue;
            }
        }
        self.cycleModel.startTime = ((MPMSettingTimeModel *)self.settingTimeArray.firstObject).signTime;
        self.cycleModel.endTime = ((MPMSettingTimeModel *)self.settingTimeArray.lastObject).returnTime;
        // 计算考勤时长
        self.cycleModel.duration = [NSString stringWithFormat:@"%.1f",duration / 3600000];
        [self.tableView reloadData];
    });
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextOrSave:(UIButton *)sender {
    DLog(@"下一步或者保存");
    if (kIsNilString(self.cycleModel.resetTime)) {
        [self showAlertControllerToLogoutWithMessage:@"请选择每天开始签到时间" sureAction:nil needCancleButton:NO];
        return;
    }
    if (kIsNilString(self.cycleModel.cycle)) {
        [self showAlertControllerToLogoutWithMessage:@"请选择考勤日期" sureAction:nil needCancleButton:NO];
        return;
    }
    if (kIsNilString(self.cycleModel.startTime) || kIsNilString(self.cycleModel.endTime)) {
        [self showAlertControllerToLogoutWithMessage:@"请选择考勤时间" sureAction:nil needCancleButton:NO];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@classSettingController/saveClassSetting?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSDictionary *params = @{@"classSettingId":kSafeString(self.cycleModel.classSettingId),@"classSettingType":self.cycleModel.classSettingType,@"cycle":self.cycleModel.cycle,@"resetTime":self.cycleModel.resetTime,@"schedulingId":self.schedulingId,@"automaticPunchCard":self.cycleModel.automaticPunchCard ? self.cycleModel.automaticPunchCard : @"0"};
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在加载" success:^(id response) {
        if (self.dulingType == kDulingTypeSetting) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // 跳入下一个控制器
            MPMSettingCardViewController *settingCard = [[MPMSettingCardViewController alloc] initWithSchedulingId:self.schedulingId settingType:kDulingTypeCreate];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingCard animated:YES];
        }
    } failure:^(NSString *error) {
        [self showAlertControllerToLogoutWithMessage:error sureAction:nil needCancleButton:NO];
    }];
}

#pragma mark - SwitchChangeDelegate
- (void)settingSwithChange:(UISwitch *)sw {
    self.cycleModel.automaticPunchCard = sw.isOn ? @"1" : @"0";
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.titlesArray[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MPMTableHeaderView *header = [[MPMTableHeaderView alloc] init];
        header.headerTextLabel.text = @"对考勤组”名称”的规则进行设置";
        return header;
    } else {
        return [[UIView alloc] init];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 排班方式
        static NSString *identifier = @"cell1";
        MPMClassSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMClassSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
        NSInteger index;
        if (kIsNilString(self.cycleModel.classSettingType)) {
            index = 0;
        } else {
            if (self.cycleModel.classSettingType.integerValue > 2 || self.cycleModel.classSettingType.integerValue < 0) {
                index = 0;
            } else {
                index = self.cycleModel.classSettingType.integerValue;
            }
        }
        cell.segmentView.selectedSegmentIndex = index;
        cell.segChangeBlock = ^(NSInteger selectedIndex) {
            // 切换了segmentControl--目前只能固定排班
        };
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        // 考勤日期/考勤周期
        static NSString *identifier = @"cell2";
        MPMClassSettingImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMClassSettingImageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
        if (kIsNilString(self.cycleModel.cnCycle)) {
            cell.detailTxLabel.text = @"请选择";
        } else {
            cell.detailTxLabel.text = self.cycleModel.cnCycle;
        }
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        // 启动下班无需打卡
        static NSString *identifier = @"cell3";
        MPMSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMSettingSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
        [cell.startNonSwitch setOn:[self.cycleModel.automaticPunchCard isEqualToString:@"1"]];
        cell.switchDelegate = self;
        return cell;
    } else {
        // 时间选择
        static NSString *identifier = @"cell4";
        MPMBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
        if (indexPath.row == 3) {
            if (kIsNilString(self.cycleModel.startTime) || kIsNilString(self.cycleModel.startTime)) {
                cell.detailTextLabel.text = @"";
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.cycleModel.startTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.cycleModel.endTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
            }
        } else if (indexPath.row == 1) {
            if (kIsNilString(self.cycleModel.resetTime)) {
                cell.detailTextLabel.text = @"";
            } else {
                cell.detailTextLabel.text = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.cycleModel.resetTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            // 每天开始签到时间
            NSDate *defaultDate = [NSDate dateWithTimeIntervalSince1970:[NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970]];
            [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeHourMinute defaultDate:defaultDate];
            __weak typeof(self) weakself = self;
            self.customDatePickerView.completeBlock = ^(NSDate *date) {
                __strong typeof(weakself) strongself = weakself;
                NSString *timerString = [NSString stringWithFormat:@"%.0f",(date.timeIntervalSince1970 - [NSDateFormatter getZeroWithTimeInterverl:date.timeIntervalSince1970] - 28800) * 1000];
                strongself.cycleModel.resetTime = timerString;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
        } else if (indexPath.row == 2) {
            // 选择考勤日期
            __weak typeof(self) weakself = self;
            [self.weekView showInViewWithCycle:self.cycleModel.cycle completeBlock:^(NSString *cycle) {
                __strong typeof(weakself) strongself = weakself;
                strongself.cycleModel.cycle = cycle;
                [strongself.cycleModel translateCycle];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        } else {
            // 跳入时间段设置页面
            MPMSettingTimeViewController *settime = [[MPMSettingTimeViewController alloc] initWithSchedulingId:self.schedulingId dulingType:kDulingTypeSetting resetTime:self.cycleModel.resetTime];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settime animated:YES];
        }
    }
}

#pragma mark - Lazy Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
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

- (MPMCustomDatePickerView *)customDatePickerView {
    if (!_customDatePickerView) {
        _customDatePickerView = [[MPMCustomDatePickerView alloc] init];
    }
    return _customDatePickerView;
}

- (MPMClassSettingSelectWeekView *)weekView {
    if (!_weekView) {
        _weekView = [[MPMClassSettingSelectWeekView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _weekView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
