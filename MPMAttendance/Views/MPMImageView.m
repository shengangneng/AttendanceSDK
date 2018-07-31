//
//  MPMImageView.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMImageView.h"

@implementation MPMImageView

+ (UIImageView *)mpmImageViewWithColor:(UIColor *)color imageName:(NSString *)name {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = ImageName(name);
    return imageView;
}

@end
