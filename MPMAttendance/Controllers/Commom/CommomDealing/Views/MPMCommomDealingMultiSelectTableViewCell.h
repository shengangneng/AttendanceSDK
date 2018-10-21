//
//  MPMCommomDealingMultiSelectTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/7.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseTableViewCell.h"

#define kTraffic @[@"其他",@"飞机",@"火车",@"汽车"]
#define kMoney   @[@"加班费",@"调休",@"无"]
#define kTafficBtnTag   777
#define kMoneyBtnTag    888

typedef void(^SelectedBtnBlock)(NSInteger index);
typedef void(^CellNeedFoldBlock)(BOOL fold);
typedef void(^CellTextFieldDidChange)(NSString *text);

typedef NS_ENUM(NSInteger, kMultiSelectionType) {
    kMultiSelectionTypeTraffic,         /** 交通工具 */
    kMultiSelectionTypeOverTimeMoney,   /** 加班补偿 */
};

@interface MPMCommomDealingMultiSelectTableViewCell : MPMBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
           multiSelectionType:(kMultiSelectionType)multiSelectionType;

@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UITextField *trafficDetailTextField;/** 交通工具，其他输入框 */
/** 记录上一次选中的按钮 */
@property (nonatomic, strong) UIButton *lastSelectedBtn;
@property (nonatomic, copy) SelectedBtnBlock selectedBtnBlock;
@property (nonatomic, copy) CellNeedFoldBlock cellNeedFoldBlock;
@property (nonatomic, copy) CellTextFieldDidChange cellTextFieldChangeBlock;

@end
