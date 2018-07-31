//
//  MPMCausationTypeData.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCausationTypeData.h"

@implementation MPMCausationTypeData

/**
 <action>
 picker1:请假、出差、补签
 picker2:时间:年月日时分
 picker3:时间:年月日
 picker4:上班、下班
 picker5:早班、中班、晚班
 */
+ (NSArray *)getTableViewDataWithCausationType:(CausationType)type addCount:(NSInteger)addCount {
    switch (type) {
        case forCausationTypeAskLeave:{  // 请假申请
            return  @[@{@"title":@"请假明细",@"cell":@[@"处理类型,请假申请"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                      @{@"title":@"处理",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                      @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                      @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                      @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
        }break;
        case forCausationTypeChangeSign:{ // 改签
            return @[@{@"title":@"班次：",@"cell":@[@"处理类型,改签"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                     @{@"title":@"处理",@"cell":@[@"实际时间,请选择"],@"cellType":@[@"UILabel"],@"action":@[@"picker2"]},
                     @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"改签原因,请输入处理理由"],@"cellType":@[@"UITextView"]},
                     @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                     @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
        }break;
        case forCausationTypeRepairSign:{   // 补签
            return @[@{@"title":@"漏卡：",@"cell":@[@"处理类型,补签"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                     @{@"title":@"处理",@"cell":@[@"处理签到时间,请选择"],@"cellType":@[@"UILabel"],@"action":@[@"picker2"]},
                     @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                     @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                     @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
        }break;
        case forCausationTypeLeave:{        // 请假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,请假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,请假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,请假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,请假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,请假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeevecation:{    // 出差
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"出差类型",@"cell":@[@"处理类型,出差"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,出差"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加出差明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"出差原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,出差"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加出差明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"出差原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,出差"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"出差原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"",@"cell":@[@"处理类型,出差"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"出差地点,如：北京、上海、广州",@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UITextField",@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"",@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加出差明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"出差原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
            
        }break;
        case forCausationTypeeveYearLeave:{ // 年假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,年假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,年假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,年假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,年假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,年假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeeveSickLeave:{ // 病假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,病假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,病假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,病假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,病假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,病假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeeveBabyLeave:{ // 产假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeeveChirdBirthLeave:{ // 陪产假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,陪产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,陪产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,陪产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,陪产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,陪产假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeeveMaryLeave:{ // 婚假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,婚假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,婚假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,婚假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,婚假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,婚假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeeveDeadLeave:{ // 丧假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,丧假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,丧假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,丧假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,丧假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,丧假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeeveThingLeave:{ // 事假
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,事假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,事假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,事假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,事假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"请假明细",@"cell":@[@"处理类型,事假"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"请假",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加请假明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"请假原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeOut:{          // 外出
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"漏卡",@"cell":@[@"处理类型,外出"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"处理",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,外出"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加外出明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"外出原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,外出"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加外出明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"外出原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,外出"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"外出原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"",@"cell":@[@"处理类型,外出"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"行程明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加外出明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"外出原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
            
        }break;
        case forCausationTypeChangeRest:{   // 调休
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"调休明细",@"cell":@[@"处理类型,调休"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"调休",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"调休原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"调休明细",@"cell":@[@"处理类型,调休"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"调休",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加调休明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"调休原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"调休明细",@"cell":@[@"处理类型,调休"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"调休",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加调休明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"调休原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"调休明细",@"cell":@[@"处理类型,调休"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"调休",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"调休原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"调休明细",@"cell":@[@"处理类型,调休"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"调休",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加调休明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"调休原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeChangeClass:{  // 调班
            return @[@{@"title":@"处理:自由补签时间",@"cell":@[@"处理类型,调班"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                     @{@"title":@"处理",@"cell":@[@"请选择调班日期,请选择",@"原班次,请选择"],@"cellType":@[@"UILabel",@"UILabel"],@"action":@[@"picker3",@"picker5"]},
                     @{@"title":@"",@"cell":@[@"请选择新调班日期,请选择",@"新班次,请选择",@"调整班次人员,方绪雷"],@"cellType":@[@"UILabel",@"UILabel",@"UILabel"],@"action":@[@"picker3",@"picker5",@"next"]},
                     @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"调班原因,请输入"],@"cellType":@[@"UITextView"]},
                     @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                     @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
        }break;
        case forCausationTypeOverTime:{     // 加班
            switch(addCount) {
                case 0: {
                    return @[@{@"title":@"加班类型",@"cell":@[@"处理类型,加班"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"加班",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"加班原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 1: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,加班"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"加班明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加加班明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"加班原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 2: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,加班"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"加班明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加加班明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"加班原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                case 3: {
                    return @[@{@"title":@"",@"cell":@[@"处理类型,加班"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"加班明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"加班原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }break;
                default:{
                    return @[@{@"title":@"",@"cell":@[@"处理类型,加班"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                             @{@"title":@"加班明细",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                             @{@"title":@"时长将自动计入考勤统计",@"cell":@[@"+增加加班明细"],@"cellType":@[@"UIButton"],@"action":@[@"addCell"]},
                             @{@"title":@"",@"cell":@[@"加班原因,请输入"],@"cellType":@[@"UITextView"]},
                             @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                             @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
                }
            }
        }break;
        case forCausationTypeDealing:{     // 处理
            return @[@{@"title":@"漏卡",@"cell":@[@"处理类型,处理"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                     @{@"title":@"处理",@"cell":@[@"处理开始签到时间,请选择"],@"cellType":@[@"UILabel"],@"action":@[@"picker2"]},
                     @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                     @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                     @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
        }break;
        case forCausationTypeExcetionApply:{  // 例外申请
            return @[@{@"title":@"漏卡",@"cell":@[@"处理类型,例外申请"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                     @{@"title":@"处理",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                     @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                     @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                     @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
        }break;
        case forCausationTypeAddFreeSign:{    // 增加自由补签
            return @[@{@"title":@"漏卡",@"cell":@[@"处理类型,补签"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                     @{@"title":@"处理",@"cell":@[@"处理补签时间,请选择",@"选择上下班,上班"],@"cellType":@[@"UILabel",@"UILabel"],@"action":@[@"picker2",@"picker4"]},
                     @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                     @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                     @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
        }break;
        default:
            return @[@{@"title":@"漏卡",@"cell":@[@"处理类型,无类型"],@"cellType":@[@"UILabel"],@"action":@[@"picker1"]},
                     @{@"title":@"处理",@"cell":@[@"开始时间,请选择",@"结束时间,请选择",@"时长(时),"],@"cellType":@[@"UILabel",@"UILabel",@"UITextField"],@"action":@[@"picker2",@"picker2",@""]},
                     @{@"title":@"处理签到将自动计入考勤统计",@"cell":@[@"处理理由,请输入处理理由"],@"cellType":@[@"UITextView"]},
                     @{@"title":@"",@"cell":@[@"审批人,请选择"],@"cellType":@[@"People"]},
                     @{@"title":@"",@"cell":@[@"抄送人,添加"],@"cellType":@[@"People"]}];
            break;
    }
}

@end
