//
//  MPMRepairSigninViewController.m
//  MPMAtendence
//  补卡
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMRepairSigninViewController.h"
#import "MPMRepairSigninAddTimeTableViewCell.h"
#import "MPMRepairSigninAddDealTableViewCell.h"
/** 可以用一个通用的“处理”页面 */
#import "MPMBaseDealingViewController.h"
#import "MPMHTTPSessionManager.h"
#import "MPMShareUser.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMBaseTableViewCell.h"
#import "MPMOauthUser.h"
#import "MPMButton.h"
#import "MPMCausationDetailModel.h"
#import "MPMNoMessageView.h"

const NSInteger MPMRepairSignLimitCount = 5;

@interface MPMRepairSigninViewController () <UITableViewDelegate, UITableViewDataSource>
// header
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) MPMNoMessageView *noMessageView;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomRepairButton;
// data
@property (nonatomic, strong) MPMRepairSignLeadCardModel *leadCardModel;
@property (nonatomic, assign) kRepairFromType fromType;

@end

@implementation MPMRepairSigninViewController

- (instancetype)initWithRepairFromType:(kRepairFromType)fromType passingLeadArray:(NSArray <MPMLerakageCardModel *> *)leadArray {
    self = [super init];
    if (self) {
        self.fromType = fromType;
        self.leadCardModel = [[MPMRepairSignLeadCardModel alloc] initWithThisMonth:YES];
        self.leadCardModel.thisMonthPassingLeadCards = leadArray;
    }
    return self;
}

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
        [strongself getDataWithThisMonth:strongself.leadCardModel.isThisMonth];
    };
    [self getDataWithThisMonth:self.leadCardModel.isThisMonth];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"漏卡记录";
    [self.bottomRepairButton addTarget:self action:@selector(repair:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(left:)];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noMessageView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomRepairButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.noMessageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@(kPreferNoMessaegViewWidthHeight));
        make.centerX.equalTo(self.view.mpm_centerX);
        make.centerY.equalTo(self.view.mpm_centerY);
    }];
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
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
    [self.bottomRepairButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(PX_H(23));
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-PX_H(23));
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
}

