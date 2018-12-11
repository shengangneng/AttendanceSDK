//
//  MPMCalendarScrollView.h
//  MPMAtendence
//  考勤打卡-日历滑动控件
//  Created by gangneng shen on 2018/5/8.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMCalendarWeekView;

@protocol MPMCalendarScrollViewDelegate<NSObject>
- (void)mpmCalendarScrollViewDidChangeYearMonth:(NSString *)yearMonth currentMiddleDate:(NSDate *)date;
@end

@interface MPMCalendarScrollView : UIScrollView

@property (nonatomic, weak)id<MPMCalendarScrollViewDelegate> mpmDelegate;

/** 一次性查找前后共三周信息的接口 */
- (void)reloadLast:(NSArray *)lastArray current:(NSArray *)currentArray next:(NSArray *)nextArray;
/** 一次性查找前后共三个月信息的接口 */
- (void)reloadData:(NSArray *)data;

/** 选中当前星期当前日期 */
- (void)changeToCurrentWeekDate;
/** 切换为下个星期 */
- (void)changeToNextWeek;
/** 切换为上个星期 */
- (void)changeToLastWeek;

@end
