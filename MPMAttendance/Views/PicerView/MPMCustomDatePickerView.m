//
//  MPMCustomDatePickerView.m
//  MPMAtendence
//  自定义跨天的PickerView(支持无限轮播)
//  Created by shengangneng on 2018/7/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCustomDatePickerView.h"
#import "MPMButton.h"
#import "MPMAttendanceHeader.h"

#define PickerViewRowHeight 50  /** 每行的高度 */
#define kLimitMonthCount 4      /** kCustomPickerViewTypeYearMonth：只显示当前月和前三个月共4个月数据 */
#define kThreeYearMonthCount 36 /** kCustomPickerViewTypeYearMonthDayHourMinute、kCustomPickerViewTypeYearMonthDay：前一年、后一年、共三年36个月的数据 */

@interface MPMCustomDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *mainMaskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *line;
// Data
@property (nonatomic, copy) NSArray *yearsOfLimit4Array;/** 当前月份并往前三个月的年-对应kCustomPickerViewTypeYearMonth */
@property (nonatomic, copy) NSArray *monthOfLimit4Array;/** 当前月份并往前三个月的月-对应kCustomPickerViewTypeYearMonth */

@property (nonatomic, copy) NSArray *yearsArray;    /** 年 */
@property (nonatomic, copy) NSArray *monthArray;    /** 月 */
@property (nonatomic, copy) NSArray *dayArray1;     /** 日：1-28 */
@property (nonatomic, copy) NSArray *dayArray2;     /** 日：1-29 */
@property (nonatomic, copy) NSArray *dayArray3;     /** 日：1-30 */
@property (nonatomic, copy) NSArray *dayArray4;     /** 日：1-31 */
@property (nonatomic, copy) NSArray *hoursArray;    /** 时 */
@property (nonatomic, copy) NSArray *minutesArray;  /** 分 */

@property (nonatomic, copy) NSString *selectYear;   /** 选中的年 */
@property (nonatomic, copy) NSString *selectMonth;  /** 选中的月 */
@property (nonatomic, copy) NSString *selectDay;    /** 选中的日 */
@property (nonatomic, copy) NSString *selectHour;   /** 选中的时 */
@property (nonatomic, copy) NSString *selectMinute; /** 选中的分 */

// PickerView类型
@property (nonatomic, assign) CustomPickerViewType customPickerViewType;

@end

@implementation MPMCustomDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
    }
    return self;
}

- (void)setupAttributes {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
    // 筛选包含当前月并往前三个月的数据
    NSMutableArray *yearsLimitTemp = [NSMutableArray arrayWithCapacity:kLimitMonthCount];
    NSMutableArray *monthLimitTemp = [NSMutableArray arrayWithCapacity:kLimitMonthCount];
    for (int i = 1; i < kLimitMonthCount + 1; i++) {
        NSInteger year = comp.year;
        NSInteger month = comp.month - kLimitMonthCount + i;
        if (month <= 0) {
            year -= 1;
            month += 12;
        }
        [yearsLimitTemp addObject:[NSString stringWithFormat:@"%ld",year]];
        [monthLimitTemp addObject:[NSString stringWithFormat:@"%ld",month]];
    }
    self.yearsOfLimit4Array = yearsLimitTemp.copy;
    self.monthOfLimit4Array = monthLimitTemp.copy;
    // 只显示前1年、后1年的数据
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:kThreeYearMonthCount];
    for (int i = 0; i < 12; i++) {
        [temp addObject:[NSString stringWithFormat:@"%ld",comp.year - 1]];
    }
    for (int i = 0; i < 12; i++) {
        [temp addObject:[NSString stringWithFormat:@"%ld",comp.year]];
    }
    for (int i = 0; i < 12; i++) {
        [temp addObject:[NSString stringWithFormat:@"%ld",comp.year + 1]];
    }
    self.yearsArray = temp.copy;
    self.monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    self.dayArray1 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
    self.dayArray2 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"];
    self.dayArray3 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"];
    self.dayArray4 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    self.hoursArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    self.minutesArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    self.isShowing = NO;
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
}

- (void)setupSubViews {
    [self addSubview:self.mainMaskView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.customPickerView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.sureButton];
    [self.contentView addSubview:self.line];
}

