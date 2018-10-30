//
//  MPMProcessTaskModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
@class MPMProcessTaskConfig;
#import "MPMProcessPeople.h"

@interface MPMProcessTaskModel : MPMBaseModel

@property (nonatomic, copy) NSString *companyId;        /** 公司id */
@property (nonatomic, copy) NSString *mpm_id;           /** 传空为新增、传值为编辑 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *order;            /** 排序 */
@property (nonatomic, copy) NSString *processDefCode;   /** 流程第一code */
@property (nonatomic, strong) MPMProcessTaskConfig *config; /** 任务定义参与者配置 */

@property (nonatomic, copy) NSArray<MPMProcessPeople *> *limitParticipants;     /** 限制不能选的人 */
@property (nonatomic, copy) NSString *limitAlertMessage;                        /** 限制不能选人的时候弹出的警告文字 */

@end

@interface MPMProcessTaskConfig : MPMBaseModel

@property (nonatomic, copy) NSString *decision;             /** 参与者为多个时，决策路由的走向。1一个通过则往下走，2全部通过才能往下走 */
@property (nonatomic, copy) NSString *groupId;              /** 忽略 */
@property (nonatomic, copy) NSString *mulitType;            /** 1串行，2并行，当前版本只支持2并行（20180827） */
@property (nonatomic, copy) NSArray<MPMProcessPeople *> *participants;          /** 参与者列表 */
@property (nonatomic, copy) NSString *addsign;              /** 是否已加签：0否 1是 */

@end
