//
//  MPMCommomDealingAddCellTableViewCell.m
//  MPMAtendence
//  增加内容
//  Created by shengangneng on 2018/5/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCommomDealingAddCellTableViewCell.h"

@interface MPMCommomDealingAddCellTableViewCell ()

@property (nonatomic, strong) UIButton *addTimeButton;

@end

@implementation MPMCommomDealingAddCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier btnTitle:(NSString *)btnTitle {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.addTimeButton setTitle:btnTitle forState:UIControlStateNormal];
        [self addSubview:self.addTimeButton];
        [self.addTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        [_addTimeButton setTitleColor:kMainBlueColor forState:UIControlStateNormal];
    }
    return _addTimeButton;
}

@end