#pragma mark - Public Method
- (void)showPicerViewWithType:(CustomPickerViewType)type defaultDate:(NSDate *)defaultDate {
    if (self.isShowing) {
        return;
    }
    self.customPickerViewType = type;
    self.isShowing = YES;
    NSInteger count = 5;
    self.customPickerView.frame = CGRectMake(0, PickerViewRowHeight, kScreenWidth, count * PickerViewRowHeight);
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (count + 1) * PickerViewRowHeight);
    // 根据默认时间来初始化PickerView的选项
    [self setupCrossPickerViewWithDefaultDate:defaultDate];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [kAppDelegate.window addSubview:self.mainMaskView];
        [kAppDelegate.window addSubview:self.contentView];
        self.mainMaskView.hidden = NO;
        self.contentView.frame = CGRectMake(0, kScreenHeight - (count + 1) * PickerViewRowHeight, kScreenWidth, (count + 1) * PickerViewRowHeight);
    } completion:nil];
}

- (void)setupCrossPickerViewWithDefaultDate:(NSDate *)defaultDate {
    if (!defaultDate) {
        defaultDate = [NSDate date];
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:defaultDate];
    // 默认PickerView先滚100转
    NSInteger initYearRow = [self.yearsArray indexOfObject:[NSString stringWithFormat:@"%ld",comp.year]];
    initYearRow = (initYearRow > 36 || initYearRow < 0) ? 12 : initYearRow;// 防止用户修改手机时间导致数组越界
    NSInteger initMonthRow = comp.month - 1;
    NSInteger initDayRow = comp.day - 1;
    NSInteger initHourRow = self.hoursArray.count * 100 + comp.hour;
    NSInteger initMinuteRow = self.minutesArray.count * 100 + comp.minute;
    // 当前月和前三个月共四个月的
    NSInteger initYearLimit4MonthRow = [self.monthOfLimit4Array indexOfObject:[NSString stringWithFormat:@"%ld",comp.month]];
    initYearLimit4MonthRow = ((initYearLimit4MonthRow > 4 || initYearLimit4MonthRow < 0) ? 3 : initYearLimit4MonthRow);// 防止用户修改手机时间导致数组越界
    // 由于小时、分钟、可以无限滚动，每次进来都先默认滚动到滚动特定的循环，形成无限循环的假象
    switch (self.customPickerViewType) {
        case kCustomPickerViewTypeYearMonthDayHourMinute:{
            [self.customPickerView selectRow:initYearRow+initMonthRow inComponent:0 animated:NO];
            [self.customPickerView selectRow:initDayRow inComponent:1 animated:NO];
            [self.customPickerView selectRow:initHourRow inComponent:2 animated:NO];
            [self.customPickerView selectRow:initMinuteRow inComponent:3 animated:NO];
        }break;
        case kCustomPickerViewTypeYearMonthDay:{
            [self.customPickerView selectRow:initYearRow+initMonthRow inComponent:0 animated:NO];
            [self.customPickerView selectRow:initDayRow inComponent:1 animated:NO];
        }break;
        case kCustomPickerViewTypeYearMonth:{
            [self.customPickerView selectRow:initYearLimit4MonthRow inComponent:0 animated:NO];
        }break;
        case kCustomPickerViewTypeHourMinute:{
            [self.customPickerView selectRow:initHourRow inComponent:0 animated:NO];
            [self.customPickerView selectRow:initMinuteRow inComponent:1 animated:NO];
        }break;
        default:
            break;
    }
    self.selectYear = [NSString stringWithFormat:@"%ld",comp.year];
    self.selectMonth = [NSString stringWithFormat:@"%ld",comp.month];
    self.selectDay = [NSString stringWithFormat:@"%ld",comp.day];
    self.selectHour = self.hoursArray[initHourRow % self.hoursArray.count];
    self.selectMinute = self.minutesArray[initMinuteRow % self.minutesArray.count];
}

#pragma mark - Target Action
- (void)cancel:(UIButton *)sender {
    [self dismiss];
}

