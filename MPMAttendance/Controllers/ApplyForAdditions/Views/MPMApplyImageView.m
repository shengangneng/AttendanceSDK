//
//  MPMApplyImageView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApplyImageView.h"
#import "MPMAttendanceHeader.h"

@interface MPMApplyImageView ()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *detailMessageLabel;

@end

@implementation MPMApplyImageView

- (instancetype)initWithTitle:(NSString *)title detailMessage:(NSString *)detailMessage {
    self = [super init];
    if (self) {
        self.titleLable.text = title;
        self.detailMessageLabel.text = detailMessage;
        [self addSubview:self.titleLable];
        [self addSubview:self.detailMessageLabel];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(20);
            make.top.equalTo(self.mas_top).offset(30);
        }];
        [self.detailMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLable.mas_leading);
            make.top.equalTo(self.titleLable.mas_bottom).offset(5);
            make.width.equalTo(@200);
        }];
    }
    return self;
}

#pragma mark - Lazy Init

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = kWhiteColor;
        _titleLable.font = BoldSystemFont(30);
        [_titleLable sizeToFit];
        _titleLable.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLable;
}

- (UILabel *)detailMessageLabel {
    if (!_detailMessageLabel) {
        _detailMessageLabel = [[UILabel alloc] init];
        _detailMessageLabel.textColor = kWhiteColor;
        _detailMessageLabel.numberOfLines = 0;
        _detailMessageLabel.font = SystemFont(15);
    }
    return _detailMessageLabel;
}
@end
