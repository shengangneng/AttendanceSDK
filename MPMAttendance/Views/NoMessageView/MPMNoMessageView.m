//
//  MPMNoMessageView.m
//  MPMAtendence
//  无信息视图
//  Created by shengangneng on 2018/10/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMNoMessageView.h"
#import "MPMAttendanceHeader.h"

@interface MPMNoMessageView ()

@property (nonatomic, strong) UIImageView *nomessageImageView;
@property (nonatomic, strong) UILabel *nomessageLabel;

@end

@implementation MPMNoMessageView

- (instancetype)initWithNoMessageViewImage:(nonnull NSString *)imageName noMessageLabelText:(NSString *)text {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        UIImage *image = ImageName(imageName);
        self.nomessageImageView.image = image;
        [self addSubview:self.nomessageImageView];
        [self.nomessageImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@(image.size.width));
            make.height.equalTo(@(image.size.height));
            make.centerX.equalTo(self.mpm_centerX);
            make.centerY.equalTo(self.mpm_centerY).offset(-20);
        }];
        if (!kIsNilString(text)) {
            self.nomessageLabel.text = text;
            [self addSubview:self.nomessageLabel];
            [self.nomessageLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.equalTo(self.mpm_width);
                make.centerX.equalTo(self.mpm_centerX);
                make.top.equalTo(self.nomessageImageView.mpm_bottom).offset(8);
            }];
        }
    }
    return self;
}

/** 设置隐藏的时候，自视图一起隐藏 */
- (void)setHidden:(BOOL)hidden {
    self.nomessageImageView.hidden = self.nomessageLabel.hidden = hidden;
    [super setHidden:hidden];
}

#pragma mark - Lazy Init
- (UIImageView *)nomessageImageView {
    if (!_nomessageImageView) {
        _nomessageImageView = [[UIImageView alloc] init];
        [_nomessageImageView sizeToFit];
    }
    return _nomessageImageView;
}

- (UILabel *)nomessageLabel {
    if (!_nomessageLabel) {
        _nomessageLabel = [[UILabel alloc] init];
        _nomessageLabel.font = SystemFont(14);
        [_nomessageLabel sizeToFit];
        _nomessageLabel.textAlignment = NSTextAlignmentCenter;
        _nomessageLabel.textColor = kMainLightGray;
    }
    return _nomessageLabel;
}

@end
