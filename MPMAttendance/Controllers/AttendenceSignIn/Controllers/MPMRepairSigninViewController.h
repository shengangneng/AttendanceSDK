//
//  MPMRepairSigninViewController.h
//  MPMAtendence
//  补签
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
@class MPMDealingModel;

typedef NS_ENUM(NSInteger, kRepairFromType)  {
    kRepairFromTypeSigning, /** 从考勤打卡进入：点击补签push进入例外申请页面 */
    kRepairFromTypeDealing, /** 从例外申请进入：点击补签pop回去 例外申请页面 */
};

typedef void(^ToDealingWithModelBlock)(MPMDealingModel *model);

@interface MPMRepairSigninViewController : MPMBaseViewController

- (instancetype)initWithRepairFromType:(kRepairFromType)fromType;

@property (nonatomic, copy) ToDealingWithModelBlock toDealingBlock;

@end
