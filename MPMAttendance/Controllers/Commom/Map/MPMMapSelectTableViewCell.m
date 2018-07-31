//
//  MPMMapSelectTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/7/26.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMMapSelectTableViewCell.h"

@interface MPMMapSelectTableViewCell ()

@end

@implementation MPMMapSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupSubViews {
    [self addSubview:self.checkLocationImage];
}

- (void)setupConstraints {
    [self.checkLocationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY);
        make.trailing.equalTo(self.mas_trailing).offset(-15);
    }];
}

- (void)setCheckLocation:(BOOL)checkLocation {
    _checkLocation = checkLocation;
    if (checkLocation) {
        self.checkLocationImage.image = ImageName(@"setting_all");
    } else {
        self.checkLocationImage.image = nil;
    }
}

- (UIImageView *)checkLocationImage {
    if (!_checkLocationImage) {
        _checkLocationImage = [[UIImageView alloc] init];
        _checkLocationImage.userInteractionEnabled = YES;
    }
    return _checkLocationImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
