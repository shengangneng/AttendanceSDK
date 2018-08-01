//
//  MPMCreateOrangeTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCreateOrangeTableViewCell.h"

@interface MPMCreateOrangeTableViewCell() <UITextFieldDelegate>

@end

@implementation MPMCreateOrangeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.accessoryType = UITableViewCellAccessoryNone;
        [self addSubview:self.classNameLabel];
        [self.classNameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.trailing.equalTo(self.mpm_trailing).offset(-15);
            make.leading.equalTo(self.textLabel.mpm_leading).offset(5);
        }];
    }
    return self;
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
    if (self.textFieldChangeBlock) {
        self.textFieldChangeBlock(toBeString);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textFieldChangeBlock) {
        self.textFieldChangeBlock(@"");
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.classNameLabel resignFirstResponder];
    return YES;
}

#pragma mark - Lazy Init
- (UITextField *)classNameLabel {
    if (!_classNameLabel) {
        _classNameLabel = [[UITextField alloc] init];
        _classNameLabel.delegate = self;
        _classNameLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
        _classNameLabel.textAlignment = NSTextAlignmentRight;
        _classNameLabel.placeholder = @"例如：客服的早班";
        _classNameLabel.font = SystemFont(17);
        _classNameLabel.textColor = kMainLightGray;
    }
    return _classNameLabel;
}

@end
