//
//  MPMAuthorityTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

#define Tag 666 /** 人员按钮tag */

typedef void(^AddPeopleBlock)(void);   /** 点击加号人员 */
typedef void(^OperationBlock)(BOOL selected);   /** 点击展开收缩 */
typedef void(^DeleteBlock)(NSInteger index);    /** 点击人员进行删除 */

@interface MPMAuthorityTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UILabel *detailTxLabel;
@property (nonatomic, strong) UIButton *addPeopleButton;
@property (nonatomic, strong) UIView *peoplesView;
@property (nonatomic, strong) UIButton *operationButton;

@property (nonatomic, copy) AddPeopleBlock addPeopleBlock;
@property (nonatomic, copy) OperationBlock operationBlock;
@property (nonatomic, copy) DeleteBlock deleteBlock;

/** 传入修改后的参与人员，修改cell */
- (void)setPeopleViewData:(NSArray *)dataArray fold:(BOOL)fold;

@end
