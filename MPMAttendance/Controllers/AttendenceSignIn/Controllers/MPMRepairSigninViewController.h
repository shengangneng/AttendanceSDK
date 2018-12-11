//
//  MPMRepairSigninViewController.h
//  MPMAtendence
//  补卡
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMLerakageCardModel.h"
@class MPMDealingModel;

typedef NS_ENUM(NSInteger, kRepairFromType)  {
    kRepairFromTypeSigning, /** 从考勤打卡进入：点击补卡push进入例外申请页面 */
    kRepairFromTypeDealing, /** 从例外申请进入：点击补卡pop回去 例外申请页面 */
};

typedef void(^ToDealingWithModelBlock)(MPMDealingModel *model);

@interface MPMRepairSigninViewController : MPMBaseViewController

- (instancetype)initWithRepairFromType:(kRepairFromType)fromType passingLeadArray:(NSArray <MPMLerakageCardModel *> *)leadArray;

@property (nonatomic, copy) ToDealingWithModelBlock toDealingBlock;

@end
