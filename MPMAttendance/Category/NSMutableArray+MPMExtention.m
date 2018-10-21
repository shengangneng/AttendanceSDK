//
//  NSMutableArray+MPMExtention.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "NSMutableArray+MPMExtention.h"
#import "MPMCausationDetailModel.h"

@implementation NSMutableArray (MPMExtention)

- (void)clearData {
    for (int i = 0; i < self.count; i++) {
        MPMCausationDetailModel *model = self[i];
        [model clearData];
    }
}

/** 移除可变数组的某一个model，后面的model自动补上 */
- (void)removeModelAtIndex:(NSInteger)index {
    if (index > self.count || index < 0) {
        return;
    }
    for (NSInteger i = index; i < self.count; i++) {
        [((MPMCausationDetailModel *)self[i]) clearData];
        if (i + 1 < self.count) {
            [((MPMCausationDetailModel *)self[i]) copyWithOtherModel:((MPMCausationDetailModel *)self[i+1])];
        }
    }
}

@end
