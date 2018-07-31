//
//  UIImage+MPMExtention.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,        // 从上到下
    GradientFromLeftToRight,            // 从左到右
    GradientFromLeftTopToRightBottom,   // 从上到下
    GradientFromLeftBottomToRightTop    // 从上到下
};

@interface UIImage (MPMExtention)

/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize    要生成的图片的大小
 *  @param colorArr     渐变颜色的数组
 *  @param percents     渐变颜色的占比数组
 *  @param gradientType 渐变色的类型
 */
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr percentage:(NSArray *)percents gradientType:(GradientType)gradientType;

/**
 *  根据给定的半径、颜色，生成一个圆形的图片
 *  @param radius   圆形的半径
 *  @param color    图片的颜色
 */
+ (UIImage *)createRoundImageWithRadius:(CGFloat)radius color:(UIColor *)color;

/**
 *  根据原始图片，生成特定尺寸的小图片
 *  @param image    传入的原始图片
 *  @param size     需要生成的图片的尺寸
 */
+ (UIImage *)getSmallImageFromOriImage:(UIImage *)image smallSize:(CGSize)size;

+ (UIImage *)getImageFromColor:(UIColor *)color;

@end
