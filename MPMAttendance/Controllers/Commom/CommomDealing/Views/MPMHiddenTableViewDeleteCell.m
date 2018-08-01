//
//  MPMHiddenTableViewDeleteCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/18.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMHiddenTableViewDeleteCell.h"
#import "MPMButton.h"
@interface MPMHiddenTableViewDeleteCell()

@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation MPMHiddenTableViewDeleteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
        [self.deleteButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.trailing.equalTo(self.mpm_trailing).offset(-15);
            make.width.height.equalTo(@20);
            make.centerY.equalTo(self.mpm_centerY);
        }];
    }
    return self;
}

#pragma mark - Target Action
- (void)delete:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(sender);
    }
}

#pragma mark - Lazy Init
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [MPMButton imageButtonWithImage:ImageName(@"approval_delete") hImage:ImageName(@"approval_delete")];
    }
    return _deleteButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
