//
//  MPMSigninDateView.m
//  MPMAtendence
//  日历顶部时间控件
//  Created by shengangneng on 2018/6/9.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSigninDateView.h"
#import "MPMAttendanceHeader.h"

@interface MPMSigninDateView ()

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weakLabel;

@property (nonatomic, copy) NSArray *laberArray;

@end

@implementation MPMSigninDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setDetailDate:(NSString *)detailDate {
    if (kIsNilString(detailDate)) {
        return;
    }
    NSArray *arr = [detailDate componentsSeparatedByString:@","];
    if (arr.count > 1) {
        self.monthLabel.text = [NSString stringWithFormat:@"%@%@",arr[1],arr[0]];
    }
    /*
     for (int i = 0; i < arr.count; i++) {
     UILabel *lb = self.laberArray[i];
     if (lb == self.dayLabel) {
     lb.text = [NSString stringWithFormat:@"%@日",arr[i]];
     } else {
     lb.text = arr[i];
     }
     }*/
}

- (void)setupAttributes {
    self.laberArray = @[self.monthLabel,self.yearLabel,self.dayLabel,self.weakLabel];
}
- (void)setupSubViews {
    [self addSubview:self.monthLabel];
    [self addSubview:self.yearLabel];
    [self addSubview:self.dayLabel];
    [self addSubview:self.weakLabel];
}
- (void)setupConstraints {
    [self.monthLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self.mpm_leading).offset(12);
    }];
    [self.yearLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.mpm_top).offset(PX_H(6));
        make.height.equalTo(@(PX_H(34)));
        make.leading.equalTo(self.monthLabel.mpm_trailing).offset(5);
    }];
    [self.dayLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.mpm_bottom).offset(-PX_H(6));
        make.height.equalTo(@(PX_H(34)));
        make.leading.equalTo(self.monthLabel.mpm_trailing).offset(5);
    }];
    [self.weakLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.mpm_bottom).offset(-PX_H(6));
        make.height.equalTo(@(PX_H(34)));
        make.leading.equalTo(self.dayLabel.mpm_trailing).offset(5);
    }];
}

#pragma mark - Lazy Init

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        [_monthLabel sizeToFit];
        _monthLabel.textColor = kWhiteColor;
        _monthLabel.font = SystemFont(30);
    }
    return _monthLabel;
}

- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        [_yearLabel sizeToFit];
        _yearLabel.textColor = kWhiteColor;
        _yearLabel.font = SystemFont(15);
    }
    return _yearLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        [_dayLabel sizeToFit];
        _dayLabel.textColor = kWhiteColor;
        _dayLabel.font = SystemFont(15);
    }
    return _dayLabel;
}

- (UILabel *)weakLabel {
    if (!_weakLabel) {
        _weakLabel = [[UILabel alloc] init];
        [_weakLabel sizeToFit];
        _weakLabel.textColor = kWhiteColor;
        _weakLabel.font = SystemFont(15);
    }
    return _weakLabel;
}

@end
