//
//  MPMAttendenceSettingTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceSettingTableViewCell.h"
#import "MPMButton.h"
#import "MPMAttendenceSettingModel.h"

@implementation MPMAttendenceSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setModel:(MPMAttendenceSettingModel *)model {
    // 参与部门和人员
    if (model.schedulingDepartments.count > 0 || model.schedulingEmplyoees.count > 0) {
        [self.workScopeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.line.mas_bottom);
            make.height.equalTo(@28);
        }];
        [self.workScopeIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workScopeView.mas_leading).offset(10);
            make.top.equalTo(self.workScopeView.mas_top).offset(3);
            make.width.equalTo(@23);
            make.height.equalTo(@23);
        }];
        [self.workScopeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workScopeIcon.mas_trailing).offset(10);
            make.top.trailing.equalTo(self.workScopeView);
            make.height.equalTo(@28);
        }];
    } else {
        [self.workScopeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.line.mas_bottom);
            make.height.equalTo(@0);
        }];
    }
    
    // 调整班次位置
    if (model.slotTimeDtos.count <= 0) {
        [self.classView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.workScopeView.mas_bottom);
            make.height.equalTo(@0);
        }];
    } else if (model.slotTimeDtos.count > 2) {
        [self.classView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.workScopeView.mas_bottom);
            make.height.equalTo(@56);
        }];
        [self.classIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.classView.mas_leading).offset(10);
            make.top.equalTo(self.classView.mas_top).offset(3);
            make.width.equalTo(@23);
            make.height.equalTo(@23);
        }];
        [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.classIcon.mas_trailing).offset(10);
            make.top.trailing.equalTo(self.classView);
            make.height.equalTo(@28);
        }];
        [self.classLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.classIcon.mas_trailing).offset(10);
            make.top.equalTo(self.classLabel.mas_bottom);
            make.height.equalTo(@28);
            make.trailing.equalTo(self.classView);
        }];
    } else {
        [self.classView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.workScopeView.mas_bottom);
            make.height.equalTo(@28);
        }];
        [self.classIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.classView.mas_leading).offset(10);
            make.top.equalTo(self.classView.mas_top).offset(3);
            make.width.equalTo(@23);
            make.height.equalTo(@23);
        }];
        [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.classIcon.mas_trailing).offset(10);
            make.height.equalTo(@28);
            make.top.trailing.equalTo(self.classView);
        }];
        [self.classLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.classIcon.mas_trailing).offset(10);
            make.top.equalTo(self.classLabel.mas_bottom);
            make.bottom.trailing.equalTo(self.classView);
        }];
    }
    // 考勤日期
    if (kIsNilString(model.cycle)) {
        [self.workDateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.classView.mas_bottom);
            make.height.equalTo(@0);
        }];
    } else {
        [self.workDateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.classView.mas_bottom);
            make.height.equalTo(@28);
        }];
        [self.workDateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workDateView.mas_leading).offset(10);
            make.centerY.equalTo(self.workDateView.mas_centerY);
            make.width.equalTo(@23);
            make.height.equalTo(@23);
        }];
        [self.workDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workDateIcon.mas_trailing).offset(10);
            make.centerY.equalTo(self.workDateView.mas_centerY);
            make.top.bottom.trailing.equalTo(self.workDateView);
        }];
    }
    // 地址
    if (kIsNilString(model.address)) {
        [self.workLocationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.workDateView.mas_bottom);
            make.height.equalTo(@0);
        }];
    } else {
        [self.workLocationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.workDateView.mas_bottom);
            make.height.equalTo(@28);
        }];
        [self.workLocationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workLocationView.mas_leading).offset(10);
            make.centerY.equalTo(self.workLocationView.mas_centerY);
            make.width.equalTo(@23);
            make.height.equalTo(@23);
        }];
        [self.workLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workLocationIcon.mas_trailing).offset(10);
            make.centerY.equalTo(self.workLocationView.mas_centerY);
            make.top.bottom.trailing.equalTo(self.workLocationView);
        }];
    }
    
    // 调整wifi位置
    if (kIsNilString(model.wifiName)) {
        [self.workWifiView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentImageView);
            make.top.equalTo(self.workEffectDateView.mas_bottom);
            make.height.equalTo(@0);
        }];
        [self.workWifiIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workWifiView.mas_leading).offset(10);
            make.centerY.equalTo(self.workWifiView.mas_centerY);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
        [self.workWifiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.workWifiIcon.mas_trailing).offset(10);
            make.centerY.equalTo(self.workWifiView.mas_centerY);
            make.top.bottom.trailing.equalTo(self.workWifiView);
        }];
    }
}

