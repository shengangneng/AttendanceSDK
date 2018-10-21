//
//  MPMSettingClassListTableViewCell.m
//  MPMAtendence
//  考勤班次cell
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingClassListTableViewCell.h"

@implementation MPMSettingClassListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setIsInUsing:(BOOL)isInUsing {
    self.checkImage.image = isInUsing ? ImageName(@"setting_all") : ImageName(@"setting_none");
}

- (void)setupAttributes {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.checkImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check:)]];
}

- (void)setupSubViews {
    [self addSubview:self.checkImage];
    [self addSubview:self.txLable];
    [self addSubview:self.detailTxLable];
}

- (void)setupConstraints {
    [self.checkImage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@(kTableViewHeight));
        make.leading.top.equalTo(self);
    }];
    [self.txLable mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.checkImage.mpm_trailing);
        make.top.bottom.equalTo(self);
        make.width.equalTo(@70);
    }];
    [self.detailTxLable mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.txLable.mpm_trailing).offset(8);
        make.trailing.equalTo(self.mpm_trailing).offset(-30);
        make.top.bottom.equalTo(self);
    }];
}

#pragma mark - Gesture
- (void)check:(UITapGestureRecognizer *)gesture {
    if (self.checkImageBlock) {
        self.checkImageBlock();
    }
}

#pragma mark - Lazy Init
- (UIImageView *)checkImage {
    if (!_checkImage) {
        _checkImage = [[UIImageView alloc] init];
        _checkImage.image = ImageName(@"setting_none");
        _checkImage.contentMode = UIViewContentModeCenter;
        _checkImage.userInteractionEnabled = YES;
    }
    return _checkImage;
}

- (UILabel *)txLable {
    if (!_txLable) {
        _txLable = [[UILabel alloc] init];
        _txLable.font = SystemFont(17);
        _txLable.textColor = kBlackColor;
        _txLable.textAlignment = NSTextAlignmentLeft;
        _txLable.text = @"班次名称";
    }
    return _txLable;
}

- (UILabel *)detailTxLable {
    if (!_detailTxLable) {
        _detailTxLable = [[UILabel alloc] init];
        [_detailTxLable sizeToFit];
        _detailTxLable.font = SystemFont(17);
        _detailTxLable.textColor = kBlackColor;
        _detailTxLable.textAlignment = NSTextAlignmentLeft;
    }
    return _detailTxLable;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
