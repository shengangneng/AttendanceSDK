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
        [self addSubview:self.roundPeopleView];
        [self addSubview:self.txLabel];
        [self addSubview:self.deleteButton];
        self.deleteButton.frame = CGRectMake(kScreenWidth - kTableViewHeight, 0, kTableViewHeight, kTableViewHeight);
        self.txLabel.frame = CGRectMake(15, 0, kScreenWidth-(60), kTableViewHeight);
        self.roundPeopleView.frame = CGRectMake(15, 0, 0, 0);
    }
    return self;
}

- (void)setIsHuman:(BOOL)isHuman {
    _isHuman = isHuman;
    if (isHuman) {
        self.roundPeopleView.hidden = NO;
        self.roundPeopleView.frame = CGRectMake(15, (kTableViewHeight - kRoundPeopleViewDefaultWidth)/2, kRoundPeopleViewDefaultWidth, kRoundPeopleViewDefaultWidth);
        self.txLabel.frame = CGRectMake(CGRectGetMaxX(self.roundPeopleView.frame)+10, 0, kScreenWidth-(20+CGRectGetMaxX(self.roundPeopleView.frame)), kTableViewHeight);
    } else {
        self.roundPeopleView.hidden = YES;
        self.roundPeopleView.frame = CGRectMake(15, 0, 0, 0);
        self.txLabel.frame = CGRectMake(15, 0, kScreenWidth-(60), kTableViewHeight);
    }
    [self layoutIfNeeded];
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
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:ImageName(@"approval_delete") forState:UIControlStateNormal];
        [_deleteButton setImage:ImageName(@"approval_delete") forState:UIControlStateHighlighted];
        _deleteButton.contentMode = UIViewContentModeCenter;
    }
    return _deleteButton;
}

- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        [_txLabel sizeToFit];
    }
    return _txLabel;
}

- (MPMRoundPeopleView *)roundPeopleView {
    if (!_roundPeopleView) {
        _roundPeopleView = [[MPMRoundPeopleView alloc] initWithWidth:kRoundPeopleViewDefaultWidth];
        _roundPeopleView.backgroundColor = kWhiteColor;
    }
    return _roundPeopleView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
