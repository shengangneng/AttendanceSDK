//
//  MPMSearchTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseTableViewCell.h"
typedef void(^SearchWillEditingBlock)(void);

@interface MPMSearchTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, copy) SearchWillEditingBlock searchWillEdtingBlock;

@end
