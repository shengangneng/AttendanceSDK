//
//  MPMApplyAdditionViewController.m
//  MPMAtendence
//  例外申请
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApplyAdditionViewController.h"
#import "MPMButton.h"
#import "MPMApplyImageView.h"
#import "MPMBaseDealingViewController.h"
#import "MPMCausationTypeData.h"
#import "MPMLoginViewController.h"
#import "MPMShareUser.h"
#import "UIImage+MPMExtention.h"

@interface MPMApplyAdditionViewController () <MPMApplyImageDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
/** 请假 */
@property (nonatomic, strong) MPMApplyImageView *leaveImageView;
/** 出差 */
@property (nonatomic, strong) MPMApplyImageView *evecationImageView;
/** 加班 */
@property (nonatomic, strong) MPMApplyImageView *overtimeImageView;
/** 外出 */
@property (nonatomic, strong) MPMApplyImageView *goOutImageView;
/** 补卡 */
@property (nonatomic, strong) MPMApplyImageView *resignImageView;

@end

@implementation MPMApplyAdditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"例外申请";
    __weak typeof(self) weakself = self;
    self.goOutImageView.foldBlock = ^(BOOL fold) {
        __strong typeof(weakself) strongself = weakself;
        [strongself.goOutImageView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(strongself.scrollView.mpm_leading).offset(10);
            make.trailing.equalTo(strongself.scrollView.mpm_trailing).offset(-10);
            make.centerX.equalTo(strongself.scrollView.mpm_centerX);
            make.top.equalTo(strongself.overtimeImageView.mpm_bottom).offset(10);
            if (fold) {
                make.height.equalTo(@126);
            } else {
                make.height.equalTo(@171);
            }
            [strongself.view layoutIfNeeded];
        }];
    };
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.leaveImageView];
    [self.scrollView addSubview:self.evecationImageView];
    [self.scrollView addSubview:self.overtimeImageView];
    [self.scrollView addSubview:self.goOutImageView];
    [self.scrollView addSubview:self.resignImageView];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    [self.scrollView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.leaveImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mpm_leading).offset(10);
        make.trailing.equalTo(self.scrollView.mpm_trailing).offset(-10);
        make.centerX.equalTo(self.scrollView.mpm_centerX);
        make.height.equalTo(@118);
        make.top.equalTo(self.scrollView.mpm_top).offset(10);
    }];
    [self.evecationImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mpm_leading).offset(10);
        make.trailing.equalTo(self.scrollView.mpm_trailing).offset(-10);
        make.centerX.equalTo(self.scrollView.mpm_centerX);
        make.height.equalTo(@118);
        make.top.equalTo(self.leaveImageView.mpm_bottom).offset(10);
    }];
    [self.overtimeImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mpm_leading).offset(10);
        make.trailing.equalTo(self.scrollView.mpm_trailing).offset(-10);
        make.centerX.equalTo(self.scrollView.mpm_centerX);
        make.top.equalTo(self.evecationImageView.mpm_bottom).offset(10);
        make.height.equalTo(@118);
    }];
    [self.goOutImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mpm_leading).offset(10);
        make.trailing.equalTo(self.scrollView.mpm_trailing).offset(-10);
        make.centerX.equalTo(self.scrollView.mpm_centerX);
        make.top.equalTo(self.overtimeImageView.mpm_bottom).offset(10);
        make.height.equalTo(@126);
    }];
    [self.resignImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mpm_leading).offset(10);
        make.trailing.equalTo(self.scrollView.mpm_trailing).offset(-10);
        make.centerX.equalTo(self.scrollView.mpm_centerX);
        make.top.equalTo(self.goOutImageView.mpm_bottom).offset(10);
        make.bottom.equalTo(self.scrollView.mpm_bottom).offset(-10);
        make.height.equalTo(@61);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.leaveImageView.layer insertSublayer:[[self class] setGradualChangingColor:self.leaveImageView fromColor:kRGBA(246, 180, 42, 1) toColor:kRGBA(241, 204, 71, 1)] atIndex:0];
    [self.evecationImageView.layer insertSublayer:[[self class] setGradualChangingColor:self.evecationImageView fromColor:kRGBA(253, 146, 64, 1) toColor:kRGBA(252, 182, 49, 1)] atIndex:0];
    [self.overtimeImageView.layer insertSublayer:[[self class] setGradualChangingColor:self.overtimeImageView fromColor:kRGBA(108, 122, 251, 1) toColor:kRGBA(122, 166, 252, 1)] atIndex:0];
    [self.goOutImageView.layer insertSublayer:[[self class] setGradualChangingColor:self.goOutImageView fromColor:kRGBA(65, 146, 229, 1) toColor:kRGBA(69, 173, 242, 1)] atIndex:0];
    [self.resignImageView.layer insertSublayer:[[self class] setGradualChangingColor:self.resignImageView fromColor:kRGBA(140, 205, 44, 1) toColor:kRGBA(151, 230, 88, 1)] atIndex:0];
}

