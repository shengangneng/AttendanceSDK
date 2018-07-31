//
//  MPMApprovalProcessTableViewCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApprovalProcessTableViewCell.h"
#import "MPMButton.h"
#import "UILabel+MPMExtention.h"

@implementation MPMApprovalProcessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kTableViewBGColor;
        [self setupSubViews];
        [self setupConstaints];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.flagImageView];
    
    [self.flagImageView addSubview:self.flagIcon];
    [self.flagImageView addSubview:self.flagLabel];
    
    [self.containerView addSubview:self.applyPersonLabel];
    [self.containerView addSubview:self.applyPersonMessageLabel];
    [self.containerView addSubview:self.extraApplyLabel];
    [self.containerView addSubview:self.extraApplyMessageLabel];
    [self.containerView addSubview:self.applyDetailLabel];
    [self.containerView addSubview:self.applyDetailMessageLabel];
    [self.containerView addSubview:self.line];
    [self.containerView addSubview:self.seeMoreLabel];
    [self.containerView addSubview:self.dateButton];
}

- (void)setupConstaints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(6);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
    [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(6);
        make.top.equalTo(self.contentView.mas_top).offset(7.5);
        make.width.equalTo(@110);
        make.height.equalTo(@35);
    }];
    [self.flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.flagIcon.mas_trailing).offset(12);
        make.bottom.equalTo(self.flagImageView.mas_bottom);
        make.trailing.equalTo(self.flagImageView.mas_trailing).offset(-2);
        make.height.equalTo(@30);
    }];
    [self.flagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flagLabel.mas_centerY);
        make.width.height.equalTo(@23);
        make.leading.equalTo(self.flagImageView.mas_leading).offset(12.5);
    }];
    [self.applyPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.flagLabel.mas_leading);
        make.top.equalTo(self.flagImageView.mas_bottom);
        make.trailing.equalTo(self.flagLabel.mas_trailing);
        make.height.equalTo(@22);
    }];
    [self.applyPersonMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.applyPersonLabel.mas_trailing).offset(10);
        make.top.equalTo(self.flagImageView.mas_bottom);
        make.trailing.equalTo(self.containerView.mas_trailing);
        make.height.equalTo(@22);
    }];
    [self.extraApplyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.flagLabel.mas_leading);
        make.trailing.equalTo(self.flagLabel.mas_trailing);
        make.top.equalTo(self.applyPersonLabel.mas_bottom);
        make.height.equalTo(@22);
    }];
    [self.extraApplyMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.extraApplyLabel.mas_trailing).offset(10);
        make.top.equalTo(self.applyPersonLabel.mas_bottom);
        make.trailing.equalTo(self.containerView.mas_trailing);
        make.height.equalTo(@22);
    }];
    [self.applyDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.flagLabel.mas_leading);
        make.trailing.equalTo(self.flagLabel.mas_trailing);
        make.top.equalTo(self.extraApplyLabel.mas_bottom);
        make.height.equalTo(@22);
    }];
    [self.applyDetailMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.applyDetailLabel.mas_trailing).offset(10);
        make.top.equalTo(self.applyDetailLabel.mas_top).offset(2.5);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-10);
//        make.height.mas_greaterThanOrEqualTo(22);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.containerView);
        make.top.equalTo(self.applyDetailMessageLabel.mas_bottom).offset(PX_W(5));
        make.height.equalTo(@0.5);
    }];
    [self.seeMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.flagLabel.mas_leading);
        make.trailing.equalTo(self.flagLabel.mas_trailing);
        make.top.equalTo(self.line.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.height.equalTo(@30);
    }];
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-8);
        make.top.equalTo(self.line.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.height.equalTo(@30);
        make.width.equalTo(@120);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIControl * _Nonnull control, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            for (UIView *view in control.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    self.selectImageView = (UIImageView *)view;
                }
            }
        }
    }];
}

#pragma mark - Lazy Init

- (UIImageView *)flagImageView {
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc] init];
    }
    return _flagImageView;
}

- (UIImageView *)flagIcon {
    if (!_flagIcon) {
        _flagIcon = [[UIImageView alloc] init];
        _flagIcon.image = ImageName(@"approval_useravatar");
    }
    return _flagIcon;
}

