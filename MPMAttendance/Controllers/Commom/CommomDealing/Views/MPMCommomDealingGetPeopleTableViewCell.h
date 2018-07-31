//
//  MPMCommomDealingGetPeopleTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

typedef void(^FoldButtonBlock)(UIButton *sender);
typedef void(^AddPeoplesBlock)(UIButton *sender);

@interface MPMCommomDealingGetPeopleTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *startIcon;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UIView *peopleView;
@property (nonatomic, strong) UIButton *accessoryButton;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, copy) FoldButtonBlock foldBlock;
@property (nonatomic, copy) AddPeoplesBlock addpBlock;

- (void)setPeopleViewData:(NSString *)data fold:(BOOL)fold;

@end
