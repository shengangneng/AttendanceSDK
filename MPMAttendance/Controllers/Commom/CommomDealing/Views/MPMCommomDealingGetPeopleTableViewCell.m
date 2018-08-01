//
//  MPMCommomDealingGetPeopleTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCommomDealingGetPeopleTableViewCell.h"
#import "MPMButton.h"

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
    [self.operationButton addTarget:self action:@selector(operate:) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryButton addTarget:self action:@selector(addPeople:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.startIcon];
    [self addSubview:self.txLabel];
    [self addSubview:self.accessoryButton];
    [self addSubview:self.peopleView];
    [self addSubview:self.operationButton];
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
        make.height.equalTo(@(50));
    }];
    [self.accessoryButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.txLabel.mpm_centerY);
        make.trailing.equalTo(self.mpm_trailing).offset(-15);
        make.width.height.equalTo(@22);
    }];
    [self.peopleView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.txLabel.mpm_bottom);
        make.bottom.equalTo(self.mpm_bottom);
    }];
    [self.operationButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0);
        make.centerX.equalTo(self.peopleView.mpm_centerX);
        make.bottom.equalTo(self.mpm_bottom);
    }];
}

- (void)setPeopleViewData:(NSString *)data fold:(BOOL)fold {
    [self.peopleView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    NSArray *arr = [data componentsSeparatedByString:@","];
    int count = 5;
    int width = 50;
    int heigth = 50;
    int margin = (kScreenWidth - width * count) / (count + 1);
    int bord = 6.5;
    for (int i = 0; i < arr.count; i++) {
        NSString *btnTitle = arr[i];
        int row = i / count;
        int line = i % count;
        UIButton *btn = [MPMButton imageUpTitleDownButtonWithTitle:btnTitle titleColor:kMainLightGray titleFont:SystemFont(13) image:ImageName(@"approval_useravatar_mid") highImage:ImageName(@"approval_useravatar_mid") backgroupColor:kWhiteColor cornerRadius:0 offset:2];
        btn.frame = CGRectMake(margin + line*(margin+width), row*(bord + heigth), width, heigth);
        [self.peopleView addSubview:btn];
    }
    
    if (fold) {
        if (arr.count > 5) {
            self.operationButton.hidden = NO;
            self.operationButton.selected = NO;
            [self.operationButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth));
                make.height.equalTo(@20);
                make.centerX.equalTo(self.peopleView.mpm_centerX);
                make.bottom.equalTo(self.mpm_bottom);
            }];
        } else {
            self.operationButton.hidden = YES;
            self.operationButton.selected = NO;
            [self.operationButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth));
                make.height.equalTo(@0);
                make.centerX.equalTo(self.peopleView.mpm_centerX);
                make.bottom.equalTo(self.mpm_bottom);
            }];
        }
    } else {
        self.operationButton.hidden = NO;
        self.operationButton.selected = YES;
        [self.operationButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth));
            make.height.equalTo(@20);
            make.centerX.equalTo(self.peopleView.mpm_centerX);
            make.bottom.equalTo(self.mpm_bottom);
        }];
    }
}

#pragma mark - Target Action
- (void)operate:(UIButton *)sender {
    if (self.foldBlock) {
        self.foldBlock(sender);
    }
}

- (void)addPeople:(UIButton *)sender {
    if (self.addpBlock) {
        self.addpBlock(sender);
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

- (UIView *)peopleView {
    if (!_peopleView) {
        _peopleView = [[UIView alloc] init];
        _peopleView.layer.masksToBounds = YES;
    }
    return _peopleView;
}

- (UIButton *)accessoryButton {
    if (!_accessoryButton) {
        _accessoryButton = [MPMButton imageButtonWithImage:ImageName(@"apply_addakey") hImage:ImageName(@"apply_addakey")];
    }
    return _accessoryButton;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.backgroundColor = kWhiteColor;
        [_operationButton setImage:ImageName(@"apply_dropdown") forState:UIControlStateNormal];
        [_operationButton setImage:ImageName(@"apply_dropdown") forState:UIControlStateHighlighted];
        [_operationButton setImage:ImageName(@"apply_toppull") forState:UIControlStateSelected];
        _operationButton.hidden = YES;
    }
    return _operationButton;
}


@end