- (void)getDataWithThisMonth:(BOOL)thisMonth {
    NSString *state = thisMonth ? @"1" : @"0";/** 0上月 1本月 */
    NSString *url = [NSString stringWithFormat:@"%@%@?state=%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_LEAKCARD,state];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在加载" success:^(id response) {
        self.leadCardModel.thisMonth = thisMonth;
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:object.count];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                MPMLerakageCardModel *model = [[MPMLerakageCardModel alloc] initWithDictionary:dic];
                [temp addObject:model];
            }
            // 如果有漏卡记录，则隐藏无数据视图，如果没有漏卡记录，则显示无数据视图
            self.noMessageView.hidden = temp.count > 0;
            if (self.leadCardModel.isThisMonth) {
                self.leadCardModel.thisMonthLeadCards = temp.copy;
                // 筛选出选中的项
                if (self.leadCardModel.thisMonthPassingLeadCards.count > 0) {
                    NSMutableArray *tempSelected = [NSMutableArray array];
                    for (int i = 0; i < self.leadCardModel.thisMonthLeadCards.count; i++) {
                        MPMLerakageCardModel *lead = self.leadCardModel.thisMonthLeadCards[i];
                        BOOL selected = NO;
                        for (int j = 0; j < self.leadCardModel.thisMonthPassingLeadCards.count; j++) {
                            MPMLerakageCardModel *slead = self.leadCardModel.thisMonthPassingLeadCards[j];
                            if ([lead.schedulingEmployeeId isEqualToString:slead.schedulingEmployeeId]) {
                                selected = YES;
                                break;
                            }
                        }
                        if (selected) {
                            [tempSelected addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                        }
                    }
                    self.leadCardModel.thisMonthSelectIndexPaths = tempSelected.copy;
                    self.leadCardModel.thisMonthPassingLeadCards = nil;
                }
            } else {
                self.leadCardModel.lastMonthLeadCards = temp.copy;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        self.leadCardModel.thisMonth = thisMonth;
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark - Target Action
- (void)left:(UIButton *)sender {
    // 无论是从打卡页面进入还是例外申请进入，返回都是直接返回上一层
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)repair:(UIButton *)sender {
    DLog(@"跳入例外申请补卡页面");
    if (!self.leadCardModel.isThisMonth || 0 == self.leadCardModel.thisMonthSelectIndexPaths.count) {
        [self showAlertControllerToLogoutWithMessage:@"请选择补卡记录" sureAction:nil needCancleButton:NO];
    } else {
        MPMDealingModel *model = [[MPMDealingModel alloc] initWithCausationType:kCausationTypeRepairSign addCount:self.leadCardModel.thisMonthSelectIndexPaths.count];
        for (int i = 0; i < self.leadCardModel.thisMonthSelectIndexPaths.count; i++) {
            NSIndexPath *indexPath = self.leadCardModel.thisMonthSelectIndexPaths[i];
            MPMLerakageCardModel *card = self.leadCardModel.thisMonthLeadCards[indexPath.row];
            model.causationDetail[i].detailId = card.schedulingEmployeeId;
            model.causationDetail[i].fillupTime = card.brushTime;
            model.causationDetail[i].signTime = card.brushTime;
        }
        if (kRepairFromTypeSigning == self.fromType) {
            MPMBaseDealingViewController *dealing = [[MPMBaseDealingViewController alloc] initWithDealType:kCausationTypeRepairSign dealingModel:model dealingFromType:kDealingFromTypeApply bizorderId:nil taskInstId:nil fastCalculate:kFastCalculateTypeNone];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dealing animated:YES];
        } else if (kRepairFromTypeDealing == self.fromType) {
            // 跳回例外申请，并带回数据
            if (self.toDealingBlock) {
                self.toDealingBlock(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
        case 1: {
            NSInteger count = self.leadCardModel.isThisMonth ? self.leadCardModel.thisMonthLeadCards.count : self.leadCardModel.lastMonthLeadCards.count;
            
            return count;break;
        }
        default:return 1; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            static NSString *cellIdTitle = @"cellIdTitle";
            MPMRepairSigninMonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdTitle];
            if (!cell) {
                cell = [[MPMRepairSigninMonthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdTitle];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"漏卡记录";
            cell.thisMonth = self.leadCardModel.isThisMonth;
            __weak typeof(self) weakself = self;
            // 切换月份
            cell.changeMonthBlock = ^(BOOL thisMonth) {
                __strong typeof(weakself) strongself = weakself;
                double bottomOffset = thisMonth ? 0 : BottomViewHeight;
                [UIView animateWithDuration:0.3 animations:^{
                    [strongself.bottomView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                        make.leading.trailing.equalTo(strongself.view);
                        make.bottom.equalTo(strongself.view.mpm_bottom).offset(bottomOffset);
                        make.height.equalTo(@(BottomViewHeight));
                    }];
                    [strongself.view layoutIfNeeded];
                } completion:nil];
                [strongself getDataWithThisMonth:thisMonth];
            };
            return cell;
        }break;
        case 1: {
            static NSString *cellIdAddDeal= @"cellIdAddDeal";
            MPMRepairSigninAddDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdAddDeal];
            if (!cell) {
                cell = [[MPMRepairSigninAddDealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdAddDeal];
            }
            NSArray *leadCardArray = self.leadCardModel.isThisMonth ? self.leadCardModel.thisMonthLeadCards : self.leadCardModel.lastMonthLeadCards;
            if (leadCardArray.count > 0) {
                MPMLerakageCardModel *model = leadCardArray[indexPath.row];
                cell.signTypeLabel.text = model.btn;
                cell.signTimeLabel.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:model.brushTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeHourMinute];
                cell.signDateLabel.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:model.brushTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
            }
            if (self.leadCardModel.thisMonthSelectIndexPaths.count > 0 && self.leadCardModel.isThisMonth) {
                BOOL selected = NO;
                for (int i = 0; i < self.leadCardModel.thisMonthSelectIndexPaths.count; i++) {
                    NSIndexPath *ind = self.leadCardModel.thisMonthSelectIndexPaths[i];
                    if (ind.row == indexPath.row) {
                        selected = YES;
                    }
                }
                if (selected) {
                    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:NO];
                } else {
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                }
            }
            cell.checkBox.hidden = !self.leadCardModel.isThisMonth;
            return cell;
        }break;
        default: return nil; break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.leadCardModel.thisMonthSelectIndexPaths = tableView.indexPathsForSelectedRows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.indexPathsForSelectedRows.count > MPMRepairSignLimitCount) {
        [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"最多只能选择%ld条漏卡记录进行补卡",MPMRepairSignLimitCount] sureAction:nil needCancleButton:NO];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    self.leadCardModel.thisMonthSelectIndexPaths = tableView.indexPathsForSelectedRows;
}

#pragma mark - Lazy Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsMultipleSelection = YES;
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

- (UIButton *)bottomRepairButton {
    if (!_bottomRepairButton) {
        _bottomRepairButton = [MPMButton titleButtonWithTitle:@"补卡" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomRepairButton;
}

- (MPMNoMessageView *)noMessageView {
    if (!_noMessageView) {
        _noMessageView = [[MPMNoMessageView alloc] initWithNoMessageViewImage:@"global_noMessage" noMessageLabelText:@"无漏卡记录"];
        _noMessageView.hidden = YES;
    }
    return _noMessageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
