//
//  MPMSettingClassListTableViewCell.h
//  MPMAtendence
//  考勤班次cell
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseTableViewCell.h"

typedef void(^CheckImageBlock)(void);

@interface MPMSettingClassListTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *checkImage;
@property (nonatomic, strong) UILabel *txLable;
@property (nonatomic, strong) UILabel *detailTxLable;
@property (nonatomic, assign) BOOL isInUsing;        /** 是否当前正在使用的 */

@property (nonatomic, copy) CheckImageBlock checkImageBlock;

@end