- (void)setupAttributes {
    self.backgroundColor = kTableViewBGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.headerDeleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    // 排班设置、班次设置、时间设置、打开设置
    [self.settingRageClassButton addTarget:self action:@selector(rageClass:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingClassButton addTarget:self action:@selector(settingClass:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingTimeButton addTarget:self action:@selector(settingTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingCardButton addTarget:self action:@selector(settingCard:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.contentImageView];
    
    [self.contentImageView addSubview:self.headerTitleLabel];
    [self.contentImageView addSubview:self.headerDeleteButton];
    [self.contentImageView addSubview:self.line];
    // 范围
    [self.contentImageView addSubview:self.workScopeView];
    [self.workScopeView addSubview:self.workScopeIcon];
    [self.workScopeView addSubview:self.workScopeLabel];
    
    // 班次
    [self.contentImageView addSubview:self.classView];
    [self.classView addSubview:self.classIcon];
    [self.classView addSubview:self.classLabel];
    [self.classView addSubview:self.classLabel2];
    
    // 考勤日期
    [self.contentImageView addSubview:self.workDateView];
    [self.workDateView addSubview:self.workDateIcon];
    [self.workDateView addSubview:self.workDateLabel];
    
    // 地点
    [self.contentImageView addSubview:self.workLocationView];
    [self.workLocationView addSubview:self.workLocationIcon];
    [self.workLocationView addSubview:self.workLocationLabel];
    
    // 考勤有效期
    [self.contentImageView addSubview:self.workEffectDateView];
    [self.workEffectDateView addSubview:self.workEffectDateIcon];
    [self.workEffectDateView addSubview:self.workEffectDateLabel];
    
    // wifi名称
    [self.contentImageView addSubview:self.workWifiView];
    [self.workWifiView addSubview:self.workWifiIcon];
    [self.workWifiView addSubview:self.workWifiLabel];
    
    [self.contentImageView addSubview:self.settingRageClassButton];
    [self.contentImageView addSubview:self.settingClassButton];
    [self.contentImageView addSubview:self.settingTimeButton];
    [self.contentImageView addSubview:self.settingCardButton];
}

- (void)setupConstraints {
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(12.5);
        make.trailing.equalTo(self.mas_trailing).offset(-12.5);
        make.top.equalTo(self.mas_top).offset(6);
        make.bottom.equalTo(self.mas_bottom).offset(-6);
    }];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentImageView).offset(10);
        make.top.equalTo(self.contentImageView.mas_top);
        make.height.equalTo(@30);
    }];
    [self.headerDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerTitleLabel.mas_centerY);
        make.width.equalTo(@15.5);
        make.height.equalTo(@18);
        make.trailing.equalTo(self.contentImageView.mas_trailing).offset(-10);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentImageView.mas_leading).offset(10);
        make.height.equalTo(@1);
        make.trailing.equalTo(self.contentImageView.mas_trailing);
        make.top.equalTo(self.headerTitleLabel.mas_bottom);
    }];
    // 范围
    [self.workScopeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentImageView);
        make.top.equalTo(self.line.mas_bottom);
    }];
    
    // 班次
    [self.classView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentImageView);
        make.top.equalTo(self.workScopeView.mas_bottom);
        make.height.equalTo(@28);
    }];
    
    // 考勤日期
    [self.workDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentImageView);
        make.top.equalTo(self.classView.mas_bottom);
        make.height.equalTo(@28);
    }];
    
    // 地点
    [self.workLocationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentImageView);
        make.top.equalTo(self.workDateView.mas_bottom);
        make.height.equalTo(@28);
    }];
    
    // 考勤有效期
    [self.workEffectDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentImageView);
        make.top.equalTo(self.workLocationView.mas_bottom);
        make.height.equalTo(@28);
    }];
    [self.workEffectDateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.workEffectDateView.mas_leading).offset(10);
        make.centerY.equalTo(self.workEffectDateView.mas_centerY);
        make.width.equalTo(@23);
        make.height.equalTo(@23);
    }];
    [self.workEffectDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.workEffectDateIcon.mas_trailing).offset(10);
        make.centerY.equalTo(self.workEffectDateView.mas_centerY);
        make.top.bottom.trailing.equalTo(self.workEffectDateView);
    }];
    
    // wifi名称
    [self.workWifiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentImageView);
        make.top.equalTo(self.workEffectDateView.mas_bottom);
        make.height.equalTo(@28);
    }];
    [self.workWifiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.workWifiView.mas_leading).offset(10);
        make.centerY.equalTo(self.workWifiView.mas_centerY);
        make.width.equalTo(@23);
        make.height.equalTo(@23);
    }];
    [self.workWifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.workWifiIcon.mas_trailing).offset(10);
        make.centerY.equalTo(self.workWifiView.mas_centerY);
        make.top.bottom.trailing.equalTo(self.workWifiView);
    }];
    // 排班设置、班次设置、时间设置、打卡设置
    NSInteger btnWidth = 54;
    NSInteger border = (kScreenWidth - (btnWidth * 4))/5;
    [self.settingRageClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentImageView.mas_leading).offset(10);
        make.bottom.equalTo(self.contentImageView.mas_bottom).offset(-5);
        make.height.equalTo(@30);
    }];
    [self.settingClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.settingRageClassButton.mas_trailing).offset(border);
        make.width.equalTo(self.settingRageClassButton.mas_width);
        make.bottom.equalTo(self.contentImageView.mas_bottom).offset(-5);
        make.height.equalTo(@30);
    }];
    [self.settingTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.settingClassButton.mas_trailing).offset(border);
        make.width.equalTo(self.settingRageClassButton.mas_width);
        make.bottom.equalTo(self.contentImageView.mas_bottom).offset(-5);
        make.height.equalTo(@30);
    }];
    [self.settingCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.settingTimeButton.mas_trailing).offset(border);
        make.width.equalTo(self.settingRageClassButton.mas_width);
        make.trailing.equalTo(self.contentImageView.mas_trailing).offset(-10);
        make.bottom.equalTo(self.contentImageView.mas_bottom).offset(-5);
        make.height.equalTo(@30);
    }];
    
}

