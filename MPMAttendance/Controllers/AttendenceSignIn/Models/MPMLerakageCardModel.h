//
//  MPMLerakageCardModel.h
//  MPMAtendence
//  漏卡记录Model
//  Created by shengangneng on 2018/6/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMLerakageCardModel : MPMBaseModel

@property (nonatomic, copy) NSString *schedulingEmployeeId; /** 处理id */
@property (nonatomic, copy) NSString *brushTime;            /** 打卡时间 */
@property (nonatomic, copy) NSString *signType;             /** 签到0、签退1 */
@property (nonatomic, copy) NSString *btn;                  /** 签到、签退 */

@end


@interface MPMRepairSignLeadCardModel: MPMBaseModel

- (instancetype)initWithThisMonth:(BOOL)isThisMonth;

@property (nonatomic, assign, getter=isThisMonth) BOOL thisMonth;

@property (nonatomic, copy) NSArray<NSIndexPath *> *thisMonthSelectIndexPaths;/** 保存当前月选中的Cell */

@property (nonatomic, copy) NSArray<MPMLerakageCardModel *> *thisMonthLeadCards;
@property (nonatomic, copy) NSArray<MPMLerakageCardModel *> *lastMonthLeadCards;

@end
