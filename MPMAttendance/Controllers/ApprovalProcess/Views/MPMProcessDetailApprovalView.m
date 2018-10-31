//
//  MPMProcessDetailApprovalView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessDetailApprovalView.h"
#import "MPMProcessDetailApprovalTriangleView.h"
#import "MPMAttendanceHeader.h"

#define kItemPerPage    5
#define kItemWidth      50

@implementation MPMProcessDetailApprovalView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setDetailMessage:(NSString *)detailMessage {
    _detailMessage = detailMessage;
    self.approvalDetailMessage.text = detailMessage;
}

- (void)setState:(NSString * _Nonnull)state route:(NSString *)route isApply:(BOOL)apply {
    if (kIsNilString(state)) {
        state = @"1";
    }
    if (apply && 6 == state.integerValue) {
        if (1 == route.integerValue) {
            self.approvalStatusMessage.text = @"已提交";
            self.approvalStatusMessage.textColor = kRGBA(147, 205, 48, 1);
            self.approvalStatusImage.image = ImageName(@"approval_detail_passed");
        } else {
            self.approvalStatusMessage.text = @"已取消";
            self.approvalStatusMessage.textColor = kRGBA(255, 184, 18, 1);
            self.approvalStatusImage.image = ImageName(@"approval_detail_reject");
        }
    } else {
        switch (state.integerValue) {
            case 1:{
                self.approvalStatusMessage.text = @"待处理";
                self.approvalStatusMessage.textColor = kMainBlueColor;
                self.approvalStatusImage.image = ImageName(@"approval_detail_pprovalending");
            }break;
            case 2:{
                self.approvalStatusMessage.text = @"跟随处理";
                self.approvalStatusMessage.textColor = kMainLightGray;
                self.approvalStatusImage.image = ImageName(@"approval_detail_follow");
            }break;
            case 3:{
                self.approvalStatusMessage.text = @"已转交";
                self.approvalStatusMessage.textColor = kRGBA(147, 205, 48, 1);
                self.approvalStatusImage.image = ImageName(@"approval_detail_passed");
            }break;
            case 6:{
                if (2 == route.integerValue) {
                    self.approvalStatusMessage.text = @"已驳回";
                    self.approvalStatusMessage.textColor = kRGBA(255, 184, 18, 1);
                    self.approvalStatusImage.image = ImageName(@"approval_detail_reject");
                } else {
                    self.approvalStatusMessage.text = @"已通过";
                    self.approvalStatusMessage.textColor = kRGBA(147, 205, 48, 1);
                    self.approvalStatusImage.image = ImageName(@"approval_detail_passed");
                }
            }break;
                
            default:
                break;
        }
        
    }
}

- (void)setupAttributes {
    self.backgroundColor = kTableViewBGColor;
}

- (void)setupSubViews {
    [self addSubview:self.userIcon];
    [self addSubview:self.userName];
    [self addSubview:self.triangleView];
    [self addSubview:self.contentImageView];
    [self.contentImageView addSubview:self.approvalStatusImage];
    [self.contentImageView addSubview:self.approvalStatusMessage];
    [self.contentImageView addSubview:self.approvalDetailMessage];
    [self.contentImageView addSubview:self.approvalTime];
}

- (void)setupConstraints {
    [self.userIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.mpm_top).offset(2);
        make.centerX.equalTo(self.userName.mpm_centerX);
        make.width.height.equalTo(@30);
    }];
    NSInteger border = (kScreenWidth - (kItemWidth * kItemPerPage)) / (kItemPerPage + 1);
    [self.userName mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mpm_bottom).offset(4);
        make.leading.equalTo(self.mpm_leading).offset(border - 20);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
    }];
    [self.triangleView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon.mpm_centerY).offset(8);
        make.trailing.equalTo(self.contentImageView.mpm_leading);
        make.width.height.equalTo(@(kTriangleWidthHeight));
    }];
    [self.contentImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.mpm_top).offset(10);
        make.leading.equalTo(self.userIcon.mpm_trailing).offset(20);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.bottom.equalTo(self.mpm_bottom).offset(-10);
    }];
    [self.approvalStatusImage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@13);
        make.leading.equalTo(self.contentImageView.mpm_leading).offset(8);
        make.top.equalTo(self.contentImageView.mpm_top).offset(11.5);
    }];
    [self.approvalStatusMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.approvalStatusImage.mpm_centerY);
        make.leading.equalTo(self.approvalStatusImage.mpm_trailing).offset(7);
        make.trailing.equalTo(self.contentImageView.mpm_trailing).offset(-8);
    }];
    [self.approvalDetailMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.approvalStatusMessage.mpm_leading);
        make.trailing.equalTo(self.contentImageView.mpm_trailing).offset(-8);
        make.top.equalTo(self.approvalStatusMessage.mpm_bottom);
        make.bottom.equalTo(self.contentImageView.mpm_bottom).offset(-8);
    }];
    [self.approvalTime mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.contentImageView.mpm_trailing).offset(-8);
        make.centerY.equalTo(self.approvalStatusImage.mpm_centerY);
    }];
}

#pragma mark - Lazy Init

- (MPMRoundPeopleView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[MPMRoundPeopleView alloc] initWithWidth:30];
        _userIcon.backgroundColor = kTableViewBGColor;
    }
    return _userIcon;
}
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.text = @"王祖蓝";
        _userName.textColor = kMainLightGray;
        _userName.textAlignment = NSTextAlignmentCenter;
        _userName.font = SystemFont(13);
    }
    return _userName;
}

- (MPMProcessDetailApprovalTriangleView *)triangleView {
    if (!_triangleView) {
        _triangleView = [[MPMProcessDetailApprovalTriangleView alloc] init];
        _triangleView.backgroundColor = kTableViewBGColor;
    }
    return _triangleView;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.backgroundColor = kWhiteColor;
        _contentImageView.layer.cornerRadius = 5;
        _contentImageView.layer.masksToBounds = YES;
    }
    return _contentImageView;
}

- (UIImageView *)approvalStatusImage {
    if (!_approvalStatusImage) {
        _approvalStatusImage = [[UIImageView alloc] init];
        _approvalStatusImage.image = ImageName(@"approval_detail_passed");
    }
    return _approvalStatusImage;
}

- (UILabel *)approvalStatusMessage {
    if (!_approvalStatusMessage) {
        _approvalStatusMessage = [[UILabel alloc] init];
        _approvalStatusMessage.textAlignment = NSTextAlignmentLeft;
        [_approvalStatusMessage sizeToFit];
        _approvalStatusMessage.text = @"待处理";
        _approvalStatusMessage.font = SystemFont(13);
        _approvalStatusMessage.textColor = kMainBlueColor;
    }
    return _approvalStatusMessage;
}
- (UILabel *)approvalTime {
    if (!_approvalTime) {
        _approvalTime = [[UILabel alloc] init];
        _approvalTime.textAlignment = NSTextAlignmentRight;
        [_approvalTime sizeToFit];
        _approvalTime.textColor = kMainLightGray;
        _approvalTime.font = SystemFont(13);
    }
    return _approvalTime;
}

- (UILabel *)approvalDetailMessage {
    if (!_approvalDetailMessage) {
        _approvalDetailMessage = [[UILabel alloc] init];
        _approvalDetailMessage.textAlignment = NSTextAlignmentLeft;
        _approvalDetailMessage.text = @"";
        _approvalDetailMessage.numberOfLines = 0;
        _approvalDetailMessage.textColor = kMainLightGray;
        _approvalDetailMessage.font = SystemFont(13);
    }
    return _approvalDetailMessage;
}
@end
