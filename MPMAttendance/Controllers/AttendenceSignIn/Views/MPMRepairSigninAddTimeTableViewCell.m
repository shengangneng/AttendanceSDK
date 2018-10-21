//
//  MPMRepairSigninAddTimeTableViewCell.m
//  MPMAtendence
//  +增加自由补签时间
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMRepairSigninAddTimeTableViewCell.h"

@interface MPMRepairSigninAddTimeTableViewCell ()

@end

@implementation MPMRepairSigninAddTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.addTimeButton];
        [self.addTimeButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.height.equalTo(self);
            make.center.equalTo(self);
            make.width.equalTo(@250);
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
- (UIButton *)addTimeButton {
    if (!_addTimeButton) {
        _addTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addTimeButton.userInteractionEnabled = NO;
        [_addTimeButton setTitle:@"+ 增加自由补签时间" forState:UIControlStateNormal];
        [_addTimeButton setTitleColor:kMainBlueColor forState:UIControlStateNormal];
    }
    return _addTimeButton;
}

@end
