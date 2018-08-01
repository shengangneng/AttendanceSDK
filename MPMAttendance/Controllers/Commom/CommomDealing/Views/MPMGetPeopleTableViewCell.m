//
//  MPMGetPeopleTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/15.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMGetPeopleTableViewCell.h"
#import "MPMButton.h"

@implementation MPMGetPeopleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Target Action
- (void)delete:(UIButton *)sender {
    
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.accessDeleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.checkButton];
    [self addSubview:self.iconImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.depertLabel];
    [self addSubview:self.accessDeleteButton];
}

- (void)setupConstraints {
    [self.checkButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(12);
        make.width.height.equalTo(@(25));
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.iconImage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.checkButton.mpm_trailing).offset(10);
        make.width.height.equalTo(@(30));
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.nameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.iconImage.mpm_trailing).offset(10);
        make.height.equalTo(self.mpm_height);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.depertLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mpm_trailing).offset(5);
        make.height.equalTo(self.mpm_height);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.accessDeleteButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@12.5);
        make.centerY.equalTo(self.mpm_centerY);
        make.trailing.equalTo(self.mpm_trailing).offset(-15);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkButton.selected = selected;
}

#pragma mark - Lazy Init

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [MPMButton imageButtonWithImage:ImageName(@"setting_none") hImage:ImageName(@"setting_none")];
        _checkButton.userInteractionEnabled = NO;
        [_checkButton setBackgroundImage:ImageName(@"setting_all") forState:UIControlStateSelected];
    }
    return _checkButton;
}
- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = ImageName(@"approval_useravatar_mid");
    }
    return _iconImage;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"梅梅";
        [_nameLabel sizeToFit];
        _nameLabel.textColor = kBlackColor;
    }
    return _nameLabel;
}
- (UILabel *)depertLabel {
    if (!_depertLabel) {
        _depertLabel = [[UILabel alloc] init];
        [_depertLabel sizeToFit];
        _depertLabel.textColor = kMainLightGray;
    }
    return _depertLabel;
}

- (UIButton *)accessDeleteButton {
    if (!_accessDeleteButton) {
        _accessDeleteButton = [MPMButton imageButtonWithImage:ImageName(@"approval_delete") hImage:ImageName(@"approval_delete")];
        _accessDeleteButton.hidden = YES;
    }
    return _accessDeleteButton;
}

@end
