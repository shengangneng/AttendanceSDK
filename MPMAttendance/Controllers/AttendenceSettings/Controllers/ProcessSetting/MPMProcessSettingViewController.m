//
//  MPMProcessSettingViewController.m
//  MPMAtendence
//  流程设置
//  Created by shengangneng on 2018/8/15.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessSettingViewController.h"
#import "MPMBaseTableViewCell.h"
#import "MPMOauthUser.h"
#import "MPMHTTPSessionManager.h"
#import "MPMProcessDef.h"
#import "MPMProcessSettingCommomViewController.h"

@interface MPMProcessSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *tableData;

@end

@implementation MPMProcessSettingViewController

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

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"流程设置";
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
}

- (void)getData {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_PROCESSDEFS];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if ([response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:object.count];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                MPMProcessDef *item = [[MPMProcessDef alloc] initWithDictionary:dic];
                [temp addObject:item];
            }
            self.tableData = temp.copy;
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
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

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MPMBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    MPMProcessDef *item = self.tableData[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MPMProcessDef *model = self.tableData[indexPath.row];
    MPMProcessSettingCommomViewController *commom = [[MPMProcessSettingCommomViewController alloc] initWithModel:model];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commom animated:YES];
}

#pragma mark - Lazy Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = kSeperateColor;
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
