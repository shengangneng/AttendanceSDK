//
//  MPMInterfaceConst.h
//  MPMAtendence
//  项目所有接口
//  Created by shengangneng on 2018/10/9.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//


/********************HOST********************/
#define MPMINTERFACE_HOST                       @"https://api.test.jifenzhi.com/attendance/"        /** HOST */
#define MPMINTERFACE_OAUTH                      @"https://auth.test.jifenzhi.com/oauth/token"       /** 单点授权获取token及刷新token */
#define MPMINTERFACE_EMDM                       @"https://api.test.jifenzhi.com/emdm/"              /** 人员部门选择 */
#define MPMINTERFACE_WORKFLOW                   @"https://api.test.jifenzhi.com/workflow/"          /** 工作流：路程设置、流程审批等 */

/********************登录、菜单********************/
#define MPMINTERFACE_MYRES                      @"api/resource/myres"                               /** 获取当前用户菜单 */

/********************考勤打卡********************/
#define MPMINTERFACE_SIGNIN_LEAKCARD            @"api/scheduleDetailController/getLerakageCardList" /** 获取漏卡记录 */
#define MPMINTERFACE_SIGNIN_CLOCKTIME           @"api/scheduleDetailController/punchTheClockTime"   /** 获取打卡信息 */
#define MPMINTERFACE_SIGNIN_GETSTATUS           @"api/attendanceStatus/monthly"                     /** 获取一周打卡状态 */
#define MPMINTERFACE_SIGNIN_PUNCHCARD           @"api/scheduleDetailController/punchCard"           /** 打卡 */
#define MPMINTERFACE_SIGNIN_ISEXISTDETAIL       @"api/rf/isExistResiveOrFillupSign"                 /** 打卡节点是否能改卡或补卡 */

/********************例外申请********************/
#define MPMINTERFACE_APPLY_GETLEAVETYPE         @"api/leaveController/getLeaveType"                 /** 获取所有请假类型 */
#define MPMINTERFACE_APPLY_CALCULATETIME        @"api/ot/calculateDayOrHour"                        /** 计算时间 */
#define MPMINTERFACE_APPLY_QUERY_LEAVE          @"api/leaveController/query"                        /** 根据id获取请假详情 */
#define MPMINTERFACE_APPLY_QUERY_TRAVEL         @"api/businessTravelController/query"               /** 根据id获取出差详情 */
#define MPMINTERFACE_APPLY_QUERY_OVERTIME       @"api/ot/detail"                                    /** 根据id获取加班详情 */
#define MPMINTERFACE_APPLY_QUERY_GOOUT          @"api/goout/detail"                                 /** 根据id获取外出详情 */
#define MPMINTERFACE_APPLY_QUERY_SIGN           @"api/rf/query"                                     /** 根据id获取改卡补卡详情 */
#define MPMINTERFACE_APPLY_SUBMIT_LEAVE         @"api/leaveController/leave"                        /** 提交请假申请 */
#define MPMINTERFACE_APPLY_UPDATE_LEAVE         @"api/leaveController/updateLeave"                  /** 更新请假申请 */
#define MPMINTERFACE_APPLY_SUBMIT_TRAVEL        @"api/businessTravelController/businessTravel"      /** 提交出差申请 */
#define MPMINTERFACE_APPLY_UPDATE_TRAVEL        @"api/businessTravelController/updateBusinessTravel"/** 更新出差申请 */
#define MPMINTERFACE_APPLY_SUBMIT_OT            @"api/ot/save"                                      /** 提交加班申请 */
#define MPMINTERFACE_APPLY_UPDATE_OT            @"api/ot/update"                                    /** 更新加班申请 */
#define MPMINTERFACE_APPLY_SUBMIT_GOOUT         @"api/goout/save"                                   /** 提交外出申请 */
#define MPMINTERFACE_APPLY_UPDATE_GOOUT         @"api/goout/update"                                 /** 更新外出申请 */
#define MPMINTERFACE_APPLY_SUBMIT_FSIGN         @"api/rf/saveFillupSign"                            /** 提交补卡申请 */
#define MPMINTERFACE_APPLY_UPDATE_FSIGN         @"api/rf/updateFillupSign"                          /** 更新补卡申请 */
#define MPMINTERFACE_APPLY_SUBMIT_CSIGN         @"api/rf/saveReviseSign"                            /** 提交改卡申请 */
#define MPMINTERFACE_APPLY_UPDATE_CSIGN         @"api/rf/updateReviseSign"                          /** 更新改卡申请 */
#define MPMINTERFACE_APPLY_FASTCALCULATE        @"api/quickTemplate/fastCalculateDayOrHour"         /** 快速计算时间模板 */

