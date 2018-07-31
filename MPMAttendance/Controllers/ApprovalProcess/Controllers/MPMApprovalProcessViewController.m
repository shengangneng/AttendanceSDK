//
//  MPMApprovalProcessViewController.m
//  MPMAtendence
//  流程审批
//  Created by gangneng shen on 2018/4/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApprovalProcessViewController.h"
#import "MPMButton.h"
#import "MPMApprovalProcessTableViewCell.h"
#import "MPMApprovalProcessDetailViewController.h"
#import "MPMSideDrawerView.h"
#import "MPMHTTPSessionManager.h"
#import "MPMShareUser.h"
#import "MPMApprovalFirstSectionModel.h"
#import "MPMApprovalFetchDetailModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMApprovalProcessHeaderSectionView.h"
#import "UILabel+MPMExtention.h"

typedef NS_ENUM(NSInteger, TableViewEditType) {
    forTableViewEdit,
    forTableViewNormal
};

@interface MPMApprovalProcessViewController () <UITableViewDelegate, UITableViewDataSource, MPMSideDrawerViewDelegate>
// Header
@property (nonatomic, strong) MPMApprovalProcessHeaderSectionView *headerSectionView;
// Bottom
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *noMessageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSingleRightButton;
@property (nonatomic, strong) UIButton *bottomDoubleLeftButton;
// Data
@property (nonatomic, copy) NSArray *firstSectionMessageArray;/** 从接口获取到的一级导航列表 */
@property (nonatomic, copy) NSArray *fetchDetailDataArray;
@property (nonatomic, copy) NSArray *passToDetailTitles;
// 选中的cell
@property (nonatomic, strong) NSMutableArray *selectedCellArray;
// 记录选中的index
@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath;
@property (nonatomic, assign) FirstSectionType firstSectionType;
// 高级筛选侧滑视图
@property (nonatomic, strong) MPMSideDrawerView *siderDrawerView;

@end

@implementation MPMApprovalProcessViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // 获取一级导航的数据
        [self getPermissionData];
    }
    return self;
}

