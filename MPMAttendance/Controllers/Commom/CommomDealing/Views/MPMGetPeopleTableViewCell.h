//
//  MPMGetPeopleTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/15.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

@interface MPMGetPeopleTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *depertLabel;
@property (nonatomic, strong) UIButton *accessDeleteButton;

@end
