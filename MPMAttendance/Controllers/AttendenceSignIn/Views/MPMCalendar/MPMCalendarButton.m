//
//  MPMCalendarButton.m
//  MPMAtendence
//  考勤签到-日历按钮
//  Created by gangneng shen on 2018/5/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCalendarButton.h"

@implementation MPMCalendarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    self.backgroundColor = kClearColor;
    [self setImage:ImageName(@"attendence_circular") forState:UIControlStateSelected];
}

- (void)setupSubViews {
    [self addSubview:self.workStatusImage];
    [self addSubview:self.dateLabel];
    [self addSubview:self.workTypeLabel];
}

- (void)setupConstraints {
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(PX_H(5));
        make.height.equalTo(self.mas_height).multipliedBy(0.5);
    }];
    [self.workTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-PX_H(5));
        make.height.equalTo(self.mas_height).multipliedBy(0.5);
    }];
    [self.workStatusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_top);
        make.centerX.equalTo(self.mas_centerX).offset(PX_H(25));
        make.height.width.equalTo(@(PX_W(20)));
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _dateLabel.textColor = kMainBlueColor;
        _workTypeLabel.textColor = kMainBlueColor;
        _workStatusImage.hidden = YES;
    } else {
        _dateLabel.textColor = kWhiteColor;
        _workTypeLabel.textColor = kWhiteColor;
        
        if (self.isWorkDay.integerValue == 0) {
            self.workStatusImage.hidden = YES;
        } else if (self.isWorkDay.integerValue == 1) {
            self.workStatusImage.hidden = YES;
        } else if (self.isWorkDay.integerValue == 2) {
            self.workStatusImage.hidden = YES;
        } else if (self.isWorkDay.integerValue == 3) {
            self.workStatusImage.hidden = NO;
        }
    }
}

- (void)setIsWorkDay:(NSString *)isWorkDay {
    _isWorkDay = isWorkDay;
    if (!isWorkDay) {
        self.workStatusImage.hidden = YES;
        self.workTypeLabel.text = @"";
    } else if (isWorkDay.integerValue == 0) {
        self.workStatusImage.hidden = YES;
        self.workTypeLabel.text = @"休";
    } else if (isWorkDay.integerValue == 1) {
        self.workStatusImage.hidden = YES;
        self.workTypeLabel.text = @"班";
    } else if (isWorkDay.integerValue == 2) {
        self.workStatusImage.hidden = YES;
        self.workTypeLabel.text = @"";
    } else if (isWorkDay.integerValue == 3) {
        self.workStatusImage.hidden = NO;
        self.workTypeLabel.text = @"班";
    }
    if (self.selected) {
        self.workStatusImage.hidden = YES;
    }
}

- (void)setRealCurrentDate:(BOOL)realCurrentDate {
    _realCurrentDate = realCurrentDate;
    if (_realCurrentDate) {
        [self setImage:ImageName(@"attendence_circular_today") forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy Init

- (UIImageView *)workStatusImage {
    if (!_workStatusImage) {
        _workStatusImage = [[UIImageView alloc] init];
        _workStatusImage.image = ImageName(@"attendence_workStatus");
        _workStatusImage.hidden = YES;
    }
    return _workStatusImage;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = @"25";
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = kWhiteColor;
        _dateLabel.font = SystemFont(PX_W(28));
    }
    return _dateLabel;
}
- (UILabel *)workTypeLabel {
    if (!_workTypeLabel) {
        _workTypeLabel = [[UILabel alloc] init];
        _workTypeLabel.textAlignment = NSTextAlignmentCenter;
        _workTypeLabel.textColor = kWhiteColor;
        _workTypeLabel.font = SystemFont(PX_W(20));
    }
    return _workTypeLabel;
}
@end
