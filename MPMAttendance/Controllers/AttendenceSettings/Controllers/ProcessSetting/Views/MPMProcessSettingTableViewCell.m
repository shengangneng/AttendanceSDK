//
//  MPMProcessSettingTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessSettingTableViewCell.h"
#import "MPMButton.h"

@implementation MPMProcessSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setCanDelete:(BOOL)canDelete {
    _canDelete = canDelete;
    if (canDelete) {
        [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@24);
            make.trailing.equalTo(self.bgImageView.mas_trailing).offset(-12);
            make.top.equalTo(self.bgImageView.mas_top).offset(8.5);
        }];
    } else {
        [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@24);
            make.width.equalTo(@0);
            make.trailing.equalTo(self.bgImageView.mas_trailing);
            make.top.equalTo(self.bgImageView.mas_top).offset(8.5);
        }];
    }
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = kTableViewBGColor;
    [self.updateButton addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Target Action
- (void)update:(UIButton *)sender {
    if (self.updateBlock) {
        self.updateBlock();
    }
}

- (void)delete:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setupSubViews {
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.flagImageView];
    [self.flagImageView addSubview:self.flagNameLabel];
    [self.bgImageView addSubview:self.flagNameLabel];
    [self.bgImageView addSubview:self.updateButton];
    [self.bgImageView addSubview:self.deleteButton];
    [self.bgImageView addSubview:self.line];
    [self.bgImageView addSubview:self.flagTitleLable];
    [self.bgImageView addSubview:self.flagDetailLabel];
    [self.bgImageView addSubview:self.applyerLabel];
    [self.bgImageView addSubview:self.applyerNameLabel];
}

- (void)setupConstraints {
    [self.bgImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(12);
        make.trailing.equalTo(self.mpm_trailing).offset(-12);
        make.top.equalTo(self.mpm_top).offset(12);
        make.bottom.equalTo(self.mpm_bottom).offset(0);
    }];
    [self.flagImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@77);
        make.height.equalTo(@34.5);
        make.leading.equalTo(self.bgImageView.mpm_leading).offset(-6.5);
        make.top.equalTo(self.bgImageView.mpm_top);
    }];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@24);
        make.centerY.equalTo(self.deleteButton.mas_centerY);
        make.trailing.equalTo(self.deleteButton.mas_leading).offset(-12);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@24);
        make.trailing.equalTo(self.bgImageView.mas_trailing).offset(-12);
        make.top.equalTo(self.bgImageView.mas_top).offset(8.5);
    }];
    [self.flagNameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.flagImageView.mpm_top).offset(4);
        make.leading.equalTo(self.flagImageView.mpm_leading).offset(19.5);
        make.trailing.equalTo(self.flagImageView.mpm_trailing);
        make.bottom.equalTo(self.flagImageView.mpm_bottom);
    }];
    [self.line mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.bgImageView);
        make.top.equalTo(self.bgImageView.mpm_top).offset(37);
        make.height.equalTo(@0.5);
    }];
    [self.flagTitleLable mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bgImageView.mpm_leading).offset(13);
        make.width.equalTo(@80);
        make.height.equalTo(@22);
        make.top.equalTo(self.line.mpm_bottom).offset(13);
    }];
    [self.flagDetailLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.flagTitleLable.mpm_trailing);
        make.top.bottom.equalTo(self.flagTitleLable);
        make.trailing.equalTo(self.bgImageView.mpm_trailing);
    }];
    [self.applyerLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bgImageView.mpm_leading).offset(13);
        make.width.equalTo(@80);
        make.height.equalTo(@22);
        make.top.equalTo(self.flagTitleLable.mpm_bottom);
    }];
    [self.applyerNameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.applyerLabel.mpm_trailing);
        make.top.bottom.equalTo(self.applyerLabel);
        make.trailing.equalTo(self.bgImageView.mpm_trailing);
    }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        UIView *reorderView = [self findReorderView:self];
        if (reorderView) {
            reorderView.backgroundColor = self.contentView.backgroundColor;
            for (UIView *sub in reorderView.subviews) {
                if ([sub isKindOfClass:[UIImageView class]]) {
                    ((UIImageView *)sub).image = nil;
                }
            }
            [reorderView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            // 把三个操作按钮加到这个排序视图上
            [reorderView addSubview:self.updateButton];
            [reorderView addSubview:self.deleteButton];
            [self.updateButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.height.width.equalTo(@24);
                make.centerY.equalTo(self.deleteButton.mpm_centerY);
                make.trailing.equalTo(self.deleteButton.mpm_leading).offset(-12);
            }];
            if (self.canDelete) {
                [self.deleteButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
                    make.height.width.equalTo(@24);
                    make.trailing.equalTo(self.bgImageView.mpm_trailing).offset(-12);
                    make.top.equalTo(self.bgImageView.mpm_top).offset(8.5);
                }];
            } else {
                [self.deleteButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
                    make.height.equalTo(@24);
                    make.width.equalTo(@0);
                    make.trailing.equalTo(self.bgImageView.mpm_trailing);
                    make.top.equalTo(self.bgImageView.mpm_top).offset(8.5);
                }];
            }
            [self layoutIfNeeded];
        }
    }
}

