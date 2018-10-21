//
//  MPMRoundPeopleView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMRoundPeopleView.h"
#import "MPMAttendanceHeader.h"

@interface MPMRoundPeopleView ()

@property (nonatomic, assign) NSInteger width;

@end

@implementation MPMRoundPeopleView

- (instancetype)initWithWidth:(NSInteger)width {
    self = [super init];
    if (self) {
        self.width = width;
        [self addSubview:self.nameLabel];
        self.nameLabel.frame = CGRectMake(0, 0, self.width, self.width);
    }
    return self;
}

// 如果被点击，不响应，让父类进行相应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (void)drawRect:(CGRect)rect {
    // 画一个蓝色的圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, self.width/2, self.width/2, self.width/2, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    [kMainBlueColor setFill];
    CGContextFillPath(context);
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = SystemFont(13);
    }
    return _nameLabel;
}

@end
