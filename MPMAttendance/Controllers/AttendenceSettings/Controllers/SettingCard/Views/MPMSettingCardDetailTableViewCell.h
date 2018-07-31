//
//  MPMSettingCardDetailTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
/** 图标+上titel+下detail */
@interface MPMSettingCardDetailTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UILabel *txDetailLabel;

@end
