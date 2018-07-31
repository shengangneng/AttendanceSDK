//
//  MPMClassSettingTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
typedef void(^SegmentChangeBlock)(NSInteger selectedIndex);

@interface MPMClassSettingTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UISegmentedControl *segmentView;
@property (nonatomic, copy) SegmentChangeBlock segChangeBlock;

@end
