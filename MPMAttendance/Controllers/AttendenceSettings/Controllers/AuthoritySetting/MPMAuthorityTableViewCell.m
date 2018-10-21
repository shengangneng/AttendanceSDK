//
//  MPMAuthorityTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAuthorityTableViewCell.h"
#import "MPMButton.h"
#import "MPMAuthorityModel.h"
#import "MPMRoundPeopleButton.h"

@implementation MPMAuthorityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Public Method
- (void)setPeopleViewData:(NSArray *)dataArray fold:(BOOL)fold {
    [self.peoplesView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MPMRoundPeopleButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    int count = 5;
    int width = 50;
    int heigth = 50;
    int margin = (kScreenWidth - width * count) / (count + 1);
    int bord = 6.5;
    for (int i = 0; i < dataArray.count; i++) {
        MPMAuthorityModel *model = dataArray[i];
        int row = i / count;
        int line = i % count;
        
        MPMRoundPeopleButton *btn = [[MPMRoundPeopleButton alloc] init];
        btn.roundPeople.nameLabel.text = model.name.length > 2 ? [model.name substringWithRange:NSMakeRange(model.name.length - 2, 2)] : model.name;
        btn.deleteIcon.hidden = NO;
        btn.nameLabel.text = model.name;
        btn.tag = i + Tag;
        [btn addTarget:self action:@selector(deletePeople:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(margin + line*(margin+width), row*(bord + heigth), width, heigth);
        [self.peoplesView addSubview:btn];
    }
    
    if (fold) {
        if (dataArray.count > 5) {
            self.operationButton.hidden = NO;
            self.operationButton.selected = NO;
            [self.operationButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth));
                make.height.equalTo(@20);
                make.centerX.equalTo(self.peoplesView.mpm_centerX);
                make.bottom.equalTo(self.mpm_bottom);
            }];
        } else {
            self.operationButton.hidden = YES;
            self.operationButton.selected = NO;
            [self.operationButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth));
                make.height.equalTo(@0);
                make.centerX.equalTo(self.peoplesView.mpm_centerX);
                make.bottom.equalTo(self.mpm_bottom);
            }];
        }
    } else {
        if (dataArray.count > 5) {
            self.operationButton.hidden = NO;
        } else {
            self.operationButton.hidden = YES;
        }
        self.operationButton.selected = YES;
        [self.operationButton mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth));
            make.height.equalTo(@(20));
            make.centerX.equalTo(self.peoplesView.mpm_centerX);
            make.bottom.equalTo(self.mpm_bottom);
        }];
    }
}

#pragma mark - Target Action
- (void)addPeople:(UIButton *)sender {
    if (self.addPeopleBlock) {
        self.addPeopleBlock();
    }
}

- (void)operate:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.operationBlock) {
        self.operationBlock(sender.selected);
    }
}

- (void)deletePeople:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(sender.tag);
    }
}

#pragma mark - setup
- (void)setupAttributes {
    self.detailTextLabel.textColor = kMainLightGray;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.addPeopleButton addTarget:self action:@selector(addPeople:) forControlEvents:UIControlEventTouchUpInside];
    [self.operationButton addTarget:self action:@selector(operate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.txLabel];
    [self addSubview:self.detailTxLabel];
    [self addSubview:self.addPeopleButton];
    [self addSubview:self.peoplesView];
    [self addSubview:self.operationButton];
}

- (void)setupConstraints {
    [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(15);
        make.height.equalTo(@22.5);
        make.top.equalTo(self.mpm_top).offset(10);
    }];
    [self.detailTxLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(15);
        make.top.equalTo(self.txLabel.mpm_bottom);
        make.height.equalTo(@20);
    }];
    [self.addPeopleButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.trailing.equalTo(self.mpm_trailing).offset(-15);
        make.centerY.equalTo(self.mpm_top).offset(30);
    }];
    [self.peoplesView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.detailTxLabel.mpm_bottom).offset(7.5);
        make.bottom.equalTo(self.mpm_bottom);
    }];
    [self.operationButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0);
        make.centerX.equalTo(self.peoplesView.mpm_centerX);
        make.bottom.equalTo(self.mpm_bottom);
    }];
}

#pragma mark - Lazy Init
- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        [_txLabel sizeToFit];
        _txLabel.font = SystemFont(17);
    }
    return _txLabel;
}

- (UILabel *)detailTxLabel {
    if (!_detailTxLabel) {
        _detailTxLabel = [[UILabel alloc] init];
        [_detailTxLabel sizeToFit];
        _detailTxLabel.font = SystemFont(13);
        _detailTxLabel.textColor = kMainLightGray;
    }
    return _detailTxLabel;
}

- (UIButton *)addPeopleButton {
    if (!_addPeopleButton) {
        _addPeopleButton = [MPMButton imageButtonWithImage:ImageName(@"commom_add") hImage:ImageName(@"commom_add")];
    }
    return _addPeopleButton;
}
- (UIView *)peoplesView {
    if (!_peoplesView) {
        _peoplesView = [[UIView alloc] init];
        _peoplesView.layer.masksToBounds = YES;
    }
    return _peoplesView;
}
- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.backgroundColor = kWhiteColor;
        [_operationButton setImage:ImageName(@"apply_dropdown") forState:UIControlStateNormal];
        [_operationButton setImage:ImageName(@"apply_dropdown") forState:UIControlStateHighlighted];
        [_operationButton setImage:ImageName(@"apply_toppull") forState:UIControlStateSelected];
        _operationButton.hidden = YES;
        _operationButton.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _operationButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
