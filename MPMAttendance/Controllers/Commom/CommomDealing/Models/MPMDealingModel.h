//
//  MPMDealingModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
#import "MPMCausationTypeData.h"
@class MPMCausationDetailModel;

@interface MPMDealingModel : MPMBaseModel

@property (nonatomic, copy) NSString *type;             /** 考勤状态：0考勤、1会议 */
@property (nonatomic, copy) NSDictionary *attendence;   /** 打卡信息 */
@property (nonatomic, copy) NSString *attendenceId;     /** 选中的补卡处理类型id */
@property (nonatomic, copy) NSString *brushDate;        /** 打卡日期 */
@property (nonatomic, copy) NSString *brushTime;        /** 打卡时间 */
@property (nonatomic, copy) NSString *attendenceDate;   /** 处理打卡时间-新 */
@property (nonatomic, copy) NSString *checkCode;        /** 校验码 */
@property (nonatomic, copy) NSString *createTime;       /** 创建时间 */
@property (nonatomic, copy) NSString *shiftName;        /** 班次：选择上下班 */
@property (nonatomic, copy) NSString *mpm_newClassName; /** 班次：新-早中晚班 */
@property (nonatomic, copy) NSString *originalClassName;/** 班次：原-早中晚班 */
@property (nonatomic, copy) NSString *signType;         /** 打卡类型：0上班 1下班 */
@property (nonatomic, copy) NSString *source;           /** 来源：0安卓、1iOS、2pc、3考勤机 */
@property (nonatomic, copy) NSNumber *early;            /** 是否早到：0否、1是 */
// 调班
@property (nonatomic, copy) NSString *mpm_newDate;  /** 新调班日期 */
@property (nonatomic, copy) NSString *originalDate; /** 原调班日期 */
// 考勤节点时间
@property (nonatomic, copy) NSString *oriAttendenceDate;

#pragma mark - 2.0接口参数

- (instancetype)initWithCausationType:(CausationType)type addCount:(NSInteger)addCount;

@property (nonatomic, assign) CausationType causationType;                                  /** 类型 */
@property (nonatomic, strong) NSMutableArray<MPMCausationDetailModel *> *causationDetail;   /** 时间、地点、小时、交通工具 */
@property (nonatomic, copy) NSString *status;           /** 打卡状态：0正常、1异常 */
@property (nonatomic, copy) NSString *remark;           /** 备注、处理理由 */
@property (nonatomic, copy) NSString *decision;         /** 参与者为多个时,决策路由的走向, 1一个通过则往下走 2全部通过才能往下走 */
@property (nonatomic, copy) NSString *name;             /** 决策名称 */
@property (nonatomic, copy) NSArray *delivers;          /** 抄送人 */
@property (nonatomic, copy) NSArray *participants;      /** 审批人 */
@property (nonatomic, copy) NSString *redress;          /** 加班补偿：1无 2调休 3加班费 */

// 以下为自定义字段
@property (nonatomic, assign) BOOL participantsCanAdd;  /** 提交至是否可以增加人 */
@property (nonatomic, assign) BOOL deliversCanAdd;      /** 抄送人是否可以增加人 */
@property (nonatomic, assign) NSInteger addMaxCount;    /** 限制增加明细最大数量：补卡为5 其余为3 */
@property (nonatomic, assign) NSInteger addCount;       /** 记录增加明细的数量：0不可修改，123为可修改并代表数量（补卡页面012345分别代表补卡记录的条数） */


- (void)clearData;

@end
