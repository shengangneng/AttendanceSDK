//
//  MPMApplyNewViewController.m
//  MPMAtendence
//
//  Created by shengangneng on 2019/1/28.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import "MPMApplyNewViewController.h"
#import "UIImage+MPMExtention.h"
#import "MPMButton.h"
#import "MPMCycleScrollView.h"
#import "MPMBaseDealingViewController.h"

@interface MPMApplyNewViewController () <MPMCycleScrollViewDelegate>
// Header
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *sickLeaveButton;
@property (nonatomic, strong) UIButton *evecationButton;
@property (nonatomic, strong) UIButton *overTimeButton;
@property (nonatomic, strong) UIButton *gooutButton;
@property (nonatomic, strong) UIView *lineView;
// Middle
@property (nonatomic, strong) MPMCycleScrollView *scrollView;
// Bottom
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UILabel *bottomNameLabel;
@property (nonatomic, strong) UIImageView *bottomRight;
// Datas
@property (nonatomic, assign) NSInteger page;/** 初始化为0。整除4则为请假，余1为出差，余2为加班，余3为外出 */
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, strong) UIButton *lastSelectButton;

@end

@implementation MPMApplyNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"例外申请";
    self.view.backgroundColor = kTableViewBGColor;
    self.page = 0;
    [self.sickLeaveButton addTarget:self action:@selector(sick:) forControlEvents:UIControlEventTouchUpInside];
    [self.evecationButton addTarget:self action:@selector(evecation:) forControlEvents:UIControlEventTouchUpInside];
    [self.overTimeButton addTarget:self action:@selector(overTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.gooutButton addTarget:self action:@selector(goout:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomButton addTarget:self action:@selector(repair:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    // Header
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.sickLeaveButton];
    [self.headerView addSubview:self.evecationButton];
    [self.headerView addSubview:self.overTimeButton];
    [self.headerView addSubview:self.gooutButton];
    [self.headerView addSubview:self.lineView];
    // Middle
    [self.view addSubview:self.scrollView];
    // Bottom
    [self.view addSubview:self.bottomButton];
    [self.bottomButton addSubview:self.bottomNameLabel];
    [self.bottomButton addSubview:self.bottomRight];
}

- (void)setupConstraints {
    [super setupConstraints];
    // Header
    [self.headerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.equalTo(@43);
    }];
    double width = 43;
    double border = (kScreenWidth - width * 4) / 5;
    [self.sickLeaveButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.leading.equalTo(self.headerView.mpm_leading).offset(border);
        make.centerY.equalTo(self.headerView.mpm_centerY);
    }];
    [self.evecationButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.leading.equalTo(self.sickLeaveButton.mpm_trailing).offset(border);
        make.centerY.equalTo(self.headerView.mpm_centerY);
    }];
    [self.overTimeButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.leading.equalTo(self.evecationButton.mpm_trailing).offset(border);
        make.centerY.equalTo(self.headerView.mpm_centerY);
    }];
    [self.gooutButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.leading.equalTo(self.overTimeButton.mpm_trailing).offset(border);
        make.trailing.equalTo(self.headerView.mpm_trailing).offset(-border);
        make.centerY.equalTo(self.headerView.mpm_centerY);
    }];
    [self.lineView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(34));
        make.height.equalTo(@2);
        make.bottom.equalTo(self.headerView.mpm_bottom);
        make.centerX.equalTo(self.sickLeaveButton.mpm_centerX);
    }];
    // Middle
    [self.scrollView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerX.equalTo(self.view.mpm_centerX);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(self.headerView.mpm_bottom).offset(15);
        make.bottom.equalTo(self.view.mpm_bottom).offset(-75);
    }];
    // Bottom
    [self.bottomButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.view.mpm_leading).offset(17);
        make.trailing.equalTo(self.view.mpm_trailing).offset(-17);
        make.bottom.equalTo(self.view.mpm_bottom).offset(-10);
        make.height.equalTo(@50);
    }];
    [self.bottomNameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomButton.mpm_leading).offset(21);
        make.centerY.equalTo(self.bottomButton.mpm_centerY);
    }];
    [self.bottomRight mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@13);
        make.centerY.equalTo(self.bottomButton.mpm_centerY);
        make.trailing.equalTo(self.bottomButton.mpm_trailing).offset(-15);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.scrollView.frame.size.height > 450) {
        // Middle
        [self.scrollView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.centerX.equalTo(self.view.mpm_centerX);
            make.width.equalTo(@(kScreenWidth));
            make.top.equalTo(self.headerView.mpm_bottom).offset(15);
            make.height.equalTo(@450);
        }];
        // Bottom
        [self.bottomButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.view.mpm_leading).offset(17);
            make.trailing.equalTo(self.view.mpm_trailing).offset(-17);
            make.top.equalTo(self.scrollView.mpm_bottom).offset(15);
            make.height.equalTo(@50);
        }];
    }
}

