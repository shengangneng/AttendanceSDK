//
//  MPMCalendarScrollView.m
//  MPMAtendence
//  考勤签到-日历滑动控件
//  Created by gangneng shen on 2018/5/8.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCalendarScrollView.h"
#import "MPMCalendarWeekView.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMAttendenceOneMonthModel.h"

#define kOneWeekInterval 604800

@interface MPMCalendarScrollView ()
// Views
@property (nonatomic, strong) MPMCalendarWeekView *lastWeekView;    /** 左一周视图 */
@property (nonatomic, strong) MPMCalendarWeekView *currentWeekView; /** 中一周视图 */
@property (nonatomic, strong) MPMCalendarWeekView *nextWeekView;    /** 右一周视图 */
// Data -- “6月,2018年,9日,周五”
@property (nonatomic, copy) NSArray *lastWeekData;                  /** 左一周视图的数据 */
@property (nonatomic, copy) NSArray *currentWeekData;               /** 中一周视图的数据 */
@property (nonatomic, copy) NSArray *nextWeekData;                  /** 右一周视图的数据 */

@property (nonatomic, strong) NSDate *currentMiddleDate;            /** 记录当前处在中间的视图的选中日期 */

@property (nonatomic, strong) NSDate *leftBoundarsDate;             /** 左三个月边界 */
@property (nonatomic, strong) NSDate *rightBoundarsDate;            /** 右三个月边界 */

@property (nonatomic, strong) NSDate *leftWeekBeginDate;            /** 左一周的左边界日期 */
@property (nonatomic, strong) NSDate *rightWeekEndDate;             /** 右一周的右边界日期 */

@property (nonatomic, assign) BOOL needBackToToday;                 /** 点击回到今天按钮的时候标记为YES */

@end

@implementation MPMCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstaints];
    }
    return self;
}

- (void)setupAttributes {
    // TODO：这里的日期[NSDate date]不知道有没有偏差
    self.needBackToToday = NO;
    self.currentMiddleDate = [NSDate date];
    self.leftBoundarsDate = [NSDate dateWithTimeInterval:-90*24*60*60 sinceDate:self.currentMiddleDate];
    self.rightBoundarsDate = [NSDate dateWithTimeInterval:90*24*60*60 sinceDate:self.currentMiddleDate];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    self.lastWeekData = [self getLeftWeek];
    self.currentWeekData = [self getMiddleWeek];
    self.nextWeekData = [self getRightWeek];
    
}

- (void)setupSubViews {
    [self addSubview:self.lastWeekView];
    [self addSubview:self.currentWeekView];
    [self addSubview:self.nextWeekView];
}

- (void)setupConstaints {
    self.lastWeekView.frame = CGRectMake(0, 0, kScreenWidth, PX_H(85));
    self.currentWeekView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, PX_H(85));
    self.nextWeekView.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, PX_H(85));
}

#pragma mark - Public Method

