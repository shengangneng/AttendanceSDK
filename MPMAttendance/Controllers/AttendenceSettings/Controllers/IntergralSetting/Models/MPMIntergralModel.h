//
//  MPMIntergralModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMIntergralModel : MPMBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mpm_description;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *scene;        /** 0考勤打卡，1例外申请 */
@property (nonatomic, copy) NSString *mpm_id;       /** 对应的id */
@property (nonatomic, copy) NSString *needCondiction;/** 是否需要显示选择器：0不显示，1显示 */
@property (nonatomic, copy) NSString *conditions;   /** 有这个参数则显示，没有则不显示。0次，1分，2时，3半天，4全天 */
@property (nonatomic, copy) NSString *integralType; /** 对应场景的子类型:(考勤打卡：0正常上班 1迟到 2早退 3漏卡 4早到 5正常下班)(例外申请：0改签 1补签 2请假 3出差 4加班 5外出) */
@property (nonatomic, copy) NSString *integralValue;/** 如：加减分：如10、-21 */
@property (nonatomic, copy) NSString *scoreTitle;   /** 如：B分、A分 */
@property (nonatomic, copy) NSString *type;         /** 0短按钮，1长按钮 */
@property (nonatomic, copy) NSString *typeCanChange;/** 加减分按钮是否能切换：0不能 1能 */
@property (nonatomic, copy) NSString *isTick;       /** 0未选中，1选中 */

@property (nonatomic, copy) NSString *isChange;     /** 1为已改变，其他或者无值为未改变 */

@end
