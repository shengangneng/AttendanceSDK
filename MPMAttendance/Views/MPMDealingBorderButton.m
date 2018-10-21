//
//  MPMDealingBorderButton.m
//  MPMAtendence
//  一个选中和普通状态不同颜色border的按钮
//  Created by shengangneng on 2018/9/8.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDealingBorderButton.h"

@interface MPMDealingBorderButton ()

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;

@end

@implementation MPMDealingBorderButton

- (instancetype)initWithTitle:(NSString *)title
                       nColor:(UIColor *)nColor
                       sColor:(UIColor *)sColor
                         font:(UIFont *)font
                 cornerRadius:(CGFloat)radius
                  borderWidth:(CGFloat)bWidth {
    self = [super init];
    if (self) {
        self.normalColor = nColor;
        self.selectedColor = sColor;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = nColor.CGColor;
        self.titleLabel.font = font;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateSelected];
        [self setTitleColor:nColor forState:UIControlStateNormal];
        [self setTitleColor:sColor forState:UIControlStateHighlighted];
        [self setTitleColor:sColor forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = self.selectedColor.CGColor;
    } else {
        self.layer.borderColor = self.normalColor.CGColor;
    }
}

@end