- (void)sure:(UIButton *)sender {
    // 把字符串的"年月日时分"转换成NSDate类型
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    if (self.customPickerViewType == kCustomPickerViewTypeYearMonthDayHourMinute) {
        NSInteger yearMonthIndex = [self.customPickerView selectedRowInComponent:0];
        NSInteger dayIndex = [self.customPickerView selectedRowInComponent:1];
        NSInteger hourIndex = [self.customPickerView selectedRowInComponent:2];
        NSInteger minuteIndex = [self.customPickerView selectedRowInComponent:3];
        self.selectYear = self.yearsArray[yearMonthIndex];
        self.selectMonth = self.monthArray[yearMonthIndex % 12];
        self.selectDay = self.dayArray4[dayIndex];
        self.selectHour = self.hoursArray[hourIndex % self.hoursArray.count];
        self.selectMinute = self.minutesArray[minuteIndex % self.minutesArray.count];
    } else if (self.customPickerViewType == kCustomPickerViewTypeYearMonthDay) {
        NSInteger yearMonthIndex = [self.customPickerView selectedRowInComponent:0];
        NSInteger dayIndex = [self.customPickerView selectedRowInComponent:1];
        self.selectYear = self.yearsArray[yearMonthIndex];
        self.selectMonth = self.monthArray[yearMonthIndex % 12];
        self.selectDay = self.dayArray4[dayIndex];
    } else if (self.customPickerViewType == kCustomPickerViewTypeYearMonth) {
        NSInteger yearMonthIndex = [self.customPickerView selectedRowInComponent:0];
        self.selectYear = self.yearsOfLimit4Array[yearMonthIndex];
        self.selectMonth = self.monthOfLimit4Array[yearMonthIndex];
    } else {
        NSInteger hourIndex = [self.customPickerView selectedRowInComponent:0];
        NSInteger minuteIndex = [self.customPickerView selectedRowInComponent:1];
        self.selectHour = self.hoursArray[hourIndex % self.hoursArray.count];
        self.selectMinute = self.minutesArray[minuteIndex % self.minutesArray.count];
    }
    [comp setYear:self.selectYear.integerValue];
    [comp setMonth:self.selectMonth.integerValue];
    [comp setDay:self.selectDay.integerValue];
    [comp setHour:self.selectHour.integerValue];
    [comp setMinute:self.selectMinute.integerValue];
    NSDate *selectDate = [cal dateFromComponents:comp];
    if (self.completeBlock) {
        self.completeBlock(selectDate);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(customDatePickerViewDidCompleteSelectDate:)]) {
        [self.delegate customDatePickerViewDidCompleteSelectDate:selectDate];
    }
    [self dismiss];
}

