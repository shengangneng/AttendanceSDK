//
//  MPMAttendenceStatisticViewController.m
//  MPMAtendence
//  考勤统计
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceStatisticViewController.h"
#import "MPMButton.h"
#import "MPMCustomDatePickerView.h"
#import "UIImage+MPMExtention.h"
#import "MPMStatisticTableViewCell.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMStatisticModel.h"
#import "MPMLoginViewController.h"
#import "MPMOauthUser.h"

#define kKeyPath1 @"currentDateType1"
#define kKeyPath2 @"currentDateType2"

typedef NS_ENUM(NSInteger, forGetDataType) {
    forDataTypePerson,
    forDataTypeTeam
};

@interface MPMAttendenceStatisticViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MPMCustomDatePickerViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *personImageView;
@property (nonatomic, strong) UIButton *selectDateButton;
@property (nonatomic, strong) UITextField *titleTextField;
// 中间的总信息
@property (nonatomic, strong) UIImageView *totalMessageView;
@property (nonatomic, strong) UILabel *totalDate;
@property (nonatomic, strong) UILabel *totalDateTitle;
@property (nonatomic, strong) UILabel *totalScore;
@property (nonatomic, strong) UILabel *totalScroeTitle;
@property (nonatomic, strong) UILabel *totalDeScore;
@property (nonatomic, strong) UILabel *totalDeScoreTitle;
@property (nonatomic, strong) UIImageView *totalLine1;
@property (nonatomic, strong) UIImageView *totalLine2;
@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
// 选择器
@property (nonatomic, strong) MPMCustomDatePickerView *customDatePickerView;
// 用于区分个人和团队
@property (nonatomic, assign) forGetDataType currentType;
// 请求回来的数据
@property (nonatomic, copy)  NSArray<MPMStatisticCountList *> *personDetaiArray;
@property (nonatomic, strong) MPMStatisticModel *model;

@property (nonatomic, strong) NSDate *currentDate;     /** 记录选中的时间，默认为当前时间 */
@property (nonatomic, copy) NSString *currentDateType1;/** 2018/04/20 */
@property (nonatomic, copy) NSString *currentDateType2;/** 2018-4 */

@end

@implementation MPMAttendenceStatisticViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver];
        [self formatDate];
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
        [strongself getData:forDataTypePerson];
    };
    [self getData:forDataTypePerson];
}

- (void)logout:(UIButton *)sender {
    kAppDelegate.window.rootViewController = [[MPMLoginViewController alloc] init];
    [[MPMOauthUser shareOauthUser] clearData];
}

- (void)formatDate {
    NSDate *currentDate = self.currentDate = [NSDate date];
    self.currentDateType1 = [NSDateFormatter formatterDate:currentDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    self.currentDateType2 = [NSDateFormatter formatterDate:currentDate withDefineFormatterType:forDateFormatTypeYearMonthBar];
}

- (void)addObserver {
    [self addObserver:self forKeyPath:kKeyPath1 options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kKeyPath2 options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kKeyPath1]) {
        
    } else if ([keyPath isEqualToString:kKeyPath2]) {
        [self.selectDateButton setTitle:self.currentDateType2 forState:UIControlStateNormal];
        [self.selectDateButton setTitle:self.currentDateType2 forState:UIControlStateHighlighted];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kKeyPath1];
    [self removeObserver:self forKeyPath:kKeyPath2];
}

- (void)getData:(forGetDataType)type {
    NSString *url = [NSString stringWithFormat:@"%@%@?month=%@",MPMINTERFACE_HOST,MPMINTERFACE_STATISTIC_COUNT,self.currentDateType1];
    NSString *encodingUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self.indicatorView startAnimating];
    [[MPMSessionManager shareManager] getRequestWithURL:encodingUrl setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        [self.indicatorView stopAnimating];
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = response[kResponseObjectKey];
            self.model = [[MPMStatisticModel alloc] initWithDictionary:object];
            NSMutableArray *temp = @[].mutableCopy;
            for (int i = 0; i < self.model.countList.count; i++) {
                NSDictionary *dic = self.model.countList[i];
                MPMStatisticCountList *list = [[MPMStatisticCountList alloc] initWithDictionary:dic];
                [temp addObject:list];
            }
            self.personDetaiArray = temp.copy;
        }
        [self updateTotalMessage];
        [self.bottomTableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
        [self.indicatorView stopAnimating];
    }];
}

