//
//  MPMPlaceHoderTextView.m
//  MPMAtendence
//
//  Created by shengangneng on 2019/1/8.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import "MPMPlaceHoderTextView.h"
#import "MPMAttendanceHeader.h"

@implementation MPMPlaceHoderTextView

- (instancetype)initWithPlaceHolder:(NSString *)placeHoder {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.placeHolder];
    self.placeHolder.font = self.font;
    [self.placeHolder mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.trailing.equalTo(self);
        make.leading.equalTo(self.mpm_leading).offset(3);
        make.height.equalTo(@37);
    }];
    [self layoutIfNeeded];
}

#pragma mark - Lazy Init
- (UILabel *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = [[MPMTempPlaceHolderLabel alloc] init];
        _placeHolder.textColor = kMainLightGray;
        _placeHolder.backgroundColor = kClearColor;
        _placeHolder.userInteractionEnabled = NO;
        _placeHolder.text = @"请输入";
        _placeHolder.textAlignment = NSTextAlignmentLeft;
        [_placeHolder sizeToFit];
    }
    return _placeHolder;
}

@end

@implementation MPMTempPlaceHolderLabel

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 重写touchBegan，让父控件响应事件
}

@end