- (void)initViewAfterGotData {
    [self setupSubViews];
    [self setupAttributes];
    [self setupConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 获取一级导航的列表
- (void)getPermissionData {
    // TODO：需要为这个控制器绑定perimissionId
    NSString *perimission = @"6";
    MPMShareUser *user = [MPMShareUser shareUser];
    NSString *url = [NSString stringWithFormat:@"%@ApproveController/getPerimssionList?employeeId=%@&token=%@&perimissionId=%@",MPMHost,user.employeeId,user.token,perimission];
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
        NSArray *arr = response[@"dataObj"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            MPMApprovalFirstSectionModel *model = [[MPMApprovalFirstSectionModel alloc] initWithDictionary:dic];
            [temp addObject:model];
        }
        self.firstSectionMessageArray = temp.copy;
        [self initViewAfterGotData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

- (void)getData:(FirstSectionType)type indexPath:(NSIndexPath *)indexPath withCausationNo:(NSArray *)cNo startDate:(NSString *)sDate endDate:(NSString *)eDate {
    if (kIsNilString(sDate))sDate = @"";
    if (kIsNilString(eDate))eDate = @"";
    
    NSString *url = [NSString stringWithFormat:@"%@ApproveController/getApproveList?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSDictionary *params;
    
    switch (type) {
        case forMyApplyType:{
            // 我的申请:startDate、endDate、employeeId、status
            id status = nil;
            switch (indexPath.row) {
                case 0:{
                    status = @1;
                }break;
                case 1:{
                    status = @6;
                }break;
                case 2:{
                    status = @4;
                }break;
                case 3:{
                    status = @5;
                }break;
                case 4:{
                    status = @0;
                }break;
                default:{
                    status = @1;
                }break;
            }
            if (cNo && cNo.count > 0) {
                params = @{@"employeeId":[MPMShareUser shareUser].employeeId,@"endDate":eDate,@"startDate":sDate,@"status":@[status],@"causationtypeNo":cNo};
            } else {
                params = @{@"employeeId":[MPMShareUser shareUser].employeeId,@"endDate":eDate,@"startDate":sDate,@"status":@[status]};
            }
        }
            break;
        case forMyApprovalType:{
            url = [NSString stringWithFormat:@"%@ApproveController/getMyApproveList?token=%@",MPMHost,[MPMShareUser shareUser].token];
            id status;
            // 我的审批：MyApprovalList：startDate、endDate、approvalId、flag、status 我的审批不需要传employeeId
            switch (indexPath.row) {
                case 0:{
                    // 待我审批：startDate、endDate、employeeId、approvalId、status
                    status = @1;
                }break;
                case 1:{
                    // 已通过：startDate、endDate、employeeId、approvalId、status
                    status = @6;
                }break;
                case 2:{
                    // 已驳回：startDate、endDate、employeeId、approvalId、status
                    status = @4;
                }break;
                default:
                    break;
                    
            }
            if (cNo && cNo.count > 0) {
                params = @{@"startDate":sDate,@"endDate":eDate,@"status":@[status],@"approveId":[MPMShareUser shareUser].employeeId,@"causationtypeNo":cNo};
            } else {
                params = @{@"startDate":sDate,@"endDate":eDate,@"status":@[status],@"approveId":[MPMShareUser shareUser].employeeId};
            }
        }
            break;
        case forCCListType:{
            // 抄送列表
            switch (indexPath.row) {
                case 0:{
                    // 抄送给我：startDate、endDate、copyNameId：自己的employeeId
                    if (cNo && cNo.count > 0) {
                        params = @{@"startDate":sDate,@"endDate":eDate,@"copyNameId":[MPMShareUser shareUser].employeeId,@"causationtypeNo":cNo};
                    } else {
                        params = @{@"startDate":sDate,@"endDate":eDate,@"copyNameId":[MPMShareUser shareUser].employeeId};
                    }
                    
                }break;
                case 1:{
                    // 我的抄送：startDate、endDate、employeeId：自己的employeeId、copyNameId = -1
                    if (cNo && cNo.count > 0) {
                        params = @{@"startDate":sDate,@"endDate":eDate,@"employeeId":[MPMShareUser shareUser].employeeId,@"copyNameId":@"",@"causationtypeNo":cNo};
                    } else {
                        params = @{@"startDate":sDate,@"endDate":eDate,@"employeeId":[MPMShareUser shareUser].employeeId,@"copyNameId":@""};
                    }
                }break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
        NSArray *arr = response[@"dataObj"];
        if (arr && arr.count > 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *modelDic = arr[i];
                MPMApprovalFetchDetailModel *model = [[MPMApprovalFetchDetailModel alloc] init];
                MPMApprovalCausationModel *causation = [[MPMApprovalCausationModel alloc] initWithDictionary:modelDic[@"approveCausation"]];
                model.causation = causation;
                id modelArr = modelDic[@"causationDetail"];
                if ([modelArr isKindOfClass:[NSArray class]]) {
                    NSArray *real = (NSArray *)modelArr;
                    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:real.count];
                    for (int j = 0; j < real.count; j++) {
                        MPMApprovalCausationDetailModel *causationDetail = [[MPMApprovalCausationDetailModel alloc] initWithDictionary:real[j]];
                        [tempArr addObject:causationDetail];
                    }
                    model.causationDetailArray = tempArr.copy;
                }
                [temp addObject:model];
            }
            self.fetchDetailDataArray = temp.copy;
            // 刷新
            [self.tableView reloadData];
            self.tableView.scrollEnabled = self.tableView.backgroundView.hidden = YES;
        } else {
            // 显示无数据的视图
            self.fetchDetailDataArray = nil;
            // 刷新
            [self.tableView reloadData];
            self.tableView.scrollEnabled = self.tableView.backgroundView.hidden = NO;
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 重新获取一下页面数据
    [self.headerSectionView setDefaultSelect];
}

- (void)setupSubViews {
    [super setupSubViews];
    self.headerSectionView = [[MPMApprovalProcessHeaderSectionView alloc] initWithFirstSectionArray:self.firstSectionMessageArray];
    [self.view addSubview:self.headerSectionView];
    [self.headerSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@85);
        make.top.leading.trailing.equalTo(self.view);
    }];
    __weak typeof (self) weakself = self;
    // 头部导航的点击
    self.headerSectionView.selectBlock = ^(NSIndexPath *indexPath, FirstSectionType firstSectionType) {
        __strong typeof(weakself) strongself = weakself;
        strongself.lastSelectIndexPath = indexPath;
        strongself.firstSectionType = firstSectionType;
        [strongself.view endEditing:YES];
        if (strongself.tableView.isEditing) {
            // 如果是tableView正在编辑状态下切换，需要先切换UI和状态
            [strongself back:nil];
        }
        switch (firstSectionType) {
            case forMyApplyType:{
                switch (indexPath.row) {
                    case 0:{
                        // 待审批
                        [strongself.bottomSingleRightButton setTitle:@"撤回" forState:UIControlStateNormal];
                        [strongself.bottomSingleRightButton setTitle:@"撤回" forState:UIControlStateHighlighted];
                        strongself.passToDetailTitles = @[@"撤回"];
                        [strongself.bottomDoubleLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomView.mas_leading);
                            make.width.equalTo(@0);
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApplyType];
                    }break;
                    case 1:{
                        // 已审批
                        strongself.passToDetailTitles = nil;
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApplyType];
                    }break;
                    case 2:{
                        // 已驳回
                        [strongself.bottomDoubleLeftButton setTitle:@"删除" forState:UIControlStateNormal];
                        [strongself.bottomDoubleLeftButton setTitle:@"删除" forState:UIControlStateHighlighted];
                        [strongself.bottomSingleRightButton setTitle:@"提交" forState:UIControlStateNormal];
                        [strongself.bottomSingleRightButton setTitle:@"提交" forState:UIControlStateHighlighted];
                        strongself.passToDetailTitles = @[@"删除",@"编辑",@"提交"];
                        [strongself.bottomDoubleLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomView.mas_leading).offset(PX_H(23));
                            make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself.bottomSingleRightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomDoubleLeftButton.mas_trailing).offset(PX_H(23));
                            make.trailing.equalTo(strongself.bottomView.mas_trailing).offset(-PX_H(23));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApplyType];
                    }break;
                    case 3:{
                        // 已撤回
                        [strongself.bottomDoubleLeftButton setTitle:@"删除" forState:UIControlStateNormal];
                        [strongself.bottomDoubleLeftButton setTitle:@"删除" forState:UIControlStateHighlighted];
                        [strongself.bottomSingleRightButton setTitle:@"提交" forState:UIControlStateNormal];
                        [strongself.bottomSingleRightButton setTitle:@"提交" forState:UIControlStateHighlighted];
                        strongself.passToDetailTitles = @[@"删除",@"编辑",@"提交"];
                        [strongself.bottomDoubleLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomView.mas_leading).offset(PX_H(23));
                            make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself.bottomSingleRightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomDoubleLeftButton.mas_trailing).offset(PX_H(23));
                            make.trailing.equalTo(strongself.bottomView.mas_trailing).offset(-PX_H(23));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApplyType];
                    }break;
                    case 4:{
                        // 草稿箱
                        [strongself.bottomDoubleLeftButton setTitle:@"删除" forState:UIControlStateNormal];
                        [strongself.bottomDoubleLeftButton setTitle:@"删除" forState:UIControlStateHighlighted];
                        [strongself.bottomSingleRightButton setTitle:@"提交" forState:UIControlStateNormal];
                        [strongself.bottomSingleRightButton setTitle:@"提交" forState:UIControlStateHighlighted];
                        strongself.passToDetailTitles = @[@"删除",@"编辑",@"提交"];
                        [strongself.bottomDoubleLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomView.mas_leading).offset(PX_H(23));
                            make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself.bottomSingleRightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomDoubleLeftButton.mas_trailing).offset(PX_H(23));
                            make.trailing.equalTo(strongself.bottomView.mas_trailing).offset(-PX_H(23));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApplyType];
                    }break;
                    default:
                        break;
                }
                
            }break;
            case forMyApprovalType:{
                switch (indexPath.row) {
                    case 0: {
                        // 待我审批
                        [strongself.bottomDoubleLeftButton setTitle:@"通过" forState:UIControlStateNormal];
                        [strongself.bottomDoubleLeftButton setTitle:@"通过" forState:UIControlStateHighlighted];
                        [strongself.bottomSingleRightButton setTitle:@"驳回" forState:UIControlStateNormal];
                        [strongself.bottomSingleRightButton setTitle:@"驳回" forState:UIControlStateHighlighted];
                        strongself.passToDetailTitles = @[@"通过",@"驳回"];
                        [strongself.bottomDoubleLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomView.mas_leading).offset(PX_H(23));
                            make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself.bottomSingleRightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomDoubleLeftButton.mas_trailing).offset(PX_H(23));
                            make.trailing.equalTo(strongself.bottomView.mas_trailing).offset(-PX_H(23));
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApprovalType];
                    }break;
                    case 1: {
                        // 已通过
                        [strongself.bottomSingleRightButton setTitle:@"驳回" forState:UIControlStateNormal];
                        [strongself.bottomSingleRightButton setTitle:@"驳回" forState:UIControlStateHighlighted];
                        strongself.passToDetailTitles = @[@"驳回"];
                        [strongself.bottomDoubleLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(strongself.bottomView.mas_leading);
                            make.width.equalTo(@0);
                            make.top.equalTo(strongself.bottomView.mas_top).offset(BottomViewTopMargin);
                            make.bottom.equalTo(strongself.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
                        }];
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApprovalType];
                    }
                    case 2: {
                        // 已驳回
                        strongself.passToDetailTitles = nil;
                        [strongself setSelectIndexPath:indexPath forSectionType:forMyApprovalType];
                    }
                    default:
                        break;
                }
            }break;
            case forCCListType:{
                switch (indexPath.row) {
                    case 0: {
                        // 抄送给我
                        strongself.passToDetailTitles = nil;
                        [strongself setSelectIndexPath:indexPath forSectionType:forCCListType];
                    }
                        break;
                    case 1: {
                        // 我的抄送
                        strongself.passToDetailTitles = nil;
                        [strongself setSelectIndexPath:indexPath forSectionType:forCCListType];
                    }
                    default:
                        break;
                }
            }break;
            default:
                break;
        }
    };
    self.headerSectionView.fillterBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        // 高级筛选
        strongself.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = NO;
        [strongself.siderDrawerView showInView:kAppDelegate.window maskViewFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) drawerViewFrame:CGRectMake(kScreenWidth, kNavigationHeight, 253, kScreenHeight - kNavigationHeight)];
    };
    // Bottom
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noMessageView];
    [kAppDelegate.window addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomSingleRightButton];
    [self.bottomView addSubview:self.bottomDoubleLeftButton];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"流程审批";
    self.selectedCellArray = [NSMutableArray array];
    [self setRightBarButtonType:forBarButtonTypeTitle title:@"编辑" image:nil action:@selector(edit:)];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    // 左上角"返回"按钮隐藏，右上角"编辑"不隐藏
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    // 底部按钮
    [self.bottomSingleRightButton addTarget:self action:@selector(singleRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomDoubleLeftButton addTarget:self action:@selector(doubleLeft:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    // Bottom
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.headerSectionView.mas_bottom);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(kAppDelegate.window);
        make.height.equalTo(@(BottomViewHeight));
        make.top.equalTo(kAppDelegate.window.mas_bottom);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
    }];
    [self.bottomDoubleLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mas_leading);
        make.width.equalTo(@0);
        make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
    }];
    [self.bottomSingleRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomDoubleLeftButton.mas_trailing).offset(12);
        make.trailing.equalTo(self.bottomView.mas_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
    }];
    [self.noMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(190));
        make.width.equalTo(@(190));
        make.centerY.equalTo(self.tableView.mas_centerY).offset(-10);
        make.centerX.equalTo(self.tableView.mas_centerX);
    }];
}