// 寻找控制cell排序的视图
- (UIView *)findReorderView:(UIView *)view {
    UIView *reorderView = nil;
    for (UIView *subview in view.subviews) {
        if ([[[subview class] description] rangeOfString:@"Reorder"].location != NSNotFound) {
            reorderView = subview;
            break;
        } else {
            reorderView = [self findReorderView:subview];
            if (reorderView != nil) {
                break;
            }
        }
    }
    return reorderView;
}

#pragma mark - Lazy Init
#define kShadowPath 0.5
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.backgroundColor = kWhiteColor;
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.layer.shadowOffset = CGSizeMake(0.1, -2);
        _bgImageView.layer.shadowColor = kMainLightGray.CGColor;
        _bgImageView.layer.shadowOpacity = 0.3;
    }
    return _bgImageView;
}
- (UIImageView *)flagImageView {
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc] init];
        _flagImageView.layer.cornerRadius = 5;
        _flagImageView.image = ImageName(@"setting_node");
    }
    return _flagImageView;
}
- (UILabel *)flagNameLabel {
    if (!_flagNameLabel) {
        _flagNameLabel = [[UILabel alloc] init];
        _flagNameLabel.textColor = kWhiteColor;
        _flagNameLabel.textAlignment = NSTextAlignmentLeft;
        _flagNameLabel.text = @"节点1";
        _flagNameLabel.font = SystemFont(15);
    }
    return _flagNameLabel;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kSeperateColor;
    }
    return _line;
}
- (UIButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [MPMButton imageButtonWithImage:ImageName(@"setting_progress_edit") hImage:ImageName(@"setting_progress_edit")];
    }
    return _updateButton;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [MPMButton imageButtonWithImage:ImageName(@"setting_progress_delete") hImage:ImageName(@"setting_progress_delete")];
    }
    return _deleteButton;
}
- (UILabel *)flagTitleLable {
    if (!_flagTitleLable) {
        _flagTitleLable = [[UILabel alloc] init];
        _flagTitleLable.textColor = kMainLightGray;
        _flagTitleLable.textAlignment = NSTextAlignmentLeft;
        _flagTitleLable.text = @"节点名称:";
        _flagTitleLable.font = SystemFont(15);
    }
    return _flagTitleLable;
}
- (UILabel *)flagDetailLabel {
    if (!_flagDetailLabel) {
        _flagDetailLabel = [[UILabel alloc] init];
        _flagDetailLabel.textColor = kBlackColor;
        _flagDetailLabel.textAlignment = NSTextAlignmentLeft;
        _flagDetailLabel.text = @"中级主管审核";
        _flagDetailLabel.font = SystemFont(15);
    }
    return _flagDetailLabel;
}
- (UILabel *)applyerLabel {
    if (!_applyerLabel) {
        _applyerLabel = [[UILabel alloc] init];
        _applyerLabel.textColor = kMainLightGray;
        _applyerLabel.textAlignment = NSTextAlignmentLeft;
        _applyerLabel.text = @"审批人:";
        _applyerLabel.font = SystemFont(15);
    }
    return _applyerLabel;
}
- (UILabel *)applyerNameLabel {
    if (!_applyerNameLabel) {
        _applyerNameLabel = [[UILabel alloc] init];
        _applyerNameLabel.textColor = kBlackColor;
        _applyerNameLabel.textAlignment = NSTextAlignmentLeft;
        _applyerNameLabel.text = @"王祖蓝";
        _applyerNameLabel.font = SystemFont(15);
    }
    return _applyerNameLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
