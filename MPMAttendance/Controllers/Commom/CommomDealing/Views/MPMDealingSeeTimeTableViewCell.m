//
//  MPMDealingSeeTimeTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDealingSeeTimeTableViewCell.h"
#import "MPMAttendanceHeader.h"

@implementation MPMDealingSeeTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = kTableViewBGColor;
}

- (void)setupSubViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.blueLineView];
    [self.bgView addSubview:self.hourLabel];
    [self.bgView addSubview:self.timeDetailLabel];
}

- (void)setupConstraints {
    [self.bgView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.mpm_top).offset(4);
        make.bottom.equalTo(self.mpm_bottom).offset(-4);
        make.trailing.equalTo(self.mpm_trailing).offset(-8);
        make.leading.equalTo(self.mpm_leading).offset(8);
    }];
    [self.blueLineView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@4);
    }];
    [self.hourLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bgView.mpm_leading).offset(20);
        make.top.equalTo(self.bgView.mpm_top).offset(15);
        make.height.equalTo(@30);
    }];
    [self.timeDetailLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bgView.mpm_leading).offset(20);
        make.top.equalTo(self.hourLabel.mpm_bottom).offset(15);
        make.height.equalTo(@30);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - Lazy Init

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UIView *)blueLineView {
    if (!_blueLineView) {
        _blueLineView = [[UIView alloc] init];
        _blueLineView.layer.cornerRadius = 5;
        _blueLineView.backgroundColor = kMainBlueColor;
    }
    return _blueLineView;
}

- (UILabel *)hourLabel {
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.text = @"4.5小时";
        _hourLabel.textColor = kBlackColor;
        _hourLabel.font = SystemFont(25);
        _hourLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _hourLabel;
}

- (UILabel *)timeDetailLabel {
    if (!_timeDetailLabel) {
        _timeDetailLabel = [[UILabel alloc] init];
        _timeDetailLabel.text = @"2018-08-01 星期一    请假09:30-17:30";
        _timeDetailLabel.textColor = kBlackColor;
        _timeDetailLabel.font = SystemFont(15);
        _timeDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeDetailLabel;
}

@end

@implementation MPMDealingTotalTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kTableViewBGColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.txLabel];
        [self.bgView addSubview:self.detailTxLabel];
        [self.bgView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(8);
            make.trailing.equalTo(self.mpm_trailing).offset(-8);
            make.top.equalTo(self.mpm_top).offset(8);
            make.bottom.equalTo(self.mpm_bottom).offset(-4);
        }];
        [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.bgView.mpm_leading).offset(20);
            make.top.equalTo(self.bgView.mpm_top).offset(15);
            make.height.equalTo(@30);
        }];
        [self.detailTxLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.bgView.mpm_leading).offset(20);
            make.top.equalTo(self.txLabel.mpm_bottom).offset(15);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kMainBlueColor;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        _txLabel.text = @"共请假12.5小时";
        _txLabel.textColor = kWhiteColor;
        _txLabel.font = SystemFont(25);
        _txLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txLabel;
}

- (UILabel *)detailTxLabel {
    if (!_detailTxLabel) {
        _detailTxLabel = [[UILabel alloc] init];
        _detailTxLabel.text = @"最小申请单位为小时";
        _detailTxLabel.textColor = kWhiteColor;
        _detailTxLabel.font = SystemFont(15);
        _detailTxLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailTxLabel;
}


@end


