//
//  MPMRepairSigninAddDealTableViewCell.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMDealingBorderButton.h"

@interface MPMRepairSigninAddDealTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UILabel *signTypeLabel;
@property (nonatomic, strong) UILabel *signTimeLabel;
@property (nonatomic, strong) UILabel *signDateLabel;
@property (nonatomic, strong) UIImageView *checkBox;/** 多选框 */

@end

typedef void(^ChangeMonthBlock)(BOOL thisMonth);/** 切换本月、上月。state: 0上月 1本月 */

@interface MPMRepairSigninMonthTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) MPMDealingBorderButton *lastMonthButton;
@property (nonatomic, strong) MPMDealingBorderButton *thisMonthButton;

@property (nonatomic, assign) BOOL thisMonth;/** YES本月 NO上个月 */

@property (nonatomic, copy) ChangeMonthBlock changeMonthBlock;

@end