- (void)updateTotalMessage {
    self.totalDate.text = [NSString stringWithFormat:@"%d / %d",self.model.actualAttendance.intValue,self.model.shouldAttendance.intValue];
    self.totalScore.text = self.model.awardCount;
    self.totalDeScore.text = self.model.buckleCount;
}

- (void)updateTableMessage {
    [self.bottomTableView reloadData];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.backImageView];
    [self.containerView addSubview:self.selectDateButton];
    [self.containerView addSubview:self.titleTextField];
    [self.containerView addSubview:self.bottomTableView];
    [self.containerView addSubview:self.indicatorView];
    [self.containerView addSubview:self.totalMessageView];
    // 个人总视图
    [self.totalMessageView addSubview:self.totalDate];
    [self.totalMessageView addSubview:self.totalDateTitle];
    [self.totalMessageView addSubview:self.totalScore];
    [self.totalMessageView addSubview:self.totalScroeTitle];
    [self.totalMessageView addSubview:self.totalDeScore];
    [self.totalMessageView addSubview:self.totalDeScoreTitle];
    [self.totalMessageView addSubview:self.totalLine1];
    [self.totalMessageView addSubview:self.totalLine2];
    [self.view addSubview:self.personImageView];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"考勤统计";
    self.titleTextField.text = [NSString stringWithFormat:@"%@  %@",kSafeString([MPMOauthUser shareOauthUser].name_cn),kSafeString([MPMOauthUser shareOauthUser].department_name)];
    self.currentType = forDataTypePerson;
    [self.selectDateButton addTarget:self action:@selector(selectData:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.scrollView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.containerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(kScreenHeight - kNavigationHeight - kTabTotalHeight - 0.5));
    }];
    [self.backImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth));
        make.centerX.equalTo(self.view.mpm_centerX);
        make.top.equalTo(self.containerView.mpm_top);
        make.height.equalTo(@(167.5));
    }];
    [self.personImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mpm_centerX);
        make.top.equalTo(self.view.mpm_top).offset(14);
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
    }];
    [self.selectDateButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.personImageView.mpm_top);
        make.leading.equalTo(self.view.mpm_leading).offset(13);
        make.width.equalTo(@(80));
        make.height.equalTo(@(25));
    }];
    
    [self.titleTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView.mpm_centerX);
        make.top.equalTo(self.personImageView.mpm_bottom).offset(10);
        make.height.equalTo(@(25));
    }];
    ////////////////////////////////////////////////////////////////////////
    [self.totalMessageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.backImageView.mpm_bottom);
        make.centerX.equalTo(self.view.mpm_centerX);
        make.width.equalTo(self.view.mpm_width).offset(-18);
        make.height.equalTo(@69);
    }];
    // 实际出勤天数
    [self.totalDate mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.totalMessageView.mpm_centerY).offset(1);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX).offset(-(kScreenWidth - 24)/3);
    }];
    [self.totalDateTitle mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.totalMessageView.mpm_centerY).offset(-1);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX).offset(-(kScreenWidth - 24)/3);
    }];
    // 奖分
    [self.totalScore mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.totalMessageView.mpm_centerY).offset(1);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX);
    }];
    [self.totalScroeTitle mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.totalMessageView.mpm_centerY).offset(-1);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX);
    }];
    // 扣分
    [self.totalDeScore mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.totalMessageView.mpm_centerY).offset(1);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX).offset((kScreenWidth - 24)/3);
    }];
    [self.totalDeScoreTitle mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.totalMessageView.mpm_centerY).offset(-1);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX).offset((kScreenWidth - 24)/3);
    }];
    [self.totalLine1 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(self.totalMessageView.mpm_height).offset(-40);
        make.width.equalTo(@1);
        make.centerY.equalTo(self.totalMessageView.mpm_centerY);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX).offset(-(kScreenWidth - 24)/6);
    }];
    [self.totalLine2 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(self.totalMessageView.mpm_height).offset(-40);
        make.width.equalTo(@1);
        make.centerY.equalTo(self.totalMessageView.mpm_centerY);
        make.centerX.equalTo(self.totalMessageView.mpm_centerX).offset((kScreenWidth - 24)/6);
    }];
    
    ////////////////////////////////////////////////////////////////////////
    [self.bottomTableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView.mpm_bottom);
        make.top.equalTo(self.backImageView.mpm_bottom);
    }];
    [self.indicatorView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerX.equalTo(self.bottomTableView.mpm_centerX);
        make.centerY.equalTo(self.bottomTableView.mpm_centerY);
    }];
    
}

