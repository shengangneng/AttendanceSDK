//
//  MPMProcessDetailApprovalTriangleView.m
//  MPMAtendence
//  白色三角形视图
//  Created by shengangneng on 2018/9/26.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessDetailApprovalTriangleView.h"
#import "MPMAttendanceHeader.h"

@implementation MPMProcessDetailApprovalTriangleView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, kTriangleWidthHeight, 0);
    CGContextAddLineToPoint(context, 0, kTriangleWidthHeight/2);
    CGContextAddLineToPoint(context, kTriangleWidthHeight, kTriangleWidthHeight);
    CGContextClosePath(context);
    [kWhiteColor setFill];
    CGContextFillPath(context);
}

@end
