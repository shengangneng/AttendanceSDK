//
//  MPMSelectDepartmentTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/24.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSelectDepartmentTableViewCell.h"
#import "MPMButton.h"

@implementation MPMSelectDepartmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.checkIconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check:)]];
        
        [self addSubview:self.checkIconImage];
        [self addSubview:self.humanIconImage];
        [self addSubview:self.txLabel];
        [self.checkIconImage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(12);
            make.width.height.equalTo(@25);
            make.centerY.equalTo(self.mpm_centerY);
        }];
        [self.humanIconImage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.checkIconImage.mpm_trailing).offset(10);
            make.width.height.equalTo(@30);
            make.centerY.equalTo(self.mpm_centerY);
        }];
        [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.humanIconImage.mpm_trailing).offset(10);
            make.trailing.equalTo(self.mpm_trailing).offset(-35);
            make.top.bottom.equalTo(self);
            make.centerY.equalTo(self.mpm_centerY);
        }];
    }
    return self;
}

- (void)setIsHuman:(NSString *)isHuman {
    _isHuman = isHuman;
    if (isHuman && isHuman.integerValue == 1) {
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.humanIconImage mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.checkIconImage.mpm_trailing).offset(10);
            make.width.height.equalTo(@30);
            make.centerY.equalTo(self.mpm_centerY);
        }];
    } else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.humanIconImage mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.checkIconImage.mpm_trailing).offset(0);
            make.height.equalTo(@30);
            make.width.equalTo(@0);
            make.centerY.equalTo(self.mpm_centerY);
        }];
    }
    [self layoutIfNeeded];
}

- (void)check:(UITapGestureRecognizer *)gesture {
    if (self.checkImageBlock) {
        self.checkImageBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init
- (UIImageView *)checkIconImage {
    if (!_checkIconImage) {
        _checkIconImage = [[UIImageView alloc] init];
        _checkIconImage.image = ImageName(@"setting_none");
        _checkIconImage.userInteractionEnabled = YES;
    }
    return _checkIconImage;
}

- (UIImageView *)humanIconImage {
    if (!_humanIconImage) {
        _humanIconImage = [[UIImageView alloc] initWithImage:ImageName(@"approval_useravatar_mid")];
    }
    return _humanIconImage;
}

- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        [_txLabel sizeToFit];
    }
    return _txLabel;
}

@end