#pragma mark - Target Action
- (void)delete:(UIButton *)sender {
    // 右上角删除
    if (self.deleteBlock) {
        self.deleteBlock(sender);
    }
}
- (void)rageClass:(UIButton *)sender {
    // 排班设置
    if (self.settingRageClassBlock) {
        self.settingRageClassBlock(sender);
    }
}
- (void)settingClass:(UIButton *)sender {
    // 班次设置
    if (self.settingClassBlock) {
        self.settingClassBlock(sender);
    }
}
- (void)settingTime:(UIButton *)sender {
    // 时间设置
    if (self.settingTimeBlock) {
        self.settingTimeBlock(sender);
    }
}
- (void)settingCard:(UIButton *)sender {
    // 打卡设置
    if (self.settingCardBlock) {
        self.settingCardBlock(sender);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.layer.cornerRadius = 5;
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.backgroundColor = kWhiteColor;
        _contentImageView.userInteractionEnabled = YES;
        _contentImageView.image = ImageName(@"setting_cell");
    }
    return _contentImageView;
}
- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.font = SystemFont(18);
    }
    return _headerTitleLabel;
}

- (UIButton *)headerDeleteButton {
    if (!_headerDeleteButton) {
        _headerDeleteButton = [MPMButton imageButtonWithImage:ImageName(@"setting_delete") hImage:ImageName(@"setting_delete")];
    }
    return _headerDeleteButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kSeperateColor;
    }
    return _line;
}
// 范围
- (UIView *)workScopeView {
    if (!_workScopeView) {
        _workScopeView = [[UIView alloc] init];
        _workScopeView.backgroundColor = kWhiteColor;
    }
    return _workScopeView;
}
- (UIImageView *)workScopeIcon {
    if (!_workScopeIcon) {
        _workScopeIcon = [[UIImageView alloc] init];
        _workScopeIcon.image = ImageName(@"setting_scope");
    }
    return _workScopeIcon;
}
- (UILabel *)workScopeLabel {
    if (!_workScopeLabel) {
        _workScopeLabel = [[UILabel alloc] init];
        _workScopeLabel.textColor = kMainLightGray;
        _workScopeLabel.font = SystemFont(13);
    }
    return _workScopeLabel;
}

// 班次
- (UIView *)classView {
    if (!_classView) {
        _classView = [[UIView alloc] init];
        _classView.backgroundColor = kWhiteColor;
    }
    return _classView;
}
- (UIImageView *)classIcon {
    if (!_classIcon) {
        _classIcon = [[UIImageView alloc] init];
        _classIcon.image = ImageName(@"setting_classes");
    }
    return _classIcon;
}
- (UILabel *)classLabel {
    if (!_classLabel) {
        _classLabel = [[UILabel alloc] init];
        _classLabel.textColor = kBlackColor;
        _classLabel.font = SystemFont(13);
    }
    return _classLabel;
}
- (UILabel *)classLabel2 {
    if (!_classLabel2) {
        _classLabel2 = [[UILabel alloc] init];
        _classLabel2.textColor = kBlackColor;
        _classLabel2.text = @"第三班次";
        _classLabel2.font = SystemFont(13);
    }
    return _classLabel2;
}

