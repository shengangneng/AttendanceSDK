//
//  MPMAttendenceExceptionTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseTableViewCell.h"

@interface MPMAttendenceExceptionTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, strong) UIView *round;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *detailTimeLabel;
@property (nonatomic, strong) UIImageView *accessaryIcon;

@end
