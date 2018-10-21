//
//  MPMBaseDealingHeader.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseDealingHeader.h"
#import "MPMButton.h"
#import "MPMAttendanceHeader.h"

@implementation MPMBaseDealingHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstaints];
    }
    return self;
}

#pragma mark - Target Action
- (void)seeDetail:(UIButton *)sender {
    if (self.seeDetailBlock) {
        self.seeDetailBlock();
    }
}

- (void)delete:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setupAttributes {
    [self.seeDetailButton addTarget:self action:@selector(seeDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.headerTitleLabel];
    [self addSubview:self.seeDetailButton];
    [self addSubview:self.deleteButton];
}

- (void)setupConstaints {
    [self.headerTitleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self.mpm_bottom);
        make.leading.equalTo(self.mpm_leading).offset(20);
    }];
    [self.seeDetailButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self.mpm_bottom);
        make.leading.equalTo(self.headerTitleLabel.mpm_trailing).offset(8);
    }];
    [self.deleteButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self.mpm_bottom);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
    }];
}

#pragma mark - Lazy Init
- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.text = @"根据排班自动计算";
        _headerTitleLabel.font = SystemFont(15);
        [_headerTitleLabel sizeToFit];
        _headerTitleLabel.textColor = kMainLightGray;
    }
    return _headerTitleLabel;
}

- (UIButton *)seeDetailButton {
    if (!_seeDetailButton) {
        _seeDetailButton = [MPMButton normalButtonWithTitle:@"查看明细" titleColor:kMainBlueColor bgcolor:kTableViewBGColor];
        _seeDetailButton.titleLabel.font = SystemFont(15);
        _seeDetailButton.hidden = YES;
        [_seeDetailButton.titleLabel sizeToFit];
    }
    return _seeDetailButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [MPMButton normalButtonWithTitle:@"删除" titleColor:kMainBlueColor bgcolor:kTableViewBGColor];
        _deleteButton.titleLabel.font = SystemFont(15);
        [_deleteButton.titleLabel sizeToFit];
    }
    return _deleteButton;
}

@end
