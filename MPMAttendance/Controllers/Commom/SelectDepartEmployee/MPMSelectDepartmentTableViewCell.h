//
//  MPMSelectDepartmentTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/24.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

typedef void(^CheckImageBlock)(void);

@interface MPMSelectDepartmentTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *checkIconImage;
@property (nonatomic, strong) UIImageView *humanIconImage;
@property (nonatomic, strong) UILabel *txLabel;

@property (nonatomic, copy) NSString *isHuman;/** 如果有值为1则为human，否则为部门 */

@property (nonatomic, copy) CheckImageBlock checkImageBlock;

@end
