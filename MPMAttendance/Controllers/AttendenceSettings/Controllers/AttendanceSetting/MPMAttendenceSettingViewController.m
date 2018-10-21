//
//  MPMAttendenceSettingViewController.m
//  MPMAtendence
//  考勤设置
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceSettingViewController.h"
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "MPMButton.h"
#import "MPMAttendenceSetTableViewCell.h"
#import "MPMSlotTimeDtosModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMOauthUser.h"
#import "MPMAttendanceSettingModel.h"
#import "MPMSignTimeSections.h"
/** 创建排班 */
#import "MPMCreateOrangeClassViewController.h"
/** 班次设置 */
#import "MPMClassSettingViewController.h"
/** 时间设置 */
#import "MPMSettingTimeViewController.h"
/** 打卡设置 */
#import "MPMSettingCardViewController.h"

@interface MPMAttendenceSettingViewController () <UITableViewDelegate, UITableViewDataSource, MPMAttendenceSetTableViewCellDelegate>
// views
@property (nonatomic, strong) UIButton *addClassButton;
@property (nonatomic, strong) UITableView *tableView;
// data
@property (nonatomic, copy) NSArray *settingsArray;
@property (nonatomic, copy) NSArray *cellHeightArray;
@property (nonatomic, strong) MPMAttendenceSetTableViewCell *lastCell;

@end

@implementation MPMAttendenceSettingViewController

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
        [strongself getDataV2];
    };
    [self getDataV2];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"考勤排班";
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.addClassButton addTarget:self action:@selector(addClass:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addClassButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView setContentInset:UIEdgeInsetsMake(6, 0, 6, 0)];
    [self.addClassButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-12.5);
        make.bottom.equalTo(self.view).offset(-12);
        make.width.height.equalTo(@50);
    }];
}

