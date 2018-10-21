//
//  MPMApprovalProcessHeaderSectionView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/18.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMApprovalFirstSectionModel.h"
#import "MPMApprovalProcessViewController.h"
/** 一级导航二级导航按钮点击 */
typedef void(^SelectButtonBlock)(NSIndexPath *indexPath);
/** 高级筛选按钮 */
typedef void(^FillterButtonBlock)(void);
/** 切换顶部Section的时候，需要设置第二级隐藏和显示 */
typedef void(^AnimateSecondSectionBlock)(BOOL needHideSecondSection);

@interface MPMApprovalProcessHeaderSectionView : UIView

// 通过设置Data来动态创建视图
@property (nonatomic, copy) NSArray *firstSectionTitlesArray;
@property (nonatomic, copy) SelectButtonBlock selectBlock;
@property (nonatomic, copy) FillterButtonBlock fillterBlock;
@property (nonatomic, copy) AnimateSecondSectionBlock animateSecondSectionBlock;
@property (nonatomic, assign, getter=isMyMatterHasUnreadCount) BOOL myMatterHasUnreadCount;/** 通过设置这个参数控制“我的事项”右上角红色的显示与否 */

/** 设置默认选中按钮，会导致重新获取接口并刷新页面 */
- (void)setDefaultSelect;

@end
