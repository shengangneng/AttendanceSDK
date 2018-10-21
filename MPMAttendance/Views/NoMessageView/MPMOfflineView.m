//
//  MPMOfflineView.m
//  MPMAtendence
//  无网络视图
//  Created by shengangneng on 2018/10/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMOfflineView.h"
#import "MPMDealingBorderButton.h"
#import "MPMAttendanceHeader.h"

@interface MPMOfflineView ()

@property (nonatomic, strong) UIImageView *offlineImageView;
@property (nonatomic, strong) UILabel *offlineLabel;
@property (nonatomic, strong) UIButton *reloadViewButton;

@end

@implementation MPMOfflineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    [self.reloadViewButton addTarget:self action:@selector(reloadView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.offlineImageView];
    [self addSubview:self.offlineLabel];
    [self addSubview:self.reloadViewButton];
}

- (void)setupConstraints {
    [self.offlineImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@190);
        make.centerX.equalTo(self.mpm_centerX);
        make.centerY.equalTo(self.mpm_centerY).offset(-50);
    }];
    [self.offlineLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(self.mpm_width);
        make.top.equalTo(self.offlineImageView.mpm_bottom).offset(8);
    }];
    [self.reloadViewButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@110);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.offlineImageView.mpm_centerX);
        make.top.equalTo(self.offlineLabel.mpm_bottom).offset(30);
    }];
}

#pragma mark - Public Setting
- (void)setState:(MPMOfflineState)state {
    if (kOfflineStateAvailable == state) {
        self.hidden =
        self.offlineImageView.hidden =
        self.offlineLabel.hidden =
        self.reloadViewButton.hidden = YES;
    } else {
        self.hidden =
        self.offlineImageView.hidden =
        self.offlineLabel.hidden =
        self.reloadViewButton.hidden = NO;
    }
}

#pragma mark - Target Action
- (void)reloadView:(UIButton *)sender {
    if (self.reloadViewBlock) {
        self.reloadViewBlock();
    }
}

#pragma mark - Lazy Init
- (UIImageView *)offlineImageView {
    if (!_offlineImageView) {
        // 150X150
        _offlineImageView = [[UIImageView alloc] initWithImage:ImageName(@"global_offline")];
    }
    return _offlineImageView;
}

- (UILabel *)offlineLabel {
    if (!_offlineLabel) {
        _offlineLabel = [[UILabel alloc] init];
        [_offlineLabel sizeToFit];
        _offlineLabel.font = SystemFont(14);
        _offlineLabel.textColor = kMainLightGray;
        _offlineLabel.textAlignment = NSTextAlignmentCenter;
        _offlineLabel.text = @"网络不可用，请检查网络设置";
    }
    return _offlineLabel;
}

- (UIButton *)reloadViewButton {
    if (!_reloadViewButton) {
        _reloadViewButton = [[MPMDealingBorderButton alloc] initWithTitle:@"重新加载" nColor:kMainBlueColor sColor:kMainLightGray font:SystemFont(17) cornerRadius:5 borderWidth:1];
    }
    return _reloadViewButton;
}

@end
