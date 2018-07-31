//
//  MPMDatePickerView.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDatePickerView.h"
#import "MPMButton.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMAttendanceHeader.h"

#define PickerViewRowHeight 50

@interface MPMDatePickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) UIView *mainMaskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *line;

@end

@implementation MPMDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        [self setupAttributes];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.mainMaskView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.datePickView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.sureButton];
    [self.contentView addSubview:self.line];
}

- (void)setupAttributes {
    self.isShowing = NO;
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
}

- (void)showInView:(UIView *)superView {
    // 需要传入superView，需要有相应的数据，否则直接return
    if (!superView || self.isShowing) {
        return;
    }
    self.isShowing = YES;
    self.superView = superView;
    self.datePickView.frame = CGRectMake(0, PickerViewRowHeight, kScreenWidth, 6 * PickerViewRowHeight);
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 7 * PickerViewRowHeight);
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.superView addSubview:self.mainMaskView];
        [self.superView addSubview:self.contentView];
        self.mainMaskView.hidden = NO;
        self.contentView.frame = CGRectMake(0, kScreenHeight - 7 * PickerViewRowHeight, kScreenWidth, 7 * PickerViewRowHeight);
    } completion:nil];
}

- (void)dismiss {
    if (!self.isShowing) {
        return;
    }
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mainMaskView.hidden = YES;
        self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 7 * PickerViewRowHeight);
    } completion:^(BOOL finished) {
        self.isShowing = NO;
        [self.mainMaskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Target Action
- (void)cancel:(UIButton *)sender {
    [self dismiss];
}

- (void)sure:(UIButton *)sender {
    DLog(@"%@",self.datePickView.date);
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mpmDatePickView:didSelectedData:)]) {
        [self.delegate mpmDatePickView:self didSelectedData:self.datePickView.date];
    }
    if (self.completeSelectDateBlock) {
        self.completeSelectDateBlock(self.datePickView.date);
    }
}

// 时间选择发生改变的时候会调用
- (void)dateChange:(UIDatePicker *)datePicker {
    DLog(@"%@",datePicker.date);
}

#pragma mark - UIPickerViewDataSource - Required

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.pickerData.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return ((NSArray *)self.pickerData[component]).count;
}

#pragma mark - Lazy Init
- (UIView *)mainMaskView {
    if (!_mainMaskView) {
        _mainMaskView = [[UIView alloc] init];
        _mainMaskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _mainMaskView.backgroundColor = kBlackColor;
        _mainMaskView.alpha = 0.2;
        _mainMaskView.hidden = YES;
    }
    return _mainMaskView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 7 * PickerViewRowHeight);
        _contentView.backgroundColor = kWhiteColor;
    }
    return _contentView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [MPMButton titleButtonWithTitle:@"取消" nTitleColor:kMainBlueColor hTitleColor:kLightBlueColor bgColor:kWhiteColor];
        _cancelButton.frame = CGRectMake(0, 0, 65, PickerViewRowHeight);
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [MPMButton titleButtonWithTitle:@"确定" nTitleColor:kMainBlueColor hTitleColor:kLightBlueColor bgColor:kWhiteColor];
        _sureButton.frame = CGRectMake(kScreenWidth - 65, 0, 65, PickerViewRowHeight);
    }
    return _sureButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kSeperateColor;
        _line.frame = CGRectMake(0, PickerViewRowHeight, kScreenWidth, 1);
    }
    return _line;
}

- (UIDatePicker *)datePickView {
    if (!_datePickView) {
        _datePickView = [[UIDatePicker alloc] init];
        _datePickView.datePickerMode = UIDatePickerModeDate;
        _datePickView.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        [_datePickView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePickView;
}


@end
