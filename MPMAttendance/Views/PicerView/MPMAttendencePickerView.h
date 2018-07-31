//
//  MPMAttendencePickerView.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/9.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteSelectedBlock)(id data);

@class MPMAttendencePickerView;
@protocol MPMAttendencePickerViewDelegate<NSObject>
- (void)mpmAttendencePickerView:(MPMAttendencePickerView *)pickerView didSelectedData:(id)data;
@end

@interface MPMAttendencePickerView : UIView

@property (nonatomic, copy) CompleteSelectedBlock completeSelectBlock;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, weak) id<MPMAttendencePickerViewDelegate> delegate;

- (void)showInView:(UIView *)superView withPickerData:(NSArray *)pickerData selectRow:(NSInteger)selectRow;

@end
