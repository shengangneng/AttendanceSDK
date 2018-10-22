//
//  MPMDetailTimeMessageView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/5.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMDetailTimeMessageView.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMAttendanceHeader.h"

@interface MPMDetailTimeMessageView()

@property (nonatomic, strong) MPMDetailDtoList *detailDto;

@end

@implementation MPMDetailTimeMessageView

/**
 * @param type 申请类型：请假、出差、外出、加班、补签、改签
 * @param withTypeLabel 是否需要显示申请类型Label
 * @param detailDto 详情信息
 */
- (instancetype)initWithCausationType:(CausationType)type withTypeLabel:(BOOL)withTypeLabel detailDto:(MPMDetailDtoList *)detailDto {
    self = [super init];
    if (self) {
        self.type = type;
        self.withTypeLabel = withTypeLabel;
        self.detailDto = detailDto;
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstaints];
    }
    return self;
}

- (void)setupAttributes {
    self.userInteractionEnabled = NO;
    self.backgroundColor = kWhiteColor;
    // 处理类型:
    self.contentTimeLeaveTypeMessage.text = kGetCausationNameFromNum[[NSString stringWithFormat:@"%ld",self.type]];
    self.contentAddressMessage.text = self.detailDto.address;
    if (kCausationTypeRepairSign == self.type) {
        // 补签
        self.contentTimeBeginTimeLabel.text = @"补签时间";
        self.contentTimeendTimeLabel.text = @"漏签时间";
        self.contentTimeBeginTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.signTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeendTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.fillupTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
    } else if (kCausationTypeChangeSign == self.type) {
        // 改签
        self.contentTimeBeginTimeLabel.text = @"考勤时间";
        self.contentTimeendTimeLabel.text = @"签到时间";
        self.contentTimeIntervalLabel.text = @"改签时间";
        self.contentTimeBeginTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.attendanceTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeendTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.signTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeIntervalMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.reviseSignTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
    } else if (kCausationTypeAskLeave == self.type) {
        // 请假
        self.contentTimeBeginTimeLabel.text = @"开始时间";
        self.contentTimeendTimeLabel.text = @"结束时间";
        self.contentTimeIntervalLabel.text = @"时长";
        self.contentTimeBeginTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.startTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeendTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.endTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeIntervalMessage.text = [NSString stringWithFormat:@"%@（小时）",self.detailDto.hourAccount];
    } else if (kCausationTypeOut == self.type) {
        // 外出
        self.contentTimeBeginTimeLabel.text = @"开始时间";
        self.contentTimeendTimeLabel.text = @"结束时间";
        self.contentTimeIntervalLabel.text = @"时长";
        self.contentTimeBeginTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.startTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeendTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.endTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeIntervalMessage.text = [NSString stringWithFormat:@"%@（小时）",self.detailDto.hourAccount];
    } else if (kCausationTypeevecation == self.type) {
        // 出差
        self.contentTimeBeginTimeLabel.text = @"开始时间";
        self.contentTimeendTimeLabel.text = @"结束时间";
        self.contentTimeIntervalLabel.text = @"时长";
        self.contentTimeBeginTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.startTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeendTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.endTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeIntervalMessage.text = [NSString stringWithFormat:@"%@（小时）",self.detailDto.hourAccount];
    } else if (kCausationTypeOverTime == self.type) {
        // 加班
        self.contentTimeBeginTimeLabel.text = @"开始时间";
        self.contentTimeendTimeLabel.text = @"结束时间";
        self.contentTimeIntervalLabel.text = @"时长";
        self.contentTimeBeginTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.startTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeendTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.detailDto.endTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        self.contentTimeIntervalMessage.text = [NSString stringWithFormat:@"%@（小时）",self.detailDto.hourAccount];
    }
    // 交通工具
    self.contentTrafficMessage.text = kIsNilString(self.detailDto.traffic) ? @"无" : self.detailDto.traffic;
    
    if (kCausationTypeevecation == self.type) {
        // 出差：预计费用
        self.contentCostMoneyLabel.text = @"预计费用";
        self.contentCostMoneyMessage.text = kIsNilString(self.detailDto.expectCost) ? @"无" : self.detailDto.expectCost;
    } else if (kCausationTypeOverTime == self.type) {
        // 加班：加班补偿
        self.contentCostMoneyLabel.text = @"加班补偿";
        self.contentCostMoneyMessage.text = !kIsNilString(self.detailDto.redress) ? ((self.detailDto.redress.integerValue > 3 || self.detailDto.redress.integerValue < 1) ? @"" : @[@"无",@"调休",@"加班费"][self.detailDto.redress.integerValue - 1]) : @"";
    }
    // 积分
    self.contentIntegralMessage.text = self.detailDto.bScore;
}

