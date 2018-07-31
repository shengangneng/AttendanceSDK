//
//  MPMCommomGetPeopleViewController.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
@class MPMGetPeopleModel;
typedef void(^CompleteSelectBlock)(NSArray<MPMGetPeopleModel *> *arr);

@interface MPMCommomGetPeopleViewController : MPMBaseViewController

/**
 * code：0多选，1单选
 * idString：多个id用","拼接的字符串
 */
- (instancetype)initWithCode:(NSString *)code idString:(NSString *)idString sureSelect:(CompleteSelectBlock)block;

@end
