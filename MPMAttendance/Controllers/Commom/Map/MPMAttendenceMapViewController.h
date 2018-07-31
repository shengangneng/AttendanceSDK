//
//  MPMAttendenceMapViewController.h
//  MPMAtendence
//  地图
//  Created by shengangneng on 2018/5/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import <MapKit/MapKit.h>
@class MPMPlaceInfoModel;

typedef void(^CompleteSelectedPlace)(MPMPlaceInfoModel *model);

@interface MPMAttendenceMapViewController : MPMBaseViewController

@property (nonatomic, copy) CompleteSelectedPlace completeSelectPlace;

@end
