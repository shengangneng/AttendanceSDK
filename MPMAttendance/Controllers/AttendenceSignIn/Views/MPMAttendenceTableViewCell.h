//
//  MPMAttendenceTableViewCell.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

@interface MPMAttendenceTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *classTypeLabel;  /** 上班下班 */
@property (nonatomic, strong) UILabel *timeLabel;       /** 时间段 */
@property (nonatomic, strong) UILabel *waitBrushLabel;  /** 等待打卡中 */
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *messageTimeLabel;
@property (nonatomic, strong) UIButton *scoreButton;
@property (nonatomic, strong) UIImageView *accessaryIcon;

@end
