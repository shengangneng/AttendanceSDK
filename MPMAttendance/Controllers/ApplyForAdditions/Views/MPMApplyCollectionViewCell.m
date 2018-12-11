//
//  MPMApplyCollectionViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/11/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApplyCollectionViewCell.h"
#import "MPMButton.h"
#import "MPMDealingBorderButton.h"
#import "MPMAttendanceHeader.h"

@interface MPMApplyCollectionViewCell ()

@end

@implementation MPMApplyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.quickLabel];
        [self.quickLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(10);
            make.trailing.equalTo(self.mpm_trailing).offset(-10);
            make.top.equalTo(self.mpm_top);
            make.bottom.equalTo(self.mpm_bottom).offset(-15);
        }];
    }
    return self;
}

#pragma mark - Lazy Init
- (UILabel *)quickLabel {
    if (!_quickLabel) {
        _quickLabel = [[UILabel alloc] init];
        _quickLabel.textColor = kWhiteColor;
        _quickLabel.font = SystemFont(16);
        _quickLabel.text = @"上午";
        _quickLabel.textAlignment = NSTextAlignmentCenter;
        _quickLabel.layer.cornerRadius = 15;
        _quickLabel.layer.borderColor = kWhiteColor.CGColor;
        _quickLabel.layer.borderWidth = 1;
    }
    return _quickLabel;
}

@end
