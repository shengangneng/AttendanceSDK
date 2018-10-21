//
//  MPMClassSettingImageTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMClassSettingImageTableViewCell.h"

@implementation MPMClassSettingImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self addSubview:self.detailImageView];
        [self addSubview:self.detailTxLabel];
        [self.detailImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@18.5);
            make.trailing.equalTo(self.mpm_trailing).offset(-15);
            make.centerY.equalTo(self.mpm_centerY);
        }];
        [self.detailTxLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.equalTo(self.textLabel.mpm_trailing).offset(5);
            make.trailing.equalTo(self.detailImageView.mpm_leading).offset(-5);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init

- (UILabel *)detailTxLabel {
    if (!_detailTxLabel) {
        _detailTxLabel = [[UILabel alloc] init];
        _detailTxLabel.textColor = kMainLightGray;
        _detailTxLabel.textAlignment = NSTextAlignmentRight;
        _detailTxLabel.font = SystemFont(17);
    }
    return _detailTxLabel;
}

- (UIImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = [[UIImageView alloc] init];
        _detailImageView.image = ImageName(@"setting_classdate");
    }
    return _detailImageView;
}

@end
