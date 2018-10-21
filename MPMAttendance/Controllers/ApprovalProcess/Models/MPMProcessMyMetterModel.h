//
//  MPMProcessMyMetterModel.h
//  MPMAtendence
//  我的事项
//  Created by shengangneng on 2018/9/3.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMProcessMyMetterModel : MPMBaseModel

@property (nonatomic, copy) NSString *appId;                /** appId */
@property (nonatomic, copy) NSString *applyUserId;          /** 申请人id */
@property (nonatomic, copy) NSString *applyUserName;        /** 申请人 */
@property (nonatomic, copy) NSString *companyId;            /** 公司Id */
@property (nonatomic, copy) NSString *createTime;           /** 创建时间 */
@property (nonatomic, copy) NSString *handleTime;           /** 处理时间 */
@property (nonatomic, copy) NSString *mpm_id;               /** 当前处理：taskInstId */
@property (nonatomic, copy) NSString *multiInstanceConfig;
@property (nonatomic, copy) NSString *multiInstanceGroupId;
@property (nonatomic, copy) NSString *multiInstanceType;
@property (nonatomic, copy) NSString *prevActionState;      /** 上一步的动作状态：1待处理 2拨回到我 - 我的事项待办 */
@property (nonatomic, copy) NSString *processDefCode;       /** 流程定义code */
@property (nonatomic, copy) NSString *processDefName;       /** 流程类型 */
@property (nonatomic, copy) NSString *processInstId;        /** 流程实例id */
@property (nonatomic, copy) NSString *processRemark;        /** 流程申请原因 */
@property (nonatomic, copy) NSString *remark;               /** 备注 */
@property (nonatomic, copy) NSString *route;                /** 提交路途：1前进 2驳回 */
@property (nonatomic, copy) NSString *state;                /** 任务状态：1待办 2转交 6已处理 */
@property (nonatomic, copy) NSString *targetTaskCode;       /** 提交到任务code */
@property (nonatomic, copy) NSString *taskCode;             /** 任务code */
@property (nonatomic, copy) NSString *taskName;             /** 任务名称 */
@property (nonatomic, copy) NSString *userId;               /** 当前环节处理人id */
@property (nonatomic, copy) NSString *name;                 /** 处理类型名称 */
@property (nonatomic, copy) NSString *username;             /** 当前环节处理人名字 */

@end
