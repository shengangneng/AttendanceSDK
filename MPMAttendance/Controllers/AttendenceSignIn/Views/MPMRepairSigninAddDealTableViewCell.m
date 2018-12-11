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
}

- (void)setupSubViews {
    [self addSubview:self.signTypeLabel];
    [self addSubview:self.signTimeLabel];
    [self addSubview:self.signDateLabel];
    [self addSubview:self.checkBox];
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
    [self.checkBox mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.centerY.equalTo(self.mpm_centerY);
        make.width.height.equalTo(@20);
    }];
}

#pragma mark - Target Action

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkBox.image = selected ? ImageName(@"commom_selected") : ImageName(@"commom_notselected");
}

#pragma mark - Lazy Init

- (UILabel *)signTypeLabel {
    if (!_signTypeLabel) {
        _signTypeLabel = [[UILabel alloc] init];
        _signTypeLabel.textAlignment = NSTextAlignmentCenter;
        _signTypeLabel.textColor = kMainBlueColor;
        _signTypeLabel.font = SystemFont(17);
        _signTypeLabel.text = @"打卡";
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

- (UIImageView *)checkBox {
    if (!_checkBox) {
        _checkBox = [[UIImageView alloc] initWithImage:ImageName(@"commom_notselected")];
    }
    return _checkBox;
}

@end

@implementation MPMRepairSigninMonthTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.lastMonthButton];
        [self addSubview:self.thisMonthButton];
        [self.lastMonthButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.top.equalTo(self.mpm_top).offset(10);
            make.bottom.equalTo(self.mpm_bottom).offset(-10);
            make.width.equalTo(@50);
            make.trailing.equalTo(self.mpm_trailing).offset(-15);
        }];
        [self.thisMonthButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.top.equalTo(self.mpm_top).offset(10);
            make.bottom.equalTo(self.mpm_bottom).offset(-10);
            make.width.equalTo(@50);
            make.trailing.equalTo(self.lastMonthButton.mpm_leading).offset(-8);
        }];
        [self.lastMonthButton addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
        [self.thisMonthButton addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setThisMonth:(BOOL)thisMonth {
    _thisMonth = thisMonth;
    if (thisMonth) {
        self.lastMonthButton.selected = NO;
        self.thisMonthButton.selected = YES;
    } else {
        self.lastMonthButton.selected = YES;
        self.thisMonthButton.selected = NO;
    }
}

- (void)changeMonth:(UIButton *)sender {
    self.thisMonth = (sender == self.thisMonthButton);
    if (self.changeMonthBlock) {
        self.changeMonthBlock(self.thisMonth);
    }
}

#pragma mark - Lazy Init
- (MPMDealingBorderButton *)lastMonthButton {
    if (!_lastMonthButton) {
        _lastMonthButton = [[MPMDealingBorderButton alloc] initWithTitle:@"上月" nColor:kLightGrayColor sColor:kMainBlueColor font:SystemFont(15) cornerRadius:5 borderWidth:1];
    }
    return _lastMonthButton;
}

- (MPMDealingBorderButton *)thisMonthButton {
    if (!_thisMonthButton) {
        _thisMonthButton = [[MPMDealingBorderButton alloc] initWithTitle:@"本月" nColor:kLightGrayColor sColor:kMainBlueColor font:SystemFont(15) cornerRadius:5 borderWidth:1];
    }
    return _thisMonthButton;
}

@end
