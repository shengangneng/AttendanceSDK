//
//  MPMBaseModel.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMBaseModel : NSObject

/** 字典转模型 */
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