- (void)getDataV2 {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_CLASS_LIST];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *arr = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dic = arr[i];
                MPMAttendanceSettingModel *model = [[MPMAttendanceSettingModel alloc] initWithDictionary:dic];
                [model translateCycle];
                [temp addObject:model];
            }
            self.settingsArray = temp.copy;
            self.cellHeightArray = [self calculaterHeightWithModels:self.settingsArray];
        }
        [self.tableView reloadData];
        if (self.settingsArray.count > 0) {
            __weak typeof(self) weakself = self;
            dispatch_async(kMainQueue, ^{
                __strong typeof(weakself) strongself = weakself;
                // 每次刷新结束滚动到顶部
                [strongself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

// 根据model计算cell的高度
- (NSArray *)calculaterHeightWithModels:(NSArray<MPMAttendanceSettingModel *> *)arr {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
    for (int i = 0; i < arr.count; i++) {
        MPMAttendanceSettingModel * model = arr[i];
        NSDictionary *dic;
        if (model.type.integerValue == 0) {
            dic = model.fixedTimeWorkSchedule.copy;
        } else {
            dic = model.flexibleTimeWorkSchedule.copy;
        }
        CGFloat height = 62.5;
        // 部门和人员
        if (model.objList.count > 0) {
            height += 24;
        }
        // 班次
        NSArray *fixed = dic[@"signTimeSections"];
        if (fixed.count != 0) {
            height += 24 * fixed.count;
        }
        // 考勤日期
        NSArray *daysOfWeek = dic[@"daysOfWeek"];
        if (daysOfWeek.count > 0) {
            height += 24;
        }
        // 地址
        NSArray *locations = dic[@"locatioinSettings"];
        if (locations.count > 0) {
            height += 24;
        }
        NSNumber *num = [NSNumber numberWithFloat:height];
        [temp addObject:num];
    }
    return temp.copy;
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addClass:(UIButton *)sender {
    DLog(@"增加排班");
    MPMCreateOrangeClassViewController *vc = [[MPMCreateOrangeClassViewController alloc] initWithModel:nil settingType:kDulingTypeCreate];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NSNumber *)self.cellHeightArray[indexPath.row]).floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SettingCell";
    MPMAttendanceSettingModel *model = self.settingsArray[indexPath.row];
    MPMAttendenceSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // 排班名称
    [cell resetCellWithModel:model cellHeight:((NSNumber *)self.cellHeightArray[indexPath.row]).floatValue];
    cell.model = model;
    cell.headerTitleLabel.text = model.name;
    // 范围：部门数量、员工数量
    NSMutableArray *departCount = [NSMutableArray array];
    NSMutableArray *peopleCount = [NSMutableArray array];
    for (MPMObjListModel *obj in model.objList) {
        if (obj.type.integerValue == 1) {
            [departCount addObject:obj];
        } else {
            [peopleCount addObject:obj];
        }
    }
    if (departCount.count > 0 && peopleCount.count > 0) {
        cell.workScopeLabel.text = [NSString stringWithFormat:@"参与人员:%ld人  参与部门:%ld个",peopleCount.count,departCount.count];
    } else if (peopleCount.count > 0) {
        cell.workScopeLabel.text = [NSString stringWithFormat:@"参与人员:%ld人",peopleCount.count];
    } else if (departCount.count > 0) {
        cell.workScopeLabel.text = [NSString stringWithFormat:@"参与部门:%ld个",departCount.count];
    } else {
        cell.workScopeLabel.text = nil;
    }
    
    // 班次
    NSArray *fixed = model.fixedTimeWorkSchedule[@"signTimeSections"];
    
    if (fixed.count == 1) {
        MPMSignTimeSections *slt = [[MPMSignTimeSections alloc] initWithDictionary:fixed[0]];
        cell.classLabel1.text = [NSString stringWithFormat:@"班次:A %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.startReturnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel2.text = cell.classLabel3.text = nil;
    } else if (fixed.count == 2) {
        MPMSignTimeSections *slt0 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[0]];
        MPMSignTimeSections *slt1 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[1]];
        cell.classLabel1.text = [NSString stringWithFormat:@"班次:A %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel2.text = [NSString stringWithFormat:@"        B %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel3.text = nil;
    } else if (fixed.count == 3) {
        MPMSignTimeSections *slt0 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[0]];
        MPMSignTimeSections *slt1 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[1]];
        MPMSignTimeSections *slt2 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[2]];
        
        cell.classLabel1.text = [NSString stringWithFormat:@"班次:A %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel2.text = [NSString stringWithFormat:@"        B %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel3.text = [NSString stringWithFormat:@"        C %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt2.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt2.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
    } else {
        cell.classLabel1.text = cell.classLabel2.text = cell.classLabel3.text = nil;
    }
    
    // 考勤日期
    cell.workDateLabel.text = kIsNilString(model.cycle) ? @"" : [NSString stringWithFormat:@"考勤日期:周%@",model.cycle];
    
    NSArray *locations = model.type.integerValue == 0 ? model.fixedTimeWorkSchedule[@"locatioinSettings"] : model.flexibleTimeWorkSchedule[@"locatioinSettings"];
    NSString *locationName = locations.firstObject[@"locationName"];
    // 考勤地址
    cell.workLocationLabel.text = kIsNilString(locationName) ? nil : [NSString stringWithFormat:@"考勤地址:%@",locationName];
    // 考勤wifi：目前还没有这个功能
    cell.workWifiLabel.text = nil;
    cell.delegate = self;
    
    __weak typeof(self) weakself = self;
    cell.editBlock = ^{
        // 跳入排班设置 - 必须流程一步一步走完
        __strong typeof(weakself) strongself = weakself;
        MPMCreateOrangeClassViewController *vc = [[MPMCreateOrangeClassViewController alloc] initWithModel:model settingType:kDulingTypeSetting];
        strongself.hidesBottomBarWhenPushed = YES;
        [strongself.navigationController pushViewController:vc animated:YES];
    };
    __weak typeof(MPMAttendenceSetTableViewCell *) weakCell = cell;
    cell.swipeShowBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        __weak typeof(MPMAttendenceSetTableViewCell *) strongCell = weakCell;
        [strongself.lastCell dismissSwipeView];
        strongself.lastCell = strongCell;
    };
    return cell;
}

- (void)attendenceSetTableCellDidDeleteWithModel:(MPMAttendanceSettingModel *)model {
    [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"确定删除\"%@\"的排班信息吗",model.name] sureAction:^(UIAlertAction * _Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_CLASS_DELETE,model.mpm_id];
        [[MPMSessionManager shareManager] deleteRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在删除" success:^(id response) {
            DLog(@"%@",response);
            [self getDataV2];
            [self.lastCell dismissSwipeView];
        } failure:^(NSString *error) {
            DLog(@"删除失败");
        }];
    } needCancleButton:YES];
}

#pragma mark - Lazy Init
- (UIButton *)addClassButton {
    if (!_addClassButton) {
        _addClassButton = [MPMButton imageButtonWithImage:ImageName(@"setting_createascheduling") hImage:ImageName(@"setting_createascheduling")];
    }
    return _addClassButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[MPMAttendenceSetTableViewCell class] forCellReuseIdentifier:@"SettingCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewBGColor;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
