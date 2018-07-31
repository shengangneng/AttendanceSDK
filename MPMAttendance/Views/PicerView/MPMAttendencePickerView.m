//
//  MPMAttendencePickerView.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/9.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendencePickerView.h"
#import "MPMButton.h"

#define PickerViewRowHeight 50.0f
#define PickerRowCount      3

@interface MPMAttendencePickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *mainMaskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIPickerView *pickerView;
// data
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, copy) NSArray *pickerData;

@end

@implementation MPMAttendencePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.mainMaskView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.pickerView];
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

- (void)showInView:(UIView *)superView withPickerData:(NSArray *)pickerData selectRow:(NSInteger)selectRow {
    // 需要传入superView，需要有相应的数据，否则直接return
    if (!superView || self.isShowing || pickerData.count <= 1) {
        return;
    }
    self.pickerData = pickerData;
    self.selectedRow = (selectRow && selectRow>=0 && selectRow <= self.pickerData.count) ? selectRow : 0;
    self.isShowing = YES;
    self.pickerView.frame = CGRectMake(0, PickerViewRowHeight, kScreenWidth, PickerRowCount * PickerViewRowHeight);
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (PickerRowCount + 1) * PickerViewRowHeight);
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:selectRow inComponent:0 animated:YES];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [superView addSubview:self.mainMaskView];
        [superView addSubview:self.contentView];
        self.mainMaskView.hidden = NO;
        self.contentView.frame = CGRectMake(0, kScreenHeight - (PickerRowCount + 1) * PickerViewRowHeight, kScreenWidth, (PickerRowCount + 1) * PickerViewRowHeight);
    } completion:nil];
}

- (void)dismiss {
    if (!self.isShowing) {
        return;
    }
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mainMaskView.hidden = YES;
        self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (PickerRowCount + 1) * PickerViewRowHeight);
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
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mpmAttendencePickerView:didSelectedData:)]) {
        [self.delegate mpmAttendencePickerView:self didSelectedData:@(self.selectedRow)];
    }
    if (self.completeSelectBlock) {
        self.completeSelectBlock(self.pickerData[self.selectedRow]);
    }
}

#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return PickerViewRowHeight;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedRow = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    // 设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = kSeperateColor;
        }
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth - 30) / 3, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SystemFont(18);
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
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
        _line.frame = CGRectMake(0, PickerViewRowHeight, kScreenWidth, 0.5);
    }
    return _line;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.frame = CGRectMake(0, PickerViewRowHeight, kScreenWidth, 6 * PickerViewRowHeight);
    }
    return _pickerView;
}

@end
