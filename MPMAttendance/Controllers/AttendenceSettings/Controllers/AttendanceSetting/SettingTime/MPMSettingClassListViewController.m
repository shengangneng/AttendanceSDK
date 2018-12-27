//
//  MPMSettingClassListViewController.m
//  MPMAtendence
//  班次设置
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingClassListViewController.h"
#import "MPMButton.h"
#import "MPMAttendanceSettingModel.h"
#import "MPMHTTPSessionManager.h"
#import "MPMOauthUser.h"
#import "MPMSearchTableViewCell.h"
#import "MPMRepairSigninAddTimeTableViewCell.h" /** 跟增加排班设置一样的cell */
#import "MPMSettingClassListTableViewCell.h"
#import "MPMSettingTimeViewController.h"
#import "MPMSettingClassListModel.h"
#import "MPMOauthUser.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMSettingSearchTimeViewController.h"

#define kSearchCell     @"SearchCell"
#define kAddListCell    @"AddListCell"
#define kClassListCell  @"ClassListCell"
#define kAlertMessage @"当前排班或者其他排班已经使用，修改后会影响排班，是否要修改"

@interface MPMSettingClassListViewController () <UITableViewDelegate, UITableViewDataSource>

// tableview
@property (nonatomic, strong) UITableView *tableView;

// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSaveButton;

// data
@property (nonatomic, strong) MPMAttendanceSettingModel *model;                             /** 从班次设置传入的model */
@property (nonatomic, copy) NSArray<MPMSettingClassListModel *> *classListArray;            /** 班次时间信息列表 */
@property (nonatomic, assign) DulingType dulingType;

@end

@implementation MPMSettingClassListViewController

