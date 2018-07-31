//
//  MPMLerakageCardModel.h
//  MPMAtendence
//  漏卡记录Model
//  Created by shengangneng on 2018/6/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMLerakageCardModel : MPMBaseModel
/** 有三个参数首字母是大写的，因为后台接口返回的字段就是大写的，不要改，否则获取不到数据 */
@property (nonatomic, copy) NSString *AttendanceId;
@property (nonatomic, copy) NSString *BrushDate;
@property (nonatomic, copy) NSString *SignType;
@property (nonatomic, copy) NSString *btn;
@property (nonatomic, copy) NSString *time;

@end
