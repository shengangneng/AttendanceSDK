//
//  MPMSelectDepartmentTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/24.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSelectDepartmentTableViewCell.h"
#import "MPMButton.h"

@interface MPMSelectDepartmentTableViewCell ()

@property (nonatomic, assign) SelectionType selectionType;/** 只能选择人则部门的圆圈必须隐藏 */

@end

@implementation MPMSelectDepartmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectionType:(SelectionType)selectionType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionType = selectionType;
        [self.checkIconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check:)]];
        
        [self addSubview:self.checkIconImage];
        [self addSubview:self.roundPeopleView];
        [self addSubview:self.txLabel];
        self.checkIconImage.frame = CGRectMake(0, 0, kTableViewHeight, kTableViewHeight);
        self.roundPeopleView.frame = CGRectMake(50, (kTableViewHeight - kRoundPeopleViewDefaultWidth)/2, kRoundPeopleViewDefaultWidth, kRoundPeopleViewDefaultWidth);
        self.txLabel.frame = CGRectMake(CGRectGetMaxX(self.roundPeopleView.frame)+10, 0, kScreenWidth-(20+CGRectGetMaxX(self.roundPeopleView.frame)), kTableViewHeight);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier selectionType:kSelectionTypeBoth];
}

- (void)setIsHuman:(BOOL)isHuman {
    _isHuman = isHuman;
    if (isHuman) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.roundPeopleView.hidden = NO;
        self.roundPeopleView.frame = CGRectMake(50, (kTableViewHeight - kRoundPeopleViewDefaultWidth)/2, kRoundPeopleViewDefaultWidth, kRoundPeopleViewDefaultWidth);
        self.txLabel.frame = CGRectMake(CGRectGetMaxX(self.roundPeopleView.frame)+10, 0, kScreenWidth-(20+CGRectGetMaxX(self.roundPeopleView.frame)), kTableViewHeight);
        self.checkIconImage.hidden = NO;
    } else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.roundPeopleView.hidden = YES;
        self.roundPeopleView.frame = CGRectMake(50, 0, 0, 0);
        if (kSelectionTypeOnlyEmployee == self.selectionType) {
            self.checkIconImage.hidden = YES;
            self.txLabel.frame = CGRectMake(15, 0, kScreenWidth-(60), kTableViewHeight);
        } else {
            self.checkIconImage.hidden = NO;
            self.txLabel.frame = CGRectMake(50, 0, kScreenWidth-(60), kTableViewHeight);
        }
    }
    [self layoutIfNeeded];
}

- (void)check:(UITapGestureRecognizer *)gesture {
    if (self.checkImageBlock) {
        self.checkImageBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init
- (UIImageView *)checkIconImage {
    if (!_checkIconImage) {
        _checkIconImage = [[UIImageView alloc] init];
        _checkIconImage.image = ImageName(@"setting_none");
        _checkIconImage.contentMode = UIViewContentModeCenter;
        _checkIconImage.userInteractionEnabled = YES;
    }
    return _checkIconImage;
}

- (MPMRoundPeopleView *)roundPeopleView {
    if (!_roundPeopleView) {
        _roundPeopleView = [[MPMRoundPeopleView alloc] initWithWidth:kRoundPeopleViewDefaultWidth];
        _roundPeopleView.backgroundColor = kWhiteColor;
    }
    return _roundPeopleView;
}

- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        [_txLabel sizeToFit];
    }
    return _txLabel;
}

@end
