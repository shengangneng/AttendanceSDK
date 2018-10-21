//
//  MPMTaskInstGroups.
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/17.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
@class MPMTaskInsts;

@interface MPMTaskInstGroups : MPMBaseModel

@property (nonatomic, copy) NSString *taskCode;
@property (nonatomic, copy) NSString *taskName;
@property (nonatomic, copy) NSArray<MPMTaskInsts *> *taskInst;


@end

@interface MPMTaskInsts : MPMBaseModel

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *handleTime;
@property (nonatomic, copy) NSString *mpm_id;
@property (nonatomic, copy) NSString *prevActionState;
@property (nonatomic, copy) NSString *remark ;
@property (nonatomic, copy) NSString *route;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *targetTaskCode;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *username;     /** 这个字段是接口返回的 */
@property (nonatomic, copy) NSString *userName;     /** 这个字段是我自定义的，为了便利这个接口 */

@end
