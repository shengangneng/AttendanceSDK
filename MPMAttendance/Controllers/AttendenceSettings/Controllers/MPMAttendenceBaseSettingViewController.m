//
//  MPMAttendenceBaseSettingViewController.m
//  MPMAtendence
//  V1.1版本考勤设置主页
//  Created by shengangneng on 2018/6/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceBaseSettingViewController.h"
#import "MPMAttendenceBaseTableViewCell.h"
#import "MPMAttendenceSettingViewController.h"
#import "MPMIntergralSettingViewController.h"
#import "MPMAuthoritySettingViewController.h"
#import "MPMProcessSettingViewController.h"
#import "MPMShareUser.h"
#import "MPMHTTPSessionManager.h"
#import "MPMSettingSwitchValueModel.h"
#import "MPMLoginViewController.h"
#import "MPMApprovalFirstSectionModel.h"
#import "MPMOauthUser.h"

#define PerimissionId @"8"   /** 考勤设置PermissionId */

@interface MPMAttendenceBaseSettingViewController () <UITableViewDelegate, UITableViewDataSource>
// views
@property (nonatomic, strong) UITableView *tableView;
// data
@property (nonatomic, copy) NSArray *tableViewData;
@property (nonatomic, strong) MPMSettingSwitchValueModel *switchValueModel;/** 未关联排版时允许打卡数据 */

@end

@implementation MPMAttendenceBaseSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
    [self getPermissionList];
}

- (void)getPermissionList {
    NSArray *arr = [MPMOauthUser shareOauthUser].perimissionArray;
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSString *key = arr[i][@"id"];
        if (!kIsNilString(key) && kAttendanceSettingPerimissionDicV2[key]) {
            [temp addObject:kAttendanceSettingPerimissionDicV2[key]];
        }
    }
    self.tableViewData = temp.copy;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SettingCell";
    MPMAttendenceBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMAttendenceBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = self.tableViewData[indexPath.row];
    cell.txLabel.text = dic[@"title"];
    cell.iconView.image = ImageName(dic[@"image"]);
    if (dic[@"switch"]) {
        cell.signSwitch.hidden = NO;
        [cell.signSwitch setOn:(self.switchValueModel.validAttend.integerValue == 1) animated:YES];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.signSwitch.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    __weak typeof(self) weakself = self;
    cell.switchChangeBlock = ^(UISwitch *sender) {
        // 切换switch
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *vcName = self.tableViewData[indexPath.row][@"Controller"];
    if (!kIsNilString(vcName)) {
        UIViewController *controller = [[NSClassFromString(vcName) alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - Init Setup

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"考勤设置";
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Lazy Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
        _tableView.backgroundColor = kTableViewBGColor;
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = kSeperateColor;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
