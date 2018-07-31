//
//  MPMIntergralDefaultData.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/7/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMIntergralModel.h"

@interface MPMIntergralDefaultData : NSObject

/** IntergralType：0考勤打卡、1例外申请 */
+ (NSArray<MPMIntergralModel *> *)getIntergralDefaultDataOfIntergralType:(NSInteger )type;

@end
