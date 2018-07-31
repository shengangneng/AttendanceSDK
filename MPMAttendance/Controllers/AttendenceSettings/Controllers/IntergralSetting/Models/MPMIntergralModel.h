//
//  MPMIntergralModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMIntergralModel : MPMBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *mpm_id;       /** 对应的id */
@property (nonatomic, copy) NSString *needCondiction;/** 是否需要显示选择器：0不显示，1显示 */
@property (nonatomic, copy) NSString *conditions;   /** 有这个参数则显示，没有则不显示。0次，1分，2时，3半天，4全天 */
@property (nonatomic, copy) NSString *integralType; /** 如：0考勤打卡、1例外申请 */
@property (nonatomic, copy) NSString *integralValue;/** 如：加减分：如10、-21 */
@property (nonatomic, copy) NSString *scoreTitle;   /** 如：B分、A分 */
@property (nonatomic, copy) NSString *type;         /** 0短按钮，1长按钮 */
@property (nonatomic, copy) NSString *typeCanChange;/** 加减分按钮是否能切换：0不能 1能 */
@property (nonatomic, copy) NSString *isTick;       /** 0未选中，1选中 */

@property (nonatomic, copy) NSString *isChange;     /** 1为已改变，其他或者无值为未改变 */

@end
