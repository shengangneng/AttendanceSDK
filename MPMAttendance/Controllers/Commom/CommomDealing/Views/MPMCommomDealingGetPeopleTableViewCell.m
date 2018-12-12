//
//  MPMCommomDealingGetPeopleTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCommomDealingGetPeopleTableViewCell.h"
#import "MPMButton.h"
#import "MPMRoundPeopleButton.h"

@interface MPMCommomDealingGetPeopleTableViewCell ()

@end

@implementation MPMCommomDealingGetPeopleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupAttributes {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.addPeopleButton addTarget:self action:@selector(addPeople:) forControlEvents:UIControlEventTouchUpInside];
    [self.addLeadButton addTarget:self action:@selector(addLeadCard:) forControlEvents:UIControlEventTouchUpInside];
    [self.explainButton addTarget:self action:@selector(explain:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.startIcon];
    [self addSubview:self.txLabel];
    [self addSubview:self.explainButton];
    [self addSubview:self.detailTxLabel];
    [self addSubview:self.addLeadButton];
    [self addSubview:self.peopleView];
}

- (void)setupConstraints {
    [self.startIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.txLabel.mpm_centerY);
        make.width.equalTo(@(PX_W(11)));
        make.height.equalTo(@(PX_H(12)));
        make.trailing.equalTo(self.txLabel.mpm_leading).offset(-4);
    }];
    [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self.mpm_leading).offset(20);
        make.height.equalTo(@49);
    }];
    [self.explainButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@17);
        make.centerY.equalTo(self.txLabel.mpm_centerY);
        make.leading.equalTo(self.txLabel.mpm_leading).offset(75);
    }];
    [self.detailTxLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self);
        make.trailing.equalTo(self.mpm_trailing).offset(-15);
        make.height.equalTo(@49);
    }];
    [self.addLeadButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.top.equalTo(self.mpm_top);
    }];
    [self.peopleView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.txLabel.mpm_bottom).offset(1);
        make.bottom.equalTo(self.mpm_bottom);
    }];
}

- (void)setPeopleViewArray:(NSArray<MPMDepartment *> *)peoples canAdd:(BOOL)canAdd {
    [self.peopleView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MPMRoundPeopleButton class]] || [obj isKindOfClass:[self.addPeopleButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    int count = 5;
    int width = 50;
    int heigth = 50;
    int margin = (kScreenWidth - width * count) / (count + 1);
    int bord = 6.5;
    NSMutableArray *temp = [NSMutableArray array];
    if (canAdd) {
        [temp addObject:[[NSObject alloc] init]];
    }
    [temp addObjectsFromArray:peoples];
    for (int i = 0; i < temp.count; i++) {
        int row = i / count;
        int line = i % count;
        if (0 == i && canAdd) {
            self.addPeopleButton.frame = CGRectMake(margin + line*(margin+width), row*(bord + heigth), width, heigth);
            [self.peopleView addSubview:self.addPeopleButton];
        } else {
            MPMDepartment *depart = temp[i];
            MPMRoundPeopleButton *btn = [[MPMRoundPeopleButton alloc] init];
            btn.roundPeople.nameLabel.text = depart.name.length > 2 ? [depart.name substringWithRange:NSMakeRange(depart.name.length - 2, 2)] : depart.name;
            if (self.peopleCanDelete) {
                btn.userInteractionEnabled = YES;
                btn.deleteIcon.hidden = NO;
                if (canAdd) {
                    btn.tag = kButtonTag + i - 1;
                } else {
                    btn.tag = kButtonTag + i;
                }
                [btn addTarget:self action:@selector(deletePeople:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                btn.userInteractionEnabled = NO;
                btn.deleteIcon.hidden = YES;
            }
            btn.nameLabel.text = depart.name;
            btn.frame = CGRectMake(margin + line*(margin+width), row*(bord + heigth), width, heigth);
            [self.peopleView addSubview:btn];
        }
    }
}

#pragma mark - Target Action

- (void)addPeople:(UIButton *)sender {
    if (self.addpBlock) {
        self.addpBlock(sender);
    }
}

- (void)addLeadCard:(UIButton *)sender {
    if (self.addLeadBlock) {
        self.addLeadBlock();
    }
}

- (void)deletePeople:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(sender);
    }
}

- (void)explain:(UIButton *)sender {
    if (self.explainBlock) {
        self.explainBlock();
    }
}

#pragma mark - Lazy Init

- (UIImageView *)startIcon {
    if (!_startIcon) {
        _startIcon = [[UIImageView alloc] init];
        _startIcon.image = ImageName(@"attendence_mandatory");
    }
    return _startIcon;
}

- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        _txLabel.font = SystemFont(17);
        [_txLabel sizeToFit];
        _txLabel.textColor = kBlackColor;
        _txLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txLabel;
}

- (UIButton *)explainButton {
    if (!_explainButton) {
        _explainButton = [MPMButton imageButtonWithImage:ImageName(@"apply_explain") hImage:ImageName(@"apply_explain")];
        _explainButton.hidden = YES;
    }
    return _explainButton;
}

- (UILabel *)detailTxLabel {
    if (!_detailTxLabel) {
        _detailTxLabel = [[UILabel alloc] init];
        _detailTxLabel.font = SystemFont(17);
        [_detailTxLabel sizeToFit];
        _detailTxLabel.textColor = kBlackColor;
        _detailTxLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailTxLabel;
}

- (UIView *)peopleView {
    if (!_peopleView) {
        _peopleView = [[UIView alloc] init];
        _peopleView.layer.masksToBounds = YES;
    }
    return _peopleView;
}

- (UIButton *)addPeopleButton {
    if (!_addPeopleButton) {
        _addPeopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPeopleButton setImage:ImageName(@"commom_add") forState:UIControlStateNormal];
        [_addPeopleButton setImage:ImageName(@"commom_add") forState:UIControlStateHighlighted];
        _addPeopleButton.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _addPeopleButton;
}

- (UIButton *)addLeadButton {
    if (!_addLeadButton) {
        _addLeadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addLeadButton setImage:ImageName(@"commom_add") forState:UIControlStateNormal];
        [_addLeadButton setImage:ImageName(@"commom_add") forState:UIControlStateHighlighted];
        _addLeadButton.contentMode = UIViewContentModeScaleAspectFit;
        _addLeadButton.hidden = YES;
    }
    return _addLeadButton;
}

@end
