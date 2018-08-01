//
//  MPMRepairSigninViewController.m
//  MPMAtendence
//  补签
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMRepairSigninViewController.h"
#import "MPMRepairSigninAddTimeTableViewCell.h"
#import "MPMRepairSigninAddDealTableViewCell.h"
/** 可以用一个通用的“处理”页面 */
#import "MPMBaseDealingViewController.h"
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "MPMLerakageCardModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMBaseTableViewCell.h"

@interface MPMRepairSigninViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
// data
@property (nonatomic, copy) NSArray<MPMLerakageCardModel *> *lerakageCardArray; /** 漏卡数据 */

@end

@implementation MPMRepairSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.title = @"补签";
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(left:)];
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

- (void)getData {
    NSString *classTimeId = @"1";
    /** 漏卡状态 */
    NSString *status = @"3";
    NSString *url = [NSString stringWithFormat:@"%@/attend/getLerakageCardList?employeeId=%@&classTimesId=%@&status=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,classTimeId,status,[MPMShareUser shareUser].token];
    [[MPMSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
        if (response[@"dataObj"] && [response[@"dataObj"] isKindOfClass:[NSArray class]]) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMLerakageCardModel *model = [[MPMLerakageCardModel alloc] initWithDictionary:dic];
                [temp addObject:model];
            }
            self.lerakageCardArray = temp.copy;
            [self.tableView reloadData];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - Target Action
- (void)left:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1; break;
        case 1: return self.lerakageCardArray.count; break;
        default:return 1; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            static NSString *cellIdTitle = @"cellIdTitle";
            MPMBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdTitle];
            if (!cell) {
                cell = [[MPMBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdTitle];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"本月漏签记录";
            return cell;
        }break;
            /*
        case 1: {
            static NSString *cellIdAddTime = @"cellIdAddTime";
            MPMRepairSigninAddTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdAddTime];
            if (!cell) {
                cell = [[MPMRepairSigninAddTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdAddTime];
            }
            return cell;
        }break;
             */
        case 1: {
            static NSString *cellIdAddDeal= @"cellIdAddDeal";
            MPMRepairSigninAddDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdAddDeal];
            if (!cell) {
                cell = [[MPMRepairSigninAddDealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdAddDeal];
            }
            MPMLerakageCardModel *model = self.lerakageCardArray[indexPath.row];
            cell.signTypeLabel.text = model.btn;
            cell.signTimeLabel.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:model.time.doubleValue/1000] withDefineFormatterType:forDateFormatTypeHourMinute];
            cell.signDateLabel.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:model.BrushDate.doubleValue/1000+28800] withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
            __weak typeof(self) weakself = self;
            cell.dealingBlock = ^{
                __strong typeof(weakself) strongself = weakself;
                // 跳入补签页面
                MPMDealingModel *dealingModel = [[MPMDealingModel alloc] init];
                dealingModel = [[MPMDealingModel alloc] init];
                dealingModel.attendenceDate = [NSString stringWithFormat:@"%.ld",(model.BrushDate.integerValue + model.time.integerValue)/1000+28800];
                dealingModel.attendenceId = model.AttendanceId;
                dealingModel.oriAttendenceDate = dealingModel.attendenceDate;
                dealingModel.brushTime = model.time;
                dealingModel.brushDate = model.BrushDate;
                dealingModel.type = model.SignType;
                dealingModel.status = @"3"; // 漏卡状态
                NSString *typeStatus = @"1";// 补签
                MPMBaseDealingViewController *dv = [[MPMBaseDealingViewController alloc] initWithDealType:forCausationTypeRepairSign typeStatus:typeStatus dealingModel:dealingModel  dealingFromType:kDealingFromTypeChangeRepair];
                strongself.hidesBottomBarWhenPushed = YES;
                [strongself.navigationController pushViewController:dv animated:YES];
                strongself.hidesBottomBarWhenPushed = NO;
            };
            return cell;
        }break;
        default: return nil; break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Lazy Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = kSeperateColor;
        _tableView.backgroundColor = kTableViewBGColor;
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.backgroundColor = kTableViewBGColor;
    }
    return _tableHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
