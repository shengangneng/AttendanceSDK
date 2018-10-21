//
//  MPMAttendenceTableViewCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceTableViewCell.h"

@implementation MPMAttendenceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    self.textLabel.font = SystemFont(16);
}

- (void)setupSubViews {
    [self addSubview:self.line];
    [self addSubview:self.roundView];
    [self.roundView addSubview:self.round];
    [self addSubview:self.classTypeLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.waitBrushLabel];
    [self addSubview:self.contentImageView];
    [self addSubview:self.statusImageView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.messageTimeLabel];
    [self addSubview:self.exceptionBtn];
    [self addSubview:self.scoreButton];
    [self addSubview:self.accessaryIcon];
}

- (void)setupConstraints {
    [self.line mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(29);
        make.height.equalTo(@(60));
        make.width.equalTo(@1);
    }];
    [self.roundView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerX.equalTo(self.line.mpm_centerX);
        make.centerY.equalTo(self.line.mpm_centerY);
    }];
    [self.round mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@10);
        make.centerX.equalTo(self.line.mpm_centerX);
        make.centerY.equalTo(self.line.mpm_centerY);
    }];
    [self.classTypeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(8);
        make.centerY.equalTo(self.mpm_centerY).offset(-8.5);
        make.height.equalTo(@17);
        make.width.equalTo(@43);
    }];
    [self.timeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(8);
        make.centerY.equalTo(self.mpm_centerY).offset(8.5);
        make.height.equalTo(@17);
        make.width.equalTo(@43);
    }];
    [self.waitBrushLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(59);
        make.trailing.equalTo(self.mpm_trailing).offset(-18);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.contentImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(59);
        make.trailing.equalTo(self.mpm_trailing).offset(-18);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.statusImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.contentImageView.mpm_centerY);
        make.leading.equalTo(self.contentImageView.mpm_leading).offset(10);
        make.width.height.equalTo(@(17));
    }];
    [self.messageLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.contentImageView.mpm_centerY);
        make.leading.equalTo(self.statusImageView.mpm_trailing).offset(8);
    }];
    [self.messageTimeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.contentImageView.mpm_centerY);
        make.leading.equalTo(self.messageLabel.mpm_trailing).offset(8);
    }];
    [self.exceptionBtn mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.contentImageView.mpm_centerY);
        make.height.equalTo(@18);
        make.width.equalTo(@40);
        make.leading.equalTo(self.messageTimeLabel.mpm_trailing).offset(8);
    }];
    [self.scoreButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.contentImageView.mpm_centerY);
        make.trailing.equalTo(self.contentImageView.mpm_trailing).offset(-30.5);
        make.height.equalTo(@18);
        make.width.equalTo(@56);
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
- (UILabel *)classTypeLabel {
    if (!_classTypeLabel) {
        _classTypeLabel = [[UILabel alloc] init];
        _classTypeLabel.font = SystemFont(12);
        _classTypeLabel.backgroundColor = kWhiteColor;
        _classTypeLabel.textAlignment = NSTextAlignmentCenter;
        _classTypeLabel.textColor = kMainLightGray;
    }
    return _classTypeLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = SystemFont(12);
        _timeLabel.text = @"12:00";
        _timeLabel.backgroundColor = kWhiteColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = kMainLightGray;
    }
    return _timeLabel;
}
- (UILabel *)waitBrushLabel {
    if (!_waitBrushLabel) {
        _waitBrushLabel = [[UILabel alloc] init];
        _waitBrushLabel.font = SystemFont(16);
        _waitBrushLabel.text = @"等待打卡中~~";
        _waitBrushLabel.backgroundColor = kWhiteColor;
        _waitBrushLabel.textColor = kMainBlueColor;
        _waitBrushLabel.textAlignment = NSTextAlignmentLeft;
        _waitBrushLabel.hidden = YES;
    }
    return _waitBrushLabel;
}
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.image = ImageName(@"attendence_cellcontent");
        _contentImageView.userInteractionEnabled = YES;
    }
    return _contentImageView;
}
- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        _statusImageView.image = ImageName(@"attendence_finish");
    }
    return _statusImageView;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        [_messageLabel sizeToFit];
        _messageLabel.text = @"打卡未完成";
        _messageLabel.font = SystemFont(16);
    }
    return _messageLabel;
}
- (UILabel *)messageTimeLabel {
    if (!_messageTimeLabel) {
        _messageTimeLabel = [[UILabel alloc] init];
        _messageTimeLabel.text = @"14:00~18:30";
        _messageTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_messageTimeLabel sizeToFit];
        _messageTimeLabel.font = SystemFont(16);
    }
    return _messageTimeLabel;
}

- (MPMDealingBorderButton *)exceptionBtn {
    if (!_exceptionBtn) {
        _exceptionBtn = [[MPMDealingBorderButton alloc] initWithTitle:@"请假" nColor:kOrangeColor sColor:kOrangeColor font:SystemFont(12) cornerRadius:5 borderWidth:1];
        _exceptionBtn.hidden = YES;
    }
    return _exceptionBtn;
}

- (UIButton *)scoreButton {
    if (!_scoreButton) {
        _scoreButton = [[UIButton alloc] init];
        _scoreButton.userInteractionEnabled = NO;
        [_scoreButton setTitle:@"999" forState:UIControlStateNormal];
        [_scoreButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _scoreButton.titleLabel.font = SystemFont(14);
        [_scoreButton.titleLabel adjustsFontSizeToFitWidth];
        [_scoreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 21, 0, 0)];
        [_scoreButton setBackgroundImage:ImageName(@"attendence_aceb") forState:UIControlStateNormal];
    }
    return _scoreButton;
}
- (UIImageView *)accessaryIcon {
    if (!_accessaryIcon) {
        _accessaryIcon = [[UIImageView alloc] init];
        _accessaryIcon.image = ImageName(@"statistics_rightenter");
    }
    return _accessaryIcon;
}

- (UIView *)roundView {
    if (!_roundView) {
        _roundView = [[UIView alloc] init];
        _roundView.backgroundColor = kWhiteColor;
    }
    return _roundView;
}

- (UIView *)round {
    if (!_round) {
        _round = [[UIView alloc] init];
        _round.backgroundColor = kRGBA(226, 226, 226, 1);
        _round.layer.cornerRadius = 5;
    }
    return _round;
}

@end
