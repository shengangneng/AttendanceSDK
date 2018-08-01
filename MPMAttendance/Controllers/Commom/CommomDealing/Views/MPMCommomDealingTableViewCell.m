//
//  MPMCommomDealingTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCommomDealingTableViewCell.h"
#import "MPMCheckRegexTool.h"
#import "MPMButton.h"

@interface MPMCommomDealingTableViewCell() <UITextFieldDelegate>

@property (nonatomic, assign) BOOL checkNumber;// 是否限制TextField为数字

@end

@implementation MPMCommomDealingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.checkNumber = NO;
    [self.deleteCellButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.startIcon];
    [self addSubview:self.txLabel];
    [self addSubview:self.detailTextField];
    [self addSubview:self.deleteCellButton];
}

- (void)setupConstraints {
    [self.startIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@(PX_W(11)));
        make.height.equalTo(@(PX_H(12)));
        make.trailing.equalTo(self.txLabel.mpm_leading).offset(-4);
    }];
    [self.txLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(20);
        make.centerY.equalTo(self.mpm_centerY);
    }];
    [self.detailTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.leading.equalTo(self.txLabel.mpm_trailing).offset(10);
    }];
    [self.deleteCellButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.trailing.equalTo(self);
        make.width.equalTo(@16.5);
        make.height.equalTo(@14);
    }];
}

#pragma mark - Target Action
- (void)deleteCell:(UIButton *)sender {
    if (self.sectionDeleteBlock) {
        self.sectionDeleteBlock(sender);
    }
}

- (void)setupTextFieldCheck:(BOOL)check {
    self.checkNumber = check;
    self.detailView = self.detailTextField;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.detailTextField.hidden = NO;
    self.detailTextLabel.hidden = YES;
}

- (void)setupUILabel {
    self.detailView = self.detailTextLabel;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.detailTextField.hidden = YES;
    self.detailTextLabel.hidden = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 限制数字，长度为4
    BOOL pass = self.checkNumber ? [MPMCheckRegexTool checkString:toBeString onlyHasDigitAndLength:4 decimalLength:1] : YES;
    if (pass) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textFieldChangeBlock) {
        self.textFieldChangeBlock(@"");
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.textFieldChangeBlock) {
        self.textFieldChangeBlock(textField.text);
    }
    return YES;
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

- (UIButton *)deleteCellButton {
    if (!_deleteCellButton) {
        _deleteCellButton = [MPMButton imageButtonWithImage:ImageName(@"apply_deleteitems") hImage:ImageName(@"apply_deleteitems")];
        _deleteCellButton.hidden = YES;
    }
    return _deleteCellButton;
}

- (UITextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = [[UITextField alloc] init];
        _detailTextField.delegate = self;
        _detailTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _detailTextField.textColor = kMainLightGray;
        _detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _detailTextField.textAlignment = NSTextAlignmentRight;
    }
    return _detailTextField;
}

@end
