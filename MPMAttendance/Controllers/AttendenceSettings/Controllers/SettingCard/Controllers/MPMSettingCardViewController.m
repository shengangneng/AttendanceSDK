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
/** 地图 */
#import "MPMAttendenceMapViewController.h"

#define kDeviationValueArray @[@"100米",@"200米",@"300米",@"400米",@"500米",@"600米",@"700米",@"800米",@"900米",@"1000米"]

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
@property (nonatomic, strong) NSMutableArray<MPMSettingCardAddressWifiModel *> *settingCardArray;
@property (nonatomic, copy) NSString *deviation;

@end

@implementation MPMSettingCardViewController

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
    [self getData];
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
    [self.bottomSaveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mas_leading).offset(12);
        make.trailing.equalTo(self.bottomView.mas_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
    }];
}

- (void)getData {
    NSString *url = [NSString stringWithFormat:@"%@cardSettingController/getCardSettingBySchedulingId?schedulingId=%@&token=%@",MPMHost,self.schedulingId,[MPMShareUser shareUser].token];
    [[MPMHTTPSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
        NSArray *arr = response[@"dataObj"];
        if (arr && arr.count > 0) {
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dic = arr[i];
                MPMSettingCardAddressWifiModel *model = [[MPMSettingCardAddressWifiModel alloc] initWithDictionary:dic];
                [self.dataArray[0] addObject:@{@"icon":@"setting_screencut",@"title":@"考勤地点",@"detail":model.address}.mutableCopy];
                self.dataArray[0][1][@"accTitle"] = [NSString stringWithFormat:@"%@米",model.deviation];
                self.deviation = model.deviation;
                [self.settingCardArray addObject:model];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
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
    NSString *url = [NSString stringWithFormat:@"%@cardSettingController/saveCardSetting?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.settingCardArray.count];
    for (int i = 0; i < self.settingCardArray.count; i++) {
        MPMSettingCardAddressWifiModel *model = self.settingCardArray[i];
        [params addObject:@{@"address":kSafeString(model.address),
                            @"deviation":kSafeString(self.deviation),
                            @"latitude":kSafeString(model.latitude),
                            @"longitude":kSafeString(model.longitude),
                            @"schedulingId":kSafeString(self.schedulingId),
                            }];
    }
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在加载" success:^(id response) {
        __weak typeof(self) weakself = self;
        [self showAlertControllerToLogoutWithMessage:@"保存成功！" sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakself) strongself = weakself;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MPMAttendenceSettingViewController class]]) {
                    [strongself.navigationController popToViewController:vc animated:YES];
                }
            }
        } needCancleButton:NO];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
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
            mo.address = kIsNilString([[model.locality stringByAppendingString:model.subLocality] stringByAppendingString:model.thoroughfare])?@"我的地址":[[model.locality stringByAppendingString:model.subLocality] stringByAppendingString:model.thoroughfare];
            mo.deviation = self.settingCardArray.count > 0?((MPMSettingCardAddressWifiModel *)self.settingCardArray[0]).deviation:@"";
            mo.latitude = [NSString stringWithFormat:@"%f",model.coordinate.latitude];
            mo.longitude = [NSString stringWithFormat:@"%f",model.coordinate.longitude];
            [self.settingCardArray addObject:mo];
            [self.dataArray[0] addObject:@{@"icon":@"setting_screencut",@"title":@"考勤地点",@"detail":mo.address}.mutableCopy];
            [self.tableView reloadData];
        };
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:map animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        NSInteger defaultValue = kIsNilString(self.deviation) ? 0 : [kDeviationValueArray indexOfObject:[NSString stringWithFormat:@"%@米",self.deviation]];
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
        _bottomSaveButton = [MPMButton titleButtonWithTitle:@"下一步" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
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
