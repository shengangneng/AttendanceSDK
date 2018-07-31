//
//  MPMIntergralDefaultData.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/7/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMIntergralDefaultData.h"
#import "MPMAttendanceHeader.h"

#define type0IDsArray @[@"0",@"5",@"4",@"1",@"2",@"3"]
#define type1IDsArray @[@"0",@"1",@"14",@"3",@"2",@"11"]

@implementation MPMIntergralDefaultData

+ (NSArray<MPMIntergralModel *> *)getIntergralDefaultDataOfIntergralType:(NSInteger )type {
    switch (type) {
        case 0:{
            NSMutableArray *temp0 = [NSMutableArray arrayWithCapacity:type0IDsArray.count];
            for (int i = 0; i < type0IDsArray.count; i++) {
                NSString *mpm_id = type0IDsArray[i];
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                mdic[@"id"] = mpm_id;
                mdic[@"title"] = kJiFenType0TitleFromId[mpm_id];
                mdic[@"subTitle"] = kJiFenType0SubTitleFromId[mpm_id];
                mdic[@"conditions"] = kJiFenType0NeedCondictionsDefaultValueFromId[mpm_id];
                mdic[@"needCondiction"] = kJiFenType0NeedCondictionFromId[mpm_id];
                mdic[@"integralValue"] = kJiFenType0IntergralValueFromId[mpm_id];
                mdic[@"type"] = kJiFenType0TypeFromId[mpm_id];
                mdic[@"isTick"] = kJiFenType0IsTickFromId[mpm_id];
                mdic[@"scoreTitle"] = @"B分";
                mdic[@"typeCanChange"] = kJiFenType0CanChangeFromId[mpm_id];
                MPMIntergralModel *model = [[MPMIntergralModel alloc] initWithDictionary:mdic];
                [temp0 addObject:model];
            }
            return temp0.copy;
        }break;
        case 1:{
            NSMutableArray *temp1 = [NSMutableArray arrayWithCapacity:type1IDsArray.count];
            for (int i = 0; i < type1IDsArray.count; i++) {
                NSString *mpm_id = type1IDsArray[i];
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                mdic[@"id"] = mpm_id;
                mdic[@"title"] = kJiFenType1TitleFromId[mpm_id];
                mdic[@"subTitle"] = kJiFenType1SubTitleFromId[mpm_id];
                mdic[@"conditions"] = kJiFenType1NeedCondictionsDefaultValueFromId[mpm_id];
                mdic[@"needCondiction"] = kJiFenType1NeedCondictionFromId[mpm_id];
                mdic[@"integralValue"] = kJiFenType1IntergralValueFromId[mpm_id];
                mdic[@"type"] = kJiFenType1TypeFromId[mpm_id];
                mdic[@"scoreTitle"] = @"B分";
                mdic[@"isTick"] = kJiFenType1IsTickFromId[mpm_id];
                mdic[@"typeCanChange"] = kJiFenType1CanChangeFromId[mpm_id];
                MPMIntergralModel *model = [[MPMIntergralModel alloc] initWithDictionary:mdic];
                [temp1 addObject:model];
            }
            return temp1.copy;
        }break;
        default:
            break;
    }
    
    
    
    return nil;
}

@end
