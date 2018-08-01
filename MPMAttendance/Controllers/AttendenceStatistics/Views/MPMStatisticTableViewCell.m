//
//  MPMStatisticTableViewCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMStatisticTableViewCell.h"

@implementation MPMStatisticTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

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
    self.separatorInset = UIEdgeInsetsMake(0, 46, 0, 0);
}

- (void)setupSubViews {
    [self addSubview:self.image];
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.scoreLabel];
}

- (void)setupConstraints {
    [self.image mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(12);
        make.centerY.equalTo(self.mpm_centerY);
        make.width.equalTo(@(24));
        make.height.equalTo(@(24));
    }];
    [self.titleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.image.mpm_trailing).offset(10);
        make.centerY.equalTo(self.mpm_centerY);
        make.height.equalTo(self);
    }];
    [self.countLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.mpm_centerY);
        make.centerX.equalTo(self.mpm_centerX);
        make.height.equalTo(self);
    }];
    [self.scoreLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.mpm_trailing).offset(-35);
        make.centerY.equalTo(self.mpm_centerY);
        make.height.equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
    }
    return _image;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel sizeToFit];
        _titleLabel.font = SystemFont(17);
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [_countLabel sizeToFit];
        _countLabel.font = SystemFont(17);
    }
    return _countLabel;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentRight;
        _scoreLabel.font = SystemFont(17);
    }
    return _scoreLabel;
}

@end
