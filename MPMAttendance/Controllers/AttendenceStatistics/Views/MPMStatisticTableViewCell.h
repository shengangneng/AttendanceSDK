//
//  MPMStatisticTableViewCell.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

@interface MPMStatisticTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *scoreLabel;

@end
