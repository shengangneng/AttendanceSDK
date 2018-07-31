//
//  NSString+MPMAttention.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MPMAttention)

/** 把时分如23:59转为秒23*60+59 */
- (double)timeValue;

- (NSString *)hourMinuteToString;

@end
