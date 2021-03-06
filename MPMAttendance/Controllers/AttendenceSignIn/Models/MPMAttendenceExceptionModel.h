//
//  MPMAttendenceExceptionModel.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"

@interface MPMAttendenceExceptionModel : MPMBaseModel

@property (nonatomic, copy) NSString *startTime;    /** 开始时间 */
@property (nonatomic, copy) NSString *endTime;      /** 结束时间 */
@property (nonatomic, copy) NSString *reason;       /** 处理理由 */
@property (nonatomic, copy) NSString *type;         /** 例外申请类型：0改卡、1补卡、2请假、3出差、4加班、5外出 */
@property (nonatomic, copy) NSString *bScore;       /** b分：加减分 */
@property (nonatomic, copy) NSString *mpm_id;       /** id */

@property (nonatomic, assign) BOOL hasJoin;         /** 自定义字段，用于分隔数组 */

@end
