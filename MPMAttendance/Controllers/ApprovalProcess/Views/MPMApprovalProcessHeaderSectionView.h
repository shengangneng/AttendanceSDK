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
typedef void(^SelectButtonBlock)(NSIndexPath *indexPath, FirstSectionType firstSectionType);
/** 高级筛选按钮 */
typedef void(^FillterButtonBlock)(void);

@interface MPMApprovalProcessHeaderSectionView : UIView

// 通过设置Data来动态创建视图
@property (nonatomic, copy) NSArray *firstSectionArray;
@property (nonatomic, copy) SelectButtonBlock selectBlock;
@property (nonatomic, copy) FillterButtonBlock fillterBlock;

- (instancetype)initWithFirstSectionArray:(NSArray<MPMApprovalFirstSectionModel *> *)firstSectionArray;
/** 设置默认选中按钮，会导致重新获取接口并刷新页面 */
- (void)setDefaultSelect;

@end
