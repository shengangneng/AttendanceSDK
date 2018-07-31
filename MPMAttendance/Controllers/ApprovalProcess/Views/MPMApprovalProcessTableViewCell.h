//
//  MPMApprovalProcessTableViewCell.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMApprovalCausationModel.h"

@interface MPMApprovalProcessTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *selectImageView;/** 编辑状态下的图标 */

@property (nonatomic, strong) UIImageView *flagImageView;
@property (nonatomic, strong) UIImageView *flagIcon;
@property (nonatomic, strong) UILabel *flagLabel;

@property (nonatomic, strong) UIView  *containerView;
@property (nonatomic, strong) UILabel *applyPersonLabel;
@property (nonatomic, strong) UILabel *applyPersonMessageLabel;
@property (nonatomic, strong) UILabel *extraApplyLabel;
@property (nonatomic, strong) UILabel *extraApplyMessageLabel;
@property (nonatomic, strong) UILabel *applyDetailLabel;
@property (nonatomic, strong) UILabel *applyDetailMessageLabel;
@property (nonatomic, strong) UIView  *line;
@property (nonatomic, strong) UILabel *seeMoreLabel;
@property (nonatomic, strong) UIButton *dateButton;

@end