#pragma mark - Private Method

- (void)setSelectIndexPath:(NSIndexPath *)indexPath forSectionType:(FirstSectionType)type {
    // 每次选中之后，调用接口获取数据
    [self.siderDrawerView reset:nil];
    [self getData:type indexPath:indexPath withCausationNo:nil startDate:@"" endDate:@""];
}

- (void)updateAfterOperation {
    // 把删除数据
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.fetchDetailDataArray.count];
    for (int i = 0; i < self.fetchDetailDataArray.count; i++) {
        BOOL isValue = NO;
        for (NSIndexPath *index in self.selectedCellArray) {
            if (i == index.row) {
                isValue = YES;
            }
        }
        if (!isValue) {
            [temp addObject:self.fetchDetailDataArray[i]];
        }
    }
    
    self.fetchDetailDataArray = temp.copy;
    [self.selectedCellArray removeAllObjects];
    
    // 刷新页面
    [self.tableView reloadData];
}

#pragma mark - Target Action

- (void)back:(UIButton *)sender {
    [self.selectedCellArray removeAllObjects];
    // 1、显示编辑按钮
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    // 2、底部按钮消失
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(kAppDelegate.window);
            make.height.equalTo(@(BottomViewHeight));
            make.top.equalTo(kAppDelegate.window.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];
    // 3、改变tableview的样式
    [self.tableView setEditing:NO animated:YES];
}

