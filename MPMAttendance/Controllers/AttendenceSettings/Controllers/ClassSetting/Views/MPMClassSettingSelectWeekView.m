//
//  MPMClassSettingSelectWeekView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMClassSettingSelectWeekView.h"
#import "MPMButton.h"
#import "MPMClassSettingSelectWeekTableViewCell.h"

typedef void(^CompleteBlock)(NSString *cycle);

#define kClassSettingTableViewHeight 45

@interface MPMClassSettingSelectWeekView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backMaskView;
@property (nonatomic, strong) UIView *mainContentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *sureButton;
// data
@property (nonatomic, copy) NSArray *weekTitleArray;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, strong) NSMutableArray *cycleArray;

@end

@implementation MPMClassSettingSelectWeekView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstaints];
    }
    return self;
}

- (void)setupAttributes {
    self.cycleArray = [NSMutableArray array];
    self.weekTitleArray = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    [self.backMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.backMaskView];
    [self addSubview:self.mainContentView];
    [self.mainContentView addSubview:self.tableView];
    [self.mainContentView addSubview:self.backButton];
    [self.mainContentView addSubview:self.sureButton];
}

- (void)setupConstaints {
    [self.backMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.mainContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(45);
        make.trailing.equalTo(self.mas_trailing).offset(-45);
        make.height.equalTo(@(kClassSettingTableViewHeight*7+61));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kClassSettingTableViewHeight*7));
        make.leading.trailing.top.equalTo(self.mainContentView);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mainContentView.mas_leading).offset(12);
        make.top.equalTo(self.tableView.mas_bottom).offset(12);
        make.bottom.equalTo(self.mainContentView.mas_bottom).offset(-12);
        make.width.equalTo(self.sureButton.mas_width);
        make.trailing.equalTo(self.sureButton.mas_leading).offset(-12);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(12);
        make.bottom.equalTo(self.mainContentView.mas_bottom).offset(-12);
        make.trailing.equalTo(self.mainContentView.mas_trailing).offset(-12);
    }];
}

#pragma mark - Public Method

- (void)showInViewWithCycle:(NSString *)cycle completeBlock:(void (^)(NSString *))completeBlock {
    self.completeBlock = completeBlock;
    [self translateCycle:cycle];
    [kAppDelegate.window addSubview:self];
    [UIView animateWithDuration:0.6 animations:^{
        self.backMaskView.alpha = 0.5;
        self.mainContentView.alpha = 1.0;
    }];
}

- (void)dismiss {
    // animate dismiss
    [UIView animateWithDuration:0.6 animations:^{
        self.backMaskView.alpha = 0;
        self.mainContentView.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Target Action
- (void)tapBack:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

- (void)back:(UIButton *)sender {
    [self dismiss];
}

- (void)sure:(UIButton *)sender {
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择日期"];
        return;
    }
    NSString *cycle = [self translateDayToString:self.tableView.indexPathsForSelectedRows];
    if (self.completeBlock) {
        self.completeBlock(cycle);
    }
    [self dismiss];
}

#pragma mark - Private Method
- (void)translateCycle:(NSString *)cycle {
    if (kIsNilString(cycle)) {
        return;
    }
    NSArray *arr = [cycle componentsSeparatedByString:@","];
    for (int i = 0; i < arr.count; i++) {
        NSString *str = arr[i];
        switch (str.integerValue) {
            case 1:{
                // 周日
                [self.cycleArray addObject:[NSIndexPath indexPathForRow:6 inSection:0]];
            }break;
            case 2:{
                [self.cycleArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
            }break;
            case 3:{
                [self.cycleArray addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
            }break;
            case 4:{
                [self.cycleArray addObject:[NSIndexPath indexPathForRow:2 inSection:0]];
            }break;
            case 5:{
                [self.cycleArray addObject:[NSIndexPath indexPathForRow:3 inSection:0]];
            }break;
            case 6:{
                [self.cycleArray addObject:[NSIndexPath indexPathForRow:4 inSection:0]];
            }break;
            case 7:{
                [self.cycleArray addObject:[NSIndexPath indexPathForRow:5 inSection:0]];
            }break;
            default:
                break;
        }
    }
}

- (NSString *)translateDayToString:(NSArray<NSIndexPath *> *)arr {
    NSString *cycle = @"";
    // 对tableview的选中数组进行排序
    NSArray *tempArr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *_Nonnull obj1, NSIndexPath *_Nonnull obj2) {
        if (obj1.row > obj2.row) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    for (int i = 0; i < tempArr.count; i++) {
        NSIndexPath *index = tempArr[i];
        switch (index.row) {
            case 0:{
                cycle = [cycle stringByAppendingString:@"2,"];
            }break;
            case 1:{
                cycle = [cycle stringByAppendingString:@"3,"];
            }break;
            case 2:{
                cycle = [cycle stringByAppendingString:@"4,"];
            }break;
            case 3:{
                cycle = [cycle stringByAppendingString:@"5,"];
            }break;
            case 4:{
                cycle = [cycle stringByAppendingString:@"6,"];
            }break;
            case 5:{
                cycle = [cycle stringByAppendingString:@"7,"];
            }break;
            case 6:{
                cycle = [cycle stringByAppendingString:@"1,"];
            }break;
            default:
                break;
        }
    }
    if ([cycle hasSuffix:@","]) {
        cycle = [cycle substringWithRange:NSMakeRange(0, cycle.length - 1)];
    }
    return cycle;
}

#pragma mark - UITabelViewDelegate && UITabelViewDataSourc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kClassSettingTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"weekCell";
    MPMClassSettingSelectWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMClassSettingSelectWeekTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.weekTitleArray[indexPath.row];
    if ([self.cycleArray containsObject:indexPath]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.cycleArray containsObject:indexPath]) {
        [self.cycleArray addObject:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.cycleArray containsObject:indexPath]) {
        [self.cycleArray removeObject:indexPath];
    }
}

#pragma mark - Lazy Init
- (UIView *)backMaskView {
    if (!_backMaskView) {
        _backMaskView = [[UIView alloc] init];
        _backMaskView.backgroundColor = kBlackColor;
        _backMaskView.alpha = 0;
    }
    return _backMaskView;
}
- (UIView *)mainContentView {
    if (!_mainContentView) {
        _mainContentView = [[UIView alloc] init];
        _mainContentView.layer.cornerRadius = 5;
        _mainContentView.layer.masksToBounds = YES;
        _mainContentView.backgroundColor = kWhiteColor;
        _mainContentView.alpha = 0;
    }
    return _mainContentView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.allowsMultipleSelection = YES;
    }
    return _tableView;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [MPMButton titleButtonWithTitle:@"返回" nTitleColor:kMainBlueColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
    }
    return _backButton;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [MPMButton titleButtonWithTitle:@"确定" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _sureButton;
}

@end
