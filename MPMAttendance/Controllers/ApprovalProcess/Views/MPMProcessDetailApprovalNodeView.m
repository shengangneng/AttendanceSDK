//
//  MPMProcessDetailApprovalNodeView.m
//  MPMAtendence
//  流程审批详情--审批节点
//  Created by shengangneng on 2018/9/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessDetailApprovalNodeView.h"
#import "MPMProcessDetailApprovalView.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMAttendanceHeader.h"

@implementation MPMProcessDetailApprovalNodeView

- (instancetype)initWithTaskGroup:(MPMTaskInstGroups *)group {
    self = [super init];
    if (self) {
        [self addSubview:self.upLine];
        [self addSubview:self.bottomLine];
        [self addSubview:self.roundView];
        [self.roundView addSubview:self.round];
        [self addSubview:self.titleLabel];
        if (group && group.taskInst.count > 0) {
            [self.upLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.mpm_leading).offset(15);
                make.top.equalTo(self.mpm_top);
                make.height.equalTo(@20);
                make.width.equalTo(@0.5);
            }];
            [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.mpm_leading).offset(15);
                make.top.equalTo(self.upLine.mpm_bottom);
                make.bottom.equalTo(self.mpm_bottom);
                make.width.equalTo(@0.5);
            }];
            [self.roundView mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@20);
                make.centerX.equalTo(self.upLine.mpm_centerX);
                make.centerY.equalTo(self.upLine.mpm_bottom);
            }];
            [self.round mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@10);
                make.centerX.equalTo(self.upLine.mpm_centerX);
                make.centerY.equalTo(self.upLine.mpm_bottom);
            }];
            [self.titleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.centerY.equalTo(self.round.mpm_centerY);
                make.height.equalTo(@16);
                make.leading.equalTo(self.round.mpm_trailing).offset(5);
                make.trailing.equalTo(self.mpm_trailing).offset(-8);
            }];
            MPMViewAttribute *lastAttributes = self.upLine.mpm_bottom;
            NSInteger offset = 20;
            for (int i = 0; i < group.taskInst.count; i++) {
                MPMTaskInsts *inst = group.taskInst[i];
                MPMProcessDetailApprovalView *detail = [[MPMProcessDetailApprovalView alloc] init];
                detail.userName.text = inst.username;
                detail.userIcon.nameLabel.text = inst.username.length > 2 ? [inst.username substringWithRange:NSMakeRange(inst.username.length - 2, 2)]: inst.username;
                if (!kIsNilString(inst.handleTime)) {
                    detail.approvalTime.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:inst.handleTime.doubleValue / 1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
                }
                if (!kIsNilString(inst.remark)) {
                    detail.detailMessage = inst.remark;
                }
                if ([group.taskCode isEqualToString:@"apply"]) {
                    [detail setState:inst.state route:inst.route isApply:YES];
                } else {
                    [detail setState:inst.state route:inst.route isApply:NO];
                }
                [self addSubview:detail];
                [detail mpm_makeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.equalTo(self.mpm_leading).offset(20);
                    make.trailing.equalTo(self.mpm_trailing);
                    make.top.equalTo(lastAttributes).offset(offset);
                    if (group.taskInst.count - 1 == i) {
                        make.bottom.equalTo(self.mpm_bottom);
                    }
                }];
                lastAttributes = detail.mpm_bottom;
                offset = 0;
            }
        } else {
            [self.upLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.mpm_leading).offset(15);
                make.top.equalTo(self.mpm_top);
                make.height.equalTo(@20);
                make.width.equalTo(@0.5);
                make.bottom.equalTo(self.mpm_bottom);
            }];
            [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.mpm_leading).offset(15);
                make.top.equalTo(self.upLine.mpm_bottom);
                make.width.equalTo(@0.5);
                make.bottom.equalTo(self.mpm_bottom);
            }];
            [self.roundView mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@20);
                make.centerX.equalTo(self.upLine.mpm_centerX);
                make.centerY.equalTo(self.upLine.mpm_bottom);
            }];
            [self.round mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@10);
                make.centerX.equalTo(self.upLine.mpm_centerX);
                make.centerY.equalTo(self.upLine.mpm_bottom);
            }];
            [self.titleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.centerY.equalTo(self.round.mpm_centerY);
                make.height.equalTo(@16);
                make.leading.equalTo(self.round.mpm_trailing).offset(5);
                make.trailing.equalTo(self.mpm_trailing).offset(-8);
            }];
        }
    }
    return self;
}

#pragma mark - Lazy Init
- (UIView *)upLine {
    if (!_upLine) {
        _upLine = [[UIView alloc] init];
        _upLine.backgroundColor = kRGBA(218, 218, 218, 1);
    }
    return _upLine;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kRGBA(218, 218, 218, 1);
    }
    return _bottomLine;
}

- (UIView *)roundView {
    if (!_roundView) {
        _roundView = [[UIView alloc] init];
        _roundView.backgroundColor = kTableViewBGColor;
    }
    return _roundView;
}

- (UIView *)round {
    if (!_round) {
        _round = [[UIView alloc] init];
        _round.backgroundColor = kRGBA(218, 218, 218, 1);
        _round.layer.cornerRadius = 5;
        _round.layer.masksToBounds = YES;
    }
    return _round;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"高级审批人";
        _titleLabel.font = SystemFont(13);
        _titleLabel.textColor = kMainLightGray;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

@end
