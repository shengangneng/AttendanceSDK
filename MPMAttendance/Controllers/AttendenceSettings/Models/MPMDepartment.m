//
//  MPMDepartment.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDepartment.h"

@implementation MPMDepartment

/** 自身的数据转为MPMObjListModel数据 */
- (MPMObjListModel *)translateToObjectList {
    MPMObjListModel *list = [[MPMObjListModel alloc] init];
    list.name = self.name;
    if (self.isHuman) {
        list.objId = self.mpm_id;
        list.type = @"0";
    } else {
        list.objId = self.mpm_id;
        list.type = @"1";
    }
    list.orgIdIndex = self.parentIds;
    return list;
}

@end
