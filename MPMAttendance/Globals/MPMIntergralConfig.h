//
//  MPMIntergralConfig.h
//  MPMAtendence
//  积分设置默认配置项
//  Created by shengangneng on 2018/6/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#ifndef MPMIntergralConfig_h
#define MPMIntergralConfig_h

// 积分设置-通过类型id获取对应配置项
#define kJiFenType0NameFromId @{@"0":@"正常上班打卡",@"5":@"正常下班打卡",@"4":@"早到",@"1":@"迟到",@"2":@"早退",@"3":@"漏卡"}
#define kJiFenType1NameFromId @{@"0":@"改卡",@"1":@"补卡",@"4":@"加班",@"3":@"出差",@"2":@"请假",@"5":@"外出"}
#define kJiFenType0DescriptionFromId @{@"0":@"每次在正常上班的(排班点)打卡奖分",@"5":@"每次在正常下班的(排班点)打卡奖分",@"4":@"每次在正常上班点前(30分钟)打卡奖分",@"1":@"每次在超过(排班点)后打卡扣分",@"2":@"每次在正常下班的(排班点)前打卡扣分",@"3":@"在正常下班限定时间未打卡扣分"}
#define kJiFenType1DescriptionFromId @{@"0":@"每次在正常上下班对(排班点)改卡奖扣分",@"1":@"每次在正常上下班(排班点)补卡奖扣分",@"4":@"按每小时奖分",@"3":@"按每小时奖分",@"2":@"按每小时奖扣分",@"5":@"按每小时奖扣分"}
// 重置的积分（默认积分）
#define kJiFenType0IntergralValueFromId @{@"0":@"5",@"5":@"0",@"4":@"10",@"1":@"-5",@"2":@"-5",@"3":@"-10"}
#define kJiFenType1IntergralValueFromId @{@"0":@"-5",@"1":@"5",@"4":@"10",@"3":@"10",@"2":@"-10",@"5":@"0"}
// 重置的是否需要奖票（默认奖票）
#define kJiFenType0IsTickFromId @{@"0":@"0",@"5":@"0",@"4":@"1",@"1":@"0",@"2":@"0",@"3":@"0"}
#define kJiFenType1IsTickFromId @{@"0":@"0",@"1":@"0",@"4":@"1",@"3":@"1",@"2":@"0",@"5":@"0"}
// 是否需要显示picker框：0否 1是
#define kJiFenType0NeedCondictionFromId @{@"0":@"0",@"5":@"0",@"4":@"0",@"1":@"0",@"2":@"0",@"3":@"0"}
#define kJiFenType1NeedCondictionFromId @{@"0":@"0",@"1":@"0",@"4":@"0",@"3":@"0",@"2":@"0",@"5":@"0"}
// picker默认值(0次，1分，2时，3半天，4全天)
#define kJiFenType0NeedCondictionsDefaultValueFromId @{@"0":@"0",@"5":@"0",@"4":@"0",@"1":@"0",@"2":@"0",@"3":@"0"}
#define kJiFenType1NeedCondictionsDefaultValueFromId @{@"0":@"0",@"1":@"0",@"4":@"2",@"3":@"2",@"2":@"2",@"5":@"2"}
// picker框所有选项
#define kJiFenType0CondictionAllValueFromId @{@"0":@[],@"5":@[],@"4":@[],@"1":@[],@"2":@[],@"3":@[]}
#define kJiFenType1CondictionAllValueFromId @{@"0":@[],@"1":@[],@"4":@[],@"3":@[],@"2":@[],@"5":@[]}
// 0长按钮 1短按钮
#define kJiFenType0TypeFromId @{@"0":@"0",@"5":@"0",@"4":@"0",@"1":@"0",@"2":@"0",@"3":@"0"}
#define kJiFenType1TypeFromId @{@"0":@"0",@"1":@"0",@"4":@"0",@"3":@"0",@"2":@"0",@"5":@"0"}
// 加减分按钮能否切换：0不能 1能
#define kJiFenType0CanChangeFromId @{@"0":@"0",@"5":@"0",@"4":@"0",@"1":@"0",@"2":@"0",@"3":@"0"}
#define kJiFenType1CanChangeFromId @{@"0":@"1",@"1":@"1",@"4":@"0",@"3":@"0",@"2":@"1",@"5":@"1"}

#endif /* MPMIntergralConfig_h */
