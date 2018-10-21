//
//  MPMCausationTypeData.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCausationTypeData.h"

@implementation MPMCausationTypeData

+ (NSArray *)getTableViewDataWithCausationType:(CausationType)type addCount:(NSInteger)addCount {
    switch (type) {
        // 请假
        case kCausationTypeAskLeave:
        case kCausationTypeThingLeave:
        case kCausationTypeSickLeave:
        case kCausationTypeChangeRestLeave:
        case kCausationTypeLactationLeave:
        case kCausationTypeYearLeave:
        case kCausationTypeMonthLeave:
        case kCausationTypeSeeRelativeLeave:
        case kCausationTypeMarryLeave:
        case kCausationTypeBabyLeave:
        case kCausationTypeCompanyBabyLeave:
        case kCausationTypeFuneralLeave:
        case kCausationTypeInjuryLeave:
        {
            switch(addCount) {
                case 0: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加请假明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"请假理由,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加请假明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"请假理由,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假理由,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }
            }
        }break;
            
        // 出差
        case kCausationTypeevecation:{
            switch(addCount) {
                case 0: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"处理理由,请输入处理理由"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加出差明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"出差原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加出差明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"出差原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"出差原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"处理理由,请输入处理理由"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }
            }
            
        }break;
        // 加班
        case kCausationTypeOverTime:{
            switch(addCount) {
                case 0: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加加班明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加加班明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }
            }
        }break;
        // 外出
        case kCausationTypeOut:{
            switch(addCount) {
                case 0: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"处理理由,请输入处理理由"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加外出明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"外出原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加外出明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"外出原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"根据排班自动计算",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"外出原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"+增加外出明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"外出原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }
            }
            
        }break;
        // 补签
        case kCausationTypeRepairSign:{
            switch (addCount) {
                case 0:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"补签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"补签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"补签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"补签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 4:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"补签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 5:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"补签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏签时间,请选择",@"补签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"补签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
            }
        }break;
        // 改签
        case kCausationTypeChangeSign:{
            return @[@{kCellHeaderTitleKey:@"处理",kCellTitleDetailKey:@[@"改签时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne]},
                     @{kCellHeaderTitleKey:@"处理签到将自动计入考勤统计",kCellTitleDetailKey:@[@"改签原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                     @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                     @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
        }break;
        default:return @[];
    }
}

@end
