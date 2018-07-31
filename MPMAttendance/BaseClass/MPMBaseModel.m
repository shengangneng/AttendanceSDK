//
//  MPMBaseModel.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
#import "NSObject+MPMExtention.h"

@implementation MPMBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (!self) {
        return nil;
    }
    return [self convertModelWithDictionary:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
