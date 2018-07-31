//
//  MPMAttendenceSetTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMAttendenceSettingModel.h"

@protocol MPMAttendenceSetTableViewCellDelegate <NSObject>

/** 删除cell使用Delegate的方式，之前block的方式在里面进行多次网络请求导致循环引用没找到解决办法 */
- (void)attendenceSetTableCellDidDeleteWithModel:(MPMAttendenceSettingModel *)model;

@end

/** 右上角编辑按钮 */
typedef void(^EditBlock)(void);
typedef void(^SwipeShowBlock)(void);

@interface MPMAttendenceSetTableViewCell : MPMBaseTableViewCell

@property (nonatomic, copy) EditBlock editBlock;
@property (nonatomic, copy) SwipeShowBlock swipeShowBlock;
@property (nonatomic, weak) id<MPMAttendenceSetTableViewCellDelegate> delegate;
@property (nonatomic, strong) MPMAttendenceSettingModel *model;


// 头部视图
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *headerIconView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIButton *headerEditButton;
// 底部视图
@property (nonatomic, strong) UIImageView *bottomImageView;
// 范围
@property (nonatomic, strong) UILabel *workScopeLabel;
// 班次
@property (nonatomic, strong) UILabel *classLabel1;
@property (nonatomic, strong) UILabel *classLabel2;
@property (nonatomic, strong) UILabel *classLabel3;
// 考勤日期
@property (nonatomic, strong) UILabel *workDateLabel;
// 地点
@property (nonatomic, strong) UILabel *workLocationLabel;
// wifi名称
@property (nonatomic, strong) UILabel *workWifiLabel;

// 自定义右滑视图
@property (nonatomic, strong) UIView *swipeView;
@property (nonatomic, strong) UILabel *swipeTitleLabel;

- (void)resetCellWithModel:(MPMAttendenceSettingModel *)model cellHeight:(CGFloat)height;
/** 隐藏SwipeView */
- (void)dismissSwipeView;

@end
