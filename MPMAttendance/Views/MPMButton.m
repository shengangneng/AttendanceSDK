//
//  MPMButton.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMButton.h"

@implementation MPMButton

/** 设置普通按钮 */
+ (UIButton *)normalButtonWithTitle:(NSString *)title titleColor:(UIColor *)tColor bgcolor:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectZero];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:tColor forState:UIControlStateNormal];
    [btn setTitleColor:tColor forState:UIControlStateHighlighted];
    if (color) {
        [btn setBackgroundColor:color];
    }
    return btn;
}

/** 文字 + 背景图片按钮 */
+ (UIButton *)titleButtonWithTitle:(NSString *)title nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor nBGImage:(UIImage *)nImage hImage:(UIImage *)hImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectZero];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:nColor forState:UIControlStateNormal];
    [btn setTitleColor:hColor forState:UIControlStateHighlighted];
    if (nImage) {
        [btn setBackgroundImage:nImage forState:UIControlStateNormal];
    }
    if (hImage) {
        [btn setBackgroundImage:hImage forState:UIControlStateHighlighted];
    }
    return btn;
}

/** 文字 + 背景色按钮 */
+ (UIButton *)titleButtonWithTitle:(NSString *)title nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor bgColor:(UIColor *)bgColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectZero];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:nColor forState:UIControlStateNormal];
    [btn setTitleColor:hColor forState:UIControlStateHighlighted];
    if (bgColor) {
        [btn setBackgroundColor:bgColor];
    }
    return btn;
}

/** 图片按钮 */
+ (UIButton *)imageButtonWithImage:(UIImage *)image hImage:(UIImage *)hImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectZero];
    if (image) {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (hImage) {
        [btn setBackgroundImage:hImage forState:UIControlStateHighlighted];
    }
    return btn;
}

/** 文字在左 + 图片在右 */
+ (UIButton *)rightImageButtonWithTitle:(NSString *)title nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor nImage:(UIImage *)nImage hImage:(UIImage *)hImage titleEdgeInset:(UIEdgeInsets)tInset imageEdgeInset:(UIEdgeInsets)imInset {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectZero];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:nColor forState:UIControlStateNormal];
    [btn setTitleColor:hColor forState:UIControlStateHighlighted];
    if (nImage) [btn setImage:nImage forState:UIControlStateNormal];
    if (hImage) [btn setImage:hImage forState:UIControlStateHighlighted];
    btn.titleEdgeInsets = tInset;
    btn.imageEdgeInsets = imInset;
    return btn;
}

/** 设置图片在上，文字在下的按钮 */
+ (UIButton *)imageUpTitleDownButtonWithTitle:(NSString *)title
                                   titleColor:(UIColor *)titleColor
                                    titleFont:(UIFont *)font
                                        image:(UIImage *)image
                                    highImage:(UIImage *)highImage
                               backgroupColor:(UIColor *)bgColor
                                 cornerRadius:(CGFloat)radius
                                       offset:(CGFloat)offset {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectZero];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setBackgroundColor:bgColor];
    if (radius > 0) {
        btn.layer.cornerRadius = radius;
        btn.layer.masksToBounds = YES;
    }
    [btn setImage:image forState:UIControlStateNormal];
    if (!highImage) {
        [btn setImage:image forState:UIControlStateHighlighted];
    } else {
        [btn setImage:highImage forState:UIControlStateHighlighted];
    }
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.intrinsicContentSize.width, -btn.imageView.intrinsicContentSize.height-offset/2, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
    
    
    return btn;
}

@end