- (void)edit:(UIButton *)sender {
    // 如果没有数据，不会切换编辑状态
    if (self.fetchDetailDataArray.count == 0) return;
    // 1、显示左上角返回
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    // 2、底部弹出按钮
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(kAppDelegate.window);
            make.height.equalTo(@(BottomViewHeight));
            make.top.equalTo(kAppDelegate.window.mas_bottom).offset(-BottomViewHeight);
        }];
        [self.view layoutIfNeeded];
    }];
    // 改变tableview状态
    [self.tableView setEditing:YES animated:YES];
}

- (void)doubleLeft:(UIButton *)sender {
    DLog(@"Left == 删除、通过...");
    if (self.selectedCellArray.count == 0) return;
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"删除"]) {
        // 删除操作，不需要status，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/deletApprove?&employeeId=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.selectedCellArray.count];
        for (int i = 0; i < self.selectedCellArray.count; i++) {
            NSIndexPath *indexPath = self.selectedCellArray[i];
            MPMApprovalFetchDetailModel *model = self.fetchDetailDataArray[indexPath.row];
            NSDictionary *dic = @{@"causationtypeNo":model.causation.causationtypeNo,@"exchangeId":model.causation.exchangeId,@"rejectReason":@"",@"status":model.causation.status};
            [params addObject:dic];
        }
        [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            [self updateAfterOperation];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    } else if ([title isEqualToString:@"通过"]) {
        // 通过操作，status传6，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"6",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.selectedCellArray.count];
        for (int i = 0; i < self.selectedCellArray.count; i++) {
            NSIndexPath *indexPath = self.selectedCellArray[i];
            MPMApprovalFetchDetailModel *model = self.fetchDetailDataArray[indexPath.row];
            NSDictionary *dic = @{@"causationtypeNo":model.causation.causationtypeNo,@"exchangeId":model.causation.exchangeId,@"rejectReason":@"",@"status":model.causation.status};
            [params addObject:dic];
        }
        [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            [self updateAfterOperation];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    }
}

- (void)singleRight:(UIButton *)sender {
    DLog(@"Right == 撤回、核销、提交...");
    if (self.selectedCellArray.count == 0) return;
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"撤回"]) {
        // 撤回操作，status传5，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"5",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.selectedCellArray.count];
        for (int i = 0; i < self.selectedCellArray.count; i++) {
            NSIndexPath *indexPath = self.selectedCellArray[i];
            MPMApprovalFetchDetailModel *model = self.fetchDetailDataArray[indexPath.row];
            NSDictionary *dic = @{@"causationtypeNo":model.causation.causationtypeNo,@"exchangeId":model.causation.exchangeId,@"rejectReason":@"",@"status":model.causation.status};
            [params addObject:dic];
        }
        [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            [self updateAfterOperation];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    } else if ([title isEqualToString:@"提交"]) {
        // 提交操作，status传1，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"1",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.selectedCellArray.count];
        for (int i = 0; i < self.selectedCellArray.count; i++) {
            NSIndexPath *indexPath = self.selectedCellArray[i];
            MPMApprovalFetchDetailModel *model = self.fetchDetailDataArray[indexPath.row];
            NSDictionary *dic = @{@"causationtypeNo":model.causation.causationtypeNo,@"exchangeId":model.causation.exchangeId,@"rejectReason":@"",@"status":model.causation.status};
            [params addObject:dic];
        }
        [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            [self updateAfterOperation];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    } else if ([title isEqualToString:@"驳回"]) {
        // 驳回操作，status传4，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"4",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.selectedCellArray.count];
        for (int i = 0; i < self.selectedCellArray.count; i++) {
            NSIndexPath *indexPath = self.selectedCellArray[i];
            MPMApprovalFetchDetailModel *model = self.fetchDetailDataArray[indexPath.row];
            NSDictionary *dic = @{@"causationtypeNo":model.causation.causationtypeNo,@"exchangeId":model.causation.exchangeId,@"rejectReason":@"",@"status":model.causation.status};
            [params addObject:dic];
        }
        [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            [self updateAfterOperation];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    }
}

#pragma mark - MPMSiderDrawerViewDelegate

- (void)siderDrawerViewDidDismiss {
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
}

- (void)siderDrawerView:(MPMSideDrawerView *)siderDrawerView didCompleteWithCausationtypeNo:(NSArray *)cNo startDate:(NSString *)sDate endDate:(NSString *)eDate {
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
    DLog(@"%@==%@==%@",cNo,sDate,eDate);
    [self getData:self.firstSectionType indexPath:self.lastSelectIndexPath withCausationNo:cNo startDate:sDate endDate:eDate];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.fetchDetailDataArray.count > 0) {
        self.noMessageView.hidden = YES;
    } else {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        self.noMessageView.hidden = NO;
    }
    return self.fetchDetailDataArray.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.firstSectionType) {
        case forMyApplyType:{
            switch (self.lastSelectIndexPath.row) {
                case 0:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                }break;
                case 1:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }break;
                case 2:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                }break;
                case 3:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                }break;
                case 4:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                }break;
                default:
                    break;
            }
        }break;
        case forMyApprovalType:{
            switch (self.lastSelectIndexPath.row) {
                case 0:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                }break;
                case 1:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }break;
                case 2:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }break;
                default:
                    break;
            }
        }break;
        case forCCListType:{
            switch (self.lastSelectIndexPath.row) {
                case 0:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }break;
                case 1:{
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }break;
                default:
                    break;
            }
        }break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellIdentifier";
    MPMApprovalProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMApprovalProcessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MPMApprovalFetchDetailModel *model = self.fetchDetailDataArray[indexPath.row];
    MPMApprovalCausationModel *causation = model.causation;
    UIImage *image;
    NSString *text;
    switch (self.firstSectionType) {
        case forMyApplyType:{
            switch (self.lastSelectIndexPath.row) {
                case 0:{
                    image = ImageName(@"approval_blueFlag");
                    text = @"待审批";
                }break;
                case 1:{
                    image = ImageName(@"approval_greenFlag");
                    text = @"已审批";
                }break;
                case 2:{
                    image = ImageName(@"approval_orangeFlag");
                    text = @"已驳回";
                }break;
                case 3:{
                    image = ImageName(@"approval_orangeFlag");
                    text = @"已撤回";
                }break;
                case 4:{
                    image = ImageName(@"approval_orangeFlag");
                    text = @"草稿箱";
                }break;
                default:
                    break;
            }
        }break;
        case forMyApprovalType:{
            switch (self.lastSelectIndexPath.row) {
                case 0:{
                    image = ImageName(@"approval_blueFlag");
                    text = @"待我审批";
                }break;
                case 1:{
                    image = ImageName(@"approval_greenFlag");
                    text = @"已通过";
                }break;
                case 2:{
                    image = ImageName(@"approval_orangeFlag");
                    text = @"已驳回";
                }break;
                default:
                    break;
            }
        }break;
        case forCCListType:{
            switch (self.lastSelectIndexPath.row) {
                case 0:{
                    image = ImageName(@"approval_orangeFlag");
                    text = @"抄送给我";
                }break;
                case 1:{
                    image = ImageName(@"approval_orangeFlag");
                    text = @"我的抄送";
                }break;
                default:
                    break;
            }
        }break;
        default:
            break;
    }
    cell.flagImageView.image = image;
    cell.flagLabel.text = text;
    if ([self.selectedCellArray containsObject:indexPath]) {
        cell.selectImageView.image = ImageName(@"setting_all_mid");
    } else {
        cell.selectImageView.image = ImageName(@"setting_none_mid");
    }
    cell.applyPersonMessageLabel.text = causation.approveName;
    cell.extraApplyMessageLabel.text = kSausactionType[causation.causationtypeNo];
    // 设置AttributeString
    [cell.applyDetailMessageLabel setAttributedString:causation.reason font:SystemFont(14) lineSpace:2.5];
    if (causation.applicantDate && causation.applicantDate.length > 10) {
        NSString *te = causation.applicantDate;
        te = [te substringToIndex:10];
        NSTimeInterval time = te.doubleValue;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *title = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
        [cell.dateButton setTitle:title forState:UIControlStateNormal];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.isEditing) {
        MPMApprovalProcessTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.selectedCellArray.count > 0 && [self.selectedCellArray containsObject:indexPath]) {
            cell.selectImageView.image = ImageName(@"setting_none_mid");
            [self.selectedCellArray removeObject:indexPath];
        } else {
            cell.selectImageView.image = ImageName(@"setting_all_mid");
            [self.selectedCellArray addObject:indexPath];
        }
    } else {
        NSString *image;
        NSString *text;
        MPMApprovalFetchDetailModel *model = self.fetchDetailDataArray[indexPath.row];
        switch (self.firstSectionType) {
            case forMyApplyType:{
                switch (self.lastSelectIndexPath.row) {
                    case 0:{
                        image = @"approval_detail_pprovalending";
                        text = @"待处理";
                    }break;
                    case 1:{
                        image = @"approval_detail_passed";
                        text = @"已通过";
                    }break;
                    case 2:{
                        image = @"approval_detail_reject";
                        if (kIsNilString(model.causation.rejectReason)) {
                            text = @"已驳回";
                        } else {
                            text = [NSString stringWithFormat:@"驳回理由:%@",model.causation.rejectReason];
                        }
                    }break;
                    case 3:{
                        image = @"approval_detail_reject";
                        text = @"已撤回";
                    }break;
                    case 4:{
                        image = @"approval_detail_pprovalending";
                        text = @"待处理";
                    }break;
                    default:
                        break;
                }
            }break;
            case forMyApprovalType:{
                switch (self.lastSelectIndexPath.row) {
                    case 0:{
                        image = @"approval_detail_pprovalending";
                        text = @"待处理";
                    }break;
                    case 1:{
                        image = @"approval_detail_passed";
                        text = @"已通过";
                    }break;
                    case 2:{
                        image = @"approval_detail_reject";
                        if (kIsNilString(model.causation.rejectReason)) {
                            text = @"已驳回";
                        } else {
                            text = [NSString stringWithFormat:@"驳回理由:%@",model.causation.rejectReason];
                        }
                    }break;
                    default:
                        break;
                }
            }break;
            case forCCListType:{
                switch (self.lastSelectIndexPath.row) {
                    case 0:{
                        image = @"approval_detail_pprovalending";
                        text = @"待处理";
                    }break;
                    case 1:{
                        image = @"approval_detail_pprovalending";
                        text = @"待处理";
                    }break;
                    default:
                        break;
                }
            }break;
            default:
                break;
        }
        
        MPMApprovalProcessDetailViewController *detail = [[MPMApprovalProcessDetailViewController alloc] initWithCausation:model.causation CausationDetailArray:model.causationDetailArray operationButtonTitles:self.passToDetailTitles image:image text:text];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - Lazy Init

// Bottom
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kTableViewBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 6, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = PX_W(300);
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

// bottom单个按钮
- (UIButton *)bottomSingleRightButton {
    if (!_bottomSingleRightButton) {
        _bottomSingleRightButton = [MPMButton titleButtonWithTitle:@"撤回" nTitleColor:kWhiteColor hTitleColor:kMainLightGray bgColor:kMainBlueColor];
        _bottomSingleRightButton.layer.cornerRadius = 5;
        _bottomSingleRightButton.titleLabel.font = SystemFont(18);
    }
    return _bottomSingleRightButton;
}
// bottom两个按钮
- (UIButton *)bottomDoubleLeftButton {
    if (!_bottomDoubleLeftButton) {
        _bottomDoubleLeftButton = [MPMButton titleButtonWithTitle:@"删除" nTitleColor:kMainBlueColor hTitleColor:kMainBlackColor nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
        _bottomDoubleLeftButton.titleLabel.font = SystemFont(18);
    }
    return _bottomDoubleLeftButton;
}

- (UIImageView *)noMessageView {
    if (!_noMessageView) {
        _noMessageView = [[UIImageView alloc] initWithImage:ImageName(@"global_noMessage")];
        _noMessageView.hidden = YES;
    }
    return _noMessageView;
}

- (MPMSideDrawerView *)siderDrawerView {
    if (!_siderDrawerView) {
        _siderDrawerView = [[MPMSideDrawerView alloc] init];
        _siderDrawerView.delegate = self;
    }
    return _siderDrawerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
