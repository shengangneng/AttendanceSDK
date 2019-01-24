//
//  MPMIntergralScoreView.m
//  MPMAtendence
//  加减分和输入框控件
//  Created by shengangneng on 2018/6/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMIntergralScoreView.h"
#import "MPMCheckRegexTool.h"
#import "MPMAttendanceHeader.h"
#import "MPMCommomTool.h"

@interface MPMIntergralScoreView () <UITextFieldDelegate>

@end

@implementation MPMIntergralScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setState:(NSInteger)state {
    _state = state;
    if (self.type == 1) {
        // 长图片
        if (state == 1) {
            self.imageView.image = ImageName(@"setting_twodec");
            self.textLabel.text = @"-B";
        } else {
            self.imageView.image = ImageName(@"setting_twoace");
            self.textLabel.text = @"+B";
        }
    } else {
        // 短图片
        if (state == 1) {
            self.imageView.image = ImageName(@"setting_onedec");
            self.textLabel.text = @"-B";
        } else {
            self.imageView.image = ImageName(@"setting_oneace");
            self.textLabel.text = @"+B";
        }
    }
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (self.state == 1) {
        // 减号
        if (type == 1) {
            self.imageView.image = ImageName(@"setting_twodec");
        } else {
            self.imageView.image = ImageName(@"setting_onedec");
        }
    } else {
        // 加号
        if (type == 1) {
            self.imageView.image = ImageName(@"setting_twoace");
        } else {
            self.imageView.image = ImageName(@"setting_oneace");
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.tfBecomeResponderBlock) {
        self.tfBecomeResponderBlock(textField);
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([MPMCommomTool textViewOrTextFieldHasEmoji:textField]) {
        return NO;
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 限制数字，长度为10
    BOOL shoulChange = [MPMCheckRegexTool checkString:toBeString onlyHasDigitAndLength:10 decimalLength:0];
    if (shoulChange && self.tfChangeTextBlock) {
        // 如果可以改变，回传文字
        self.tfChangeTextBlock(toBeString);
    }
    return shoulChange;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0 && self.tfChangeTextBlock) {
        textField.text = @"0";
        self.tfChangeTextBlock(@"0");
    }
}

#pragma mark - UITapGesture
- (void)changeState:(UITapGestureRecognizer *)gesture {
    self.state == 1 ? (self.state = 0) : (self.state = 1);
    if (self.changeStateBlock) {
        self.changeStateBlock(self.state);
    }
}

- (void)setupAttributes {
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeState:)]];
}

- (void)setupSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.textfield];
}

- (void)setupConstraints {
    [self.imageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.textLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self.mpm_leading).offset(1);
        make.width.equalTo(@33);
    }];
    [self.textfield mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self.mpm_top).offset(1);
        make.trailing.equalTo(self.mpm_trailing).offset(-1);
        make.width.equalTo(@43);
    }];
}

#pragma mark - Lazy Init
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.image = ImageName(@"setting_oneace");
        [_imageView sizeToFit];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"+B";
        _textLabel.font = SystemFont(17);
        _textLabel.textColor = kWhiteColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc] init];
        _textfield.keyboardType = UIKeyboardTypeNumberPad;
        _textfield.font = SystemFont(17);
        _textfield.textAlignment = NSTextAlignmentCenter;
        _textfield.delegate = self;
    }
    return _textfield;
}

@end
