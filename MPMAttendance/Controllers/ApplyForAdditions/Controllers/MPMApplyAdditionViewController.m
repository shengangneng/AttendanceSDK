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

@interface MPMApplyAdditionViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
/** 请假 */
@property (nonatomic, strong) MPMApplyImageView *leaveImageView;
/** 出差 */
@property (nonatomic, strong) MPMApplyImageView *evecationImageView;
/** 加班 */
@property (nonatomic, strong) MPMApplyImageView *overtimeImageView;
/** 外出 */
@property (nonatomic, strong) MPMApplyImageView *goOutImageView;

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
    [self.leaveImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leave:)]];
    [self.evecationImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(evecation:)]];
    [self.overtimeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overtime:)]];
    [self.goOutImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOut:)]];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    
    [self.containerView addSubview:self.leaveImageView];
    [self.containerView addSubview:self.evecationImageView];
    [self.containerView addSubview:self.overtimeImageView];
    [self.containerView addSubview:self.goOutImageView];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@554);
    }];
    [self.leaveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.containerView.mas_leading).offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-10);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.containerView.mas_top).offset(2.5);
    }];
    [self.evecationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.containerView.mas_leading).offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-10);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.leaveImageView.mas_bottom).offset(-5);
    }];
    [self.overtimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.containerView.mas_leading).offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-10);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.evecationImageView.mas_bottom).offset(-5);
    }];
    [self.goOutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.containerView.mas_leading).offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-10);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.overtimeImageView.mas_bottom).offset(-5);
    }];
}

#pragma mark - Target Action

- (void)leave:(UITapGestureRecognizer *)gesture {
    DLog(@"请假");
    MPMBaseDealingViewController *dv = [[MPMBaseDealingViewController alloc] initWithDealType:forCausationTypeLeave typeStatus:nil dealingModel:nil dealingFromType:kDealingFromTypeApply];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dv animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)evecation:(UITapGestureRecognizer *)gesture {
    DLog(@"出差");
    MPMBaseDealingViewController *dv = [[MPMBaseDealingViewController alloc] initWithDealType:forCausationTypeevecation typeStatus:nil dealingModel:nil dealingFromType:kDealingFromTypeApply];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dv animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)overtime:(UITapGestureRecognizer *)gesture {
    DLog(@"加班");
    MPMBaseDealingViewController *dv = [[MPMBaseDealingViewController alloc] initWithDealType:forCausationTypeOverTime typeStatus:nil dealingModel:nil dealingFromType:kDealingFromTypeApply];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dv animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)goOut:(UITapGestureRecognizer *)gesture {
    DLog(@"外出");
    MPMBaseDealingViewController *dv = [[MPMBaseDealingViewController alloc] initWithDealType:forCausationTypeOut typeStatus:nil dealingModel:nil dealingFromType:kDealingFromTypeApply];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dv animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Lazy Init
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = kWhiteColor;
    }
    return _containerView;
}

- (MPMApplyImageView *)leaveImageView {
    if (!_leaveImageView) {
        _leaveImageView = [[MPMApplyImageView alloc] initWithTitle:@"请假" detailMessage:@"因个人的特殊情况无法正常上班请假"];
        [_leaveImageView sizeToFit];
        _leaveImageView.userInteractionEnabled = YES;
        _leaveImageView.image = ImageName(@"apply_vacate");
    }
    return _leaveImageView;
}

- (MPMApplyImageView *)evecationImageView {
    if (!_evecationImageView) {
        _evecationImageView = [[MPMApplyImageView alloc] initWithTitle:@"出差" detailMessage:@"工作人员临时被派遣异地办公"];
        [_evecationImageView sizeToFit];
        _evecationImageView.userInteractionEnabled = YES;
        _evecationImageView.image = ImageName(@"apply_evection");
    }
    return _evecationImageView;
}

- (MPMApplyImageView *)overtimeImageView {
    if (!_overtimeImageView) {
        _overtimeImageView = [[MPMApplyImageView alloc] initWithTitle:@"加班" detailMessage:@"非工作日上班或延长工作时间"];
        [_overtimeImageView sizeToFit];
        _overtimeImageView.userInteractionEnabled = YES;
        _overtimeImageView.image = ImageName(@"apply_overtime");
    }
    return _overtimeImageView;
}

- (MPMApplyImageView *)goOutImageView {
    if (!_goOutImageView) {
        _goOutImageView = [[MPMApplyImageView alloc] initWithTitle:@"外出" detailMessage:@"因事临时外出办事，需申请审批"];
        _goOutImageView.userInteractionEnabled = YES;
        [_goOutImageView sizeToFit];
        _goOutImageView.image = ImageName(@"apply_goout");
    }
    return _goOutImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
