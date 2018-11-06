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
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "MPMApprovalFirstSectionModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMApprovalProcessHeaderSectionView.h"
#import "UILabel+MPMExtention.h"
#import "MPMOauthUser.h"
#import "MPMProcessMyMetterModel.h"
#import "MPMMainTabBarViewController.h"
#import "MPMNoMessageView.h"
#import "MPMRefreshFooter.h"

@interface MPMApprovalProcessViewController () <UITableViewDelegate, UITableViewDataSource, MPMSideDrawerViewDelegate, MPMRefreshFooterDelegate>
// Header
@property (nonatomic, strong) MPMApprovalProcessHeaderSectionView *headerSectionView;
// Bottom
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MPMNoMessageView *noMessageView;
@property (nonatomic, strong) MPMRefreshFooter *refreshFooter;
// Data
@property (nonatomic, copy) NSArray *firstSectionMessageArray;  /** 从接口获取到的一级导航列表 */
@property (nonatomic, copy) NSArray *fetchDetailDataArray;      /** 流程审批数据 */
@property (nonatomic, copy) NSArray *passToDetailTitles;        /** 传递到审批详情页面的 */
// 选中的cell
@property (nonatomic, strong) NSMutableArray *selectedCellArray;
// 记录选中的index
@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath;
@property (nonatomic, assign) ProgcessFirstSectionType firstSectionType;
// 高级筛选侧滑视图
@property (nonatomic, strong) MPMSideDrawerView *siderDrawerView;

@end

@implementation MPMApprovalProcessViewController

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self) weakself = self;
    self.goodNetworkToLoadBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        // 重新获取一下页面数据
        [strongself.headerSectionView setDefaultSelect];
    };
    // 重新获取一下页面数据
    [self.headerSectionView setDefaultSelect];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadCount:) name:kUnreadCountNotification object:nil];
}

#pragma mark - Notification

- (void)updateUnreadCount:(NSNotification *)notification {
    if (notification.object && [notification.object isKindOfClass:[NSNumber class]]) {
        if (0 == ((NSNumber *)notification.object).integerValue) {
            self.headerSectionView.myMatterHasUnreadCount = NO;
        } else {
            self.headerSectionView.myMatterHasUnreadCount = YES;
        }
    }
}

- (void)setupSubViews {
    [super setupSubViews];
    self.headerSectionView = [[MPMApprovalProcessHeaderSectionView alloc] init];
    [self.view addSubview:self.headerSectionView];
    [self.headerSectionView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@85);
        make.top.leading.trailing.equalTo(self.view);
    }];
    __weak typeof (self) weakself = self;
    self.headerSectionView.animateSecondSectionBlock = ^(BOOL needHideSecondSection) {
        __strong typeof(weakself) strongself = weakself;
        double height;
        if (needHideSecondSection) {
            height = 46;
        } else {
            height = 85;
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [strongself.headerSectionView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.height.equalTo(@(height));
                make.top.leading.trailing.equalTo(strongself.view);
            }];
            [strongself.view layoutIfNeeded];
        } completion:nil];
    };
    
    // 头部导航的点击
    self.headerSectionView.selectBlock = ^(NSIndexPath *indexPath) {
        __strong typeof(weakself) strongself = weakself;
        if (indexPath != strongself.lastSelectIndexPath) {
            // 如果切换成不同类型，则重置“高级筛选”中选中的数据
            [strongself.siderDrawerView reset:nil];
            strongself.headerSectionView.firstFillterButton.selected = NO;
        }
        strongself.lastSelectIndexPath = indexPath;
        strongself.firstSectionType = indexPath.section;
        switch (strongself.firstSectionType) {
            case kMyMatterType:{
                switch (indexPath.row) {
                    case 0:{
                        // 待办
                        strongself.passToDetailTitles = @[@"待办"];
                        [strongself setSelectIndexPath:indexPath forSectionType:kMyMatterType];
                    }break;
                    case 1:{
                        // 已审批
                        strongself.passToDetailTitles = @[@"已办"];
                        [strongself setSelectIndexPath:indexPath forSectionType:kMyMatterType];
                    }break;
                    default:
                        break;
                }
                
            }break;
            case kMyApplyType:{
                // 我的申请
                strongself.passToDetailTitles = @[@"我的申请"];
                [strongself setSelectIndexPath:indexPath forSectionType:kMyApplyType];
            }break;
            case kCCToMeType:{
                // 抄送给我
                strongself.passToDetailTitles = @[@"抄送给我"];
                [strongself setSelectIndexPath:indexPath forSectionType:kCCToMeType];
            }break;
            default:
                break;
        }
    };
    self.headerSectionView.fillterBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        NSArray *statusTitles = nil;
        switch (strongself.firstSectionType) {
            case kMyMatterType:{
                switch (strongself.lastSelectIndexPath.row) {
                    case 0:{
                        // 待办
                        statusTitles = @[@"全部",@"待处理",@"驳回的"];
                    }break;
                    case 1:{
                        // 已审批
                        statusTitles = @[@"全部",@"已通过",@"已驳回"];
                    }break;
                    default:
                        break;
                }
                
            }break;
            case kMyApplyType:{
                // 我的申请
                statusTitles = @[@"全部",@"进行中",@"已完成",@"已取消"];
            }break;
            case kCCToMeType:{
                // 抄送给我
                statusTitles = nil;
            }break;
            default:
                break;
        }
        // 高级筛选：使用代理方式返回筛选数据
        [strongself.siderDrawerView showInView:kAppDelegate.window maskViewFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) drawerViewFrame:CGRectMake(kScreenWidth, kNavigationHeight, 253, kScreenHeight - kNavigationHeight) statusTitles:statusTitles];
    };
    // Bottom
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noMessageView];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"流程审批";
    self.selectedCellArray = [NSMutableArray array];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    // Bottom
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.headerSectionView.mpm_bottom);
    }];
    [self.noMessageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.width.equalTo(@(kPreferNoMessaegViewWidthHeight));
        make.centerY.equalTo(self.view.mpm_centerY).offset(-10);
        make.centerX.equalTo(self.view.mpm_centerX);
    }];
}

