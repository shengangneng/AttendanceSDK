//
//  MPMClassSettingTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

typedef NS_ENUM(NSInteger, ClassType) {
    kClassTypeFixation = 0, /** 固定排班 */
    kClassTypeFree = 1      /** 自由排班 */
};

#define kClassTypes @[@"固定",@"自由"]    /** 只能选择‘固定’或‘自由’ */
#define kSegmentItemWidth   52

typedef void(^SegmentChangeBlock)(ClassType classType);

@interface MPMClassSettingTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UISegmentedControl *segmentView;
@property (nonatomic, copy) SegmentChangeBlock segChangeBlock;

@end
