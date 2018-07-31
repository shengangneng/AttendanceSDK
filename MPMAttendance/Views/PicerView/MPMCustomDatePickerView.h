//
//  MPMCustomDatePickerView.h
//  MPMAtendence
//  自定义时间PickerView(时、分支持无限轮播)
//  Created by shengangneng on 2018/7/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CustomPickerViewType) {
    kCustomPickerViewTypeYearMonthDayHourMinute,    /** 年、月、日、时、分 */
    kCustomPickerViewTypeYearMonthDay,              /** 年、月、日 */
    kCustomPickerViewTypeYearMonth,                 /** 年、月(限制只显示当前月份和前面三个月) */
    kCustomPickerViewTypeHourMinute                 /** 时、分 */
};

typedef void(^CompleteSelectDateBlock)(NSDate *date);

@protocol MPMCustomDatePickerViewDelegate <NSObject>

- (void)customDatePickerViewDidCompleteSelectDate:(NSDate *)date;

@end

@interface MPMCustomDatePickerView : UIView

@property (nonatomic, strong) UIPickerView *customPickerView;
@property (nonatomic, copy) CompleteSelectDateBlock completeBlock;       /** 使用Block的方式回传数据 */
@property (nonatomic, weak) id<MPMCustomDatePickerViewDelegate> delegate;/** 使用Delegate的方式回传数据 */
@property (nonatomic, assign) BOOL isShowing;

/** 传入一个默认时间，如果没有默认时间，则取当前时间 */
- (void)showPicerViewWithType:(CustomPickerViewType)type defaultDate:(NSDate *)defaultDate;

@end
