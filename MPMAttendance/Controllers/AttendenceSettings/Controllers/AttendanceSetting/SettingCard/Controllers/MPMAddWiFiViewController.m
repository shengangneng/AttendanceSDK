//
//  MPMAddWiFiViewController.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAddWiFiViewController.h"
#import "MPMButton.h"
#import "MPMSettingCardDetailTableViewCell.h"
#import "MPMTableHeaderView.h"
// wifi
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface MPMAddWiFiViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSaveButton;

// data
@property (nonatomic, copy) NSArray *wifiListArray;

@end

@implementation MPMAddWiFiViewController

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
    self.wifiListArray = @[[self getWiFiInfo]];
}

- (NSDictionary *)getWiFiInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"添加考勤WiFi";
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
        make.height.equalTo(@0.5);
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
    DLog(@"保存");
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wifiListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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
    static NSString *cellIdentifier = @"cellIdentifier";
    MPMSettingCardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MPMSettingCardDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.imageIcon.image = ImageName(@"approval_cell_unselected");
    cell.txLabel.text = self.wifiListArray[indexPath.row][@"SSID"];
    cell.txDetailLabel.text = self.wifiListArray[indexPath.row][@"BSSID"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MPMSettingCardDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = !cell.selected;
}

#pragma mark - Lazy Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = kSeperateColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        _bottomSaveButton = [MPMButton titleButtonWithTitle:@"保存" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomSaveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