#pragma mark - Target Action
- (void)sick:(UIButton *)sender {
    [self selectBtnAtIndex:0];
    [self.scrollView scrollToIndex:(self.scrollView.currentIndex - self.scrollView.currentIndex % 4)];
}

- (void)evecation:(UIButton *)sender {
    [self selectBtnAtIndex:1];
    [self.scrollView scrollToIndex:(self.scrollView.currentIndex - self.scrollView.currentIndex % 4 + 1)];
}

- (void)overTime:(UIButton *)sender {
    [self selectBtnAtIndex:2];
    [self.scrollView scrollToIndex:(self.scrollView.currentIndex - self.scrollView.currentIndex % 4 + 2)];
}

- (void)goout:(UIButton *)sender {
    [self selectBtnAtIndex:3];
    [self.scrollView scrollToIndex:(self.scrollView.currentIndex - self.scrollView.currentIndex % 4 + 3)];
}

- (void)repair:(UIButton *)sender {
    // 补卡
    MPMBaseDealingViewController *dv = [[MPMBaseDealingViewController alloc] initWithDealType:kCausationTypeRepairSign dealingModel:nil dealingFromType:kDealingFromTypeApply bizorderId:nil taskInstId:nil fastCalculate:kFastCalculateTypeNone];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dv animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Private Method
- (void)selectBtnAtIndex:(NSInteger)index {
    UIButton *sender;
    switch (index) {
        case 0:
            sender = self.sickLeaveButton;
            break;
        case 1:
            sender = self.evecationButton;
            break;
        case 2:
            sender = self.overTimeButton;
            break;
        case 3:
            sender = self.gooutButton;
            break;
        default:
            sender = self.sickLeaveButton;
            break;
    }
    self.lastSelectButton.selected = NO;
    sender.selected = YES;
    self.lastSelectButton = sender;
    [UIView animateWithDuration:0.25 animations:^{
        [self.lineView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@(34));
            make.height.equalTo(@2);
            make.bottom.equalTo(self.headerView.mpm_bottom);
            make.centerX.equalTo(sender.mpm_centerX);
        }];
        [self.headerView layoutIfNeeded];
    }];
}

#pragma mark - MPMCycleScrollViewDelegate
- (void)cycleScrollView:(MPMCycleScrollView *)cycleScrollView currentPageIndex:(NSInteger)index {
    if (index == 0) {
        [self sick:self.sickLeaveButton];
    } else if (index == 1) {
        [self evecation:self.evecationButton];
    } else if (index == 2) {
        [self overTime:self.overTimeButton];
    } else {
        [self goout:self.gooutButton];
    }
}

