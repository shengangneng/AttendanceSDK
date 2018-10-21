//
//  MPMLerakageCardModel.m
//  MPMAtendence
//  漏卡记录Model
//  Created by shengangneng on 2018/6/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMLerakageCardModel.h"

@implementation MPMLerakageCardModel

@end

@implementation MPMRepairSignLeadCardModel

- (instancetype)initWithThisMonth:(BOOL)isThisMonth {
    self = [super init];
    if (self) {
        self.thisMonth = isThisMonth;
    }
    return self;
}

@end
