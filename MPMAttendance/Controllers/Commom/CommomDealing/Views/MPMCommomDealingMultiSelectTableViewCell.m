//
//  MPMCommomDealingMultiSelectTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/7.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCommomDealingMultiSelectTableViewCell.h"
#import "MPMDealingBorderButton.h"
#import "MPMCommomTool.h"

#define kItemWidth 45

@interface MPMCommomDealingMultiSelectTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *trafficView;
@property (nonatomic, strong) UIView *moneyView;

@property (nonatomic, strong) UIView *trafficDetailView;

@end

@implementation MPMCommomDealingMultiSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
           multiSelectionType:(kMultiSelectionType)multiSelectionType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setMultiSelectionType:multiSelectionType];
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Target Action
- (void)traffic:(UIButton *)sender {
    NSInteger index = sender.tag - kTafficBtnTag;
    
    if (index == 0) {
        if (self.cellNeedFoldBlock) {
            self.cellNeedFoldBlock(NO);
        }
    } else {
        if (self.cellNeedFoldBlock) {
            self.cellNeedFoldBlock(YES);
        }
    }
    
    sender.selected = YES;
    if (self.lastSelectedBtn == sender) {
        return;
    } else {
        self.lastSelectedBtn.selected = NO;
        self.lastSelectedBtn = sender;
    }
    if (self.selectedBtnBlock) {
        self.selectedBtnBlock(index);
    }
}

- (void)money:(UIButton *)sender {
    NSInteger index = sender.tag - kMoneyBtnTag;
    sender.selected = YES;
    if (self.lastSelectedBtn == sender) {
        return;
    } else {
        self.lastSelectedBtn.selected = NO;
        self.lastSelectedBtn = sender;
    }
    if (self.selectedBtnBlock) {
        self.selectedBtnBlock(index);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.cellTextFieldChangeBlock) {
        self.cellTextFieldChangeBlock(textField.text);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.cellTextFieldChangeBlock) {
        self.cellTextFieldChangeBlock(@"");
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([MPMCommomTool textViewOrTextFieldHasEmoji:textField]) {
        return NO;
    }
    return YES;
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupSubViews {
    [self addSubview:self.trafficDetailView];
    [self.trafficDetailView addSubview:self.trafficDetailTextField];
    [self addSubview:self.trafficView];
    [self addSubview:self.moneyView];
    [self addSubview:self.txLabel];
}

- (void)setupConstraints {
    [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(kTableViewHeight));
        make.leading.equalTo(self.mpm_leading).offset(20);
    }];
    [self.trafficView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(kTableViewHeight));
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.width.equalTo(@(kTraffic.count * kItemWidth + (kTraffic.count - 1) * 8));
    }];
    [self.moneyView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.width.equalTo(@(kMoney.count * kItemWidth + (kTraffic.count - 1) * 8));
    }];
    [self.trafficDetailView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mpm_bottom).offset(-kTableViewHeight);
        make.height.equalTo(@(kTableViewHeight));
    }];
    [self.trafficDetailTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self.trafficDetailView);
        make.trailing.equalTo(self.trafficDetailView.mpm_trailing).offset(-15);
        make.leading.equalTo(self.trafficDetailView.mpm_leading).offset(20);
    }];
}

- (void)setMultiSelectionType:(kMultiSelectionType)multiSelectionType {
    if (kMultiSelectionTypeTraffic == multiSelectionType) {
        // 交通工具
        self.txLabel.text = @"交通工具";
        self.trafficView.hidden = NO;
        self.moneyView.hidden = YES;
    } else if (kMultiSelectionTypeOverTimeMoney == multiSelectionType) {
        // 加班补偿
        self.txLabel.text = @"加班补偿";
        self.moneyView.hidden = NO;
        self.trafficView.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init
- (UILabel *)txLabel {
    if (!_txLabel) {
        _txLabel = [[UILabel alloc] init];
        _txLabel.font = SystemFont(17);
        _txLabel.textColor = kBlackColor;
        _txLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txLabel;
}

- (UIView *)moneyView {
    if (!_moneyView) {
        _moneyView = [[UIView alloc] init];
        _moneyView.backgroundColor = kWhiteColor;
        _moneyView.hidden = YES;
        double trailing = 0;
        MPMViewAttribute *attributes = _moneyView.mpm_trailing;
        for (int i = 0; i < kMoney.count; i++) {
            NSString *title = kMoney[i];
            MPMDealingBorderButton *btn = [[MPMDealingBorderButton alloc] initWithTitle:title nColor:kMainLightGray sColor:kMainBlueColor font:SystemFont(14) cornerRadius:5 borderWidth:1];
            btn.tag = kMoneyBtnTag + i;
            [btn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
            [_moneyView addSubview:btn];
            [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.trailing.equalTo(attributes).offset(trailing);
                make.top.equalTo(_moneyView.mpm_top).offset(10);
                make.width.equalTo(@(kItemWidth));
                make.height.equalTo(@30);
            }];
            attributes = btn.mpm_leading;
            trailing = -8;
        }
    }
    return _moneyView;
}

- (UIView *)trafficView {
    if (!_trafficView) {
        _trafficView = [[UIView alloc] init];
        _trafficView.backgroundColor = kWhiteColor;
        _trafficView.hidden = YES;
        double trailing = 0;
        MPMViewAttribute *attributes = _trafficView.mpm_trailing;
        for (int i = 0; i < kTraffic.count; i++) {
            NSString *title = kTraffic[i];
            MPMDealingBorderButton *btn = [[MPMDealingBorderButton alloc] initWithTitle:title nColor:kMainLightGray sColor:kMainBlueColor font:SystemFont(14) cornerRadius:5 borderWidth:1];
            btn.tag = kTafficBtnTag + i;
            [btn addTarget:self action:@selector(traffic:) forControlEvents:UIControlEventTouchUpInside];
            [_trafficView addSubview:btn];
            [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.trailing.equalTo(attributes).offset(trailing);
                make.top.equalTo(_trafficView.mpm_top).offset(10);
                make.width.equalTo(@(kItemWidth));
                make.height.equalTo(@30);
            }];
            attributes = btn.mpm_leading;
            trailing = -8;
        }
    }
    return _trafficView;
}

- (UIView *)trafficDetailView {
    if (!_trafficDetailView) {
        _trafficDetailView = [[UIView alloc] init];
        _trafficDetailView.backgroundColor = kWhiteColor;
    }
    return _trafficDetailView;
}

- (UITextField *)trafficDetailTextField {
    if (!_trafficDetailTextField) {
        _trafficDetailTextField = [[UITextField alloc] init];
        _trafficDetailTextField.delegate = self;
        _trafficDetailTextField.font = SystemFont(17);
        _trafficDetailTextField.textAlignment = NSTextAlignmentRight;
        _trafficDetailTextField.placeholder = @"请输入交通工具";
        _trafficDetailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _trafficDetailTextField;
}

@end
