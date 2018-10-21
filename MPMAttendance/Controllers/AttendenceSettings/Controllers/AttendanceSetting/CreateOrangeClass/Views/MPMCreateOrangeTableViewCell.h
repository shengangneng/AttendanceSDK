//
//  MPMCreateOrangeTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"

typedef void(^TextFieldChangeTextBlock)(NSString *text);

@interface MPMCreateOrangeTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UITextField *classNameLabel;
@property (nonatomic, copy) TextFieldChangeTextBlock textFieldChangeBlock;

@end
