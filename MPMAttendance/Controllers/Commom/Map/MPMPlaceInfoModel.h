//
//  MPMPlaceInfoModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/24.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
#import <MapKit/MapKit.h>

@interface MPMPlaceInfoModel : MPMBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *locality;
@property (nonatomic, copy) NSString *subLocality;
@property (nonatomic, copy) NSString *thoroughfare;
@property (nonatomic, copy) NSString *subThoroughfare;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