// 考勤日期
- (UIView *)workDateView {
    if (!_workDateView) {
        _workDateView = [[UIView alloc] init];
        _workDateView.backgroundColor = kWhiteColor;
    }
    return _workDateView;
}
- (UIImageView *)workDateIcon {
    if (!_workDateIcon) {
        _workDateIcon = [[UIImageView alloc] init];
        _workDateIcon.image = ImageName(@"setting_date");
    }
    return _workDateIcon;
}
- (UILabel *)workDateLabel {
    if (!_workDateLabel) {
        _workDateLabel = [[UILabel alloc] init];
        _workDateLabel.textColor = kBlackColor;
        _workDateLabel.font = SystemFont(13);
    }
    return _workDateLabel;
}

// 地点
- (UIView *)workLocationView {
    if (!_workLocationView) {
        _workLocationView = [[UIView alloc] init];
        _workLocationView.backgroundColor = kWhiteColor;
    }
    return _workLocationView;
}
- (UIImageView *)workLocationIcon {
    if (!_workLocationIcon) {
        _workLocationIcon = [[UIImageView alloc] init];
        _workLocationIcon.image = ImageName(@"setting_location");
    }
    return _workLocationIcon;
}
- (UILabel *)workLocationLabel {
    if (!_workLocationLabel) {
        _workLocationLabel = [[UILabel alloc] init];
        _workLocationLabel.textColor = kMainLightGray;
        _workLocationLabel.font = SystemFont(13);
    }
    return _workLocationLabel;
}

// 考勤有效期
- (UIView *)workEffectDateView {
    if (!_workEffectDateView) {
        _workEffectDateView = [[UIView alloc] init];
        _workEffectDateView.backgroundColor = kWhiteColor;
    }
    return _workEffectDateView;
}
- (UIImageView *)workEffectDateIcon {
    if (!_workEffectDateIcon) {
        _workEffectDateIcon = [[UIImageView alloc] init];
        _workEffectDateIcon.image = ImageName(@"setting_effectivedate");
    }
    return _workEffectDateIcon;
}
- (UILabel *)workEffectDateLabel {
    if (!_workEffectDateLabel) {
        _workEffectDateLabel = [[UILabel alloc] init];
        _workEffectDateLabel.textColor = kMainLightGray;
        _workEffectDateLabel.font = SystemFont(13);
    }
    return _workEffectDateLabel;
}

// wifi名称
- (UIView *)workWifiView {
    if (!_workWifiView) {
        _workWifiView = [[UIView alloc] init];
        _workWifiView.backgroundColor = kWhiteColor;
    }
    return _workWifiView;
}
- (UIImageView *)workWifiIcon {
    if (!_workWifiIcon) {
        _workWifiIcon = [[UIImageView alloc] init];
        _workWifiIcon.image = ImageName(@"setting_wifi");
    }
    return _workWifiIcon;
}
- (UILabel *)workWifiLabel {
    if (!_workWifiLabel) {
        _workWifiLabel = [[UILabel alloc] init];
        _workWifiLabel.textColor = kMainLightGray;
        _workWifiLabel.font = SystemFont(13);
    }
    return _workWifiLabel;
}

///
- (UIButton *)settingRageClassButton {
    if (!_settingRageClassButton) {
        _settingRageClassButton = [MPMButton titleButtonWithTitle:@"排班设置" nTitleColor:kWhiteColor hTitleColor:kMainLightGray bgColor:kClearColor];
        _settingRageClassButton.titleLabel.font = SystemFont(13);
    }
    return _settingRageClassButton;
}
- (UIButton *)settingClassButton {
    if (!_settingClassButton) {
        _settingClassButton = [MPMButton titleButtonWithTitle:@"班次设置" nTitleColor:kWhiteColor hTitleColor:kMainLightGray bgColor:kClearColor];
        _settingClassButton.titleLabel.font = SystemFont(13);
    }
    return _settingClassButton;
}
- (UIButton *)settingTimeButton {
    if (!_settingTimeButton) {
        _settingTimeButton = [MPMButton titleButtonWithTitle:@"时间设置" nTitleColor:kWhiteColor hTitleColor:kMainLightGray bgColor:kClearColor];
        _settingTimeButton.titleLabel.font = SystemFont(13);
    }
    return _settingTimeButton;
}
- (UIButton *)settingCardButton {
    if (!_settingCardButton) {
        _settingCardButton = [MPMButton titleButtonWithTitle:@"打卡设置" nTitleColor:kWhiteColor hTitleColor:kMainLightGray bgColor:kClearColor];
        _settingCardButton.titleLabel.font = SystemFont(13);
    }
    return _settingCardButton;
}

@end
