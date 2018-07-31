//
//  MPMIntergralScoreView.h
//  MPMAtendence
//  加减分和输入框控件
//  Created by shengangneng on 2018/6/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 输入框聚焦 */
typedef void(^TextFieldBecomeResponderBlock)(UITextField *textfield);
/** 输入框改变文字 */
typedef void(^TextFieldChangeTextBlock)(NSString *text);
/** 控件被点击，切换状态 */
typedef void(^ChangeStateBlock)(NSInteger state);

@interface MPMIntergralScoreView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;/** -B\+B */
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, assign) NSInteger state;  /** 0加号、1减号 */
@property (nonatomic, assign) NSInteger type;   /** 0短图片、1长图片 */
@property (nonatomic, copy) TextFieldBecomeResponderBlock tfBecomeResponderBlock;/** 当textfield聚焦时候，tableView滚动到特定位置 */
@property (nonatomic, copy) TextFieldChangeTextBlock tfChangeTextBlock;          /** 当textfield文字改变的时候 */
@property (nonatomic, copy) ChangeStateBlock changeStateBlock;                   /** 点击图片的时候，切换图片 */

@end
