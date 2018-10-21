//
//  MPMRoundPeopleButton.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMRoundPeopleButton.h"
#import "MPMAttendanceHeader.h"

@implementation MPMRoundPeopleButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.roundPeople];
        [self addSubview:self.deleteIcon];
        [self addSubview:self.nameLabel];
        [self.roundPeople mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.width.height.equalTo(@(kRoundPeopleViewDefaultWidth));
            make.centerX.equalTo(self.mpm_centerX);
            make.top.equalTo(self.mpm_top).offset(2);
        }];
        [self.deleteIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@13.5);
            make.height.equalTo(@13);
            make.top.equalTo(self.roundPeople).offset(-2);
            make.trailing.equalTo(self.roundPeople.mpm_trailing).offset(5);
        }];
        [self.nameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.mpm_bottom);
        }];
    }
    return self;
}

- (MPMRoundPeopleView *)roundPeople {
    if (!_roundPeople) {
        _roundPeople = [[MPMRoundPeopleView alloc] initWithWidth:kRoundPeopleViewDefaultWidth];
        _roundPeople.backgroundColor = kWhiteColor;
    }
    return _roundPeople;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kMainLightGray;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = SystemFont(13);
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UIImageView *)deleteIcon {
    if (!_deleteIcon) {
        _deleteIcon = [[UIImageView alloc] initWithImage:ImageName(@"setting_people_delete")];
        _deleteIcon.userInteractionEnabled = NO;
        _deleteIcon.hidden = YES;
    }
    return _deleteIcon;
}

@end
