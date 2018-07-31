//
//  MPMRepairSigninAddDealTableViewCell.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
typedef void(^DeadlingBlock)(void);

@interface MPMRepairSigninAddDealTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UILabel *signTypeLabel;
@property (nonatomic, strong) UILabel *signTimeLabel;
@property (nonatomic, strong) UILabel *signDateLabel;
@property (nonatomic, strong) UIButton *signDealButton;
@property (nonatomic, copy) DeadlingBlock dealingBlock;

@end
