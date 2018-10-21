//
//  MPMProcessDef.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMProcessDef : MPMBaseModel

@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *bizType;
@property (nonatomic, copy) NSString *bizType2;
@property (nonatomic, copy) NSString *crossLevelAble;
@property (nonatomic, copy) NSString *addSignAble;      /** 终审加签：0不允许 1允许 */
@property (nonatomic, copy) NSString *deliverConfig;
@property (nonatomic, copy) NSString *bizReqApi;
@property (nonatomic, copy) NSString *bizUpdateApi;
@property (nonatomic, copy) NSString *takeEffectApi;

@property (nonatomic, copy) NSString *currentTaskCode;  /** 信息详情终审人加签，需要传入用来打卡特定的节点 */
@property (nonatomic, assign) BOOL canDelete;/** 如果节点只剩下一个，则不允许删除（隐藏删除按钮) */

@end
