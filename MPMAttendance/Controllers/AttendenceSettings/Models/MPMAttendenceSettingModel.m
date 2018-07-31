//
//  MPMAttendenceSettingModel.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceSettingModel.h"

@implementation MPMAttendenceSettingModel

- (void)translateCycle {
    if (kIsNilString(self.cycle)) {
        self.cnCycle = @"";
    } else {
        NSArray *arr = [self.cycle componentsSeparatedByString:@","];
        NSString *tempString = @"";
        if (arr.count > 0) {
            for (int i = 0; i < arr.count; i++) {
                NSString *numS = arr[i];
                NSString *tempS;
                switch (numS.integerValue) {
                    case 1:{
                        tempS = @"日、";
                    }break;
                    case 2:{
                        tempS = @"一、";
                    }break;
                    case 3:{
                        tempS = @"二、";
                    }break;
                    case 4:{
                        tempS = @"三、";
                    }break;
                    case 5:{
                        tempS = @"四、";
                    }break;
                    case 6:{
                        tempS = @"五、";
                    }break;
                    case 7:{
                        tempS = @"六、";
                    }break;
                    default:
                        break;
                }
                tempString = [tempString stringByAppendingString:tempS];
            }
        }
        if ([tempString hasSuffix:@"、"]) {
            self.cnCycle =[tempString substringWithRange:NSMakeRange(0, tempString.length - 1)];
        } else {
            self.cnCycle = tempString;
        }
    }
}

@end
