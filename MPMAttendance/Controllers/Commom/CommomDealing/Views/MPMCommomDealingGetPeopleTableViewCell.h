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

typedef void(^AddPeoplesBlock)(UIButton *sender);
typedef void(^AddLeadBlock)(void);
typedef void(^DeletePeoplesBlock)(UIButton *sender);
typedef void(^ExplainBlock)(void);

@interface MPMCommomDealingGetPeopleTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *startIcon;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UILabel *detailTxLabel;
@property (nonatomic, strong) UIView *peopleView;
@property (nonatomic, strong) UIButton *addPeopleButton;/** 添加人员 */
@property (nonatomic, strong) UIButton *addLeadButton;  /** 添加漏卡 */
@property (nonatomic, assign) BOOL peopleCanDelete;     /** 抄送人可以删除，提交至如果是自己选择的，则可以删除 */
@property (nonatomic, copy) AddPeoplesBlock addpBlock;
@property (nonatomic, copy) AddLeadBlock addLeadBlock;
@property (nonatomic, copy) DeletePeoplesBlock deleteBlock;
@property (nonatomic, copy) ExplainBlock explainBlock;

- (void)setPeopleViewArray:(NSArray<MPMDepartment *> *)peoples canAdd:(BOOL)canAdd;

@end
