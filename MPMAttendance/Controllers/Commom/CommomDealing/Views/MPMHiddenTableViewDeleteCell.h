//
//  MPMHiddenTableViewDeleteCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/18.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

typedef void(^DeleteBlock)(UIButton *sender);

@interface MPMHiddenTableViewDeleteCell : MPMBaseTableViewCell

@property (nonatomic, copy) DeleteBlock deleteBlock;

@end
