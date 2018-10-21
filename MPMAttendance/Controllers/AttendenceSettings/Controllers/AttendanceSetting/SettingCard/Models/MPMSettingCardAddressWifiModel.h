//
//  MPMSettingCardAddressWifiModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/30.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMSettingCardAddressWifiModel : MPMBaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *allWifi;
@property (nonatomic, copy) NSString *cardSettingId;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *deviation;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, copy) NSString *thisWifi;

@end
