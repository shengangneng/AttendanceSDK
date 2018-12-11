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
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加请假明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"请假原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加请假明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"请假原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细3",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假类型,请选择",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeDealingType,kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"请假原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
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
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"处理理由,请输入处理理由"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加出差明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"出差原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加出差明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"出差原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"明细3",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"出差原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"出差地点,请输入",@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长",@"交通工具,",@"预计费用,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextField,kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField,kCellDetailTypeSelectTool,kCellDetailTypeUITextField],kCellActionTypeKey:@[@"",kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@"",kAction_TrafficTool,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"处理理由,请输入处理理由"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
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
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1: {
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加加班明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加加班明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细3",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"加班原因,请输入",@"加班补偿,"],kCellDetailTypeKey:@[kCellDetailTypeUITextView,kCellDetailTypeSelectTool]},
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
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加外出明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"外出原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"+增加外出明细"],kCellDetailTypeKey:@[@"UIButton"],kCellActionTypeKey:@[kAction_AddCell]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"外出原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3: {
                    return @[@{kCellHeaderTitleKey:@"明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"明细3",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"开始时间,请选择",@"结束时间,请选择",@"时长,自动计算时长"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel,kCellDetailTypeUITextField],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne,@""]},
                             @{kCellHeaderTitleKey:@"",kCellHeaderDetailKey:@"",kCellTitleDetailKey:@[@"外出原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
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
            // 补卡
        case kCausationTypeRepairSign:{
            switch (addCount) {
                case 0:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"补卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 1:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"漏卡明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"补卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 2:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"漏卡明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"补卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 3:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"漏卡明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细3",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"补卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 4:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"漏卡明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细3",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细4",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"补卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                case 5:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"漏卡明细1",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细2",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细3",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细4",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"漏卡明细5",kCellHeaderDetailKey:@"删除",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"补卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
                default:{
                    return @[@{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡明细,"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"漏卡时间,请选择",@"补卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel,kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne,kAction_PickerTypeTimeOfOne]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"补卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                             @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
                }break;
            }
        }break;
            // 改卡
        case kCausationTypeChangeSign:{
            return @[@{kCellHeaderTitleKey:@"处理",kCellTitleDetailKey:@[@"改卡时间,请选择"],kCellDetailTypeKey:@[kCellDetailTypeUILabel],kCellActionTypeKey:@[kAction_PickerTypeTimeOfOne]},
                     @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"改卡原因,请输入"],kCellDetailTypeKey:@[kCellDetailTypeUITextView]},
                     @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"提交至,请选择"],kCellDetailTypeKey:@[kCellDetailTypePeople]},
                     @{kCellHeaderTitleKey:@"",kCellTitleDetailKey:@[@"抄送人,添加"],kCellDetailTypeKey:@[kCellDetailTypePeople]}];
        }break;
        default:return @[];
    }
}

@end
