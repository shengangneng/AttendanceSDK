//
//  MPMSiderDrawerCollectionViewTimeCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/26.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSiderDrawerCollectionViewTimeCell.h"
#import "MPMButton.h"
#import "MPMAttendanceHeader.h"

@interface MPMSiderDrawerCollectionViewTimeCell()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *startTimeButton;
@property (nonatomic, strong) UIButton *endTimeButton;
@property (nonatomic, strong) UIView *line;

@end

@implementation MPMSiderDrawerCollectionViewTimeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
    }
    return self;
}

- (void)setupAttributes {
    [self.startTimeButton addTarget:self action:@selector(selectStartTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.endTimeButton addTarget:self action:@selector(selectEndTime:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.backView];
    [self.backView addSubview:self.startTimeButton];
    [self.backView addSubview:self.endTimeButton];
    [self.backView addSubview:self.line];
}

#pragma mark - Target Action
- (void)selectStartTime:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(siderDrawerCell:didSelectStartTime:)]) {
        [self.delegate siderDrawerCell:self didSelectStartTime:sender];
    }
}

- (void)selectEndTime:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(siderDrawerCell:didSelectEndTime:)]) {
        [self.delegate siderDrawerCell:self didSelectEndTime:sender];
    }
}

#pragma mark - Lazy Init
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(6, 6, 229, 43);
        _backView.layer.cornerRadius = 5;
        _backView.backgroundColor = kTableViewBGColor;
    }
    return _backView;
}

- (UIButton *)startTimeButton {
    if (!_startTimeButton) {
        _startTimeButton = [MPMButton normalButtonWithTitle:@"开始时间" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _startTimeButton.frame = CGRectMake(6, 6, 96.5, 31);
        _startTimeButton.tag = StartButtonTag;
        _startTimeButton.layer.cornerRadius = 3;
        _startTimeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _startTimeButton.titleLabel.font = SystemFont(14);
    }
    return _startTimeButton;
}

- (UIButton *)endTimeButton {
    if (!_endTimeButton) {
        _endTimeButton = [MPMButton normalButtonWithTitle:@"结束时间" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _endTimeButton.frame = CGRectMake(126.5, 6, 96.5, 31);
        _endTimeButton.tag = EndButtonTag;
        _endTimeButton.layer.cornerRadius = 3;
        _endTimeButton.titleLabel.font = SystemFont(14);
        _endTimeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _endTimeButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kMainTextFontColor;
        _line.frame = CGRectMake(108.5, 21.5, 12, 1);
    }
    return _line;
}

@end
