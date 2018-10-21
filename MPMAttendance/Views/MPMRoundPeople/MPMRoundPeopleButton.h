//
//  MPMRoundPeopleButton.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMRoundPeopleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPMRoundPeopleButton : UIButton

@property (nonatomic, strong) UIImageView *deleteIcon;
@property (nonatomic, strong) MPMRoundPeopleView *roundPeople;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
