//
//  MPMClassSettingCycleModel.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMClassSettingCycleModel.h"

@implementation MPMClassSettingCycleModel

- (void)translateCycle {
    if (kIsNilString(self.cycle)) {
        self.cnCycle = @"";
    } else {
        NSArray *arr = [self.cycle componentsSeparatedByString:@","];
        NSString *tempString = @"每周";
        if (arr.count > 0) {
            for (int i = 0; i < arr.count; i++) {
                NSString *numS = arr[i];
                NSString *tempS;
                switch (numS.integerValue) {
                    case 1:{
                        tempS = @"日";
                    }break;
                    case 2:{
                        tempS = @"一";
                    }break;
                    case 3:{
                        tempS = @"二";
                    }break;
                    case 4:{
                        tempS = @"三";
                    }break;
                    case 5:{
                        tempS = @"四";
                    }break;
                    case 6:{
                        tempS = @"五";
                    }break;
                    case 7:{
                        tempS = @"六";
                    }break;
                    default:
                        break;
                }
                tempString = [tempString stringByAppendingString:tempS];
            }
        }
        self.cnCycle = tempString;
    }
}

@end
