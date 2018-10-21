//
//  MPMProcessSettingTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/21.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseTableViewCell.h"
typedef void(^UpdateBlock)(void);
typedef void(^DeleteBlock)(void);

@interface MPMProcessSettingTableViewCell : MPMBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier canDelete:(BOOL)canDelete;

@property (nonatomic, strong) UIImageView *bgImageView;     /** 背景 */
@property (nonatomic, strong) UIImageView *flagImageView;   /** flag背景图 */
@property (nonatomic, strong) UILabel *flagNameLabel;       /** flag名称 */
@property (nonatomic, strong) UIView *line;                 /** 分割线 */
@property (nonatomic, strong) UIButton *updateButton;       /** 修改 */
@property (nonatomic, strong) UIButton *deleteButton;       /** 删除 */
@property (nonatomic, strong) UILabel *flagTitleLable;      /** 节点名称lable */
@property (nonatomic, strong) UILabel *flagDetailLabel;     /** 节点名称 */
@property (nonatomic, strong) UILabel *applyerLabel;        /** 审批人lable */
@property (nonatomic, strong) UILabel *applyerNameLabel;    /** 审批人名字 */

@property (nonatomic, assign) BOOL canDelete;               /** 如果只有一个节点，不允许再删除 */

@property (nonatomic, copy) UpdateBlock updateBlock;
@property (nonatomic, copy) DeleteBlock deleteBlock;

@end
