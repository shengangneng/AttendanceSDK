//
//  MPMProcessInst.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/17.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMProcessInst : MPMBaseModel

@property (nonatomic, copy) NSString *bizOrderId;   /** 业务单id */
@property (nonatomic, copy) NSString *bizType;      /** kaoqin */
@property (nonatomic, copy) NSString *bizType2;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *currentTaskCode;
@property (nonatomic, copy) NSString *currentTaskName;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *processDefCode;
@property (nonatomic, copy) NSString *processDefName;
@property (nonatomic, copy) NSString *processRemark;
@property (nonatomic, copy) NSString *startAppId;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *username;

@end
