//
//  MPMIntergralDefaultData.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/7/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMIntergralDefaultData.h"

#define type0TypesArray @[@"0",@"5",@"4",@"1",@"2",@"3"]
#define type1TypesArray @[@"0",@"1",@"4",@"3",@"2",@"5"]

@implementation MPMIntergralDefaultData

+ (NSArray<MPMIntergralModel *> *)getIntergralDefaultDataOfScene:(NSInteger)scene {
    switch (scene) {
        case 0:{
            NSMutableArray *temp0 = [NSMutableArray arrayWithCapacity:type0TypesArray.count];
            for (int i = 0; i < type0TypesArray.count; i++) {
                NSString *type = type0TypesArray[i];
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                mdic[@"integralType"] = type0TypesArray[i];
                mdic[@"name"] = kJiFenType0NameFromId[type];
                mdic[@"description"] = kJiFenType0DescriptionFromId[type];
                mdic[@"conditions"] = kJiFenType0NeedCondictionsDefaultValueFromId[type];
                mdic[@"needCondiction"] = kJiFenType0NeedCondictionFromId[type];
                mdic[@"integralValue"] = kJiFenType0IntergralValueFromId[type];
                mdic[@"type"] = kJiFenType0TypeFromId[type];
                mdic[@"isTick"] = kJiFenType0IsTickFromId[type];
                mdic[@"scoreTitle"] = @"B分";
                mdic[@"typeCanChange"] = kJiFenType0CanChangeFromId[type];
                MPMIntergralModel *model = [[MPMIntergralModel alloc] initWithDictionary:mdic];
                [temp0 addObject:model];
            }
            return temp0.copy;
        }break;
        case 1:{
            NSMutableArray *temp1 = [NSMutableArray arrayWithCapacity:type1TypesArray.count];
            for (int i = 0; i < type1TypesArray.count; i++) {
                NSString *type = type1TypesArray[i];
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                mdic[@"integralType"] = type1TypesArray[i];
                mdic[@"name"] = kJiFenType1NameFromId[type];
                mdic[@"description"] = kJiFenType1DescriptionFromId[type];
                mdic[@"conditions"] = kJiFenType1NeedCondictionsDefaultValueFromId[type];
                mdic[@"needCondiction"] = kJiFenType1NeedCondictionFromId[type];
                mdic[@"integralValue"] = kJiFenType1IntergralValueFromId[type];
                mdic[@"type"] = kJiFenType1TypeFromId[type];
                mdic[@"scoreTitle"] = @"B分";
                mdic[@"isTick"] = kJiFenType1IsTickFromId[type];
                mdic[@"typeCanChange"] = kJiFenType1CanChangeFromId[type];
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
