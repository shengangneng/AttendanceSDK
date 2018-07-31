//
//  MPMCausationTypeData.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CausationType) {
    forCausationTypeAskLeave = -1,  // 请假申请
    forCausationTypeChangeSign = 0,    // 改签
    forCausationTypeRepairSign,        // 补签
    forCausationTypeLeave,             // 请假
    forCausationTypeevecation,         // 出差
    forCausationTypeeveYearLeave,      // 年假
    forCausationTypeeveSickLeave,      // 病假
    forCausationTypeeveBabyLeave,      // 产假
    forCausationTypeeveChirdBirthLeave,// 陪产假
    forCausationTypeeveMaryLeave,      // 婚假
    forCausationTypeeveDeadLeave,      // 丧假
    forCausationTypeeveThingLeave,     // 事假
    forCausationTypeOut,               // 外出
    forCausationTypeChangeRest,        // 调休
    forCausationTypeChangeClass,       // 调班
    forCausationTypeOverTime,          // 加班
    forCausationTypeDealing,           // 处理
    forCausationTypeExcetionApply,     // 例外申请
    forCausationTypeAddFreeSign,       // 增加自由补签
};

@interface MPMCausationTypeData : NSObject

+ (NSArray *)getTableViewDataWithCausationType:(CausationType)type addCount:(NSInteger)addCount;

@end
