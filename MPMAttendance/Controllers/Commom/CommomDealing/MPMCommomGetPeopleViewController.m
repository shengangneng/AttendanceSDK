//
//  MPMCommomGetPeopleViewController.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCommomGetPeopleViewController.h"
#import "MPMButton.h"
#import "MPMGetPeopleTableViewCell.h"
#import "MPMTableHeaderView.h"
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "MPMGetPeopleModel.h"
#import "MPMHiddenTableViewDataSourceDelegate.h"

@interface MPMCommomGetPeopleViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MPMHiddenTabelViewDelegate>

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UISearchBar *headerSearchBar;

@property (nonatomic, strong) UITableView *middleTableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *bottomTotalSelectedLabel;
@property (nonatomic, strong) UIButton *bottomSureButton;
// 当点击底部的弹出按钮时，顶部也会弹下一个遮盖视图
@property (nonatomic, strong) UIView *headerHiddenMaskView;
@property (nonatomic, strong) UIButton *bottomUpButton;
@property (nonatomic, strong) UIView *bottomHiddenView;
@property (nonatomic, strong) UITableView *bottomHiddenTableView;
// data
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSArray *idsArray;
@property (nonatomic, copy) CompleteSelectBlock completeSelectedBlock;
@property (nonatomic, assign) BOOL searchMode;
@property (nonatomic, strong) MPMHiddenTableViewDataSourceDelegate *dataSourceDelegate;

@property (nonatomic, strong) NSMutableArray *selectedIndexPath;        /** 未筛选时候的选中项 */
@property (nonatomic, copy) NSArray *peoplesArray;                      /** 请求回来的所有人员列表 */
@property (nonatomic, strong) NSMutableArray *searchSelectedIndexPath;  /** 搜索之后的选中项 */
@property (nonatomic, strong) NSMutableArray *searchPeoplesArray;       /** 搜索之后的人员列表 */

@end

@implementation MPMCommomGetPeopleViewController

- (instancetype)initWithCode:(NSString *)code idString:(NSString *)idString sureSelect:(CompleteSelectBlock)block; {
    self = [super init];
    if (self) {
        self.code = code;
        if (!kIsNilString(idString)) {
            self.idsArray = [idString componentsSeparatedByString:@","];
        }
        self.completeSelectedBlock = block;
        if (code.integerValue == 0) {
            self.middleTableView.allowsMultipleSelection = YES;
        } else if (code.integerValue == 1) {
            self.middleTableView.allowsMultipleSelection = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
    [self getData];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.title = @"参与人员";
    self.searchMode = NO;
    self.selectedIndexPath = [NSMutableArray array];
    self.searchPeoplesArray = [NSMutableArray array];
    self.searchSelectedIndexPath = [NSMutableArray array];
    [self.headerHiddenMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)]];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(left:)];
    [self.bottomUpButton addTarget:self action:@selector(popUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomSureButton addTarget:self action:@selector(bottomSure:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerSearchBar];
    [self.view addSubview:self.middleTableView];
    
    [self.view addSubview:self.bottomHiddenView];
    [self.bottomHiddenView addSubview:self.bottomHiddenTableView];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.headerHiddenMaskView];
    [self.view addSubview:self.bottomUpButton];
    [self.bottomView addSubview:self.bottomSureButton];
    [self.bottomView addSubview:self.bottomTotalSelectedLabel];
    [self.bottomView addSubview:self.bottomLine];
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
        make.leading.equalTo(self.headerView.mpm_leading);
        make.trailing.equalTo(self.headerView.mpm_trailing);
        make.bottom.equalTo(self.headerView.mpm_bottom);
        make.top.equalTo(self.headerView.mpm_top);
    }];
    
    [self.middleTableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerView.mpm_bottom);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomUpButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mpm_top);
        make.centerX.equalTo(self.bottomView.mpm_centerX);
        make.height.equalTo(@(34));
        make.width.equalTo(@(86));
    }];
    [self.bottomTotalSelectedLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
        make.leading.equalTo(self.bottomView.mpm_leading).offset(12);
        make.width.equalTo(self.bottomView.mpm_width).multipliedBy(0.5);
    }];
    [self.bottomSureButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
        make.width.equalTo(@(88.5));
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
    }];
    
    [self.bottomHiddenView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.bottomUpButton.mpm_bottom);
        make.height.equalTo(@300);
    }];
    [self.headerHiddenMaskView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(kScreenHeight - 300));
        make.bottom.equalTo(self.view.mpm_top).offset(-kNavigationHeight);
    }];
    [self.bottomHiddenTableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.bottomHiddenView);
    }];
}

