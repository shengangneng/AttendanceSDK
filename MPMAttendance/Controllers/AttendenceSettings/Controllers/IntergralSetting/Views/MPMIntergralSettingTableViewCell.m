//
//  MPMIntergralSettingTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMIntergralSettingTableViewCell.h"
#import "MPMButton.h"

@implementation MPMIntergralSettingTableViewCell

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
- (void)selectTime:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectTimePickerBlock) {
        self.selectTimePickerBlock(sender);
    }
}

- (void)selectTicket:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectTicketBlock) {
        self.selectTicketBlock(sender);
    }
}

#pragma mark - Init Setup
- (void)setupAttributes {
    self.backgroundColor = kTableViewBGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakself = self;
    self.intergralView.tfBecomeResponderBlock = ^(UITextField *textfield) {
        __strong typeof(weakself) strongself = weakself;
        if (strongself.tfBecomeResponderBlock) {
            strongself.tfBecomeResponderBlock(textfield);
        }
    };
    self.intergralView.changeStateBlock = ^(NSInteger state) {
        __strong typeof(weakself) strongself = weakself;
        if (strongself.changeStateBlock) {
            strongself.changeStateBlock(state);
        }
    };
    self.intergralView.tfChangeTextBlock = ^(NSString *text) {
        __strong typeof(weakself) strongself = weakself;
        if (strongself.tfChangeTextBlock) {
            strongself.tfChangeTextBlock(text);
        }
    };
    [self.selectionButton addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.ticketButton addTarget:self action:@selector(selectTicket:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.bgroundView];
    [self.bgroundView addSubview:self.titleLabel];
    [self.bgroundView addSubview:self.subTitleLabel];
    [self.bgroundView addSubview:self.selectionButton];
    [self.bgroundView addSubview:self.seperateLine];
    [self.bgroundView addSubview:self.intergralView];
    [self.bgroundView addSubview:self.ticketButton];
}

- (void)setupConstraints {
    [self.bgroundView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.mpm_top).offset(5);
        make.bottom.equalTo(self.mpm_bottom).offset(-5);
        make.leading.equalTo(self.mpm_leading).offset(10);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
    }];
    [self.titleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.bgroundView.mpm_top).offset(6);
        make.height.equalTo(@20);
        make.leading.equalTo(self.bgroundView.mpm_leading).offset(15);
    }];
    [self.subTitleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mpm_bottom).offset(4);
        make.height.equalTo(@15);
        make.leading.equalTo(self.bgroundView.mpm_leading).offset(15);
    }];
    [self.ticketButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@75);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.titleLabel.mpm_centerY);
        make.trailing.equalTo(self.bgroundView.mpm_trailing).offset(-15);
    }];
    [self.seperateLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bgroundView.mpm_leading).offset(15);
        make.trailing.equalTo(self.bgroundView.mpm_trailing);
        make.height.equalTo(@1);
        make.centerY.equalTo(self.bgroundView.mpm_centerY);
    }];
    [self.intergralView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bgroundView.mpm_leading).offset(15);
        make.height.equalTo(@26);
        make.width.equalTo(@79.5);
        make.bottom.equalTo(self.bgroundView.mpm_bottom).offset(-12);
    }];
    [self.selectionButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.bgroundView.mpm_bottom).offset(-12);
        make.height.equalTo(@26);
        make.width.equalTo(@79.5);
        make.trailing.equalTo(self.bgroundView.mpm_trailing).offset(-15);
    }];
}

#pragma mark - Lazy Init
#define kShadowPath 1
- (UIImageView *)bgroundView {
    if (!_bgroundView) {
        _bgroundView = [[UIImageView alloc] initWithImage:ImageName(@"setting_integralcell")];
        _bgroundView.userInteractionEnabled = YES;
        _bgroundView.layer.shadowOffset = CGSizeZero;
        _bgroundView.layer.shadowColor = kMainLightGray.CGColor;
        _bgroundView.layer.shadowOpacity = 1.0;
        _bgroundView.layer.shadowRadius = 3;
        _bgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 100 - kShadowPath/2, kScreenWidth - 20, kShadowPath)].CGPath;
        [_bgroundView sizeToFit];
    }
    return _bgroundView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"加班";
        _titleLabel.font = SystemFont(17);
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"例如 加班每小时奖励5分";
        _subTitleLabel.font = SystemFont(13);
        _subTitleLabel.textColor = kMainLightGray;
        [_subTitleLabel sizeToFit];
    }
    return _subTitleLabel;
}
- (UIButton *)selectionButton {
    if (!_selectionButton) {
        _selectionButton = [MPMButton titleButtonWithTitle:@"全天" nTitleColor:kMainBlueColor hTitleColor:kMainBlueColor nBGImage:ImageName(@"setting_integralSelectbox") hImage:ImageName(@"setting_closedintegralSelectbox")];
        _selectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, -26, 0, 0);
        _selectionButton.titleLabel.font = SystemFont(15);
    }
    return _selectionButton;
}
- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = kSeperateColor;
    }
    return _seperateLine;
}
- (MPMIntergralScoreView *)intergralView {
    if (!_intergralView) {
        _intergralView = [[MPMIntergralScoreView alloc] init];
        [_intergralView sizeToFit];
    }
    return _intergralView;
}

- (UIButton *)ticketButton {
    if (!_ticketButton) {
        _ticketButton = [MPMButton rightImageButtonWithTitle:@"奖票" nTitleColor:kMainLightGray hTitleColor:kMainLightGray nImage:ImageName(@"setting_cell_unselected") hImage:ImageName(@"setting_cell_selected") titleEdgeInset:UIEdgeInsetsMake(0, -35, 0, 0) imageEdgeInset:UIEdgeInsetsMake(0, 55, 0, 0)];
        [_ticketButton setImage:ImageName(@"setting_cell_selected") forState:UIControlStateSelected];
        _ticketButton.titleLabel.font = SystemFont(17);
    }
    return _ticketButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
