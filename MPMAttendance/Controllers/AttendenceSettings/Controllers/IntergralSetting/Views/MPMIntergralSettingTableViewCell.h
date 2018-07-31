//
//  MPMIntergralSettingTableViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMBaseTableViewCell.h"
#import "MPMIntergralScoreView.h"
/** 点击“每小时、半天、全天”按钮 */
typedef void(^SelectTimePickerBlock)(UIButton *sender);
/** 积分TextField聚焦的时候 */
typedef void(^TextFieldBecomeResponderBlock)(UITextField *textfield);
/** 积分TextField改变了数字 */
typedef void(^TextFieldChangeTextBlock)(NSString *text);
/** 点击“奖票”按钮 */
typedef void(^SelectTicketBlock)(UIButton *sender);
/** 点击“加减分”的时候，进行切换 */
typedef void(^ChangeStateBlock)(NSInteger state);

@interface MPMIntergralSettingTableViewCell : MPMBaseTableViewCell

@property (nonatomic, strong) UIImageView *bgroundView;
@property (nonatomic, strong) UILabel *titleLabel;          /** 加班、出差、请假等 */
@property (nonatomic, strong) UILabel *subTitleLabel;       /** 简介 */
@property (nonatomic, strong) UIButton *selectionButton;    /** 弹出Picker并选择 */
@property (nonatomic, strong) UIView *seperateLine;         /** 分割线 */
//@property (nonatomic, strong) UILabel *scroeTypeLabel;      /** A分、B分 */
@property (nonatomic, strong) MPMIntergralScoreView *intergralView; /** 加减分控件 */
@property (nonatomic, strong) UIButton *ticketButton;       /** 奖票 */

@property (nonatomic, copy) SelectTimePickerBlock selectTimePickerBlock;
@property (nonatomic, copy) TextFieldBecomeResponderBlock tfBecomeResponderBlock;
@property (nonatomic, copy) TextFieldChangeTextBlock tfChangeTextBlock;
@property (nonatomic, copy) SelectTicketBlock selectTicketBlock;
@property (nonatomic, copy) ChangeStateBlock changeStateBlock;

@end
