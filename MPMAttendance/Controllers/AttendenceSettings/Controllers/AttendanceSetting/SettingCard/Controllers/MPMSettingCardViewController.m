//
//  MPMSettingCardViewController.m
//  MPMAtendence
//  打卡设置
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingCardViewController.h"
#import "MPMButton.h"
#import "MPMSettingCardTableViewCell.h"
#import "MPMSettingCardDetailTableViewCell.h"
#import "MPMTableHeaderView.h"
#import "MPMAttendencePickerView.h"
#import "MPMShareUser.h"
#import "MPMHTTPSessionManager.h"
#import "MPMPlaceInfoModel.h"
#import "MPMSettingCardAddressWifiModel.h"
#import "MPMAttendanceSettingModel.h"
#import "MPMOauthUser.h"
/** 地图 */
#import "MPMAttendenceMapViewController.h"

#define kDeviationValueArray @[@"300米",@"400米",@"500米",@"600米",@"700米",@"800米",@"900米",@"1000米"]

@interface MPMSettingCardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSaveButton;
@property (nonatomic, strong) MPMAttendencePickerView *pickerView;
// data
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, assign) DulingType dulingType;
@property (nonatomic, strong) NSMutableArray<MPMSettingCardAddressWifiModel *> *settingCardArray;   /** 打开设置地点、误差、经纬度的model */
@property (nonatomic, copy) NSString *deviation;
@property (nonatomic, strong) MPMAttendanceSettingModel *model;

@end

@implementation MPMSettingCardViewController

