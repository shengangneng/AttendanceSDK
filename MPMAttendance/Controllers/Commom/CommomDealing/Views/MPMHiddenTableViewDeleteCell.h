//
//  MPMHiddenTableViewDeleteCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/18.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMRoundPeopleView.h"

typedef void(^DeleteBlock)(UIButton *sender);

@interface MPMHiddenTableViewDeleteCell : MPMBaseTableViewCell

@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) MPMRoundPeopleView *roundPeopleView;
@property (nonatomic, assign) BOOL isHuman; /** 人员或部门 */
@property (nonatomic, copy) DeleteBlock deleteBlock;

@end
