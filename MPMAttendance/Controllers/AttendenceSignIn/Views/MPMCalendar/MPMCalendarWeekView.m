//
//  MPMCalendarWeekView.m
//  MPMAtendence
//  考勤签到日历控件
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCalendarWeekView.h"
#import "MPMCalendarButton.h"
#import "MPMAttendenceOneMonthModel.h"

#define kViewBounds             (kScreenWidth / 7)
#define kMPMCalendarButtonTag   999

@interface MPMCalendarWeekView ()

@property (nonatomic, assign) CalendarWeekType weekType;
@property (nonatomic, strong) MPMCalendarButton *lastCalendarSelectedButton;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) NSDate *currentMiddleDate;

@end

@implementation MPMCalendarWeekView

// 第一次初始化，通过当前日期来决定当前星期的信息

- (instancetype)initWithWeekType:(CalendarWeekType)weekType days:(NSArray *)days currentMiddleDate:(NSDate *)middleDate {
    self = [super init];
    if (self) {
        self.buttons = [NSMutableArray array];
        self.currentMiddleDate = middleDate;
        self.weekType = weekType;
        self.days = days;
        [self setupSubViews];
    }
    return self;
}

- (void)setupAttributes {
    
}

- (void)setupSubViews {
    for (int i = 0; i < self.days.count; i++) {
        UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(i * kViewBounds, 0, kViewBounds, PX_H(85))];
        
        MPMCalendarButton *btn = [[MPMCalendarButton alloc] init];
        btn.tag = 999 + i;
        [btn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, PX_H(80), PX_H(80));
        btn.layer.cornerRadius = PX_H(40);
        btn.dateLabel.text = [self.days[i] componentsSeparatedByString:@","][2];
        CGPoint center = temp.center;
        btn.center = center;
        [self addSubview:btn];
        [self.buttons addObject:btn];
    }
    // 如果初始化的时候是当前的weekView，那么让它选中当前日期的按钮
    if (self.weekType == forCurrentWeek && self.currentMiddleDate) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:self.currentMiddleDate];
        MPMCalendarButton *btn = self.buttons[comp.weekday-1];
        [self selectDate:btn];
    }
}

- (void)changeDays:(NSArray *)days {
    self.days = days;
    for (int i = 0; i < days.count; i++) {
        MPMCalendarButton *btn = self.buttons[i];
        NSString *title = [days[i] componentsSeparatedByString:@","][2];
        btn.dateLabel.text = title;
        if (btn.selected && self.weekType == forCurrentWeek) {
            self.currentSelectedYearMonth = days[i];
        }
    }
}

- (void)setupConstraints {
    
}

#pragma mark - Target Action
/// 点击按钮，选中某一天
- (void)selectDate:(MPMCalendarButton *)sender {
    NSInteger offsetDay = sender.tag - self.lastCalendarSelectedButton.tag;
    self.lastCalendarSelectedButton.selected = NO;
    sender.selected = !sender.selected;
    self.lastCalendarSelectedButton = sender;
    self.currentSelectedYearMonth = self.days[sender.tag - 999];
    if (self.clickBlock) {
        self.clickBlock(offsetDay);
    }
}

#pragma mark - Public Method
- (void)selectCurrentDate {
    if (self.weekType != forCurrentWeek) return;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:self.currentMiddleDate];
    MPMCalendarButton *btn = self.buttons[comp.weekday-1];
    [self selectDate:btn];
}

- (void)updateButtonsView:(NSArray *)arr {
    for (int i = 0; i < arr.count; i++) {
        MPMCalendarButton *btn = self.buttons[i];
        MPMAttendenceOneMonthModel *model = arr[i];
        btn.isWorkDay = model.isWorkDay;
        btn.realCurrentDate = model.realCurrentDate;
    }
}

@end
