//
//  MPMCommomDealingReasonTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCommomDealingReasonTableViewCell.h"
#import "MPMButton.h"

@interface MPMCommomDealingReasonTableViewCell() <UITextViewDelegate>

@property (nonatomic, strong) UIButton *textViewClearButton;

@end

@implementation MPMCommomDealingReasonTableViewCell

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
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.textViewClearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.startIcon];
    [self addSubview:self.txLabel];
    [self addSubview:self.detailTextView];
    [self addSubview:self.textViewTotalLength];
    [self addSubview:self.textViewClearButton];
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
    
    [self.detailTextView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.txLabel.mpm_trailing).offset(5);
        make.top.equalTo(self.mpm_top).offset(7);
        make.bottom.equalTo(self.mpm_bottom).offset(-7);
        make.trailing.equalTo(self.mpm_trailing);
    }];
    [self.textViewTotalLength mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.mpm_bottom).offset(-7);
        make.trailing.equalTo(self.mpm_trailing).offset(-15);
        make.height.equalTo(@39);
    }];
    [self.textViewClearButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@(12.5));
        make.centerY.equalTo(self.textViewTotalLength.mpm_centerY);
        make.trailing.equalTo(self.textViewTotalLength.mpm_leading).offset(-5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Target Action
- (void)clear:(UIButton *)sender {
    self.detailTextView.text = @"";
    self.textViewTotalLength.attributedText = [self getAttributeString:[NSString stringWithFormat:@"%d/30",0]];
    if (self.changeTextBlock) {
        self.changeTextBlock(@"");
    }
    sender.hidden = YES;
}

#pragma mark - Private Method
- (NSAttributedString *)getAttributeString:(NSString *)str {
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSInteger loca = str.length - 2;
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:kMainLightGray
                          range:NSMakeRange(loca, 2)];
    return AttributedStr;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:UITextViewPlaceHolder1] || [textView.text isEqualToString:UITextViewPlaceHolder2]) {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 || [textView.text isEqualToString:UITextViewPlaceHolder1] || [textView.text isEqualToString:UITextViewPlaceHolder2]) {
        self.textViewClearButton.hidden = YES;
        self.textViewTotalLength.attributedText = [self getAttributeString:[NSString stringWithFormat:@"%d/30",0]];
    } else {
        self.textViewClearButton.hidden = NO;
        self.textViewTotalLength.attributedText = [self getAttributeString:[NSString stringWithFormat:@"%ld/30",textView.text.length]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *callbackString = nil;
    if (textView.text.length == 0) {
        textView.text = @"请输入";
        callbackString = @"";
    } else {
        callbackString = textView.text;
    }
    self.textViewTotalLength.attributedText = [self getAttributeString:[NSString stringWithFormat:@"%ld/30",callbackString.length]];
    if (self.changeTextBlock) {
        self.changeTextBlock(callbackString);
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
        [_txLabel sizeToFit];
        _txLabel.font = SystemFont(17);
        _txLabel.text = @"处理理由";
    }
    return _txLabel;
}

- (UITextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [[UITextView alloc] init];
        _detailTextView.clearsOnInsertion = YES;
        _detailTextView.delegate = self;
        _detailTextView.font = SystemFont(17);
        _detailTextView.textColor = kMainLightGray;
    }
    return _detailTextView;
}

- (UILabel *)textViewTotalLength {
    if (!_textViewTotalLength) {
        _textViewTotalLength = [[UILabel alloc] init];
        _textViewTotalLength.textColor = kBlackColor;
        _textViewTotalLength.attributedText = [self getAttributeString:@"0/30"];
        _textViewTotalLength.textAlignment = NSTextAlignmentRight;
        [_textViewTotalLength sizeToFit];
    }
    return _textViewTotalLength;
}

- (UIButton *)textViewClearButton {
    if (!_textViewClearButton) {
        _textViewClearButton = [MPMButton imageButtonWithImage:ImageName(@"approval_delete") hImage:ImageName(@"approval_delete")];
        _textViewClearButton.hidden = YES;
    }
    return _textViewClearButton;
}

@end
