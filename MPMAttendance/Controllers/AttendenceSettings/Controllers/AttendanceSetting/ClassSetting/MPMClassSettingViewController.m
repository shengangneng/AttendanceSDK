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
#import "MPMAttendanceSettingModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMSettingClassListViewController.h"
#import "MPMSettingClassListModel.h"

@interface MPMClassSettingViewController () <UITableViewDelegate, UITableViewDataSource, MPMSettingSwitchTableViewCellSwitchDelegate, MPMSettingClassTimeDelegate>

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
@property (nonatomic, strong) MPMAttendanceSettingModel *model; /** 一个全局的model保存数据 */
@property (nonatomic, copy) NSArray *settingTimeArray;

@end

@implementation MPMClassSettingViewController

- (instancetype)initWithModel:(nonnull MPMAttendanceSettingModel *)model settingType:(DulingType)dulingType {
    self = [super init];
    if (self) {
        self.model = model;
        if (kIsNilString(self.model.type)) {
            self.model.type = @"0";// 默认为固定排班
        }
        ClassType type = self.model.type.integerValue;
        if (type == kClassTypeFixation) {
            if (!self.model.fixedTimeWorkSchedule[@"daysOfWeek"]) {
                self.model.fixedTimeWorkSchedule[@"daysOfWeek"] = @[@"2",@"3",@"4",@"5",@"6"];
                [self.model translateCycle];
            }
        } else if (type == kClassTypeFree) {
            if (!self.model.flexibleTimeWorkSchedule[@"daysOfWeek"]) {
                self.model.flexibleTimeWorkSchedule[@"daysOfWeek"] = @[@"2",@"3",@"4",@"5",@"6"];
                [self.model translateCycle];
            }
        }
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
}

- (void)setupAttributes {
    [super setupAttributes];
    [self.bottomNextOrSaveButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.bottomNextOrSaveButton setTitle:@"下一步" forState:UIControlStateHighlighted];
    self.navigationItem.title = @"班次设置";
    [self changeUIAndDataWithClassType:self.model.type.integerValue];
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

#pragma mark - Private Method
/** 固定排班、自由排班切换之后，需要更新数据和UI */
- (void)changeUIAndDataWithClassType:(ClassType)classType {
    self.model.type = [NSString stringWithFormat:@"%ld",classType];
    
    // 需要交换固定排班和自由排班的数据
    if (classType == kClassTypeFixation) {
        // 固定排班
        self.titlesArray = @[@[@"排班方式",@"考勤日期",@"考勤班次"],
                             //                             @[@"启动下班无需打卡"]
                             ];
        if (((NSArray *)self.model.flexibleTimeWorkSchedule[@"daysOfWeek"]).count > 0) {
            self.model.fixedTimeWorkSchedule[@"daysOfWeek"] = self.model.flexibleTimeWorkSchedule[@"daysOfWeek"];
        }
        if (((NSArray *)self.model.flexibleTimeWorkSchedule[@"locatioinSettings"]).count > 0) {
            self.model.fixedTimeWorkSchedule[@"locatioinSettings"] = self.model.flexibleTimeWorkSchedule[@"locatioinSettings"];
        }
        if (self.model.flexibleTimeWorkSchedule[@"offset"]) {
            self.model.fixedTimeWorkSchedule[@"offset"] = self.model.flexibleTimeWorkSchedule[@"offset"];
        }
    } else if (classType == kClassTypeFree) {
        // 自由排班
        self.titlesArray = @[@[@"排班方式",@"考勤日期"],
                             //                             @[@"启动下班无需打卡"]
                             ];
        if (((NSArray *)self.model.fixedTimeWorkSchedule[@"daysOfWeek"]).count > 0) {
            self.model.flexibleTimeWorkSchedule[@"daysOfWeek"] = self.model.fixedTimeWorkSchedule[@"daysOfWeek"];
        }
        if (((NSArray *)self.model.fixedTimeWorkSchedule[@"locatioinSettings"]).count > 0) {
            self.model.flexibleTimeWorkSchedule[@"locatioinSettings"] = self.model.fixedTimeWorkSchedule[@"locatioinSettings"];
        }
        if (self.model.fixedTimeWorkSchedule[@"offset"]) {
            self.model.flexibleTimeWorkSchedule[@"offset"] = self.model.fixedTimeWorkSchedule[@"offset"];
        }
    }
}

/** 根据班次返回拼接的字符串 */
- (NSString *)getTimeStringWithTimeSchedule:(NSMutableDictionary *)schedule {
    NSString *timeString;
    NSArray *signTimeSections = schedule[@"signTimeSections"];
    NSDictionary *freeTimeSection = [schedule[@"freeTimeSection"] isKindOfClass:[NSDictionary class]] ? schedule[@"freeTimeSection"] : nil;
    NSString *hour = schedule[@"hour"];
    
    if (!signTimeSections || signTimeSections.count == 0) {
        timeString = @"";
    } else if (signTimeSections.count == 1) {
        // 这里可能还要考虑‘间休’
        NSString *signTime = signTimeSections.firstObject[@"signTime"];
        NSString *returnTime = signTimeSections.firstObject[@"returnTime"];
        if (freeTimeSection && ![freeTimeSection[@"start"] isKindOfClass:[NSNull class]] && ![freeTimeSection[@"end"] isKindOfClass:[NSNull class]]) {
            NSString *start = kNumberSafeString(freeTimeSection[@"start"]);
            NSString *end = kNumberSafeString(freeTimeSection[@"end"]);
            timeString = [NSString stringWithFormat:@"%@ A%@-%@间休%@-%@ %@小时",kSafeString(((NSString *)schedule[@"name"])),[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:start.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:end.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
        } else {
            timeString = [NSString stringWithFormat:@"%@ A%@-%@ %@小时",kSafeString(((NSString *)schedule[@"name"])),[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
        }
    } else if (signTimeSections.count == 2) {
        NSString *signTime0 = signTimeSections.firstObject[@"signTime"];
        NSString *returnTime0 = signTimeSections.firstObject[@"returnTime"];
        NSString *signTime1 = signTimeSections[1][@"signTime"];
        NSString *returnTime1 = signTimeSections[1][@"returnTime"];
        timeString = [NSString stringWithFormat:@"%@ A%@-%@ B%@-%@ %@小时",kSafeString(((NSString *)schedule[@"name"])),[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
    } else if (signTimeSections.count == 3) {
        NSString *signTime0 = signTimeSections.firstObject[@"signTime"];
        NSString *returnTime0 = signTimeSections.firstObject[@"returnTime"];
        NSString *signTime1 = signTimeSections[1][@"signTime"];
        NSString *returnTime1 = signTimeSections[1][@"returnTime"];
        NSString *signTime2 = signTimeSections[2][@"signTime"];
        NSString *returnTime2 = signTimeSections[2][@"returnTime"];
        timeString = [NSString stringWithFormat:@"%@ A%@-%@ B%@-%@ C%@-%@ %@小时",kSafeString(((NSString *)schedule[@"name"])),[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime2.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime2.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
    }
    
    return timeString;
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextOrSave:(UIButton *)sender {
    DLog(@"下一步或者保存");
    if (self.model.type.integerValue == 0) {
        // 固定排班
        NSArray *daysOfWeek = self.model.fixedTimeWorkSchedule[@"daysOfWeek"];
        if (daysOfWeek.count == 0) {
            [self showAlertControllerToLogoutWithMessage:@"请选择考勤日期" sureAction:nil needCancleButton:NO];
            return;
        }
        NSArray *signTimeSection = self.model.fixedTimeWorkSchedule[@"signTimeSections"];
        if (!signTimeSection || signTimeSection.count == 0) {
            [self showAlertControllerToLogoutWithMessage:@"请选择考勤班次" sureAction:nil needCancleButton:NO];
            return;
        }
    } else if (self.model.type.integerValue == 1) {
        // 自由排班
        NSArray *daysOfWeek = self.model.flexibleTimeWorkSchedule[@"daysOfWeek"];
        if (daysOfWeek.count == 0) {
            [self showAlertControllerToLogoutWithMessage:@"请选择考勤日期" sureAction:nil needCancleButton:NO];
            return;
        }
    }
    
    // 跳入下一个控制器
    MPMSettingCardViewController *settingCard = [[MPMSettingCardViewController alloc] initWithModel:self.model settingType:self.dulingType];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingCard animated:YES];
}

#pragma mark - MPMSettingClassTimeDelegate
/** 固定排班考勤班次时间选择 */
- (void)settingClassTimeDidCompleteWithTimeModel:(MPMSettingClassListModel *)model {
    self.model.fixedTimeWorkSchedule[@"id"] = model.mpm_id;
    self.model.fixedTimeWorkSchedule[@"name"] = model.schedule.name;
    self.model.fixedTimeWorkSchedule[@"hour"] = model.schedule.hour;
    self.model.fixedTimeWorkSchedule[@"signTimeSections"] = model.schedule.signTimeSections;
    self.model.fixedTimeWorkSchedule[@"freeTimeSection"] = model.schedule.freeTimeSection;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - SwitchChangeDelegate
- (void)settingSwithChange:(UISwitch *)sw {
    // TODO 是否下班自由打卡
    //    self.cycleModel.automaticPunchCard = sw.isOn ? @"1" : @"0";
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
        header.headerTextLabel.text = [NSString stringWithFormat:@"对考勤组”%@”的规则进行设置",kSafeString(self.model.name)];
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
        cell.segmentView.selectedSegmentIndex = self.model.type.integerValue;
        __weak typeof(self) weakself = self;
        cell.segChangeBlock = ^(ClassType classType) {
            // 切换了固定排班和自由排班
            __strong typeof(weakself) strongself = weakself;
            [strongself changeUIAndDataWithClassType:classType];
            [strongself.tableView reloadData];
        };
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        // 考勤日期/考勤周期
        static NSString *identifier = @"cell2";
        MPMClassSettingImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMClassSettingImageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
        if (kIsNilString(self.model.cycle)) {
            cell.detailTxLabel.text = @"请选择";
        } else {
            cell.detailTxLabel.text = self.model.cycle;
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
        //        [cell.startNonSwitch setOn:[self.cycleModel.automaticPunchCard isEqualToString:@"1"]];
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
        if (indexPath.row == 2) {
            NSArray *arr = self.model.fixedTimeWorkSchedule[@"signTimeSections"];
            if (arr.count > 0) {
                cell.detailTextLabel.text = [self getTimeStringWithTimeSchedule:self.model.fixedTimeWorkSchedule];
            } else {
                cell.detailTextLabel.text = @"";
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
            // 选择考勤日期
            NSArray *cycleArray = self.model.type.integerValue == 0 ? self.model.fixedTimeWorkSchedule[@"daysOfWeek"] : self.model.flexibleTimeWorkSchedule[@"daysOfWeek"];
            __weak typeof(self) weakself = self;
            [self.weekView showInViewWithCycleArray:cycleArray completeBlock:^(NSArray *cycle) {
                __strong typeof(weakself) strongself = weakself;
                if (strongself.model.type.integerValue == 0) {
                    strongself.model.fixedTimeWorkSchedule[@"daysOfWeek"] = cycle;
                } else {
                    strongself.model.flexibleTimeWorkSchedule[@"daysOfWeek"] = cycle;
                }
                [strongself.model translateCycle];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        } else {
            // 跳入时间段设置页面
            MPMSettingClassListViewController *settime = [[MPMSettingClassListViewController alloc] initWithModel:self.model dulingType:self.dulingType];
            settime.delegate = self;
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
