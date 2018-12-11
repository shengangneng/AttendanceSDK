//
//  MPMAttendenceSetTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMAttendanceSettingModel.h"

@protocol MPMAttendenceSetTableViewCellDelegate <NSObject>

/** 删除cell使用Delegate的方式，之前block的方式在里面进行多次网络请求导致循环引用没找到解决办法 */
- (void)attendenceSetTableCellDidDeleteWithModel:(MPMAttendanceSettingModel *)model;

@end

/** 右上角编辑按钮 */
typedef void(^EditBlock)(void);
typedef void(^SwipeShowBlock)(void);
typedef void(^FoldBlock)(void);

@interface MPMAttendenceSetTableViewCell : MPMBaseTableViewCell

@property (nonatomic, copy) EditBlock editBlock;
@property (nonatomic, copy) SwipeShowBlock swipeShowBlock;
@property (nonatomic, copy) FoldBlock foldBlock;
@property (nonatomic, weak) id<MPMAttendenceSetTableViewCellDelegate> delegate;
@property (nonatomic, strong) MPMAttendanceSettingModel *model;

// 头部视图
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *headerIconView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIButton *headerEditButton;
@property (nonatomic, strong) UIButton *headerDeleteButton;
@property (nonatomic, strong) UIView *headerSeperateLine;
// 底部视图
@property (nonatomic, strong) UIImageView *bottomImageView;
// 参与人员
@property (nonatomic, strong) UILabel *workScopeLabel;
@property (nonatomic, strong) UILabel *workScopeMessage;
// 班次
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *classMessage;
// 考勤日期
@property (nonatomic, strong) UILabel *workDateLabel;
@property (nonatomic, strong) UILabel *workDateMessage;
// 地点
@property (nonatomic, strong) UILabel *workLocationLabel;
@property (nonatomic, strong) UILabel *workLocationMessage;

@property (nonatomic, strong) UIButton *foldLocationsButton;

// 自定义右滑视图
@property (nonatomic, strong) UIView *swipeView;
@property (nonatomic, strong) UILabel *swipeTitleLabel;

/** 隐藏SwipeView */
- (void)dismissSwipeView;

@end
