//
//  MPMSettingCardDetailTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingCardDetailTableViewCell.h"

@implementation MPMSettingCardDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstaints];
    }
    return self;
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupSubViews {
    [self addSubview:self.imageIcon];
    [self addSubview:self.txLabel];
    [self addSubview:self.txDetailLabel];
}

- (void)setupConstaints {
    [self.imageIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(13);
        make.centerY.equalTo(self.mpm_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.imageIcon.mpm_trailing).offset(10);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.top.equalTo(self.mpm_top);
        make.height.equalTo(@25);
    }];
    [self.txDetailLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.imageIcon.mpm_trailing).offset(10);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.top.equalTo(self.txLabel.mpm_bottom);
        make.height.equalTo(@25);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init

- (UIImageView *)imageIcon {
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc] init];
        _imageIcon.image = ImageName(@"setting_addition");
    }
    return _imageIcon;
}

- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        [_txLabel sizeToFit];
        _txLabel.textColor = kBlackColor;
        _txLabel.font = SystemFont(17);
        _txLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txLabel;
}

- (UILabel *)txDetailLabel {
    if (!_txDetailLabel) {
        _txDetailLabel = [[UILabel alloc] init];
        [_txDetailLabel sizeToFit];
        _txDetailLabel.textColor = kMainLightGray;
        _txDetailLabel.font = SystemFont(13);
        _txDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txDetailLabel;
}

@end
