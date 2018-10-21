//
//  MPMSelectDepartmentTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/24.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMRoundPeopleView.h"
#import "MPMSelectDepartmentViewController.h"

typedef void(^CheckImageBlock)(void);

@interface MPMSelectDepartmentTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *checkIconImage;
@property (nonatomic, strong) MPMRoundPeopleView *roundPeopleView;
@property (nonatomic, strong) UILabel *txLabel;

@property (nonatomic, assign) BOOL isHuman; /** 人员或部门 */

@property (nonatomic, copy) CheckImageBlock checkImageBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectionType:(SelectionType)selectionType;

@end