- (void)reloadData:(NSArray *)data {
    // 传入当前月份的信息
    NSMutableArray *currArray = [NSMutableArray arrayWithCapacity:7];
    NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:7];
    NSMutableArray *nextArray = [NSMutableArray arrayWithCapacity:7];
    
    NSString *realCurrentDateString = [NSDateFormatter formatterDate:[NSDate date] withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    
    for (int i = 0; i < data.count; i++) {
        MPMAttendenceOneMonthModel *model = data[i];
        for (int j = 0; j < self.currentWeekView.days.count; j++) {
            if ([self.currentWeekView.days[j] componentsSeparatedByString:@","].count > 2) {
                NSString *monthString = [self.currentWeekView.days[j] componentsSeparatedByString:@","].firstObject;
                NSString *dayString = [self.currentWeekView.days[j] componentsSeparatedByString:@","][2];
                if ([model.day containsString:[NSString stringWithFormat:@"-%02d-%02d",[monthString substringToIndex:monthString.length-1].intValue,dayString.intValue]]) {
                    if ([model.day isEqualToString:realCurrentDateString]) {
                        model.realCurrentDate = YES;
                    }
                    [currArray addObject:model];
                    continue;
                }
            }
        }
    }
    [self.currentWeekView updateButtonsView:currArray.copy];
    
    for (int i = 0; i < data.count; i++) {
        MPMAttendenceOneMonthModel *model = data[i];
        for (int j = 0; j < self.lastWeekView.days.count; j++) {
            if ([self.lastWeekView.days[j] componentsSeparatedByString:@","].count > 2) {
                NSString *monthString = [self.lastWeekView.days[j] componentsSeparatedByString:@","].firstObject;
                NSString *dayString = [self.lastWeekView.days[j] componentsSeparatedByString:@","][2];
                if ([model.day containsString:[NSString stringWithFormat:@"-%02d-%02d",[monthString substringToIndex:monthString.length-1].intValue,dayString.intValue]]) {
                    if ([model.day isEqualToString:realCurrentDateString]) {
                        model.realCurrentDate = YES;
                    }
                    [lastArray addObject:model];
                    continue;
                }
            }
        }
    }
    [self.lastWeekView updateButtonsView:lastArray.copy];
    
    for (int i = 0; i < data.count; i++) {
        MPMAttendenceOneMonthModel *model = data[i];
        for (int j = 0; j < self.nextWeekView.days.count; j++) {
            if ([self.nextWeekView.days[j] componentsSeparatedByString:@","].count > 2) {
                NSString *monthString = [self.nextWeekView.days[j] componentsSeparatedByString:@","].firstObject;
                NSString *dayString = [self.nextWeekView.days[j] componentsSeparatedByString:@","][2];
                if ([model.day containsString:[NSString stringWithFormat:@"-%02d-%02d",[monthString substringToIndex:monthString.length-1].intValue,dayString.intValue]]) {
                    if ([model.day isEqualToString:realCurrentDateString]) {
                        model.realCurrentDate = YES;
                    }
                    [nextArray addObject:model];
                    continue;
                }
            }
        }
    }
    [self.nextWeekView updateButtonsView:nextArray.copy];
}

- (void)changeToCurrentWeekDate {
    self.needBackToToday = YES;
    self.currentMiddleDate = [NSDate date];
    // 选中当前日期的按钮
    [self.currentWeekView selectCurrentDate];
    [self updateThreeWeekViewData];
    self.needBackToToday = NO;
}

- (void)changeToNextWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:self.currentMiddleDate];
    [comp setDay:([comp day] + 7 + 7 - (comp.weekday - 1))];
    NSDate *rightEndDate  = [cal dateFromComponents:comp];
    if ([rightEndDate compare:self.rightBoundarsDate] == NSOrderedDescending) return;
    self.rightWeekEndDate = rightEndDate;
    self.currentMiddleDate = [self.currentMiddleDate dateByAddingTimeInterval:kOneWeekInterval];
    [self updateThreeWeekViewData];
}

