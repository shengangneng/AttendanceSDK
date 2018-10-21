//
//  MPMProcessTaskModel.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessTaskModel.h"

@implementation MPMProcessTaskModel

@end

@implementation MPMProcessTaskConfig

- (NSString *)participants_type {
    return NSStringFromClass([MPMProcessPeople class]);
}

@end
