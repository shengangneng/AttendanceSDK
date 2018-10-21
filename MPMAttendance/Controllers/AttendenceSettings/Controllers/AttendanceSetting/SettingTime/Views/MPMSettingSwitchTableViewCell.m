//
//  MPMSettingSwitchTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/24.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingSwitchTableViewCell.h"
#import "MPMButton.h"

@interface MPMSettingSwitchTableViewCell()

@property (nonatomic, strong) UIButton *lastSelectedButton;

@end

@implementation MPMSettingSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.startNonSwitch addTarget:self action:@selector(startNonRest:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.startNonSwitch];
        [self.startNonSwitch mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@60);
            make.trailing.equalTo(self.mpm_trailing).offset(-15);
            make.centerY.equalTo(self.mpm_centerY);
        }];
    }
    return self;
}

#pragma mark - Target Action
- (void)startNonRest:(UISwitch *)sender {
    if (self.switchDelegate && [self.switchDelegate respondsToSelector:@selector(settingSwithChange:)]) {
        [self.switchDelegate settingSwithChange:sender];
    }
}

#pragma mark - Lazy Init

- (UISwitch *)startNonSwitch {
    if (!_startNonSwitch) {
        _startNonSwitch = [[UISwitch alloc] init];
        [_startNonSwitch sizeToFit];
        _startNonSwitch.onTintColor = kMainBlueColor;
    }
    return _startNonSwitch;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
