//
//  MPMCalendarButton.h
//  MPMAtendence
//  考勤打卡-日历按钮
//  Created by gangneng shen on 2018/5/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMCalendarButton : UIButton

@property (nonatomic, strong) UIImageView *workStatusImage;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *workTypeLabel;

@property (nonatomic, copy) NSString *isWorkDay;
@property (nonatomic, assign) BOOL realCurrentDate;

@end