- (void)getData {
    NSString *url = [NSString stringWithFormat:@"%@getPeopleList?code=%@&token=%@",MPMHost,self.code,[MPMShareUser shareUser].token];
    [[MPMSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
        if ([response[@"dataObj"] isKindOfClass:[NSArray class]]) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMGetPeopleModel *model = [[MPMGetPeopleModel alloc] initWithDictionary:dic];
                for (NSString *str in self.idsArray) {
                    if ([model.mpm_id isEqualToString:str]) {
                        [self.selectedIndexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    }
                }
                [temp addObject:model];
            }
            self.peoplesArray = temp.copy;
        }
        [self.middleTableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - MPMHiddenTabelViewDelegate
- (void)hiddenTableView:(UITableView *)tableView deleteData:(MPMGetPeopleModel *)people {
    [self.dataSourceDelegate.peoplesArray removeObject:people];
    [self.bottomHiddenTableView reloadData];
    
    if (self.searchMode) {
        for (int i = 0; i < self.searchPeoplesArray.count; i++) {
            BOOL needDelete = NO;
            MPMGetPeopleModel *model = self.searchPeoplesArray[i];
            if ([model.mpm_id isEqualToString:people.mpm_id]) {
                needDelete = YES;
            }
            if (needDelete) {
                [self.searchSelectedIndexPath removeObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
    } else {
        for (int i = 0; i < self.peoplesArray.count; i++) {
            BOOL needDelete = NO;
            MPMGetPeopleModel *model = self.peoplesArray[i];
            if ([model.mpm_id isEqualToString:people.mpm_id]) {
                needDelete = YES;
            }
            if (needDelete) {
                [self.selectedIndexPath removeObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
    }
    [self.middleTableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchMode) {
        return self.searchPeoplesArray.count;
    } else {
        return self.peoplesArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    } else {
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MPMTableHeaderView *header = [[MPMTableHeaderView alloc] init];
    if (section == 0) {
        header.headerTextLabel.text = @"选择参与人";
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    MPMGetPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MPMGetPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.searchMode) {
        MPMGetPeopleModel *model = self.searchPeoplesArray[indexPath.row];
        cell.nameLabel.text = model.name;
    } else {
        MPMGetPeopleModel *model = self.peoplesArray[indexPath.row];
        cell.nameLabel.text = model.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchMode) {
        if ([self.searchSelectedIndexPath containsObject:indexPath]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
        }
        self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数:(%lu)",(unsigned long)self.searchSelectedIndexPath.count];
    } else {
        if ([self.selectedIndexPath containsObject:indexPath]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
        }
        self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数:(%lu)",(unsigned long)self.selectedIndexPath.count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchMode) {
        if ([self.searchSelectedIndexPath containsObject:indexPath]) {
            return;
        }
        [self.searchSelectedIndexPath addObject:indexPath];
        self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数:(%lu)",(unsigned long)self.searchSelectedIndexPath.count];
    } else {
        if ([self.selectedIndexPath containsObject:indexPath]) {
            return;
        }
        [self.selectedIndexPath addObject:indexPath];
        self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数:(%lu)",(unsigned long)self.selectedIndexPath.count];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchMode) {
        [self.searchSelectedIndexPath removeObject:indexPath];
        self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数:(%lu)",(unsigned long)self.searchSelectedIndexPath.count];
    } else {
        [self.selectedIndexPath removeObject:indexPath];
        self.bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数:(%lu)",(unsigned long)self.selectedIndexPath.count];
    }
}

#pragma mark - Target Action
- (void)left:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bottomSure:(UIButton *)sender {
    if ((self.searchMode && self.searchSelectedIndexPath == 0) || (!self.searchMode && self.selectedIndexPath.count == 0)) {
        [self showAlertControllerToLogoutWithMessage:@"请选择参与人员" sureAction:nil needCancleButton:NO];
        return;
    }
    NSArray *indexArr = self.searchMode ? self.searchSelectedIndexPath : self.selectedIndexPath;
    NSArray *peopleArr = self.searchMode ? self.searchPeoplesArray : self.peoplesArray;
    if (self.completeSelectedBlock) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:indexArr.count];
        for (int i = 0; i < indexArr.count; i++) {
            NSIndexPath *index = indexArr[i];
            MPMGetPeopleModel *model = peopleArr[index.row];
            [temp addObject:model];
        }
        self.completeSelectedBlock(temp.copy);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popUp:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSArray *indexPath;
    NSArray *arr;
    if (self.searchMode) {
        indexPath = self.searchSelectedIndexPath.copy;
        arr = self.searchPeoplesArray;
    } else {
        indexPath = self.selectedIndexPath.copy;
        arr = self.peoplesArray;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        BOOL needAdd = NO;
        for (int j = 0; j < indexPath.count; j++) {
            NSIndexPath *index = indexPath[j];
            if (index.row == i) {
                needAdd = YES;
            }
        }
        if (needAdd) [temp addObject:arr[i]];
    }
    self.dataSourceDelegate.peoplesArray = temp;
    [self.bottomHiddenTableView reloadData];
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomUpButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.bottom.equalTo(self.bottomView.mpm_top).offset(-300);
                make.centerX.equalTo(self.bottomView.mpm_centerX);
                make.height.equalTo(@(34));
                make.width.equalTo(@(86));
            }];
            [self.headerHiddenMaskView mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@(kScreenHeight - 300));
                make.bottom.equalTo(self.view.mpm_top).offset(kScreenHeight - 300 - kNavigationHeight - BottomViewHeight);
            }];
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomUpButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.bottom.equalTo(self.bottomView.mpm_top);
                make.centerX.equalTo(self.bottomView.mpm_centerX);
                make.height.equalTo(@(34));
                make.width.equalTo(@(86));
            }];
            [self.headerHiddenMaskView mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@(kScreenHeight - 300));
                make.bottom.equalTo(self.view.mpm_top).offset(-kNavigationHeight);
            }];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)hide:(UITapGestureRecognizer *)gesture {
    self.bottomUpButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomUpButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mpm_top);
            make.centerX.equalTo(self.bottomView.mpm_centerX);
            make.height.equalTo(@(34));
            make.width.equalTo(@(86));
        }];
        [self.headerHiddenMaskView mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@(kScreenHeight - 300));
            make.bottom.equalTo(self.view.mpm_top).offset(-kNavigationHeight);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UISearchBarDelegeat

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    DLog(@"%@", searchText);
    // 改变搜索框，筛选数据
    
    if (kIsNilString(searchText)) {
        self.searchMode = NO;
        // 筛选数据 -> 全数据
        for (int i = 0 ; i < self.searchSelectedIndexPath.count; i++) {
            NSIndexPath *indexPath = self.searchSelectedIndexPath[i];
            MPMGetPeopleModel *model = self.searchPeoplesArray[indexPath.row];
            for (int j = 0 ; j < self.peoplesArray.count; j++) {
                MPMGetPeopleModel *modelNew = self.peoplesArray[j];
                if ([modelNew.name isEqualToString:model.name]) {
                    [self.selectedIndexPath addObject:[NSIndexPath indexPathForRow:j inSection:0]];
                }
            }
        }
        [self.searchPeoplesArray removeAllObjects];
        [self.searchSelectedIndexPath removeAllObjects];
    } else {
        self.searchMode = YES;
        if (self.selectedIndexPath.count > 0) {
            // 全数据 -> 筛选数据
            for (int i = 0; i < self.peoplesArray.count; i++) {
                MPMGetPeopleModel *model = self.peoplesArray[i];
                if ([model.name containsString:searchText]) {
                    [self.searchPeoplesArray addObject:model];
                }
            }
            int index = 0;
            for (int i = 0; i < self.selectedIndexPath.count; i++) {
                NSIndexPath *indexPath = self.selectedIndexPath[i];
                MPMGetPeopleModel *model = self.peoplesArray[indexPath.row];
                for (int j = 0 ; j < self.searchPeoplesArray.count; j++) {
                    MPMGetPeopleModel *modelNew = self.searchPeoplesArray[j];
                    if ([modelNew.name isEqualToString:model.name]) {
                        [self.searchSelectedIndexPath addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                        index++;
                    }
                }
            }
        } else {
            // 筛选数据 -> 筛选数据
            NSMutableArray *temp = [NSMutableArray array];
            NSMutableArray *tempIndex = [NSMutableArray array];
            for (int i = 0; i < self.peoplesArray.count; i++) {
                MPMGetPeopleModel *model = self.peoplesArray[i];
                if ([model.name containsString:searchText]) {
                    [temp addObject:model];
                }
            }
            int index = 0;
            for (int i = 0 ; i < self.searchSelectedIndexPath.count; i++) {
                NSIndexPath *indexPath = self.searchSelectedIndexPath[i];
                MPMGetPeopleModel *model = self.searchPeoplesArray[indexPath.row];
                for (int j = 0 ; j < temp.count; j++) {
                    MPMGetPeopleModel *modelNew = temp[j];
                    if ([modelNew.name isEqualToString:model.name]) {
                        [tempIndex addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                        index++;
                    }
                }
            }
            self.searchPeoplesArray = temp;
            self.searchSelectedIndexPath = tempIndex;
        }
        [self.selectedIndexPath removeAllObjects];
    }
    
    [self.middleTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 点击搜索，收回键盘
    [self.headerSearchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.headerSearchBar resignFirstResponder];
}

#pragma mark - Lazy Init
// header
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
        _headerSearchBar.delegate = self;
        _headerSearchBar.barTintColor = kClearColor;
        _headerSearchBar.backgroundImage = [[UIImage alloc] init];
        _headerSearchBar.placeholder = @"搜索参与人员";
    }
    return _headerSearchBar;
}
// middle
- (UITableView *)middleTableView {
    if (!_middleTableView) {
        _middleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _middleTableView.delegate = self;
        _middleTableView.dataSource = self;
        _middleTableView.separatorColor = kSeperateColor;
        _middleTableView.backgroundColor = kTableViewBGColor;
        _middleTableView.tableFooterView = [[UIView alloc] init];
    }
    return _middleTableView;
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
- (UIButton *)bottomUpButton {
    if (!_bottomUpButton) {
        _bottomUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomUpButton setImage:ImageName(@"attendence_pullup") forState:UIControlStateNormal];
        [_bottomUpButton setImage:ImageName(@"attendence_pullup") forState:UIControlStateHighlighted];
        [_bottomUpButton setImage:ImageName(@"attendence_pulldown") forState:UIControlStateSelected];
    }
    return _bottomUpButton;
}
- (UILabel *)bottomTotalSelectedLabel {
    if (!_bottomTotalSelectedLabel) {
        _bottomTotalSelectedLabel = [[UILabel alloc] init];
        _bottomTotalSelectedLabel.text = [NSString stringWithFormat:@"选中人数(%lu)",(unsigned long)self.selectedIndexPath.count];
        _bottomTotalSelectedLabel.textColor = kBlackColor;
        _bottomTotalSelectedLabel.textAlignment= NSTextAlignmentLeft;
    }
    return _bottomTotalSelectedLabel;
}
- (UIButton *)bottomSureButton {
    if (!_bottomSureButton) {
        _bottomSureButton = [MPMButton titleButtonWithTitle:@"确定" nTitleColor:kWhiteColor hTitleColor:kLightGrayColor nBGImage:ImageName(@"approval_but_determine") hImage:ImageName(@"approval_but_determine")];
    }
    return _bottomSureButton;
}
- (UIView *)bottomHiddenView {
    if (!_bottomHiddenView) {
        _bottomHiddenView = [[UIView alloc] init];
        _bottomHiddenView.backgroundColor = kRedColor;
    }
    return _bottomHiddenView;
}
- (UITableView *)bottomHiddenTableView {
    if (!_bottomHiddenTableView) {
        _bottomHiddenTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bottomHiddenTableView.delegate = self.dataSourceDelegate;
        _bottomHiddenTableView.dataSource = self.dataSourceDelegate;
        _bottomHiddenTableView.separatorColor = kSeperateColor;
        _bottomHiddenTableView.backgroundColor = kWhiteColor;
        _bottomHiddenTableView.tableFooterView = [[UIView alloc] init];
    }
    return _bottomHiddenTableView;
}
- (MPMHiddenTableViewDataSourceDelegate *)dataSourceDelegate {
    if (!_dataSourceDelegate) {
        _dataSourceDelegate = [[MPMHiddenTableViewDataSourceDelegate alloc] init];
        _dataSourceDelegate.delegate = self;
    }
    return _dataSourceDelegate;
}
- (UIView *)headerHiddenMaskView {
    if (!_headerHiddenMaskView) {
        _headerHiddenMaskView = [[UIView alloc] init];
        _headerHiddenMaskView.backgroundColor = kBlackColor;
        _headerHiddenMaskView.alpha = 0.3;
    }
    return _headerHiddenMaskView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
