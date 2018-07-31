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
#import "MPMShareUser.h"
#import "MPMHTTPSessionManager.h"
#import "MPMSettingSwitchValueModel.h"
#import "MPMLoginViewController.h"
#import "MPMApprovalFirstSectionModel.h"

#define PerimissionId @"8"   /** 考勤设置PermissionId */

@interface MPMAttendenceBaseSettingViewController () <UITableViewDelegate, UITableViewDataSource>
// views
@property (nonatomic, strong) UITableView *tableView;
// data
@property (nonatomic, copy) NSArray *tableViewData;
@property (nonatomic, strong) MPMSettingSwitchValueModel *switchValueModel;/** 未关联排版时允许打卡数据 */

@end

@implementation MPMAttendenceBaseSettingViewController

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
//    [self getData];
    [self getPermissionList];
}

- (void)getData {
    // 获取“未关联排班时允许打卡”的信息
    NSString *url = [NSString stringWithFormat:@"%@kqCompanyConfigController/getKqCompanyConfig?token=%@",MPMHost,[MPMShareUser shareUser].token];
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:nil success:^(id response) {
        if ([response[@"dataObj"] isKindOfClass:[NSDictionary class]]) {
            self.switchValueModel = [[MPMSettingSwitchValueModel alloc] initWithDictionary:response[@"dataObj"]];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

- (void)getPermissionList {
    
    NSString *url = [NSString stringWithFormat:@"%@ApproveController/getPerimssionList?token=%@&employeeId=%@&perimissionId=%@",MPMHost,[MPMShareUser shareUser].token,[MPMShareUser shareUser].employeeId,PerimissionId];
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:nil success:^(id response) {
        DLog(@"%@",response);
        if ([response[@"dataObj"] isKindOfClass:[NSArray class]]) {
            NSArray *permission = response[@"dataObj"];
            NSMutableArray *temp = [NSMutableArray array];
            // 现在进入考勤设置，考勤排班固定写死
            [temp addObject:kClassSettingPerimission];
            for (id data in permission) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    MPMApprovalFirstSectionModel *model = [[MPMApprovalFirstSectionModel alloc] initWithDictionary:(NSDictionary *)data];
                    if (kAttendanceSettingPerimissionDic[model.mpm_id]) {
                        [temp addObject:kAttendanceSettingPerimissionDic[model.mpm_id]];
                    }
                }
            }
            self.tableViewData = temp.copy;
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
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
        __strong typeof (weakself) strongself = weakself;
        NSString *url = [NSString stringWithFormat:@"%@kqCompanyConfigController/kqCompanyConfigSet?token=%@",MPMHost,[MPMShareUser shareUser].token];
        NSDictionary *params = @{@"companyId":strongself.switchValueModel.companyId,@"id":strongself.switchValueModel.mpm_id,@"validAttend":(sender.isOn?@"1":@"0")};
        [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在加载" success:^(id response) {
            // 修改成功
            strongself.switchValueModel.validAttend = (sender.isOn?@"1":@"0");
            [strongself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^(NSString *error) {
            // 修改失败
            [strongself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
