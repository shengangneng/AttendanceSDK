//
//  NSObject+MPMExtention.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MPMExtention)

/**
 * Runtime字典转模型：主要方便在MPMBaseModel里面调用
 */
- (instancetype)convertModelWithDictionary:(NSDictionary *)dic;

@end