#pragma mark - Private Method

- (void)getData:(ProgcessFirstSectionType)SectionType indexPath:(NSIndexPath *)indexPath {
    NSString *pagesize = [NSString stringWithFormat:@"%ld",self.siderDrawerView.pagesize];
    NSString *page = @"0";
    NSString *url;
    
    NSString *processDefCode = @"";
    if (!kIsNilString(self.siderDrawerView.type)) {
        processDefCode = [NSString stringWithFormat:@"&processDefCode=%@",self.siderDrawerView.type];
    }
    NSString *fromdate = @"";
    if (self.siderDrawerView.startDate) {
        fromdate = [NSString stringWithFormat:@"&fromdate=%@",[NSDateFormatter formatterDate:self.siderDrawerView.startDate withDefineFormatterType:forDateFormatTypeYearMonthDaySlash]];
    }
    NSString *todate = @"";
    if (self.siderDrawerView.endDate) {
        todate = [NSString stringWithFormat:@"&todate=%@",[NSDateFormatter formatterDate:self.siderDrawerView.endDate withDefineFormatterType:forDateFormatTypeYearMonthDaySlash]];
    }
    
    switch (SectionType) {
        case kMyMatterType:{
            // 我的事项:
            switch (indexPath.row) {
                case 0:{
                    NSString *prevActionState = @"";
                    if (!kIsNilString(self.siderDrawerView.state)) {
                        prevActionState = [NSString stringWithFormat:@"&prevActionState=%@",self.siderDrawerView.state];
                    }
                    url = [NSString stringWithFormat:@"%@%@?pagesize=%@&page=%@%@%@%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_MYPENDING,pagesize,page,prevActionState,processDefCode,fromdate,todate];
                    [((MPMMainTabBarViewController *)self.tabBarController) updateApprovalUnreadCount];
                }break;
                case 1:{
                    NSString *route = @"";
                    if (!kIsNilString(self.siderDrawerView.state)) {
                        route = [NSString stringWithFormat:@"&route=%@",self.siderDrawerView.state];
                    }
                    url = [NSString stringWithFormat:@"%@%@?pagesize=%@&page=%@%@%@%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_MYDONE,pagesize,page,route,processDefCode,fromdate,todate];
                }break;
                default:{}break;
            }
        }
            break;
        case kMyApplyType:{
            // 我的申请
            NSString *sta = @"";
            if (!kIsNilString(self.siderDrawerView.state)) {
                sta = [NSString stringWithFormat:@"&state=%@",self.siderDrawerView.state];
            }
            url = [NSString stringWithFormat:@"%@%@?pagesize=%@&page=%@%@%@%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_MYAPPLY,pagesize,page,sta,processDefCode,fromdate,todate];
        }break;
        case kCCToMeType:{
            // 抄送给我
            url = [NSString stringWithFormat:@"%@%@?pagesize=%@&page=%@%@%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_MYDELIVER,pagesize,page,processDefCode,fromdate,todate];
        }break;
        default:
            break;
    }
    DLog(@"%@",url);
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在加载" success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] &&
            [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]] &&
            [response[kResponseObjectKey][@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *list = response[kResponseObjectKey][@"list"];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:list.count];
            for (int i = 0; i < list.count; i++) {
                NSDictionary *dic = list[i];
                MPMProcessMyMetterModel *model = [[MPMProcessMyMetterModel alloc] initWithDictionary:dic];
                [temp addObject:model];
            }
            self.fetchDetailDataArray = temp.copy;
            [self.tableView reloadData];
            dispatch_async(kMainQueue, ^{
                if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
                    self.refreshFooter.hidden = YES;
                } else {
                    self.refreshFooter.hidden = NO;
                }
            });
        }
        [self.refreshFooter endRefreshFooter];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
        [self.refreshFooter endRefreshFooter];
    }];
}

