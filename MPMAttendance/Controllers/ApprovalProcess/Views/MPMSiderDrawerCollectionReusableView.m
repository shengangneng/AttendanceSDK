//
//  MPMSiderDrawerCollectionReusableView.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/26.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSiderDrawerCollectionReusableView.h"
#import "MPMAttendanceHeader.h"

@interface MPMSiderDrawerCollectionReusableView()


@end

@implementation MPMSiderDrawerCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.label];
}

#pragma mark - Lazy Init
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(6, 0, 100, 19);
        _label.font = SystemFont(14);
        _label.textColor = kBlackColor;
    }
    return _label;
}


@end