- (void)changeToLastWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:self.currentMiddleDate];
    [comp setDay:([comp day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:comp];
    [comp setDay:(comp.day - comp.weekday + 1)];
    NSDate *leftWeekBegin = [cal dateFromComponents:comp];
    if ([leftWeekBegin compare:self.leftBoundarsDate] == NSOrderedAscending) return;
    self.leftWeekBeginDate = leftWeekBegin;
    self.currentMiddleDate = lastWeek;
    [self updateThreeWeekViewData];
}

#pragma mark - Private Method

- (void)updateThreeWeekViewData {
    self.lastWeekData = [self getLeftWeek];
    self.currentWeekData = [self getMiddleWeek];
    self.nextWeekData = [self getRightWeek];
    [self.lastWeekView changeDays:self.lastWeekData];
    [self.currentWeekView changeDays:self.currentWeekData];
    [self.nextWeekView changeDays:self.nextWeekData];
    if (!kIsNilString(self.currentWeekView.currentSelectedYearMonth) && self.mpmDelegate && [self.mpmDelegate respondsToSelector:@selector(mpmCalendarScrollViewDidChangeYearMonth:currentMiddleDate:)]) {
        [self.mpmDelegate mpmCalendarScrollViewDidChangeYearMonth:self.currentWeekView.currentSelectedYearMonth currentMiddleDate:self.currentMiddleDate];
    }
}

- (NSArray *)getLeftWeek {
    // 当前日期减去7天
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:self.currentMiddleDate];
    [comp setDay:([comp day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:comp];
    NSArray *left = [self getWeekFromDate:lastWeek];
    return left;
}

- (NSArray *)getMiddleWeek {
    NSArray *middle = [self getWeekFromDate:self.currentMiddleDate];
    return middle;
}

- (NSArray *)getRightWeek {
    NSArray *right = [self getWeekFromDate:[self.currentMiddleDate dateByAddingTimeInterval:kOneWeekInterval]];
    return right;
}

/** 通过某一天，获取这一天所属周的信息 */
- (NSArray *)getWeekFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    // 得到星期几
    NSInteger weekDay = [comp weekday];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 0;
        lastDiff = 6;
    } else {
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 7 - weekDay;
    }
    NSMutableArray *currentWeeks = [NSMutableArray arrayWithCapacity:7];
    for (NSInteger i = firstDiff; i < lastDiff + 1; i++) {
        // 从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:date];
        NSString *dateStr = [NSDateFormatter formatterDate:curDate withDefineFormatterType:forDateFormatTypeMonthYearDayWeek];
        [currentWeeks addObject:dateStr];
    }
    return currentWeeks.copy;
}

#pragma mark - KVO contentOffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGPoint oldValue = [change[NSKeyValueChangeOldKey] CGPointValue];
    CGPoint newValue = [change[NSKeyValueChangeOldKey] CGPointValue];
    if (oldValue.x == 0 && newValue.x == 0) {
        return;
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetX = self.contentOffset.x;
        CGFloat littleValue = 0.2f;
        if (offsetX > kScreenWidth*2 - littleValue) {
            // 往右划到将近结束
            self.contentOffset = CGPointMake(kScreenWidth, 0);
            [self changeToNextWeek];
        } else if (offsetX < littleValue) {
            // 往左划到将近结束
            self.contentOffset = CGPointMake(kScreenWidth, 0);
            [self changeToLastWeek];
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - Lazy Init

- (MPMCalendarWeekView *)lastWeekView {
    if (!_lastWeekView) {
        _lastWeekView = [[MPMCalendarWeekView alloc] initWithWeekType:forLastWeek days:self.lastWeekData currentMiddleDate:self.currentMiddleDate];
    }
    return _lastWeekView;
}

- (MPMCalendarWeekView *)currentWeekView {
    if (!_currentWeekView) {
        _currentWeekView = [[MPMCalendarWeekView alloc] initWithWeekType:forCurrentWeek days:self.currentWeekData currentMiddleDate:self.currentMiddleDate];
        __weak typeof(self) weakself = self;
        _currentWeekView.clickBlock = ^(NSInteger offsetDay) {
            __strong typeof(weakself) strongself = weakself;
            if (strongself.needBackToToday) {
                return;
            }
            if (!kIsNilString(self.currentWeekView.currentSelectedYearMonth) && strongself.mpmDelegate && [strongself.mpmDelegate respondsToSelector:@selector(mpmCalendarScrollViewDidChangeYearMonth:currentMiddleDate:)]) {
                
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:strongself.currentMiddleDate];
                [comp setDay:([comp day] + offsetDay)];
                strongself.currentMiddleDate  = [cal dateFromComponents:comp];
                
                [strongself.mpmDelegate mpmCalendarScrollViewDidChangeYearMonth:strongself.currentWeekView.currentSelectedYearMonth currentMiddleDate:strongself.currentMiddleDate];
            }
        };
    }
    return _currentWeekView;
}

- (MPMCalendarWeekView *)nextWeekView {
    if (!_nextWeekView) {
        _nextWeekView = [[MPMCalendarWeekView alloc] initWithWeekType:forNextWeek days:self.nextWeekData currentMiddleDate:self.currentMiddleDate];
    }
    return _nextWeekView;
}
@end