#pragma mark - MPMApplyImageDelegate

- (void)applyImageView:(MPMApplyImageView *)applyView didSelectFastIndex:(NSInteger)index {
    CausationType type = kCausationTypeAskLeave;
    FastCalculateType fastType;
    if (applyView == self.leaveImageView) {
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
    } else if (applyView == self.evecationImageView) {
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
    } else if (applyView == self.overtimeImageView) {
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
    } else if (applyView == self.goOutImageView) {
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

#pragma mark - Private Method
// 绘制渐变背景
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColo toColor:(UIColor *)toColor {
    // CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.cornerRadius = 5;
    // 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColo.CGColor,(__bridge id)toColor.CGColor];
    // 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    // 设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
}

#pragma mark - Lazy Init
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
}

- (MPMApplyImageView *)leaveImageView {
    if (!_leaveImageView) {
        _leaveImageView = [[MPMApplyImageView alloc] initWithTitle:@"请假申请" image:ImageName(@"apply_leave_icon") labels:@[@"上午",@"下午",@"明天"]];
        _leaveImageView.delegate = self;
        [_leaveImageView sizeToFit];
        _leaveImageView.userInteractionEnabled = YES;
    }
    return _leaveImageView;
}

- (MPMApplyImageView *)evecationImageView {
    if (!_evecationImageView) {
        _evecationImageView = [[MPMApplyImageView alloc] initWithTitle:@"出差申请" image:ImageName(@"apply_evection_icon") labels:@[@"明天",@"2天",@"3天"]];
        _evecationImageView.delegate = self;
        [_evecationImageView sizeToFit];
        _evecationImageView.userInteractionEnabled = YES;
    }
    return _evecationImageView;
}

- (MPMApplyImageView *)overtimeImageView {
    if (!_overtimeImageView) {
        _overtimeImageView = [[MPMApplyImageView alloc] initWithTitle:@"加班申请" image:ImageName(@"apply_overtime_icon") labels:@[@"1小时",@"2小时",@"3小时",@"明天"]];
        _overtimeImageView.delegate = self;
        [_overtimeImageView sizeToFit];
        _overtimeImageView.userInteractionEnabled = YES;
    }
    return _overtimeImageView;
}

- (MPMApplyImageView *)goOutImageView {
    if (!_goOutImageView) {
        _goOutImageView = [[MPMApplyImageView alloc] initWithTitle:@"外出申请" image:ImageName(@"apply_goout_icon") labels:@[@"1小时",@"2小时",@"3小时",@"上午",@"下午",@"明天"]];
        _goOutImageView.delegate = self;
        _goOutImageView.userInteractionEnabled = YES;
        [_goOutImageView sizeToFit];
    }
    return _goOutImageView;
}

- (MPMApplyImageView *)resignImageView {
    if (!_resignImageView) {
        _resignImageView = [[MPMApplyImageView alloc] initWithTitle:@"补卡申请" image:ImageName(@"apply_repair_icon") labels:nil];
        _resignImageView.delegate = self;
        _resignImageView.userInteractionEnabled = YES;
        [_resignImageView sizeToFit];
    }
    return _resignImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
