//
//  MPMDealingSeeTimeTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseTableViewCell.h"

@interface MPMDealingSeeTimeTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *blueLineView;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *timeDetailLabel;

@end

@interface MPMDealingTotalTimeTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UILabel *detailTxLabel;

@end
