//
//  MPMAttendenceExceptionTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceExceptionTableViewCell.h"

@implementation MPMAttendenceExceptionTableViewCell

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
}

- (void)setupSubViews {
    [self addSubview:self.line];
    [self addSubview:self.roundView];
    [self addSubview:self.contentImageView];
    [self.roundView addSubview:self.round];
    [self.contentImageView addSubview:self.typeLabel];
    [self.contentImageView addSubview:self.detailTimeLabel];
    [self.contentImageView addSubview:self.accessaryIcon];
}

- (void)setupConstraints {
    
    [self.line mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(29);
        make.height.equalTo(@(60));
        make.width.equalTo(@1);
    }];
    [self.roundView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.centerY.equalTo(self.mpm_centerY);
        make.centerX.equalTo(self.line.mpm_centerX);
    }];
    [self.round mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@8);
        make.centerY.equalTo(self.roundView.mpm_centerY);
        make.centerX.equalTo(self.roundView.mpm_centerX);
    }];
    [self.contentImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(59);
        make.trailing.equalTo(self.mpm_trailing).offset(-18);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.typeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentImageView.mpm_leading).offset(8);
        make.trailing.equalTo(self.contentImageView.mpm_trailing).offset(-8);
        make.top.equalTo(self.contentImageView.mpm_top);
        make.height.equalTo(@25);
    }];
    [self.detailTimeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentImageView.mpm_leading).offset(8);
        make.trailing.equalTo(self.contentImageView.mpm_trailing).offset(-8);
        make.bottom.equalTo(self.contentImageView.mpm_bottom).offset(-3);
        make.top.equalTo(self.typeLabel.mpm_bottom);
    }];
    [self.accessaryIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.contentImageView.mpm_centerY);
        make.trailing.equalTo(self.contentImageView.mpm_trailing).offset(-12);
        make.height.equalTo(@11);
        make.width.equalTo(@6.5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kRGBA(226, 226, 226, 1);
    }
    return _line;
}

- (UIView *)roundView {
    if (!_roundView) {
        _roundView = [[UIView alloc] init];
        _roundView.backgroundColor = kWhiteColor;
    }
    return  _roundView;
}

- (UIView *)round {
    if (!_round) {
        _round = [[UIView alloc] init];
        _round.backgroundColor = kSeperateColor;
        _round.layer.cornerRadius = 4;
    }
    return _round;
}
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.image = ImageName(@"attendence_cellcontent");
        _contentImageView.userInteractionEnabled = YES;
    }
    return _contentImageView;
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"请假（病假）";
        _typeLabel.font = SystemFont(16);
        _typeLabel.textColor = kBlackColor;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}
- (UILabel *)detailTimeLabel {
    if (!_detailTimeLabel) {
        _detailTimeLabel = [[UILabel alloc] init];
        _detailTimeLabel.text = @"2018-10-09 10：00";
        _detailTimeLabel.font = SystemFont(12);
        _detailTimeLabel.textColor = kMainLightGray;
        _detailTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailTimeLabel;
}

- (UIImageView *)accessaryIcon {
    if (!_accessaryIcon) {
        _accessaryIcon = [[UIImageView alloc] init];
        _accessaryIcon.image = ImageName(@"statistics_rightenter");
    }
    return _accessaryIcon;
}


@end
