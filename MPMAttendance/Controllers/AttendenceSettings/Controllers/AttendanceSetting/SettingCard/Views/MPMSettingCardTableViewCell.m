//
//  MPMSettingCardTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingCardTableViewCell.h"

@implementation MPMSettingCardTableViewCell

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
    self.separatorInset = UIEdgeInsetsMake(0, 43, 0, 0);
}

- (void)setupSubViews {
    [self addSubview:self.imageIcon];
    [self addSubview:self.txLabel];
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
        make.centerY.equalTo(self.mpm_centerY);
        make.top.bottom.equalTo(self);
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
        _txLabel.textColor = kBlackColor;
        [_txLabel sizeToFit];
        _txLabel.font = SystemFont(17);
        _txLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txLabel;
}
@end