/********************流程审批********************/
#define MPMINTERFACE_APPROVAL_MYNEWS            @"api/wfinst/mynews"                                /** 我的待办未读消息数 */
#define MPMINTERFACE_APPROVAL_MYPENDING         @"api/wfinst/mypending"                             /** 我的事项-待办 */
#define MPMINTERFACE_APPROVAL_MYDONE            @"api/wfinst/mydone"                                /** 我的事项-已办 */
#define MPMINTERFACE_APPROVAL_MYAPPLY           @"api/wfinst/myapply"                               /** 我的申请 */
#define MPMINTERFACE_APPROVAL_MYDELIVER         @"api/wfinst/mydeliver"                             /** 抄送给我 */
#define MPMINTERFACE_APPROVAL_BACKTASK          @"api/wfinst/backwardtaskdefs"                      /** 获取所有驳回节点 */
#define MPMINTERFACE_APPROVAL_NEXTTASK          @"api/wfdef/nexttaskdef"                            /** 是否含有下一节点 */
#define MPMINTERFACE_APPROVAL_COMPLETETASK      @"api/wfinst/completetask"                          /** 完成节点：通过、驳回 */
#define MPMINTERFACE_APPROVAL_REASSIGN          @"api/wfinst/reassign"                              /** 转交 */
#define MPMINTERFACE_APPROVAL_FULLPROCESS       @"api/wfinst/fullprocessinstbypid"                  /** 详情：我的申请、抄送给我 */
#define MPMINTERFACE_APPROVAL_ADDSIGN           @"api/wfinst/addsign"                               /** 终审加签 */
#define MPMINTERFACE_APPROVAL_DETAIL            @"api/wfinst/fullprocessinstbytid"                  /** 流程审批详情 */
#define MPMINTERFACE_APPROVAL_DETAIL_BIZ        @"api/wfinst/fullprocessinstbybizid"                /** 流程审批详情-根据业务单id */



/*******************流程统计*******************/
#define MPMINTERFACE_STATISTIC_COUNT            @"api/attendanceCount/count"                        /** 流程统计列表 */

/********************流程设置********************/
/**********权限设置**********/
#define MPMINTERFACE_SETTING_ROLE_LIST          @"api/role/list"                                    /** 权限列表*/
#define MPMINTERFACE_SETTING_ROLE_AUTHORIZE     @"api/role/authorize"                               /** 权限人员 */
/**********班次设置**********/
#define MPMINTERFACE_SETTING_CLASS_LIST         @"api/workScheduleConfig/list"                      /** 获取班次列表 */
#define MPMINTERFACE_SETTING_CLASS_DELETE       @"api/workScheduleConfig/delete"                    /** 删除班次 */
#define MPMINTERFACE_SETTING_CLASS_ADD          @"api/workScheduleConfig/add"                       /** 保存班次 */
#define MPMINTERFACE_SETTING_TIME_SAVE          @"api/schedule/save"                                /** 时间段保存 */
#define MPMINTERFACE_SETTING_TIME_LIST          @"api/schedule/list"                                /** 班次设置列表 */
#define MPMINTERFACE_SETTING_TIME_DELETE        @"api/schedule/delete"                              /** 班次设置删除 */
#define MPMINTERFACE_SETTING_TIME_SEARCH        @"api/schedule/search"                              /** 班次搜索 */
/**********积分设置**********/
#define MPMINTERFACE_SETTING_INTERGRAL_LIST     @"api/scoreConfig/list"                             /** 积分设置 */
#define MPMINTERFACE_SETTING_INTERGRAL_SAVE     @"api/scoreConfig/save"                             /** 积分设置保存 */
/**********流程设置**********/
#define MPMINTERFACE_SETTING_PROCESSDEFS        @"api/wfdef/processdefs"                            /** 流程设置-获取流程定义 */
#define MPMINTERFACE_SETTING_TASKDEFSWA         @"api/wfdef/taskdefswithoutapply"                   /** 流程设置-获取活动定义 */
#define MPMINTERFACE_SETTING_TASKDEF            @"api/wfdef/taskdef"                                /** 流程设置-保存活动定义 */
#define MPMINTERFACE_SETTING_ORDERTASK          @"api/wfdef/ordertaskdef"                           /** 流程设置-排序活动 */
#define MPMINTERFACE_SETTING_ADDSIGN            @"api/wfdef/processdefaddsign"                      /** 流程设置-保存终审加签 */

/********************人员部门数据********************/
#define MPMINTERFACE_EMDM_CURRENTUSER           @"api/emdm/employee/currentuser"                    /** 获取用户 */
#define MPMINTERFACE_EMDM_COMPANY               @"api/emdm/company"                                 /** 获取公司 */
#define MPMINTERFACE_EMDM_MIX_FINDBYORGID       @"api/emdm/mix/findByOrgId"                         /** 混合查询部门和人员 */
#define MPMINTERFACE_EMDM_MIX_FINDBYKEYWORD     @"api/emdm/mix/findByKeyword"                       /** 混合查询部门和人员通过关键字 */



