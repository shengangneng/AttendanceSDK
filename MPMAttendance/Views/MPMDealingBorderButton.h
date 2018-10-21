//
//  MPMDealingButton.h
//  MPMAtendence
//  一个选中和普通状态不同颜色border的按钮
//  Created by shengangneng on 2018/9/8.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMDealingBorderButton : UIButton
/**
 * @param title     按钮文字
 * @param nColor    普通状态下的文字颜色和按钮border颜色
 * @param sColor    高亮、选中状态下的文字颜色和按钮border颜色
 * @param font      按钮文字大小
 * @param radius    按钮borderRadius
 * @param bWidth    按钮borderWidth
 *
 */
- (instancetype)initWithTitle:(NSString *)title
                       nColor:(UIColor *)nColor
                       sColor:(UIColor *)sColor
                         font:(UIFont *)font
                 cornerRadius:(CGFloat)radius
                  borderWidth:(CGFloat)bWidth;

@end