- (instancetype)initWithModel:(MPMAttendanceSettingModel *)model dulingType:(DulingType)type {
    self = [super init];
    if (self) {
        self.model = model;
        self.dulingType = type;
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
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_TIME_LIST];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:object.count];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                NSDictionary *scheduleDic = dic[@"schedule"];
                MPMSettingClassListModel *model = [[MPMSettingClassListModel alloc] initWithDictionary:dic];
                MPMSettingClassScheduleModel *schedule = [[MPMSettingClassScheduleModel alloc] initWithDictionary:scheduleDic];
                model.schedule = schedule;
                [temp addObject:model];
            }
            self.classListArray = temp.copy;
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.classListArray = [NSMutableArray array];
    NSArray *signTimeSections = self.model.fixedTimeWorkSchedule[@"signTimeSections"];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:signTimeSections.count];
    for (int i = 0; i < signTimeSections.count; i++) {
        NSDictionary *dic = signTimeSections[i];
        MPMSettingClassListModel *list = [[MPMSettingClassListModel alloc] initWithDictionary:dic];
        [temp addObject:list];
    }
    self.classListArray = temp.copy;
    self.navigationItem.title = @"考勤班次";
    [self.bottomSaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
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
        make.top.leading.trailing.equalTo(self.view);
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
/** 根据排班几段时间拼接时间字符串 */
+ (NSString *)getTimeStringWithModel:(MPMSettingClassListModel *)model {
    NSString *timeString;
    NSArray *signTimeSections = model.schedule.signTimeSections;
    NSDictionary *freeTimeSection = [model.schedule.freeTimeSection isKindOfClass:[NSDictionary class]] ? model.schedule.freeTimeSection : nil;
    NSString *hour = model.schedule.hour;
    if (!signTimeSections || signTimeSections.count == 0) {
        timeString = @"";
    } else if (signTimeSections.count == 1) {
        // 这里可能还要考虑‘间休’
        NSString *signTime = signTimeSections.firstObject[@"signTime"];
        NSString *returnTime = signTimeSections.firstObject[@"returnTime"];
        if (freeTimeSection && ![freeTimeSection[@"start"] isKindOfClass:[NSNull class]] && ![freeTimeSection[@"end"] isKindOfClass:[NSNull class]]) {
            NSString *start = kNumberSafeString(freeTimeSection[@"start"]);
            NSString *end = kNumberSafeString(freeTimeSection[@"end"]);
            timeString = [NSString stringWithFormat:@"A%@-%@间休%@-%@ %@小时",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:start.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:end.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
        } else {
            timeString = [NSString stringWithFormat:@"A%@-%@ %@小时",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
        }
    } else if (signTimeSections.count == 2) {
        NSString *signTime0 = signTimeSections.firstObject[@"signTime"];
        NSString *returnTime0 = signTimeSections.firstObject[@"returnTime"];
        NSString *signTime1 = signTimeSections[1][@"signTime"];
        NSString *returnTime1 = signTimeSections[1][@"returnTime"];
        timeString = [NSString stringWithFormat:@"A%@-%@ B%@-%@ %@小时",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
    } else if (signTimeSections.count == 3) {
        NSString *signTime0 = signTimeSections.firstObject[@"signTime"];
        NSString *returnTime0 = signTimeSections.firstObject[@"returnTime"];
        NSString *signTime1 = signTimeSections[1][@"signTime"];
        NSString *returnTime1 = signTimeSections[1][@"returnTime"];
        NSString *signTime2 = signTimeSections[2][@"signTime"];
        NSString *returnTime2 = signTimeSections[2][@"returnTime"];
        timeString = [NSString stringWithFormat:@"A%@-%@ B%@-%@ C%@-%@ %@小时",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime0.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime1.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:signTime2.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:returnTime2.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],hour];
    }
    
    return timeString;
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(UIButton *)sender {
    // 选中的班次id
    NSString *mpm_id = self.model.fixedTimeWorkSchedule[@"id"];
    if (kIsNilString(mpm_id)) {
        [self showAlertControllerToLogoutWithMessage:@"请选择一个班次再保存" sureAction:nil needCancleButton:NO];return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingClassTimeDidCompleteWithTimeModel:)]) {
        MPMSettingClassListModel *saveModel;
        for (int i = 0; i < self.classListArray.count; i++) {
            MPMSettingClassListModel *model = self.classListArray[i];
            if ([model.mpm_id isEqualToString:mpm_id]) {
                saveModel = model;
                break;
            }
        }
        [self.delegate settingClassTimeDidCompleteWithTimeModel:saveModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return self.classListArray.count;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            MPMSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCell forIndexPath:indexPath];
            // 进入搜索
            __weak typeof(self) weakself = self;
            cell.searchWillEdtingBlock = ^{
                __strong typeof(weakself) strongself = weakself;
                MPMSettingSearchTimeViewController *search = [[MPMSettingSearchTimeViewController alloc] initWithSaveDelegate:strongself.delegate];
                strongself.hidesBottomBarWhenPushed = YES;
                [strongself.navigationController pushViewController:search animated:YES];
            };
            return cell;
        }break;
        case 1:{
            MPMRepairSigninAddTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddListCell forIndexPath:indexPath];
            [cell.addTimeButton setTitle:@"+创建班次" forState:UIControlStateNormal];
            return cell;
        }break;
        case 2:{
            MPMSettingClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClassListCell forIndexPath:indexPath];
            MPMSettingClassListModel *model = self.classListArray[indexPath.row];
            cell.txLable.text = model.schedule.name;
            cell.detailTxLable.text = [MPMSettingClassListViewController getTimeStringWithModel:model];
            NSString *mpm_id;
            if (self.model.fixedTimeWorkSchedule && [self.model.fixedTimeWorkSchedule isKindOfClass:[NSDictionary class]]) {
                mpm_id = self.model.fixedTimeWorkSchedule[@"id"];
            }
            // 如果列表中的时间id和全局排班model的id相同，则为当前排班正在使用的（如果是新建的排班，刚进来的时候全局的id是为空的，之后选择了再赋值上去）
            cell.isInUsing = [model.mpm_id isEqualToString:mpm_id];
            __weak typeof(self) weakself = self;
            cell.checkImageBlock = ^{
                // 选中某个排班
                __strong typeof(weakself) strongself = weakself;
                strongself.model.fixedTimeWorkSchedule[@"id"] = model.mpm_id;
                [tableView reloadData];
            };
            return cell;
        }break;
        default:
            return nil;
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        MPMSettingClassListModel *model = self.classListArray[indexPath.row];
        if (1 == model.isUsed.integerValue) {
            [self showAlertControllerToLogoutWithMessage:@"当前班次已被使用，无法删除" sureAction:nil needCancleButton:NO];
        } else {
            __weak typeof(self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"确认删除‘%@’吗",model.schedule.name] sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                NSString *url = [NSString stringWithFormat:@"%@%@/%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_TIME_DELETE,model.mpm_id];
                [[MPMSessionManager shareManager] deleteRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在删除" success:^(id response) {
                    [strongself getData];
                } failure:^(NSString *error) {
                    [MPMProgressHUD showErrorWithStatus:error];
                }];
            } needCancleButton:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            // 点击搜索框的cell
        } break;
        case 1:{
            // 增加班次时间
            MPMSettingTimeViewController *st = [[MPMSettingTimeViewController alloc] initWithModel:nil dulingType:self.dulingType classTimeId:nil];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:st animated:YES];
        } break;
        case 2:{
            // 编辑时间
            MPMSettingClassListModel *model = self.classListArray[indexPath.row];
            // 如果已经被使用，弹出提示
            if (1 == model.isUsed.integerValue) {
                __weak typeof(self) weakself = self;
                [self showAlertControllerToLogoutWithMessage:kAlertMessage sureAction:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakself) strongself = weakself;
                    MPMSettingTimeViewController *st = [[MPMSettingTimeViewController alloc] initWithModel:model dulingType:strongself.dulingType classTimeId:model.mpm_id];
                    strongself.hidesBottomBarWhenPushed = YES;
                    [strongself.navigationController pushViewController:st animated:YES];
                } sureActionTitle:@"修改" needCancleButton:YES];
            } else {
                MPMSettingTimeViewController *st = [[MPMSettingTimeViewController alloc] initWithModel:model dulingType:self.dulingType classTimeId:nil];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:st animated:YES];
            }
        } break;
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
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.backgroundColor = kTableViewBGColor;
        [_tableView registerClass:[MPMSearchTableViewCell class] forCellReuseIdentifier:kSearchCell];
        [_tableView registerClass:[MPMRepairSigninAddTimeTableViewCell class] forCellReuseIdentifier:kAddListCell];
        [_tableView registerClass:[MPMSettingClassListTableViewCell class] forCellReuseIdentifier:kClassListCell];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
