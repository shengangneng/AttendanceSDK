//
//  MPMApplyAdditionConfig.h
//  MPMAtendence
//  例外申请模块
//  Created by shengangneng on 2018/7/3.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#ifndef MPMApplyAdditionConfig_h
#define MPMApplyAdditionConfig_h

#define kSausactionType @{@"-1":@"请假申请",@"0":@"改签",@"1":@"补签",@"2":@"请假",@"3":@"出差",@"4":@"年假",@"5":@"病假",@"6":@"产假",@"7":@"陪产假",@"8":@"婚假",@"9":@"丧假",@"10":@"事假",@"11":@"外出",@"12":@"调休",@"13":@"调班",@"14":@"加班",@"15":@"处理",@"16":@"例外申请",@"17":@"增加自由补签"}
#define kSausactionNo  @{@"请假申请":@"-1",@"改签":@"0",@"补签":@"1",@"请假":@"2",@"出差":@"3",@"年假":@"4",@"病假":@"5",@"产假":@"6",@"陪产假":@"7",@"婚假":@"8",@"丧假":@"9",@"事假":@"10",@"外出":@"11",@"调休":@"12",@"调班":@"13",@"加班":@"14",@"处理":@"15",@"例外申请":@"16",@"增加自由补签":@"17"}
#define kApprovalStatusType @{@"0":@"草稿箱",@"1":@"待我审批",@"2":@"初审",@"3":@"终审",@"4":@"已驳回",@"5":@"已撤回",@"6":@"已审批"}
// 考勤接口Status对应的状态
#define kAttendenceStatus @{@"0":@"准时",@"1":@"迟到",@"2":@"早退",@"3":@"漏卡",@"4":@"早到",@"5":@"下班",@"6":@"加班"}
#define kShiftName @{@"上班":@"0",@"下班":@"1"}
#define kClassName @{@"早班":@"1",@"中班":@"2",@"晚班":@"3"}
#define kShiftNameRever @{@"0":@"上班",@"1":@"下班"}
#define kClassNameRever @{@"1":@"早班",@"2":@"中班",@"3":@"晚班"}
#define kStatisticCellImage @{@"上班":@"statistics_signin",@"下班":@"statistics_signout",@"缺勤":@"statistics_absenteeism",@"补签":@"statistics_retroactive",@"早到":@"statistics_earlyarrival",@"早退":@"statistics_early",@"漏卡":@"statistics_leakcard",@"迟到":@"statistics_belate",@"加班":@"statistics_overtime",@"出差":@"statistics_evection",@"外出":@"statistics_goout",@"改签":@"statistics_endorse",@"请假":@"statistics_askforleave"}

#endif /* MPMApplyAdditionConfig_h */
