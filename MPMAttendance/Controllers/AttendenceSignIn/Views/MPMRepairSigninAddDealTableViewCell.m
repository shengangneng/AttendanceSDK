//
//  MPMRepairSigninAddDealTableViewCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMRepairSigninAddDealTableViewCell.h"
#import "MPMButton.h"

@implementation MPMRepairSigninAddDealTableViewCell

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
    [self.signDealButton addTarget:self action:@selector(deal:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.signTypeLabel];
    [self addSubview:self.signTimeLabel];
    [self addSubview:self.signDateLabel];
    [self addSubview:self.signDealButton];
}

- (void)setupConstraints {
    [self.signTypeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.width.equalTo(@(60));
    }];
    [self.signTimeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self.signTypeLabel.mpm_trailing);
    }];
    [self.signDateLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self);
        make.width.equalTo(@(130));
    }];
    [self.signDealButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(55));
        make.height.equalTo(@(30));
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
    }];
}

#pragma mark - Target Action
- (void)deal:(UIButton *)sender {
    if (self.dealingBlock) {
        self.dealingBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init

- (UILabel *)signTypeLabel {
    if (!_signTypeLabel) {
        _signTypeLabel = [[UILabel alloc] init];
        _signTypeLabel.textAlignment = NSTextAlignmentCenter;
        _signTypeLabel.textColor = kMainBlueColor;
        _signTypeLabel.font = SystemFont(17);
        _signTypeLabel.text = @"签到";
    }
    return _signTypeLabel;
}
- (UILabel *)signTimeLabel {
    if (!_signTimeLabel) {
        _signTimeLabel = [[UILabel alloc] init];
        _signTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_signTimeLabel sizeToFit];
        _signTimeLabel.textColor = kMainBlueColor;
        _signTimeLabel.font = SystemFont(17);
        _signTimeLabel.text = @"19:00";
    }
    return _signTimeLabel;
}
- (UILabel *)signDateLabel {
    if (!_signDateLabel) {
        _signDateLabel = [[UILabel alloc] init];
        _signDateLabel.textAlignment = NSTextAlignmentCenter;
        _signDateLabel.font = SystemFont(17);
        _signDateLabel.text = @"2018.05.06";
    }
    return _signDateLabel;
}
- (UIButton *)signDealButton {
    if (!_signDealButton) {
        _signDealButton = [MPMButton titleButtonWithTitle:@"处理" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"attendence_dispose") hImage:ImageName(@"attendence_dispose")];
        _signDealButton.titleLabel.font = SystemFont(15);
    }
    return _signDealButton;
}

@end
