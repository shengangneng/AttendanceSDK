//
//  MPMCalendarWeekView.h
//  MPMAtendence
//  考勤打卡日历控件
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CalendarWeekType) {
    forCurrentWeek,
    forLastWeek,
    forNextWeek
};

typedef void(^CurrentWeekButtonClickBlock)(NSInteger offsetDay);

@interface MPMCalendarWeekView : UIView

/** 通过当前星期、上个星期、下个星期进行初始化 */
- (instancetype)initWithWeekType:(CalendarWeekType)weekType days:(NSArray *)days currentMiddleDate:(NSDate *)middleDate;
/** "2018年5月,25"使用逗号来分割 */
@property (nonatomic, copy) NSArray *days;
/** 班次信息 */
@property (nonatomic, copy) NSArray *attendanceArray;
/** 记录当前的年月:2018年5月 */
@property (nonatomic, copy) NSString *currentSelectedYearMonth;
@property (nonatomic, copy) CurrentWeekButtonClickBlock clickBlock;

- (void)changeDays:(NSArray *)days;
/** 选中当前月份当前日 */
- (void)selectCurrentDate;
- (void)updateButtonsView:(NSArray *)arr;


@end
