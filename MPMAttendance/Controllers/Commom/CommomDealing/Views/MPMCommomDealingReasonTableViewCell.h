//
//  MPMCommomDealingReasonTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#define UITextViewPlaceHolder1 @"请输入"
#define UITextViewPlaceHolder2 @"请输入处理理由"

typedef void(^TextViewChangeTextBlock)(NSString *currentText);

@interface MPMCommomDealingReasonTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *startIcon;
@property (nonatomic, strong) UILabel *txLabel;
@property (nonatomic, strong) UITextView *detailTextView;
@property (nonatomic, strong) UILabel *textViewTotalLength;

@property (nonatomic, copy) TextViewChangeTextBlock changeTextBlock;

@end
