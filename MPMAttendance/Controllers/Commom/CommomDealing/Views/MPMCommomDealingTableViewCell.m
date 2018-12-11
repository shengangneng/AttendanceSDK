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

/** 是否限制TextField为只能输入数字（包含小数点） */
@property (nonatomic, assign) BOOL needCheckNumber;
/** 限制数字位数：默认为4位 */
@property (nonatomic, assign) NSInteger limitLength;

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
    self.detailTextLabel.textColor = kMainLightGray;
    self.needCheckNumber = NO;
    self.limitLength = 4;
    [self.explainButton addTarget:self action:@selector(explain:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteCellButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.startIcon];
    [self addSubview:self.txLabel];
    [self addSubview:self.explainButton];
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
    [self.explainButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@17);
        make.centerY.equalTo(self.txLabel.mpm_centerY);
        make.leading.equalTo(self.txLabel.mpm_leading).offset(38);
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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.accessoryMaskView];
    [self.accessoryMaskView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.trailing.equalTo(self);
        make.height.equalTo(@(kTableViewHeight));
        make.width.equalTo(@30);
    }];
}

#pragma mark - Target Action
- (void)explain:(UIButton *)sender {
    if (self.explainBlock) {
        self.explainBlock();
    }
}

- (void)deleteCell:(UIButton *)sender {
    if (self.sectionDeleteBlock) {
        self.sectionDeleteBlock(sender);
    }
}

/** 是否限制输入数字，并限制数字的长度 */
- (void)needCheckNumber:(BOOL)needCheckNumber limitLength:(NSInteger)length {
    self.needCheckNumber = needCheckNumber;
    if (self.needCheckNumber) {
        self.limitLength = length;
    }
}

- (void)setupDetailToBeUITextField {
    self.detailView = self.detailTextField;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.detailTextField.hidden = NO;
    self.detailTextLabel.hidden = YES;
}

- (void)setupDetailToBeLabel {
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
    // 限制数字，默认长度为4，预计费用为10位
    BOOL pass = self.needCheckNumber ? [MPMCheckRegexTool checkString:toBeString onlyHasDigitAndLength:self.limitLength decimalLength:1] : YES;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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

- (UIButton *)explainButton {
    if (!_explainButton) {
        _explainButton = [MPMButton imageButtonWithImage:ImageName(@"apply_explain") hImage:ImageName(@"apply_explain")];
        _explainButton.hidden = YES;
    }
    return _explainButton;
}

- (UIButton *)deleteCellButton {
    if (!_deleteCellButton) {
        _deleteCellButton = [MPMButton imageButtonWithImage:ImageName(@"apply_deleteitems") hImage:ImageName(@"apply_deleteitems")];
        _deleteCellButton.hidden = YES;
    }
    return _deleteCellButton;
}

- (UIView *)accessoryMaskView {
    if (!_accessoryMaskView) {
        _accessoryMaskView = [[UIView alloc] init];
        _accessoryMaskView.backgroundColor = kWhiteColor;
        _accessoryMaskView.hidden = YES;
    }
    return _accessoryMaskView;
}

- (UITextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = [[UITextField alloc] init];
        _detailTextField.delegate = self;
        _detailTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _detailTextField.returnKeyType = UIReturnKeyDone;
        _detailTextField.textColor = kMainLightGray;
        _detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _detailTextField.textAlignment = NSTextAlignmentRight;
    }
    return _detailTextField;
}

@end