- (void)setupSubViews {
    // 处理类型
    [self addSubview:self.contentTimeLeaveTypeLabel];
    [self addSubview:self.contentTimeLeaveTypeMessage];
    // 出差地点
    [self addSubview:self.contentAddressLabel];
    [self addSubview:self.contentAddressMessage];
    // 开始时间、结束时间、时长等
    [self addSubview:self.contentTimeBeginTimeLabel];
    [self addSubview:self.contentTimeBeginTimeMessage];
    [self addSubview:self.contentTimeendTimeLabel];
    [self addSubview:self.contentTimeendTimeMessage];
    [self addSubview:self.contentTimeIntervalLabel];
    [self addSubview:self.contentTimeIntervalMessage];
    // 交通工具
    [self addSubview:self.contentTrafficLabel];
    [self addSubview:self.contentTrafficMessage];
    // 预计费用、加班补偿
    [self addSubview:self.contentCostMoneyLabel];
    [self addSubview:self.contentCostMoneyMessage];
    // 积分
    [self addSubview:self.contentIntegralLabel];
    [self addSubview:self.contentIntegralMessage];
    // 蓝色条
    [self addSubview:self.contentTimeLeftBar];
}

- (void)setupConstaints {
    [self.contentTimeLeftBar mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@4);
    }];
    
    if (self.withTypeLabel) {
        [self.contentTimeLeaveTypeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(self.mpm_top).offset(8);
            make.width.equalTo(@87);
            make.height.equalTo(@(22));
        }];
        [self.contentTimeLeaveTypeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTimeLeaveTypeLabel.mpm_trailing).offset(8);
            make.top.equalTo(self.contentTimeLeaveTypeLabel.mpm_top);
            make.height.equalTo(self.contentTimeLeaveTypeLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    } else {
        [self.contentTimeLeaveTypeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(self.mpm_top).offset(8);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
        [self.contentTimeLeaveTypeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTimeLeaveTypeLabel.mpm_trailing).offset(8);
            make.top.equalTo(self.contentTimeLeaveTypeLabel.mpm_top);
            make.height.equalTo(self.contentTimeLeaveTypeLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    }
    
    // 行程地点：只属于出差
    MPMViewAttribute *lastAttribute = self.contentTimeLeaveTypeLabel.mpm_bottom;
    if (kCausationTypeevecation == self.type) {
        [self.contentAddressLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@87);
            make.height.equalTo(@22);
        }];
        [self.contentAddressMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentAddressLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentAddressLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
        lastAttribute = self.contentAddressLabel.mpm_bottom;
    } else {
        [self.contentAddressLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
        [self.contentAddressMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentAddressLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentAddressLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    }
    
    [self.contentTimeBeginTimeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading);
        make.top.equalTo(lastAttribute);
        make.width.equalTo(@87);
        make.height.equalTo(@22);
    }];
    [self.contentTimeBeginTimeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentTimeBeginTimeLabel.mpm_trailing).offset(8);
        make.top.equalTo(lastAttribute);
        make.height.equalTo(@22);
        make.trailing.equalTo(self.mpm_trailing).offset(-5);
    }];
    [self.contentTimeendTimeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading);
        make.top.equalTo(self.contentTimeBeginTimeLabel.mpm_bottom);
        make.width.equalTo(@87);
        make.height.equalTo(@22);
    }];
    [self.contentTimeendTimeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentTimeendTimeLabel.mpm_trailing).offset(8);
        make.top.equalTo(self.contentTimeendTimeLabel.mpm_top);
        make.height.equalTo(@22);
        make.trailing.equalTo(self.mpm_trailing).offset(-5);
    }];
    // 补签的时候需要隐藏
    lastAttribute = self.contentTimeendTimeLabel.mpm_bottom;
    if (kCausationTypeRepairSign == self.type) {
        [self.contentTimeIntervalLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@(0));
            make.height.equalTo(@(0));
        }];
        [self.contentTimeIntervalMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTimeIntervalLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentTimeIntervalLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    } else {
        [self.contentTimeIntervalLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@(87));
            make.height.equalTo(@(22));
        }];
        [self.contentTimeIntervalMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTimeIntervalLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentTimeIntervalLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
        lastAttribute = self.contentTimeIntervalLabel.mpm_bottom;
    }
    // 交通工具：只属于出差
    if (kCausationTypeevecation == self.type) {
        [self.contentTrafficLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@(87));
            make.height.equalTo(@(22));
        }];
        [self.contentTrafficMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTrafficLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentTrafficLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
        lastAttribute = self.contentTrafficLabel.mpm_bottom;
    } else {
        [self.contentTrafficLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@(0));
            make.height.equalTo(@(0));
        }];
        [self.contentTrafficMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTrafficLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentTrafficLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    }
    // 预计费用、加班补偿：出差和外出
    if (kCausationTypeevecation == self.type || kCausationTypeOverTime == self.type) {
        [self.contentCostMoneyLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@(87));
            make.height.equalTo(@(22));
        }];
        [self.contentCostMoneyMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentCostMoneyLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentCostMoneyLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
        lastAttribute = self.contentCostMoneyLabel.mpm_bottom;
    } else {
        [self.contentCostMoneyLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(lastAttribute);
            make.width.equalTo(@(0));
            make.height.equalTo(@(0));
        }];
        [self.contentCostMoneyMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentCostMoneyLabel.mpm_trailing).offset(8);
            make.top.equalTo(lastAttribute);
            make.height.equalTo(self.contentCostMoneyLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    }
    // 积分
    [self.contentIntegralLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading);
        make.top.equalTo(lastAttribute);
        make.width.equalTo(@(87));
        make.height.equalTo(@(22));
    }];
    [self.contentIntegralMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentIntegralLabel.mpm_trailing).offset(8);
        make.top.equalTo(lastAttribute);
        make.height.equalTo(self.contentIntegralLabel.mpm_height);
        make.trailing.equalTo(self.mpm_trailing).offset(-5);
    }];
}