#pragma mark - Target Action
// 个人页面选择日期
- (void)selectData:(UIButton *)sender {
    [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeYearMonth defaultDate:self.currentDate];
}
- (void)selectTextField:(UIButton *)sender {
    if (self.titleTextField.isFirstResponder) {
        [self.titleTextField resignFirstResponder];
    } else {
        [self.titleTextField becomeFirstResponder];
    }
}

#pragma mark - MPMCustomDatePickerViewDelegate

- (void)customDatePickerViewDidCompleteSelectDate:(NSDate *)date {
    self.currentDate = date;
    self.currentDateType1 = [NSDateFormatter formatterDate:self.currentDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    self.currentDateType2 = [NSDateFormatter formatterDate:self.currentDate withDefineFormatterType:forDateFormatTypeYearMonthBar];
    [self getData:self.currentType];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personDetaiArray?self.personDetaiArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    MPMStatisticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMStatisticTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    MPMStatisticCountList *detailModel = self.personDetaiArray[indexPath.row];
    cell.image.image = ImageName(kStatisticCellImage[detailModel.name]);
    cell.titleLabel.text = detailModel.name;
    cell.countLabel.text = [NSString stringWithFormat:@"%d次",detailModel.count.intValue];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%d分",detailModel.sumScore.intValue];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Lazy Init
- (MPMCustomDatePickerView *)customDatePickerView {
    if (!_customDatePickerView) {
        _customDatePickerView = [[MPMCustomDatePickerView alloc] init];
        _customDatePickerView.delegate = self;
    }
    return _customDatePickerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = ImageName(@"statistics_background");
    }
    return _backImageView;
}

- (UIImageView *)personImageView {
    if (!_personImageView) {
        _personImageView = [[UIImageView alloc] init];
        _personImageView.image = ImageName(@"statistics_icon");
    }
    return _personImageView;
}

- (UIButton *)selectDateButton {
    if (!_selectDateButton) {
        _selectDateButton = [MPMButton rightImageButtonWithTitle:self.currentDateType2 nTitleColor:kWhiteColor hTitleColor:kLightGrayColor nImage:ImageName(@"statistics_pulldown") hImage:ImageName(@"statistics_pulldown") titleEdgeInset:UIEdgeInsetsMake(0, -19, 0, 0) imageEdgeInset:UIEdgeInsetsMake(0, 65, 0, 0)];
        _selectDateButton.layer.cornerRadius = 5;
        _selectDateButton.layer.borderColor = kWhiteColor.CGColor;
        _selectDateButton.layer.borderWidth = 1;
        _selectDateButton.layer.masksToBounds = YES;
        _selectDateButton.titleLabel.font = SystemFont(14);
    }
    return _selectDateButton;
}

- (UITextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.delegate = self;
        _titleTextField.userInteractionEnabled = NO;
        [_titleTextField sizeToFit];
        _titleTextField.returnKeyType = UIReturnKeyDone;
        _titleTextField.textColor = kWhiteColor;
        _titleTextField.textAlignment = NSTextAlignmentCenter;
        _titleTextField.text = @"欧阳锋  研发部 Java";
        _titleTextField.font = SystemFont(15);
    }
    return _titleTextField;
}

