//
//  MPMCausationTypeData.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 typedef NS_ENUM(NSInteger, CausationType) {
 forCausationTypeAskLeave = -1,     // 请假申请
 forCausationTypeChangeSign = 0,    // 改卡
 forCausationTypeRepairSign,        // 补卡
 forCausationTypeLeave,             // 请假
 forCausationTypeevecation,         // 出差
 forCausationTypeeveYearLeave,      // 年假
 forCausationTypeeveSickLeave,      // 病假
 forCausationTypeeveBabyLeave,      // 产假
 forCausationTypeeveChirdBirthLeave,// 陪产假
 forCausationTypeeveMaryLeave,      // 婚假
 forCausationTypeeveDeadLeave,      // 丧假
 forCausationTypeeveThingLeave,     // 事假
 forCausationTypeOut,               // 外出
 forCausationTypeChangeRest,        // 调休
 forCausationTypeChangeClass,       // 调班
 forCausationTypeOverTime,          // 加班
 forCausationTypeDealing,           // 处理
 forCausationTypeExcetionApply,     // 例外申请
 forCausationTypeAddFreeSign,       // 增加自由补卡
 };
 */


typedef NS_ENUM(NSInteger, CausationType) {
    // 请假、出差、加班、外出、补卡、改卡
    kCausationTypeAskLeave = 100,       /** 请假 */
    kCausationTypeevecation = 101,      /** 出差 */
    kCausationTypeOverTime = 102,       /** 加班 */
    kCausationTypeOut = 103,            /** 外出 */
    kCausationTypeRepairSign = 104,     /** 补卡 */
    kCausationTypeChangeSign = 105,     /** 改卡 */
    kCausationTypeExtraApply = 106,     /** 例外申请 */
    // 请假具体类型
    kCausationTypeThingLeave = 0,       /** 事假 */
    kCausationTypeSickLeave = 1,        /** 病假 */
    kCausationTypeChangeRestLeave = 2,  /** 调休 */
    kCausationTypeLactationLeave = 3,   /** 哺乳假 */
    kCausationTypeYearLeave = 4,        /** 年假 */
    kCausationTypeMonthLeave = 5,       /** 月休假 */
    kCausationTypeSeeRelativeLeave = 6, /** 探亲假 */
    kCausationTypeMarryLeave = 7,       /** 婚假 */
    kCausationTypeBabyLeave = 8,        /** 产假 */
    kCausationTypeCompanyBabyLeave = 9, /** 陪产假 */
    kCausationTypeFuneralLeave = 10,    /** 丧假 */
    kCausationTypeInjuryLeave = 11,     /** 工伤假 */
};



// Key
#define kCellHeaderTitleKey              @"CellHeaderTitle"  /** Header的文字 */
#define kCellHeaderDetailKey             @"CellHeaderDetail" /** Header右边的文字 */
#define kCellTitleDetailKey              @"CellTitleDetail"  /** Title和DetailTitle */
#define kCellDetailTypeKey               @"CellDetailType"   /** Detail的控件类型 */
#define kCellActionTypeKey               @"CellActionType"   /** Detail的操作类型 */
// 选择器控件类型
#define kAction_PickerTypeDealingType    @"DealingType"      /** 选择器：请假、出差、补卡等处理类型 */
#define kAction_PickerTypeTimeOfOne      @"TimeOfOne"        /** 选择器：年月日时分秒 */
#define kAction_PickerTypeTimeOfTwo      @"TimeOfTwo"        /** 选择器：年月日 */
#define kAction_PickerTypeTwoClass       @"TwoClass"         /** 选择器：上班、下班 */
#define kAction_PickerTypeThreeClass     @"ThreeClass"       /** 选择器：早班、中班、晚班 */
#define kAction_TrafficTool              @"TrafficTool"      /** 交通工具 */
#define kAction_AddCell                  @"AddCell"          /** 增加一个Section */
// DetailType
#define kCellDetailTypeUILabel           @"UILabel"          /** UILabel */
#define kCellDetailTypeUIButton          @"UIButton"         /** UIButton */
#define kCellDetailTypeUITextView        @"UITextView"       /** UITextView */
#define kCellDetailTypeUITextField       @"UITextField"      /** UITextField */
#define kCellDetailTypeSelectTool        @"SelectTool"       /** 交通工具、出差补偿 */
#define kCellDetailTypePeople            @"People"           /** 审批人、抄送人 */

@interface MPMCausationTypeData : NSObject

+ (NSArray *)getTableViewDataWithCausationType:(CausationType)type addCount:(NSInteger)addCount;

@end
