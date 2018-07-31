//
//  MPMDatePickerView.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMDatePickerView;
/** 回传时间 */
typedef void(^CompleteSelectedDateBlock)(NSDate *date);

@protocol MPMDatePickerViewDelegate <NSObject>

- (void)mpmDatePickView:(MPMDatePickerView *)sender didSelectedData:(NSDate *)date;

@end

@interface MPMDatePickerView : UIView

@property (nonatomic, strong) UIDatePicker *datePickView;
@property (nonatomic, copy) CompleteSelectedDateBlock completeSelectDateBlock;
@property (nonatomic, copy) NSArray *pickerData;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, weak) id<MPMDatePickerViewDelegate> delegate;

- (void)showInView:(UIView *)superView;

@end
