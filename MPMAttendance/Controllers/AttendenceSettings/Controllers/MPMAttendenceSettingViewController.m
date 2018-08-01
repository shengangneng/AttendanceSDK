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
#import "MPMAttendenceSettingModel.h"
#import "MPMButton.h"
#import "MPMAttendenceSettingTableViewCell.h"
#import "MPMAttendenceSetTableViewCell.h"
#import "MPMSchedulingDepartmentsModel.h"
#import "MPMSchedulingEmplyoeeModel.h"
#import "MPMSlotTimeDtosModel.h"
#import "NSDateFormatter+MPMExtention.h"
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
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

- (void)getData {
    NSString *url  = [NSString stringWithFormat:@"%@schedulingSetting/getSchedulingByCompanyId?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSDictionary *params = @{@"companyId":[MPMShareUser shareUser].departmentId};
    [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在加载" success:^(id response) {
        NSArray *arr = response[@"dataObj"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            MPMAttendenceSettingModel *model = [[MPMAttendenceSettingModel alloc] initWithDictionary:dic];
            [model translateCycle];
            NSArray *schedulingDepartments = [dic[@"schedulingDepartments"] isKindOfClass:[NSArray class]] ? dic[@"schedulingDepartments"] : @[];
            NSMutableArray *temp1 = [NSMutableArray arrayWithCapacity:schedulingDepartments.count];
            for (int i = 0;i < schedulingDepartments.count; i++) {
                NSDictionary *tempDic = schedulingDepartments[i];
                MPMSchedulingDepartmentsModel *dep = [[MPMSchedulingDepartmentsModel alloc] initWithDictionary:tempDic];
                [temp1 addObject:dep];
            }
            model.schedulingDepartments = temp1.copy;
            
            NSArray *schedulingEmployees = [dic[@"schedulingEmplyoees"] isKindOfClass:[NSArray class]] ? dic[@"schedulingEmplyoees"] : @[];
            NSMutableArray *temp2 = [NSMutableArray arrayWithCapacity:schedulingEmployees.count];
            for (int i = 0;i < schedulingEmployees.count; i++) {
                NSDictionary *tempDic = schedulingEmployees[i];
                MPMSchedulingEmplyoeeModel *emp = [[MPMSchedulingEmplyoeeModel alloc] initWithDictionary:tempDic];
                [temp2 addObject:emp];
            }
            model.schedulingEmplyoees = temp2.copy;
            
            NSArray *slotTime = [dic[@"slotTimeDtos"] isKindOfClass:[NSArray class]] ? dic[@"slotTimeDtos"] : @[];;
            NSMutableArray *temp3 = [NSMutableArray arrayWithCapacity:slotTime.count];
            for (int i = 0;i < slotTime.count; i++) {
                NSDictionary *tempDic = slotTime[i];
                MPMSlotTimeDtosModel *slt = [[MPMSlotTimeDtosModel alloc] initWithDictionary:tempDic];
                [temp3 addObject:slt];
            }
            model.slotTimeDtos = temp3.copy;
            [temp addObject:model];
        }
        self.settingsArray = temp.copy;
        self.cellHeightArray = [self calculaterHeightWithModels:self.settingsArray];
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
- (NSArray *)calculaterHeightWithModels:(NSArray<MPMAttendenceSettingModel *> *)arr {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
    for (int i = 0; i < arr.count; i++) {
        MPMAttendenceSettingModel * model = arr[i];
        CGFloat height = 62.5;
        // 部门和人员
        if (model.schedulingEmplyoees.count > 0 || model.schedulingDepartments.count > 0) {
            height += 24;
        }
        // 班次
        if (model.slotTimeDtos.count != 0) {
            height += 24 * model.slotTimeDtos.count;
        }
        // 考勤日期
        if (!kIsNilString(model.cycle)) {
            height += 24;
        }
        // 地址
        if (!kIsNilString(model.address)) {
            height += 24;
        }
        // wifi
        if (!kIsNilString(model.wifiName)) {
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
    MPMCreateOrangeClassViewController *vc = [[MPMCreateOrangeClassViewController alloc] initWithSchedulingId:nil settingType:kDulingTypeCreate];
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
    MPMAttendenceSettingModel *model = self.settingsArray[indexPath.row];
    MPMAttendenceSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // 排班名称
    [cell resetCellWithModel:model cellHeight:((NSNumber *)self.cellHeightArray[indexPath.row]).floatValue];
    cell.model = model;
    cell.headerTitleLabel.text = model.schedulingName;
    // 范围：部门数量、员工数量
    if (model.schedulingEmplyoees.count > 0 && model.schedulingDepartments.count > 0) {
        cell.workScopeLabel.text = [NSString stringWithFormat:@"参与人员:%ld人  参与部门:%ld个",model.schedulingEmplyoees.count,model.schedulingDepartments.count];
    } else if (model.schedulingEmplyoees.count > 0) {
        cell.workScopeLabel.text = [NSString stringWithFormat:@"参与人员:%ld人",model.schedulingEmplyoees.count];
    } else if (model.schedulingDepartments.count > 0) {
        cell.workScopeLabel.text = [NSString stringWithFormat:@"参与部门:%ld个",model.schedulingDepartments.count];
    } else {
        cell.workScopeLabel.text = nil;
    }
    // 班次
    if (model.slotTimeDtos.count == 1) {
        MPMSlotTimeDtosModel *slt = model.slotTimeDtos[0];
        cell.classLabel1.text = [NSString stringWithFormat:@"班次:A %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel2.text = cell.classLabel3.text = nil;
    } else if (model.slotTimeDtos.count == 2) {
        MPMSlotTimeDtosModel *slt0 = model.slotTimeDtos[0];
        MPMSlotTimeDtosModel *slt1 = model.slotTimeDtos[1];
        cell.classLabel1.text = [NSString stringWithFormat:@"班次:A %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel2.text = [NSString stringWithFormat:@"        B %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel3.text = nil;
    } else if (model.slotTimeDtos.count == 3) {
        MPMSlotTimeDtosModel *slt0 = model.slotTimeDtos[0];
        MPMSlotTimeDtosModel *slt1 = model.slotTimeDtos[1];
        MPMSlotTimeDtosModel *slt2 = model.slotTimeDtos[2];
        
        cell.classLabel1.text = [NSString stringWithFormat:@"班次:A %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel2.text = [NSString stringWithFormat:@"        B %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        cell.classLabel3.text = [NSString stringWithFormat:@"        C %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt2.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt2.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
    } else {
        cell.classLabel1.text = cell.classLabel2.text = cell.classLabel3.text = nil;
    }
    // 考勤日期
    cell.workDateLabel.text = kIsNilString(model.cnCycle) ? nil : [NSString stringWithFormat:@"考勤日期:周%@",model.cnCycle];
    // 考勤地址
    cell.workLocationLabel.text = kIsNilString(model.address) ? nil : [NSString stringWithFormat:@"考勤地址:%@",model.address];
    // 考勤wifi：目前还没有这个功能
    cell.workWifiLabel.text = nil;
    cell.delegate = self;
    
    __weak typeof(self) weakself = self;
    cell.editBlock = ^{
        // 跳入排班设置 - 必须流程一步一步走完
        __strong typeof(weakself) strongself = weakself;
        MPMCreateOrangeClassViewController *vc = [[MPMCreateOrangeClassViewController alloc] initWithSchedulingId:model.schedulingId settingType:kDulingTypeSetting];
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

- (void)attendenceSetTableCellDidDeleteWithModel:(MPMAttendenceSettingModel *)model {
    [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"确定删除\"%@\"的排班信息吗",model.schedulingName] sureAction:^(UIAlertAction * _Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"%@schedulingSetting/deleteScheduling?schedulingId=%@&token=%@",MPMHost,model.schedulingId,[MPMShareUser shareUser].token];
        [[MPMSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在删除" success:^(id response) {
            [self getData];
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
