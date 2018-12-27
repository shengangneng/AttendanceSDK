//
//  MPMCustomProgressHUD.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/11/8.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMCustomProgressHUD : UIView

/** 四个圆圈的旋转动画 */
+ (void)showProgressHUD;

/** 纯文本 */
+ (void)showWithMessage:(NSString *)message;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
