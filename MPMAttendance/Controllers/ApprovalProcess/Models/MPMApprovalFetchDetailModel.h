//
//  MPMApprovalFetchDetailModel.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseModel.h"
#import "MPMApprovalCausationModel.h"
#import "MPMApprovalCausationDetailModel.h"

@interface MPMApprovalFetchDetailModel : MPMBaseModel

@property (nonatomic, strong) MPMApprovalCausationModel *causation;
/** MPMApprovalCausationDetailModel */
@property (nonatomic, copy) NSArray *causationDetailArray;

@end
