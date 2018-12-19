//
//  MPMSettingSearchTimeViewController.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingSearchTimeViewController.h"
#import "MPMButton.h"
#import "MPMSettingClassListTableViewCell.h"
#import "MPMSettingClassListModel.h"
#import "MPMSessionManager.h"
#import "MPMNoMessageView.h"

@interface MPMSettingSearchTimeViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *headerSearchBar;
@property (nonatomic, strong) UIImageView *headerView;

// tableview
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MPMNoMessageView *noMessageView;

// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSaveButton;

// data
@property (nonatomic, copy) NSArray *searchArray;
@property (nonatomic, copy) NSString *selectId;     /** 记录当前选中的班次id */
@property (nonatomic, weak) id delegate;

@end

@implementation MPMSettingSearchTimeViewController

- (instancetype)initWithSaveDelegate:(id<MPMSettingClassTimeDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.view.backgroundColor = kTableViewBGColor;
    self.navigationItem.title = @"搜索考勤班次";
    [self.headerSearchBar becomeFirstResponder];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.bottomSaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerSearchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noMessageView];
    // bottom
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomSaveButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.headerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.view.mpm_leading);
        make.top.equalTo(self.view.mpm_top);
        make.trailing.equalTo(self.view.mpm_trailing);
        make.height.equalTo(@(52));
    }];
    [self.headerSearchBar mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.headerView);
    }];
    
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerView.mpm_bottom);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    [self.noMessageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.width.equalTo(@(kPreferNoMessaegViewWidthHeight));
        make.centerY.equalTo(self.view.mpm_centerY).offset(-10);
        make.centerX.equalTo(self.view.mpm_centerX);
    }];
    // bottom
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@1);
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
    if (kIsNilString(self.selectId) || 0 == self.searchArray.count) {
        [self showAlertControllerToLogoutWithMessage:@"请选择班次再保存" sureAction:nil needCancleButton:NO];return;
    }
    BOOL hasSelected = NO;
    MPMSettingClassListModel *saveModel;
    for (int i = 0; i < self.searchArray.count; i++) {
        MPMSettingClassListModel *model = self.searchArray[i];
        if ([model.mpm_id isEqualToString:self.selectId]) {
            hasSelected = YES;
            saveModel = model;
            break;
        }
    }
    if (!hasSelected) {
        [self showAlertControllerToLogoutWithMessage:@"请选择班次再保存" sureAction:nil needCancleButton:NO];return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingClassTimeDidCompleteWithTimeModel:)] && saveModel) {
        __weak typeof(self) weakself = self;
        [self showAlertControllerToLogoutWithMessage:@"保存成功" sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakself) strongself = weakself;
            [strongself.delegate settingClassTimeDidCompleteWithTimeModel:saveModel];
            UIViewController *vc = strongself.navigationController.viewControllers[strongself.navigationController.viewControllers.count - 3];
            [strongself.navigationController popToViewController:vc animated:YES];
        } needCancleButton:NO];
    }
    
}

#pragma mark - GetData
- (void)getDataOfText:(NSString *)text {
    if (kIsNilString(text)) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@?keyword=%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_TIME_SEARCH,text];
    NSString *encodingUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [[MPMSessionManager shareManager] getRequestWithURL:encodingUrl setAuth:YES params:nil loadingMessage:@"正在搜索" success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:object.count];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                NSDictionary *scheduleDic = dic[@"schedule"];
                MPMSettingClassListModel *model = [[MPMSettingClassListModel alloc] initWithDictionary:dic];
                MPMSettingClassScheduleModel *schedule = [[MPMSettingClassScheduleModel alloc] initWithDictionary:scheduleDic];
                model.schedule = schedule;
                [temp addObject:model];
            }
            self.searchArray = temp.copy;
        } else {
            self.searchArray = nil;
        }
        if (self.searchArray.count == 0) {
            [MPMProgressHUD showErrorWithStatus:@"未搜到相关班次！"];
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
    
}
#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchArray.count == 0) {
        self.noMessageView.hidden = NO;
    } else {
        self.noMessageView.hidden = YES;
    }
    return self.searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SearchCell";
    MPMSettingClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMSettingClassListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    MPMSettingClassListModel *model = self.searchArray[indexPath.row];
    cell.txLable.text = model.schedule.name;
    cell.detailTxLable.text = [MPMSettingClassListViewController getTimeStringWithModel:model];
    // 根据之前记录的排班id确定是否选中
    cell.isInUsing = [model.mpm_id isEqualToString:self.selectId];
    __weak typeof(self) weakself = self;
    cell.checkImageBlock = ^{
        // 选中某个排班
        __strong typeof(weakself) strongself = weakself;
        strongself.selectId = model.mpm_id;
        [tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self resignHeaderSearchBar];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MPMSettingClassListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checkImageBlock();
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    DLog(@"%@", searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self resignHeaderSearchBar];
    [self getDataOfText:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self resignHeaderSearchBar];
}

- (void)resignHeaderSearchBar {
    [self.headerSearchBar resignFirstResponder];
    UIButton *cancelButton = [self.headerSearchBar valueForKey:@"cancelButton"];
    cancelButton.enabled = YES;
}

#pragma mark - Lazy Init

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.userInteractionEnabled = YES;
        _headerView.image = ImageName(@"statistics_nav");
    }
    return _headerView;
}

- (UISearchBar *)headerSearchBar {
    if (!_headerSearchBar) {
        _headerSearchBar = [[UISearchBar alloc] init];
        UIButton *cancelButton = [_headerSearchBar valueForKey:@"cancelButton"];
        cancelButton.enabled = YES;
        [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
        [cancelButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [cancelButton setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        _headerSearchBar.delegate = self;
        _headerSearchBar.barTintColor = kClearColor;
        _headerSearchBar.backgroundImage = [[UIImage alloc] init];
        _headerSearchBar.placeholder = @"请输入班次名称";
    }
    return _headerSearchBar;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kTableViewBGColor;
        _tableView.allowsMultipleSelection = YES;
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
// bottom
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

- (MPMNoMessageView *)noMessageView {
    if (!_noMessageView) {
        _noMessageView = [[MPMNoMessageView alloc] initWithNoMessageViewImage:@"global_noMessage" noMessageLabelText:@"没有找到相关结果"];
        _noMessageView.hidden = YES;
    }
    return _noMessageView;
}

@end