/** 点击了快捷申请 */
- (void)cycleScrollView:(MPMCycleScrollView *)cycleScrollView didSelectFastIndex:(NSInteger)index {
    CausationType type = kCausationTypeAskLeave;
    FastCalculateType fastType;
    if (cycleScrollView.currentIndex % 4 == 0) {
        // 请假
        type = kCausationTypeAskLeave;
        if (0 == index) {
            fastType = kFastCalculateTypeAM;
        } else if (1 == index) {
            fastType = kFastCalculateTypePM;
        } else if (2 == index) {
            fastType = kFastCalculateTypeTomorrow;
        } else {
            fastType = kFastCalculateTypeNone;
        }
    } else if (cycleScrollView.currentIndex % 4 == 1) {
        // 出差
        type = kCausationTypeevecation;
        if (0 == index) {
            fastType = kFastCalculateTypeTomorrow;
        } else if (1 == index) {
            fastType = kFastCalculateTypeTwoDays;
        } else if (2 == index) {
            fastType = kFastCalculateTypeThreeDays;
        } else {
            fastType = kFastCalculateTypeNone;
        }
    } else if (cycleScrollView.currentIndex % 4 == 2) {
        // 加班
        type = kCausationTypeOverTime;
        if (0 == index) {
            fastType = kFastCalculateTypeOneHour;
        } else if (1 == index) {
            fastType = kFastCalculateTypeTwoHour;
        } else if (2 == index) {
            fastType = kFastCalculateTypeThreeHour;
        } else if (3 == index) {
            fastType = kFastCalculateTypeTomorrow;
        } else {
            fastType = kFastCalculateTypeNone;
        }
    } else if (cycleScrollView.currentIndex % 4 == 3) {
        // 外出
        type = kCausationTypeOut;
        if (0 == index) {
            fastType = kFastCalculateTypeOneHour;
        } else if (1 == index) {
            fastType = kFastCalculateTypeTwoHour;
        } else if (2 == index) {
            fastType = kFastCalculateTypeThreeHour;
        } else if (3 == index) {
            fastType = kFastCalculateTypeAM;
        } else if (4 == index) {
            fastType = kFastCalculateTypePM;
        } else if (5 == index) {
            fastType = kFastCalculateTypeTomorrow;
        } else {
            fastType = kFastCalculateTypeNone;
        }
    } else {
        // 补卡/改卡
        type = kCausationTypeRepairSign;
        fastType = kFastCalculateTypeNone;
    }
    MPMBaseDealingViewController *dv = [[MPMBaseDealingViewController alloc] initWithDealType:type dealingModel:nil dealingFromType:kDealingFromTypeApply bizorderId:nil taskInstId:nil fastCalculate:fastType];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dv animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Lazy Init

// Header
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = kWhiteColor;
        _headerView.layer.shadowColor = kRGBA(147, 179, 216, 0.48).CGColor;
        _headerView.layer.shadowOffset = CGSizeMake(0,1);
        _headerView.layer.shadowOpacity = 1;
        _headerView.layer.shadowRadius = 1;
    }
    return _headerView;
}

- (UIButton *)sickLeaveButton {
    if (!_sickLeaveButton) {
        _sickLeaveButton = [MPMButton normalButtonWithTitle:@"请假" titleColor:kMainLightGray bgcolor:kWhiteColor];
        [_sickLeaveButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _sickLeaveButton.titleLabel.font = SystemFont(16);
    }
    return _sickLeaveButton;
}

- (UIButton *)evecationButton {
    if (!_evecationButton) {
        _evecationButton = [MPMButton normalButtonWithTitle:@"出差" titleColor:kMainLightGray bgcolor:kWhiteColor];
        [_evecationButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _evecationButton.titleLabel.font = SystemFont(16);
    }
    return _evecationButton;
}

- (UIButton *)overTimeButton {
    if (!_overTimeButton) {
        _overTimeButton = [MPMButton normalButtonWithTitle:@"加班" titleColor:kMainLightGray bgcolor:kWhiteColor];
        [_overTimeButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _overTimeButton.titleLabel.font = SystemFont(16);
    }
    return _overTimeButton;
}

- (UIButton *)gooutButton {
    if (!_gooutButton) {
        _gooutButton = [MPMButton normalButtonWithTitle:@"外出" titleColor:kMainLightGray bgcolor:kWhiteColor];
        [_gooutButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _gooutButton.titleLabel.font = SystemFont(16);
    }
    return _gooutButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kMainBlueColor;
        _lineView.layer.cornerRadius = 1;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

// Middle

- (MPMCycleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [MPMCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 400) shouldCycleLoop:YES imageGroups:self.imageArray];
        _scrollView.isZoom = YES;
        _scrollView.itemWidth = 260;
        _scrollView.itemSpace = 0;
        _scrollView.delegate = self;
        _scrollView.cornerRadius = 10;
    }
    return _scrollView;
}

// Bottom
- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.layer.cornerRadius = 10;
        _bottomButton.layer.masksToBounds = YES;
        _bottomButton.backgroundColor = kWhiteColor;
    }
    return _bottomButton;
}

- (UILabel *)bottomNameLabel {
    if (!_bottomNameLabel) {
        _bottomNameLabel = [[UILabel alloc] init];
        _bottomNameLabel.font = SystemFont(15);
        _bottomNameLabel.text = @"补卡申请";
        _bottomNameLabel.textColor = kRGBA(106, 116, 128, 1);
        [_bottomNameLabel sizeToFit];
    }
    return _bottomNameLabel;
}

- (UIImageView *)bottomRight {
    if (!_bottomRight) {
        _bottomRight = [[UIImageView alloc] initWithImage:ImageName(@"apply_right")];
    }
    return _bottomRight;
}

// Datas
- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[kRGBA(46, 140, 247, 1),kRGBA(101, 116, 249, 1),kRGBA(249, 190, 54, 1),kRGBA(136, 211, 53, 1)];
    }
    return _imageArray;
}

@end
