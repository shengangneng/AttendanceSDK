//
//  MPMApprovalProcessDetailTableViewCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/3.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApprovalProcessDetailTableViewCell.h"

@implementation MPMApprovalProcessDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kTableViewBGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.detailTitleLabel];
    [self addSubview:self.detailMessageImageView];
    [self.detailMessageImageView addSubview:self.detailMessageIcon];
    [self.detailMessageImageView addSubview:self.detailMessageName];
    [self.detailMessageImageView addSubview:self.detailMessageTime];
    [self.detailMessageImageView addSubview:self.detailMessageDetailText];
}

- (void)setupConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.width.equalTo(@30);
    }];
    [self.detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(15);
        make.top.equalTo(self.iconImageView.mas_top);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    [self.detailMessageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
        make.top.equalTo(self.detailTitleLabel.mas_bottom);
        make.trailing.equalTo(self.mas_trailing).offset(-14);
        make.height.equalTo(@50);
    }];
    [self.detailMessageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.detailMessageImageView.mas_leading).offset(15);
        make.top.equalTo(self.detailMessageImageView.mas_top).offset(8);
        make.width.height.equalTo(@13);
    }];
    [self.detailMessageName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.detailMessageImageView.mas_leading).offset(36);
        make.centerY.equalTo(self.detailMessageIcon.mas_centerY);
        make.height.equalTo(@25);
    }];
    [self.detailMessageTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.detailMessageImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.detailMessageIcon.mas_centerY);
        make.height.equalTo(@25);
    }];
    [self.detailMessageDetailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.detailMessageImageView.mas_leading).offset(36);
        make.top.equalTo(self.detailMessageName.mas_bottom);
        make.trailing.equalTo(self.detailMessageImageView.mas_trailing).offset(-10);
        make.height.equalTo(@25);
    }];
}

#pragma mark - Lazy Init
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = ImageName(@"approval_useravatar_mid");
    }
    return _iconImageView;
}
- (UILabel *)detailTitleLabel {
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.backgroundColor = kClearColor;
        _detailTitleLabel.text = @"审批";
        _detailTitleLabel.font = SystemFont(14);
        _detailTitleLabel.textColor = kMainLightGray;
    }
    return _detailTitleLabel;
}
- (UIImageView *)detailMessageImageView {
    if (!_detailMessageImageView) {
        _detailMessageImageView = [[UIImageView alloc] init];
        _detailMessageImageView.image = ImageName(@"approval_detail_infobox");
    }
    return _detailMessageImageView;
}
- (UIImageView *)detailMessageIcon {
    if (!_detailMessageIcon) {
        _detailMessageIcon = [[UIImageView alloc] init];
        _detailMessageIcon.image = ImageName(@"approval_detail_passed");
    }
    return _detailMessageIcon;
}
- (UILabel *)detailMessageName {
    if (!_detailMessageName) {
        _detailMessageName = [[UILabel alloc] init];
        _detailMessageName.text = @"李强";
        [_detailMessageName sizeToFit];
        _detailMessageName.font = SystemFont(14);
    }
    return _detailMessageName;
}
- (UILabel *)detailMessageTime {
    if (!_detailMessageTime) {
        _detailMessageTime = [[UILabel alloc] init];
        _detailMessageTime.textAlignment = NSTextAlignmentRight;
        _detailMessageTime.text = @"2月9日 18：20";
        [_detailMessageTime sizeToFit];
        _detailMessageTime.font = SystemFont(14);
        _detailMessageTime.textColor = kMainLightGray;
    }
    return _detailMessageTime;
}
- (UILabel *)detailMessageDetailText {
    if (!_detailMessageDetailText) {
        _detailMessageDetailText = [[UILabel alloc] init];
        _detailMessageDetailText.text = @"记录人奖分：20";
        _detailMessageDetailText.font = SystemFont(14);
        _detailMessageDetailText.textColor = kMainLightGray;
    }
    return _detailMessageDetailText;
}

@end