- (void)setSelectIndexPath:(NSIndexPath *)indexPath forSectionType:(ProgcessFirstSectionType)type {
    // 每次选中之后，调用接口获取数据
    [self getData:type indexPath:indexPath];
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

#pragma mark - MPMSiderDrawerViewDelegate

- (void)siderDrawerViewDidDismiss {
    
}

/** 高级筛选返回筛选数据 */
- (void)siderDrawerViewDidCompleteSelected {
    if (self.siderDrawerView.state || self.siderDrawerView.type || self.siderDrawerView.startDate || self.siderDrawerView.endDate) {
        self.headerSectionView.firstFillterButton.selected = YES;
    } else {
        self.headerSectionView.firstFillterButton.selected = NO;
    }
    [self getData:self.firstSectionType indexPath:self.lastSelectIndexPath];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.fetchDetailDataArray.count > 0) {
        self.noMessageView.hidden = YES;
    } else {
        self.noMessageView.hidden = NO;
    }
    return self.fetchDetailDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellIdentifier";
    MPMApprovalProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMApprovalProcessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MPMProcessMyMetterModel *model = self.fetchDetailDataArray[indexPath.row];
    NSString *imageName;
    NSString *text;
    
    switch (self.firstSectionType) {
        case kMyMatterType:{
            // 我的事项:
            switch (self.lastSelectIndexPath.row) {
                case 0:{
                    // 我的待办：1提交到我 2驳回到我
                    if (model.prevActionState.integerValue == 1) {
                        text = @"待处理";
                        imageName = @"approval_blueFlag";
                    } else {
                        text = @"已驳的";
                        imageName = @"approval_orangeFlag";
                    }
                }break;
                case 1:{
                    // 我的已办：1待办 2跟随处理 3转交 6已处理
                    if (model.state.integerValue == 6 && model.route.integerValue == 1) {
                        text = @"已通过";
                        imageName = @"approval_greenFlag";
                    } else {
                        text = @"已驳回";
                        imageName = @"approval_orangeFlag";
                    }
                }break;
                default:{}break;
            }
        }
            break;
        case kMyApplyType:{
            // 我的申请：1运行中2结束3撤销
            switch (model.state.integerValue) {
                case 1:{
                    text = @"进行中";
                    imageName = @"approval_blueFlag";
                }break;
                case 2:{
                    text = @"已完成";
                    imageName = @"approval_greenFlag";
                }break;
                case 3:{
                    text = @"已取消";
                    imageName = @"approval_orangeFlag";
                }break;
                default:{
                    text = @"进行中";
                    imageName = @"approval_blueFlag";
                }break;
            }
        }break;
        case kCCToMeType:{
            // 抄送给我
            text = @"抄送给我";
            imageName = @"approval_blueFlag";
        }break;
        default:
            break;
    }
    cell.flagImageView.image = ImageName(imageName);
    cell.flagLabel.text = text;
    if ([self.selectedCellArray containsObject:indexPath]) {
        cell.selectImageView.image = ImageName(@"setting_all_mid");
    } else {
        cell.selectImageView.image = ImageName(@"setting_none_mid");
    }
    cell.applyPersonMessageLabel.text = (kMyMatterType == self.firstSectionType) ? model.applyUserName : model.username;
    cell.extraApplyMessageLabel.text = model.name;
    // 设置AttributeString
    NSString *reason;
    if (kIsNilString(model.processRemark)) {
        reason = @"去参加阿里巴巴管理会议，了解中国积分制管理";
    } else {
        reason = model.processRemark;
    }
    [cell.applyDetailMessageLabel setAttributedString:reason font:SystemFont(14) lineSpace:2.5];
    if (model.createTime && model.createTime.length > 10) {
        NSString *te = model.createTime;
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
    MPMProcessMyMetterModel *model = self.fetchDetailDataArray[indexPath.row];
    MPMApprovalProcessDetailViewController *detail = [[MPMApprovalProcessDetailViewController alloc] initWithModel:model selectedIndexPath:self.lastSelectIndexPath];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - RefreshFooterDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.refreshFooter.hidden = YES;
        return;
    } else {
        self.refreshFooter.hidden = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat distance = scrollView.contentSize.height - offsetY;
    CGFloat height = distance + kRefreshFooterHeight + self.refreshFooter.superContentInsets.top + self.refreshFooter.superContentInsets.bottom;
    if (scrollView.contentSize.height > 0 && height < scrollView.bounds.size.height) {
        [self.refreshFooter beginRefreshFooter];
    }
}

- (void)refreshFooterDidBeginRefresh {
    self.siderDrawerView.pagesize+=10;
    [self getData:self.firstSectionType indexPath:self.lastSelectIndexPath];
}

- (void)refreshFooterDidEndRefresh {
    [UIView animateWithDuration:1.0 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 6, 0);
    }];
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

- (MPMNoMessageView *)noMessageView {
    if (!_noMessageView) {
        _noMessageView = [[MPMNoMessageView alloc] initWithNoMessageViewImage:@"global_noMessage" noMessageLabelText:@"暂无数据"];
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

- (MPMRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [[MPMRefreshFooter alloc] initWithsuperScrollView:self.tableView];
        _refreshFooter.delegate = self;
    }
    _refreshFooter.frame = CGRectMake(10, self.tableView.contentSize.height + _refreshFooter.superContentInsets.bottom, kScreenWidth-20, kRefreshFooterHeight);
    return _refreshFooter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
