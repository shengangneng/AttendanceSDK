//
//  MPMClassSettingSelectWeekTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMClassSettingSelectWeekTableViewCell.h"
#import "MPMButton.h"

@implementation MPMClassSettingSelectWeekTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        [self addSubview:self.checkButton];
        [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@25);
            make.centerY.equalTo(self.mas_centerY);
            make.trailing.equalTo(self.mas_trailing).offset(-15);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkButton.selected = selected;
}

#pragma mark - Lazy Init
- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [MPMButton imageButtonWithImage:ImageName(@"setting_none") hImage:ImageName(@"setting_none")];
        [_checkButton setBackgroundImage:ImageName(@"setting_all") forState:UIControlStateSelected];
        _checkButton.userInteractionEnabled = NO;
    }
    return _checkButton;
}

@end
