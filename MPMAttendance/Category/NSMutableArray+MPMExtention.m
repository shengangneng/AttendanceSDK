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

- (void)removeModelAtIndex:(NSInteger)index {
    if (index > 3 || self.count < 3) {
        return;
    }
    
    if (index == 0) {
        [((MPMCausationDetailModel *)self[0]) clearData];
        [((MPMCausationDetailModel *)self[0]) copyWithOtherModel:((MPMCausationDetailModel *)self[1])];
        [((MPMCausationDetailModel *)self[1]) clearData];
        [((MPMCausationDetailModel *)self[1]) copyWithOtherModel:((MPMCausationDetailModel *)self[2])];
        [((MPMCausationDetailModel *)self[2]) clearData];
    } else if (index == 1) {
        [((MPMCausationDetailModel *)self[1]) clearData];
        [((MPMCausationDetailModel *)self[1]) copyWithOtherModel:((MPMCausationDetailModel *)self[2])];
        [((MPMCausationDetailModel *)self[2]) clearData];
    } else {
        [((MPMCausationDetailModel *)self[2]) clearData];
    }
}

@end
