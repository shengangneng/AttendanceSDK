//
//  MPMCommomDealingTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

typedef void(^TextFieldChangeBlock)(NSString *currentText);
typedef void(^SectionDeleteBlock)(UIButton *sender);

@interface MPMCommomDealingTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *startIcon;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UIButton *deleteCellButton;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, copy) TextFieldChangeBlock textFieldChangeBlock;
@property (nonatomic, copy) SectionDeleteBlock sectionDeleteBlock;

@property (nonatomic, strong) UITextField *detailTextField;

- (void)setupTextFieldCheck:(BOOL)check;
- (void)setupUILabel;

@end
