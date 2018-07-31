//
//  MPMMapSelectTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/7/26.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseTableViewCell.h"

@interface MPMMapSelectTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *checkLocationImage;  /** 选中的地址 */
@property (nonatomic, assign) BOOL checkLocation;               /** 设置选中该地址 */

@end
