//
//  MPMCommomDealingGetPeopleTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMDepartment.h"

#define kButtonTag 789

typedef void(^FoldButtonBlock)(UIButton *sender);
typedef void(^AddPeoplesBlock)(UIButton *sender);
typedef void(^DeletePeoplesBlock)(UIButton *sender);

@interface MPMCommomDealingGetPeopleTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *startIcon;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UIView *peopleView;
@property (nonatomic, strong) UIButton *accessoryButton;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, assign) BOOL peopleCanDelete;     /** 抄送人可以删除，提交至如果是自己选择的，则可以删除 */
@property (nonatomic, copy) FoldButtonBlock foldBlock;
@property (nonatomic, copy) AddPeoplesBlock addpBlock;
@property (nonatomic, copy) DeletePeoplesBlock deleteBlock;

- (void)setPeopleViewArray:(NSArray<MPMDepartment *> *)peoples fold:(BOOL)fold;

@end
