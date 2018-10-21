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
@property (nonatomic, copy) NSString *type;         /** 例外申请类型：0改签、1补签、2请假、3出差、4加班、5外出 */
@property (nonatomic, copy) NSString *bScore;       /** b分：加减分 */
@property (nonatomic, copy) NSString *mpm_id;       /** id */

@end
