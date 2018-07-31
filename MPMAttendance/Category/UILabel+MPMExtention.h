//
//  UILabel+MPMExtention.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/7/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MPMExtention)

/** 快捷设置UILabel的UIFont和换行高度 */
- (void)setAttributedString:(NSString *)string font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

@end
