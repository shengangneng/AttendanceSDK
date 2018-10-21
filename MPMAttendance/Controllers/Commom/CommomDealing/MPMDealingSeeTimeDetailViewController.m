//
//  MPMDealingSeeTimeDetailViewController.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDealingSeeTimeDetailViewController.h"
#import "MPMDealingSeeTimeTableViewCell.h"
#import "MPMOauthUser.h"
#import "MPMSessionManager.h"
#import "MPMCausationDetailModel.h"
#import "NSDateFormatter+MPMExtention.h"

@interface MPMDealingSeeTimeDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<MPMCausationDetailModel *> *detailArray;
@property (nonatomic, strong) MPMCausationDetailModel *model;

@end

@implementation MPMDealingSeeTimeDetailViewController

- (instancetype)initWithCausationDetail:(MPMCausationDetailModel *)model; {
    self = [super init];
    if (self) {
        self.model = model;
        [self defaultSetting];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cauculate];
}

- (void)cauculate {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_CALCULATETIME];
    NSString *type = self.model.causationType == kCausationTypeOverTime ? @"1" : @"0";
    NSDictionary *params = @{@"startTime":kSafeString(self.model.startTime),@"endTime":kSafeString(self.model.endTime),@"type":type};
    DLog(@"%@",params);
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:nil success:^(id response) {
        DLog(@"计算时长 === %@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = response[kResponseObjectKey];
            id day;
            id hour;
            if ([object[@"day"] isKindOfClass:[NSNumber class]]) {
                day = ((NSNumber *)object[@"day"]).stringValue;
            } else if ([object[@"day"] isKindOfClass:[NSString class]]) {
                day = object[@"day"];
            }
            if ([object[@"hour"] isKindOfClass:[NSNumber class]]) {
                hour = ((NSNumber *)object[@"hour"]).stringValue;
            } else if ([object[@"hour"] isKindOfClass:[NSString class]]) {
                hour = object[@"hour"];
            }
            self.model.hourAccount = hour;
            self.model.dayAccount = day;
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"计算时长失败 === %@",error);
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"计算明细";
    self.view.backgroundColor = kTableViewBGColor;
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        static NSString *identifier = @"totalCell";
        MPMDealingTotalTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMDealingTotalTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.txLabel.text = [NSString stringWithFormat:@"总共加班%@小时",self.model.hourAccount];
        cell.detailTxLabel.text = @"最小申请单位为（小时）";
        return cell;
    } else {
        static NSString *identifier = @"cell";
        MPMDealingSeeTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMDealingSeeTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.hourLabel.text = [NSString stringWithFormat:@"%@小时",self.model.hourAccount];
        double start = self.model.startTime.doubleValue/1000 + 28800;
        double end = self.model.endTime.doubleValue/1000 + 28800;
        double interval = self.model.startTime ? self.model.startTime.doubleValue : self.model.endTime.doubleValue;
        interval = interval/1000 + 28800;
        cell.timeDetailLabel.text = [NSString stringWithFormat:@"%@     %@%@-%@",[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:interval] withDefineFormatterType:forDateFormatTypeMonthYearDayWeek2],@"加班",[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:start] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:end] withDefineFormatterType:forDateFormatTypeHourMinute]];
        return cell;
    }
}

#pragma mark - Lazy Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewBGColor;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
