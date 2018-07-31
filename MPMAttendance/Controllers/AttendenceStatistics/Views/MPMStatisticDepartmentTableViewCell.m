//
//  MPMStatisticDepartmentTableViewCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMStatisticDepartmentTableViewCell.h"

@implementation MPMStatisticDepartmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.image];
    [self addSubview:self.titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init
#define leftMargin (kScreenWidth - PX_W(690))/2
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.frame = CGRectMake(leftMargin, (PX_H(96) - PX_W(48))/2, PX_W(48), PX_W(48));
    }
    return _image;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(leftMargin+PX_W(72), 0, PX_W(300), PX_H(96));
        _titleLabel.font = SystemFont(PX_W(40));
    }
    return _titleLabel;
}

@end