- (instancetype)initWithModel:(MPMAttendanceSettingModel *)model settingType:(DulingType)dulingType {
    self = [super init];
    if (self) {
        self.model = model;
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
- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"打卡设置";
    self.settingCardArray = [NSMutableArray array];
    self.dataArray = @[@[@{@"icon":@"setting_addition",
                           @"title":@"添加考勤地点"
                           }.mutableCopy,
                         @{@"icon":@"",
                           @"title":@"允许偏差",
                           @"accTitle":@"请选择",
                           @"acc":@"true"
                           }.mutableCopy
                         ].mutableCopy
                       ].mutableCopy;
    NSDictionary *classDic;
    if (0 == self.model.type.integerValue) {
        classDic = self.model.fixedTimeWorkSchedule;
    } else if (1 == self.model.type.integerValue) {
        classDic = self.model.flexibleTimeWorkSchedule;
    }
    NSArray *locations = classDic[@"locatioinSettings"];
    NSString *offset = @"300";
    if (classDic[@"offset"]) {
        if ([classDic[@"offset"] isKindOfClass:[NSString class]]) {
            offset = classDic[@"offset"];
        } else if ([classDic[@"offset"] isKindOfClass:[NSNumber class]]) {
            offset = ((NSNumber *)classDic[@"offset"]).stringValue;
        }
    }
    self.deviation = offset;
    self.dataArray[0][1][@"accTitle"] = [NSString stringWithFormat:@"%@米",self.deviation];
    if (locations.count != 0) {
        for (int i = 0; i < locations.count; i++) {
            NSDictionary *dic = locations[i];
            MPMSettingCardAddressWifiModel *mo = [[MPMSettingCardAddressWifiModel alloc] init];
            mo.address = dic[@"locationName"];
            mo.deviation = offset;
            mo.latitude = dic[@"latitude"];
            mo.longitude = dic[@"longitude"];
            [self.settingCardArray addObject:mo];
            [self.dataArray[0] addObject:@{@"icon":@"setting_screencut",@"title":@"考勤地点",@"detail":mo.address}.mutableCopy];
        }
    }
    [self.tableView reloadData];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
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

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save:(UIButton *)sender {
    DLog(@"保存考勤地址");
    if (self.settingCardArray.count == 0) {
        [self showAlertControllerToLogoutWithMessage:@"请选择考勤地址" sureAction:nil needCancleButton:NO];
        return;
    }
    if (kIsNilString(self.deviation)) {
        [self showAlertControllerToLogoutWithMessage:@"请选择允许偏差" sureAction:nil needCancleButton:NO];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"立即生效，今天考勤结果将按新规则重算" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof (UIAlertController *) weakAlert = alertController;
    __weak typeof(self) weakself = self;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"立即生效" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakself) strongself = weakself;
        [strongself saveClassWithEffective:@"1" transfer:@"1"];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"明天生效" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakself) strongself = weakself;
        [strongself saveClassWithEffective:@"0" transfer:@"1"];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [weakAlert addAction:cancelAction];
    [weakAlert addAction:sure];
    [self presentViewController:weakAlert animated:YES completion:nil];
}

/** isEffective：是否立即生效，0否 1是 isTransfer:是否排班转移：0否 1是*/
- (void)saveClassWithEffective:(NSString *)isEffective transfer:(NSString *)isTransfer {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_CLASS_ADD];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *mpm_id = kSafeString(self.model.mpm_id);
    NSString *name = kSafeString(self.model.name);
    NSString *type = kSafeString(self.model.type);
    NSString *companyId = [MPMOauthUser shareOauthUser].company_id;
    NSMutableArray *objList = [NSMutableArray array];
    for (int i = 0; i < self.model.objList.count; i++) {
        MPMObjListModel *obj = self.model.objList[i];
        NSMutableDictionary *objDic = [NSMutableDictionary dictionaryWithCapacity:4];
        objDic[@"name"] = obj.name;
        objDic[@"objId"] = obj.objId;
        objDic[@"orgIdIndex"] = obj.orgIdIndex;
        objDic[@"type"] = obj.type;
        [objList addObject:objDic];
    }
    NSMutableDictionary *fixedTimeWorkSchedule = [NSMutableDictionary dictionary];      // 固定排班
    NSMutableDictionary *flexibleTimeWorkSchedule = [NSMutableDictionary dictionary];   // 自由排班
    
    if (self.model.type.integerValue == 0) {
        fixedTimeWorkSchedule[@"daysOfWeek"] = self.model.fixedTimeWorkSchedule[@"daysOfWeek"];
        NSMutableArray *locations = [NSMutableArray arrayWithCapacity:self.settingCardArray.count];
        for (int i = 0; i < self.settingCardArray.count; i++) {
            MPMSettingCardAddressWifiModel *model = self.settingCardArray[i];
            [locations addObject:@{@"locationName":kSafeString(model.address),
                                   @"latitude":kNumberSafeString(model.latitude),
                                   @"longitude":kNumberSafeString(model.longitude),
                                   }];
        }
        fixedTimeWorkSchedule[@"locatioinSettings"] = locations.copy;
        fixedTimeWorkSchedule[@"name"] = self.model.fixedTimeWorkSchedule[@"name"];
        fixedTimeWorkSchedule[@"hour"] = self.model.fixedTimeWorkSchedule[@"hour"];
        fixedTimeWorkSchedule[@"id"] = self.model.fixedTimeWorkSchedule[@"id"];
        fixedTimeWorkSchedule[@"offset"] = self.deviation;
        fixedTimeWorkSchedule[@"signTimeSections"] = self.model.fixedTimeWorkSchedule[@"signTimeSections"];
        if (self.model.fixedTimeWorkSchedule[@"freeTimeSection"] && [self.model.fixedTimeWorkSchedule[@"freeTimeSection"] isKindOfClass:[NSDictionary class]] && ![self.model.fixedTimeWorkSchedule[@"freeTimeSection"][@"start"] isKindOfClass:[NSNull class]] && ![self.model.fixedTimeWorkSchedule[@"freeTimeSection"][@"end"] isKindOfClass:[NSNull class]]) {
            fixedTimeWorkSchedule[@"freeTimeSection"] = self.model.fixedTimeWorkSchedule[@"freeTimeSection"];
        }
        fixedTimeWorkSchedule[@"startSignTime"] = @"123";
        params[@"fixedTimeWorkSchedule"] = fixedTimeWorkSchedule;
    } else {
        flexibleTimeWorkSchedule[@"daysOfWeek"] = self.model.flexibleTimeWorkSchedule[@"daysOfWeek"];
        NSMutableArray *locations = [NSMutableArray arrayWithCapacity:self.settingCardArray.count];
        for (int i = 0; i < self.settingCardArray.count; i++) {
            MPMSettingCardAddressWifiModel *model = self.settingCardArray[i];
            [locations addObject:@{@"locationName":kSafeString(model.address),
                                   @"latitude":kNumberSafeString(model.latitude),
                                   @"longitude":kNumberSafeString(model.longitude),
                                   }];
        }
        flexibleTimeWorkSchedule[@"locatioinSettings"] = locations.copy;
        flexibleTimeWorkSchedule[@"offset"] = self.deviation;
        flexibleTimeWorkSchedule[@"signTimeSections"] = self.model.flexibleTimeWorkSchedule[@"signTimeSections"];
        flexibleTimeWorkSchedule[@"startSignTime"] = @"123";
        params[@"flexibleTimeWorkSchedule"] = flexibleTimeWorkSchedule;
    }
    
    params[@"id"] = mpm_id;
    params[@"name"] = name;
    params[@"type"] = type;
    params[@"companyId"] = companyId;
    params[@"objList"] = objList.copy;
    params[@"isEffective"] = isEffective;
    if (isTransfer) {
        params[@"isTransfer"] = isTransfer;
    }
    
    NSString *message = (kDulingTypeCreate == self.dulingType) ? @"创建" : @"修改";
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在加载" success:^(id response) {
        DLog(@"%@",response);
        if (response && kRequestSuccess == ((NSString *)response[@"responseData"][kCode]).integerValue) {
            __weak typeof(self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%@成功",message] sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MPMAttendenceSettingViewController class]]) {
                        [strongself.navigationController popToViewController:vc animated:YES];
                    }
                }
            } needCancleButton:NO];
        } else if (response && 304 == ((NSString *)response[@"responseData"][kCode]).integerValue) {
            // 人员迁移
            NSString *message = response[@"responseData"][@"message"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(UIAlertController *) weakAlert = alertController;
            __weak typeof(self) weakself = self;
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *change = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself saveClassWithEffective:@"1" transfer:@"1"];
                [strongself dismissViewControllerAnimated:YES completion:nil];
            }];
            [weakAlert addAction:cancel];
            [weakAlert addAction:change];
            [self presentViewController:weakAlert animated:YES completion:nil];
        } else {
            NSString *message = response[@"responseData"][@"message"];
            [MPMProgressHUD showErrorWithStatus:kSafeString(message)];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@失败",message]];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.dataArray[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MPMTableHeaderView *header = [[MPMTableHeaderView alloc] init];
        header.headerTextLabel.text = @"设置符合你企业要求的考勤方式";
        return header;
    } else {
        return [[UIView alloc] init];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arr = self.dataArray[indexPath.section];
    NSMutableDictionary *dic = arr[indexPath.row];
    NSString *detail = dic[@"detail"];
    if (kIsNilString(detail)) {
        static NSString *cellIdentifier = @"cellIdentifier1";
        MPMSettingCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMSettingCardTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        NSString *icon = dic[@"icon"];
        NSString *title = dic[@"title"];
        NSString *accTitle = dic[@"accTitle"];
        NSString *acc = dic[@"acc"];
        if (kIsNilString(icon)) {
            cell.imageIcon.image = nil;
        } else {
            cell.imageIcon.image = ImageName(icon);
        }
        if (kIsNilString(title)){
            cell.txLabel.text = nil;
        } else {
            cell.txLabel.text = title;
        }
        if (kIsNilString(accTitle)) {
            cell.detailTextLabel.text = nil;
        } else {
            cell.detailTextLabel.text = accTitle;
        }
        if (kIsNilString(acc)) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    } else {
        static NSString *cellIdentifier = @"cellIdentifier2";
        MPMSettingCardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMSettingCardDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        if (indexPath.row == arr.count - 1) {
            cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        } else {
            cell.separatorInset = UIEdgeInsetsMake(0, 43, 0, 0);
        }
        NSString *icon = dic[@"icon"];
        NSString *title = dic[@"title"];
        NSString *detail = dic[@"detail"];
        if (kIsNilString(icon)) {
            cell.imageIcon.image = nil;
        } else {
            cell.imageIcon.image = ImageName(icon);
        }
        if (kIsNilString(title)){
            cell.txLabel.text = nil;
        } else {
            cell.txLabel.text = title;
        }
        if (kIsNilString(detail)) {
            cell.txDetailLabel.text = nil;
        } else {
            cell.txDetailLabel.text = detail;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 添加考勤地点
        MPMAttendenceMapViewController *map = [[MPMAttendenceMapViewController alloc] init];
        map.completeSelectPlace = ^(MPMPlaceInfoModel *model) {
            // 从地图选完位置跳转回来
            MPMSettingCardAddressWifiModel *mo = [[MPMSettingCardAddressWifiModel alloc] init];
            mo.address = kIsNilString([[kSafeString(model.locality) stringByAppendingString:kSafeString(model.subLocality)] stringByAppendingString:kSafeString(model.thoroughfare)])?@"我的地址":[[kSafeString(model.locality) stringByAppendingString:kSafeString(model.subLocality)] stringByAppendingString:kSafeString(model.thoroughfare)];
            mo.deviation = self.settingCardArray.count > 0?((MPMSettingCardAddressWifiModel *)self.settingCardArray[0]).deviation:@"";
            mo.latitude = [NSString stringWithFormat:@"%f",model.coordinate.latitude];
            mo.longitude = [NSString stringWithFormat:@"%f",model.coordinate.longitude];
            BOOL canAdd = YES;
            for (int i = 0; i < self.settingCardArray.count; i++) {
                MPMSettingCardAddressWifiModel *item = self.settingCardArray[i];
                if ([item.address isEqualToString:mo.address]) {
                    canAdd = NO;break;
                }
            }
            if (canAdd) {
                [self.settingCardArray addObject:mo];
                [self.dataArray[0] addObject:@{@"icon":@"setting_screencut",@"title":@"考勤地点",@"detail":mo.address}.mutableCopy];
                [self.tableView reloadData];
            } else {
                [self showAlertControllerToLogoutWithMessage:@"该地址名称已在列表中，请添加不同地址名称" sureAction:nil needCancleButton:NO];
            }
        };
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:map animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        NSInteger defaultValue = kIsNilString(self.deviation) ? 0 : ([kDeviationValueArray containsObject:[NSString stringWithFormat:@"%@米",self.deviation]] ? [kDeviationValueArray indexOfObject:[NSString stringWithFormat:@"%@米",self.deviation]] : 0);
        // 允许偏差
        [self.pickerView showInView:kAppDelegate.window withPickerData:kDeviationValueArray selectRow:defaultValue];
        __weak typeof(self) weakself = self;
        MPMSettingCardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.pickerView.completeSelectBlock = ^(NSString *data) {
            __strong typeof(weakself) strongself = weakself;
            cell.detailTextLabel.text = data;
            strongself.dataArray[0][1][@"accTitle"] = data;
            strongself.deviation = kIsNilString(data) ? @"0" : [data substringWithRange:NSMakeRange(0, data.length - 1)];
        };
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        // 添加考勤WIFI
    } else {
        // 其余，删除数据
        NSString *message = ((MPMSettingCardAddressWifiModel *)self.settingCardArray[indexPath.row - 2]).address;
        __weak typeof(self) weakself = self;
        [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"确定删除\"%@\"吗",message] sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakself) strongself = weakself;
            [strongself.dataArray[0] removeObjectAtIndex:indexPath.row];
            [strongself.settingCardArray removeObjectAtIndex:indexPath.row - 2];
            [strongself.tableView reloadData];
        } needCancleButton:YES];
    }
}

#pragma mark - Lazy Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
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
        _bottomSaveButton = [MPMButton titleButtonWithTitle:@"完成" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomSaveButton;
}

- (MPMAttendencePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MPMAttendencePickerView alloc] init];
    }
    return _pickerView;
}
@end