#pragma mark - Private Method
- (NSString *)formatdate:(NSString *)date time:(NSString *)time {
    if (kIsNilString(date) || date.length < 3) {
        return @"";
    }
    // +8小时
    NSDate *tt = [NSDate dateWithTimeIntervalSince1970:((time.integerValue)/1000+28800) + date.integerValue/1000];
    NSString *real = [NSDateFormatter formatterDate:tt withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
    return real;
}

#pragma mark - Lazy Init
- (UIImageView *)contentTimeLeftBar {
    if (!_contentTimeLeftBar) {
        _contentTimeLeftBar = [[UIImageView alloc] init];
        _contentTimeLeftBar.image = ImageName(@"approval_detail_colorbar");
        _contentTimeLeftBar.hidden = YES;
    }
    return _contentTimeLeftBar;
}

- (UILabel *)contentTimeLeaveTypeLabel {
    if (!_contentTimeLeaveTypeLabel) {
        _contentTimeLeaveTypeLabel = [[UILabel alloc] init];
        _contentTimeLeaveTypeLabel.text = @"处理类型";
        _contentTimeLeaveTypeLabel.textAlignment = NSTextAlignmentRight;
        _contentTimeLeaveTypeLabel.textColor = kMainLightGray;
        _contentTimeLeaveTypeLabel.font = SystemFont(15);
    }
    return _contentTimeLeaveTypeLabel;
}
- (UILabel *)contentTimeLeaveTypeMessage {
    if (!_contentTimeLeaveTypeMessage) {
        _contentTimeLeaveTypeMessage = [[UILabel alloc] init];
        _contentTimeLeaveTypeMessage.textAlignment = NSTextAlignmentLeft;
        _contentTimeLeaveTypeMessage.text = @"事假";
        _contentTimeLeaveTypeMessage.font = SystemFont(15);
    }
    return _contentTimeLeaveTypeMessage;
}

- (UILabel *)contentAddressLabel {
    if (!_contentAddressLabel) {
        _contentAddressLabel = [[UILabel alloc] init];
        _contentAddressLabel.text = @"出差地址";
        _contentAddressLabel.textAlignment = NSTextAlignmentRight;
        _contentAddressLabel.textColor = kMainLightGray;
        _contentAddressLabel.font = SystemFont(15);
    }
    return _contentAddressLabel;
}
- (UILabel *)contentAddressMessage {
    if (!_contentAddressMessage) {
        _contentAddressMessage = [[UILabel alloc] init];
        _contentAddressMessage.textAlignment = NSTextAlignmentLeft;
        _contentAddressMessage.text = @"具体地址";
        _contentAddressMessage.font = SystemFont(15);
    }
    return _contentAddressMessage;
}
- (UILabel *)contentTimeBeginTimeLabel {
    if (!_contentTimeBeginTimeLabel) {
        _contentTimeBeginTimeLabel = [[UILabel alloc] init];
        _contentTimeBeginTimeLabel.text = @"开始时间";
        _contentTimeBeginTimeLabel.textAlignment = NSTextAlignmentRight;
        _contentTimeBeginTimeLabel.textColor = kMainLightGray;
        _contentTimeBeginTimeLabel.font = SystemFont(15);
    }
    return _contentTimeBeginTimeLabel;
}
- (UILabel *)contentTimeBeginTimeMessage {
    if (!_contentTimeBeginTimeMessage) {
        _contentTimeBeginTimeMessage = [[UILabel alloc] init];
        _contentTimeBeginTimeMessage.text = @"2018-02-09";
        _contentTimeBeginTimeMessage.font = SystemFont(15);
    }
    return _contentTimeBeginTimeMessage;
}
- (UILabel *)contentTimeendTimeLabel {
    if (!_contentTimeendTimeLabel) {
        _contentTimeendTimeLabel = [[UILabel alloc] init];
        _contentTimeendTimeLabel.text = @"结束时间";
        _contentTimeendTimeLabel.textAlignment = NSTextAlignmentRight;
        _contentTimeendTimeLabel.textColor = kMainLightGray;
        _contentTimeendTimeLabel.font = SystemFont(15);
    }
    return _contentTimeendTimeLabel;
}
- (UILabel *)contentTimeendTimeMessage {
    if (!_contentTimeendTimeMessage) {
        _contentTimeendTimeMessage = [[UILabel alloc] init];
        _contentTimeendTimeMessage.text = @"2018-02-10";
        _contentTimeendTimeMessage.font = SystemFont(15);
    }
    return _contentTimeendTimeMessage;
}
- (UILabel *)contentTimeIntervalLabel {
    if (!_contentTimeIntervalLabel) {
        _contentTimeIntervalLabel = [[UILabel alloc] init];
        _contentTimeIntervalLabel.text = @"时长";
        _contentTimeIntervalLabel.textAlignment = NSTextAlignmentRight;
        _contentTimeIntervalLabel.textColor = kMainLightGray;
        _contentTimeIntervalLabel.font = SystemFont(15);
    }
    return _contentTimeIntervalLabel;
}
- (UILabel *)contentTimeIntervalMessage {
    if (!_contentTimeIntervalMessage) {
        _contentTimeIntervalMessage = [[UILabel alloc] init];
        _contentTimeIntervalMessage.text = @"10（小时）";
        _contentTimeIntervalMessage.font = SystemFont(15);
    }
    return _contentTimeIntervalMessage;
}
// 交通工具
- (UILabel *)contentTrafficLabel {
    if (!_contentTrafficLabel) {
        _contentTrafficLabel = [[UILabel alloc] init];
        _contentTrafficLabel.text = @"交通工具";
        _contentTrafficLabel.textAlignment = NSTextAlignmentRight;
        _contentTrafficLabel.textColor = kMainLightGray;
        _contentTrafficLabel.font = SystemFont(15);
    }
    return _contentTrafficLabel;
}
- (UILabel *)contentTrafficMessage {
    if (!_contentTrafficMessage) {
        _contentTrafficMessage = [[UILabel alloc] init];
        _contentTrafficMessage.text = @"马航MH370";
        _contentTrafficMessage.font = SystemFont(15);
    }
    return _contentTrafficMessage;
}
// 预计费用、加班补偿
- (UILabel *)contentCostMoneyLabel {
    if (!_contentCostMoneyLabel) {
        _contentCostMoneyLabel = [[UILabel alloc] init];
        _contentCostMoneyLabel.text = @"预计费用";
        _contentCostMoneyLabel.textAlignment = NSTextAlignmentRight;
        _contentCostMoneyLabel.textColor = kMainLightGray;
        _contentCostMoneyLabel.font = SystemFont(15);
    }
    return _contentCostMoneyLabel;
}
- (UILabel *)contentCostMoneyMessage {
    if (!_contentCostMoneyMessage) {
        _contentCostMoneyMessage = [[UILabel alloc] init];
        _contentCostMoneyMessage.text = @"费用100万";
        _contentCostMoneyMessage.font = SystemFont(15);
    }
    return _contentCostMoneyMessage;
}
// 积分
- (UILabel *)contentIntegralLabel {
    if (!_contentIntegralLabel) {
        _contentIntegralLabel = [[UILabel alloc] init];
        _contentIntegralLabel.text = @"积分";
        _contentIntegralLabel.textAlignment = NSTextAlignmentRight;
        _contentIntegralLabel.textColor = kMainLightGray;
        _contentIntegralLabel.font = SystemFont(15);
    }
    return _contentIntegralLabel;
}
- (UILabel *)contentIntegralMessage {
    if (!_contentIntegralMessage) {
        _contentIntegralMessage = [[UILabel alloc] init];
        _contentIntegralMessage.text = @"+100";
        _contentIntegralMessage.font = SystemFont(15);
    }
    return _contentIntegralMessage;
}

@end
