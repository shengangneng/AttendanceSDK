//
//  MPMApprovalProcessDetailTableViewCell.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/5/3.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

@interface MPMApprovalProcessDetailTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *detailTitleLabel;            /** 审批人、抄送人、记录人 */
@property (nonatomic, strong) UIImageView *detailMessageImageView;
@property (nonatomic, strong) UIImageView *detailMessageIcon;
@property (nonatomic, strong) UILabel *detailMessageName;
@property (nonatomic, strong) UILabel *detailMessageTime;
@property (nonatomic, strong) UILabel *detailMessageDetailText;


@end
