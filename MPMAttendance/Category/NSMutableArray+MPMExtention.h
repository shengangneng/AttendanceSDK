//
//  NSMutableArray+MPMExtention.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MPMExtention)

/** 暂时只为流程审批使用 */
- (void)clearData;
/** 暂时只为流程审批使用 */
- (void)removeModelAtIndex:(NSInteger)index;

@end