#pragma mark - Private Method
- (void)dismiss {
    if (!self.isShowing) {
        return;
    }
    NSInteger count = 5;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mainMaskView.hidden = YES;
        self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (count + 1) * PickerViewRowHeight);
    } completion:^(BOOL finished) {
        self.isShowing = NO;
        [self.mainMaskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.customPickerViewType) {
        case kCustomPickerViewTypeYearMonthDayHourMinute:
            return 4;
            break;
        case kCustomPickerViewTypeYearMonthDay:
            return 2;
            break;
        case kCustomPickerViewTypeYearMonth:
            return 1;
            break;
        case kCustomPickerViewTypeHourMinute:
            return 2;
            break;
        default:
            return 5;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.customPickerViewType == kCustomPickerViewTypeYearMonthDayHourMinute) {
        switch (component) {
            case 0: {
                return 120;
            }break;
            case 1:
            case 2:
            case 3:{
                return (kScreenWidth - 130)/3;
            }break;
            default:
                return 0;
                break;
        }
    } else if (self.customPickerViewType == kCustomPickerViewTypeYearMonthDay) {
        return kScreenWidth / 2;
    } else if (self.customPickerViewType == kCustomPickerViewTypeYearMonth) {
        return kScreenWidth - 20;
    } else {
        return kScreenWidth / 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.customPickerViewType) {
        case kCustomPickerViewTypeYearMonthDayHourMinute: {
            switch (component) {
                case 0:{
                    return self.yearsArray.count;
                }break;
                case 1:{
                    NSInteger index = [pickerView selectedRowInComponent:0];
                    NSString *yearTitle = self.yearsArray[index];
                    switch (index % 12) {
                        case 0:
                        case 2:
                        case 4:
                        case 6:
                        case 7:
                        case 9:
                        case 11:{
                            return self.dayArray4.count;
                        }break;
                        case 3:
                        case 5:
                        case 8:
                        case 10:{
                            return self.dayArray3.count;
                        }break;
                        case 1:{
                            if ((yearTitle.integerValue % 4==0 && yearTitle.integerValue % 100 != 0) || yearTitle.integerValue % 400 == 0) {
                                // 闰年
                                return self.dayArray2.count;
                            } else {
                                return self.dayArray1.count;
                            }
                        }break;
                            
                        default:
                            break;
                    }
                }break;
                case 2:{
                    return 99999;
                }break;
                case 3:{
                    return 99999;
                }break;
                default:
                    return 99999;
                    break;
            }
        }break;
            
        case kCustomPickerViewTypeYearMonthDay: {
            switch (component) {
                case 0:{
                    return self.yearsArray.count;
                }break;
                case 1:{
                    NSInteger index = [pickerView selectedRowInComponent:0];
                    NSString *yearTitle = self.yearsArray[index];
                    switch (index % 12) {
                        case 0:
                        case 2:
                        case 4:
                        case 6:
                        case 7:
                        case 9:
                        case 11:{
                            return self.dayArray4.count;
                        }break;
                        case 3:
                        case 5:
                        case 8:
                        case 10:{
                            return self.dayArray3.count;
                        }break;
                        case 1:{
                            if ((yearTitle.integerValue % 4==0 && yearTitle.integerValue % 100 != 0) || yearTitle.integerValue % 400 == 0) {
                                // 闰年
                                return self.dayArray2.count;
                            } else {
                                return self.dayArray1.count;
                            }
                        }break;
                            
                        default:
                            break;
                    }
                }break;
                    return 0;
                    break;
            }
        }break;
            
        case kCustomPickerViewTypeYearMonth: {
            switch (component) {
                case 0:{
                    return self.yearsOfLimit4Array.count;
                }break;
                    return self.yearsOfLimit4Array.count;
                    break;
            }
        }break;
            
        case kCustomPickerViewTypeHourMinute: {
            switch (component) {
                case 0:{
                    return 99999;
                }break;
                case 1:{
                    return 99999;
                }break;
                default:
                    return 99999;
                    break;
            }
        }break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return PickerViewRowHeight;
}

// 根据取模返回数组里面的重复数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.customPickerViewType) {
        case kCustomPickerViewTypeYearMonthDayHourMinute:{
            switch (component) {
                case 0:{
                    return [NSString stringWithFormat:@"%@年%@月",self.yearsArray[row],self.monthArray[row % 12]];
                }break;
                case 1:{
                    return [NSString stringWithFormat:@"%@日",self.dayArray4[row]];
                }break;
                case 2:{
                    NSInteger index = row % self.hoursArray.count;
                    NSString *str = [self.hoursArray objectAtIndex:index];
                    return [NSString stringWithFormat:@"%@时",str];
                }break;
                case 3:{
                    NSInteger index = row % self.minutesArray.count;
                    NSString *str = [self.minutesArray objectAtIndex:index];
                    return [NSString stringWithFormat:@"%@分",str];
                }break;
                default:
                    return @"";break;
            }
        }break;
            
        case kCustomPickerViewTypeYearMonthDay:{
            switch (component) {
                case 0:{
                    return [NSString stringWithFormat:@"%@年%@月",self.yearsArray[row],self.monthArray[row % 12]];
                }break;
                case 1:{
                    return [NSString stringWithFormat:@"%@日",self.dayArray4[row]];
                }break;
                default:
                    return @"";break;
            }
        }break;
            
        case kCustomPickerViewTypeYearMonth:{
            switch (component) {
                case 0:{
                    return [NSString stringWithFormat:@"%@年%@月",self.yearsOfLimit4Array[row],self.monthOfLimit4Array[row]];
                }break;
                default:
                    return @"";break;
            }
        }break;
            
        case kCustomPickerViewTypeHourMinute:{
            switch (component) {
                case 0:{
                    NSInteger index = row % self.hoursArray.count;
                    NSString *str = [self.hoursArray objectAtIndex:index];
                    return [NSString stringWithFormat:@"%@时",str];
                }break;
                case 1:{
                    NSInteger index = row % self.minutesArray.count;
                    NSString *str = [self.minutesArray objectAtIndex:index];
                    return [NSString stringWithFormat:@"%@分",str];
                }break;
                default:
                    return @"";break;
            }
        }break;
        default:return @"";break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.customPickerViewType) {
        case kCustomPickerViewTypeYearMonthDayHourMinute: {
            switch (component) {
                case 0:{
                    [pickerView reloadComponent:1];
                } break;
                case 1:{
                } break;
                case 2:{
                } break;
                case 3:{
                } break;
                default:
                    break;
            }
        }break;
        case kCustomPickerViewTypeYearMonthDay: {
            switch (component) {
                case 0:{
                    [pickerView reloadComponent:1];
                } break;
                case 1:{
                } break;
                default:
                    break;
            }
        }break;
        case kCustomPickerViewTypeYearMonth: {
            switch (component) {
                case 0:{
                } break;
                default:
                    break;
            }
        }break;
        case kCustomPickerViewTypeHourMinute: {
            switch (component) {
                case 0:{
                } break;
                case 1:{
                } break;
                default:
                    break;
            }
        }break;
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    // 设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = kSeperateColor;
        }
    }
    UILabel *label = [[UILabel alloc] init];
    // 设置字体
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

- (UIPickerView *)customPickerView {
    if (!_customPickerView) {
        _customPickerView = [[UIPickerView alloc] init];
        _customPickerView.delegate = self;
        _customPickerView.dataSource = self;
        _customPickerView.frame = CGRectMake(0, PickerViewRowHeight, kScreenWidth, 6 * PickerViewRowHeight);
    }
    return _customPickerView;
}

@end
