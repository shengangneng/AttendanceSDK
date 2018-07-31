//
//  UIButton+MPMExtention.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/15.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "UIButton+MPMExtention.h"

@implementation UIButton (MPMExtention)

- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type {
    
    UIImage *backImage = [[UIImage alloc]createImageWithSize:btnSize gradientColors:clrs percentage:percent gradientType:type];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    
    return self;
}

@end