- (UILabel *)flagLabel {
    if (!_flagLabel) {
        _flagLabel = [[UILabel alloc] init];
        _flagLabel.text = @"待审批";
        _flagLabel.font = SystemFont(14);
        _flagLabel.textColor = kWhiteColor;
        _flagLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _flagLabel;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = kWhiteColor;
    }
    return _containerView;
}

- (UILabel *)applyPersonLabel {
    if (!_applyPersonLabel) {
        _applyPersonLabel = [[UILabel alloc] init];
        _applyPersonLabel.text = @"申请人";
        _applyPersonLabel.font = SystemFont(14);
        _applyDetailLabel.backgroundColor = kClearColor;
        _applyPersonLabel.textColor = kMainLightGray;
        _applyPersonLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _applyPersonLabel;
}

- (UILabel *)applyPersonMessageLabel {
    if (!_applyPersonMessageLabel) {
        _applyPersonMessageLabel = [[UILabel alloc] init];
        _applyPersonMessageLabel.font = SystemFont(14);
        _applyPersonMessageLabel.textAlignment = NSTextAlignmentLeft;
        _applyPersonMessageLabel.text = @"迪丽热巴";
    }
    return _applyPersonMessageLabel;
}

- (UILabel *)extraApplyLabel {
    if (!_extraApplyLabel) {
        _extraApplyLabel = [[UILabel alloc] init];
        _extraApplyLabel.text = @"处理类型";
        _extraApplyLabel.font = SystemFont(14);
        _extraApplyLabel.textColor = kMainLightGray;
        _extraApplyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _extraApplyLabel;
}

- (UILabel *)extraApplyMessageLabel {
    if (!_extraApplyMessageLabel) {
        _extraApplyMessageLabel = [[UILabel alloc] init];
        _extraApplyMessageLabel.font = SystemFont(14);
        _extraApplyMessageLabel.textAlignment = NSTextAlignmentLeft;
        _extraApplyMessageLabel.text = @"事假";
    }
    return _extraApplyMessageLabel;
}

- (UILabel *)applyDetailLabel {
    if (!_applyDetailLabel) {
        _applyDetailLabel = [[UILabel alloc] init];
        _applyDetailLabel.text = @"处理理由";
        _applyDetailLabel.numberOfLines = 0;
        [_applyDetailLabel sizeToFit];
        _applyDetailLabel.font = SystemFont(14);
        _applyDetailLabel.textColor = kMainLightGray;
        _applyDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _applyDetailLabel;
}

- (UILabel *)applyDetailMessageLabel {
    if (!_applyDetailMessageLabel) {
        _applyDetailMessageLabel = [[UILabel alloc] init];
        _applyDetailMessageLabel.numberOfLines = 0;
        [_applyDetailMessageLabel sizeToFit];
        [_applyDetailMessageLabel setAttributedString:@"去参加阿里巴去参加阿里巴去参加阿里巴去参加阿里巴去参加阿里巴去参加阿里巴" font:SystemFont(14) lineSpace:2.5];
        [_applyDetailMessageLabel setContentMode:UIViewContentModeTop];
        _applyDetailMessageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _applyDetailMessageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _applyDetailMessageLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kSeperateColor;
    }
    return _line;
}

- (UILabel *)seeMoreLabel {
    if (!_seeMoreLabel) {
        _seeMoreLabel = [[UILabel alloc] init];
        _seeMoreLabel.text = @"点击查看";
        _seeMoreLabel.font = SystemFont(14);
        _seeMoreLabel.textColor = kMainLightGray;
        _seeMoreLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _seeMoreLabel;
}

- (UIButton *)dateButton {
    if (!_dateButton) {
        _dateButton = [MPMButton rightImageButtonWithTitle:@"2018-04-21" nTitleColor:kMainLightGray hTitleColor:kMainLightGray nImage:ImageName(@"statistics_rightenter") hImage:ImageName(@"statistics_rightenter") titleEdgeInset:UIEdgeInsetsMake(0, 0, 0, -10) imageEdgeInset:UIEdgeInsetsMake(0, 115, 0, 0)];
        _dateButton.userInteractionEnabled = NO;
        _dateButton.titleLabel.font = SystemFont(14);
    }
    return _dateButton;
}

@end
