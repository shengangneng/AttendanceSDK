//
//  MPMAttendenceBaseTableViewCell.m
//  MPMAtendence
//  V1.1版本考勤设置主页Cell
//  Created by shengangneng on 2018/6/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceBaseTableViewCell.h"

@implementation MPMAttendenceBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)switchChange:(UISwitch *)signSwitch {
    if (self.switchChangeBlock) {
        self.switchChangeBlock(signSwitch);
    }
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.signSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupSubViews {
    [self addSubview:self.iconView];
    [self addSubview:self.txLabel];
    [self addSubview:self.signSwitch];
}

- (void)setupConstraints {
    [self.iconView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(13);
        make.width.height.equalTo(@24);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mpm_trailing).offset(13);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.signSwitch mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.mpm_trailing).offset(-15);
        make.centerY.equalTo(self.mpm_centerY);
    }];
}

#pragma mark - Lazy Init

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}
- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        _txLabel.font = SystemFont(17);
        [_txLabel sizeToFit];
    }
    return _txLabel;
}
- (UISwitch *)signSwitch {
    if (!_signSwitch) {
        _signSwitch = [[UISwitch alloc] init];
        _signSwitch.hidden = YES;
        _signSwitch.onTintColor = kMainBlueColor;
    }
    return _signSwitch;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