////////////////////////////////////////////////////
- (UIImageView *)totalMessageView {
    if (!_totalMessageView) {
        _totalMessageView = [[UIImageView alloc] initWithImage:ImageName(@"statistics_selectButtonbg")];
    }
    return _totalMessageView;
}

- (UILabel *)totalDate {
    if (!_totalDate) {
        _totalDate = [[UILabel alloc] init];
        _totalDate.textAlignment = NSTextAlignmentCenter;
        [_totalDate sizeToFit];
        _totalDate.font = SystemFont(17);
        _totalDate.backgroundColor = kWhiteColor;
        _totalDate.text = @"0";
    }
    return _totalDate;
}
- (UILabel *)totalDateTitle {
    if (!_totalDateTitle) {
        _totalDateTitle = [[UILabel alloc] init];
        _totalDateTitle.textAlignment = NSTextAlignmentCenter;
        [_totalDateTitle sizeToFit];
        _totalDateTitle.font = SystemFont(12);
        _totalDateTitle.textColor = kMainLightGray;
        _totalDateTitle.text = @"实际出勤/应出勤";
    }
    return _totalDateTitle;
}
- (UILabel *)totalScore {
    if (!_totalScore) {
        _totalScore = [[UILabel alloc] init];
        [_totalScore sizeToFit];
        _totalScore.font = SystemFont(17);
        _totalScore.textAlignment = NSTextAlignmentCenter;
        _totalScore.text = @"0";
    }
    return _totalScore;
}
- (UILabel *)totalScroeTitle {
    if (!_totalScroeTitle) {
        _totalScroeTitle = [[UILabel alloc] init];
        [_totalScroeTitle sizeToFit];
        _totalScroeTitle.textAlignment = NSTextAlignmentCenter;
        _totalScroeTitle.font = SystemFont(12);
        _totalScroeTitle.textColor = kMainLightGray;
        _totalScroeTitle.text = @"奖分";
    }
    return _totalScroeTitle;
}
- (UILabel *)totalDeScore {
    if (!_totalDeScore) {
        _totalDeScore = [[UILabel alloc] init];
        [_totalDeScore sizeToFit];
        _totalDeScore.font = SystemFont(17);
        _totalDeScore.textAlignment = NSTextAlignmentCenter;
        _totalDeScore.text = @"0";
    }
    return _totalDeScore;
}
- (UILabel *)totalDeScoreTitle {
    if (!_totalDeScoreTitle) {
        _totalDeScoreTitle = [[UILabel alloc] init];
        [_totalDeScoreTitle sizeToFit];
        _totalDeScoreTitle.textAlignment = NSTextAlignmentCenter;
        _totalDeScoreTitle.font = SystemFont(12);
        _totalDeScoreTitle.textColor = kMainLightGray;
        _totalDeScoreTitle.text = @"扣分";
    }
    return _totalDeScoreTitle;
}

- (UIImageView *)totalLine1 {
    if (!_totalLine1) {
        _totalLine1 = [[UIImageView alloc] init];
        _totalLine1.backgroundColor = kSeperateColor;
    }
    return _totalLine1;
}

- (UIImageView *)totalLine2 {
    if (!_totalLine2) {
        _totalLine2 = [[UIImageView alloc] init];
        _totalLine2.backgroundColor = kSeperateColor;
    }
    return _totalLine2;
}

///////////////////////////////////////////////////////////
- (UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.tableFooterView = [[UIView alloc] init];
        [_bottomTableView setSeparatorColor:kSeperateColor];
    }
    return _bottomTableView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
