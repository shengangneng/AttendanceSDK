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

@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, strong) MPMApprovalCausationModel *model;
@property (nonatomic, strong) MPMApprovalCausationDetailModel *detailModel;

@end

@implementation MPMDetailTimeMessageView

- (instancetype)initWithFrame:(CGRect)frame typeName:(NSString *)name model:(MPMApprovalCausationModel *)model detail:(MPMApprovalCausationDetailModel *)detailModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.detailModel = detailModel;
        self.typeName = name;
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstaints];
    }
    return self;
}

- (void)setupAttributes {
    self.userInteractionEnabled = NO;
    self.backgroundColor = kWhiteColor;
    if (self.detailModel) {
        
        self.contentAddressMessageLabel.text = self.detailModel.address;
        if (kIsNilString(self.typeName)) {
            self.contentTimeLeaveTypeLabel.text = @"";
            self.contentTimeLeaveTypeMessage.text = @"";
        } else {
            self.contentTimeLeaveTypeLabel.text = @"处理类型:";
            self.contentTimeLeaveTypeMessage.text = kSausactionType[kSafeString(self.model.causationtypeNo)];
        }
        self.contentTimeBeginTimeMessage.text = [self formatdate:self.detailModel.startDate time:self.detailModel.startTime];
        self.contentTimeendTimeMessage.text = [self formatdate:self.detailModel.endDate time:self.detailModel.endTime];
        self.contentTimeIntervalMessage.text = [NSString stringWithFormat:@"%@（小时）",self.detailModel.days];
    } else {
        if (self.model.causationtypeNo.integerValue == 0) {
            // 改签
            self.contentTimeLeaveTypeLabel.text = @"处理类型:";
            self.contentTimeLeaveTypeMessage.text = self.typeName;
            self.contentTimeBeginTimeLabel.text = @"考勤时间:";
            self.contentTimeBeginTimeMessage.text =[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.model.schedulingDate.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
            self.contentTimeendTimeLabel.text = @"签到时间:";
            self.contentTimeendTimeMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.model.attendanceTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
            self.contentTimeIntervalLabel.text = @"改签时间:";
            self.contentTimeIntervalMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.model.attendanceDate.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        } else {
            // 补签
            self.contentTimeLeaveTypeLabel.text = @"";
            self.contentTimeLeaveTypeMessage.text = @"";
            self.contentTimeBeginTimeLabel.text = @"处理类型:";
            self.contentTimeBeginTimeMessage.text = self.typeName;
            self.contentTimeendTimeLabel.text = @"漏卡时间:";
            self.contentTimeendTimeMessage.text =[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.model.schedulingDate.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
            self.contentTimeIntervalLabel.text = @"补签时间:";
            self.contentTimeIntervalMessage.text = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.model.attendanceDate.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        }
    }
}

- (void)setupSubViews {
    [self addSubview:self.contentTimeLeaveTypeLabel];
    [self addSubview:self.contentTimeLeaveTypeMessage];
    [self addSubview:self.contentAddressLabel];
    [self addSubview:self.contentAddressMessageLabel];
    [self addSubview:self.contentTimeBeginTimeLabel];
    [self addSubview:self.contentTimeBeginTimeMessage];
    [self addSubview:self.contentTimeendTimeLabel];
    [self addSubview:self.contentTimeendTimeMessage];
    [self addSubview:self.contentTimeIntervalLabel];
    [self addSubview:self.contentTimeIntervalMessage];
    [self addSubview:self.contentTimeLeftBar];
}

- (void)setupConstaints {
    [self.contentTimeLeftBar mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@4);
    }];
    if (kIsNilString(self.typeName) || self.model.causationtypeNo.integerValue == 1) {
        [self.contentTimeLeaveTypeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(self.mpm_top).offset(12);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
        [self.contentTimeLeaveTypeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTimeLeaveTypeLabel.mpm_trailing).offset(5);
            make.top.equalTo(self.contentTimeLeaveTypeLabel.mpm_top);
            make.height.equalTo(self.contentTimeLeaveTypeLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    } else {
        [self.contentTimeLeaveTypeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(self.mpm_top).offset(12);
            make.width.equalTo(@87);
            make.height.equalTo(@(22));
        }];
        [self.contentTimeLeaveTypeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentTimeLeaveTypeLabel.mpm_trailing).offset(5);
            make.top.equalTo(self.contentTimeLeaveTypeLabel.mpm_top);
            make.height.equalTo(self.contentTimeLeaveTypeLabel.mpm_height);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
    }
    
    // 行程地点
    MPMViewAttribute *lastAttribute = self.contentTimeLeaveTypeLabel.mpm_bottom;
    if (self.detailModel && !kIsNilString(self.detailModel.address)) {
        [self.contentAddressLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading);
            make.top.equalTo(self.contentTimeLeaveTypeLabel.mpm_bottom);
            make.width.equalTo(@87);
            make.height.equalTo(@22);
        }];
        [self.contentAddressMessageLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.contentAddressLabel.mpm_trailing).offset(5);
            make.top.equalTo(self.contentTimeLeaveTypeLabel.mpm_bottom);
            make.height.equalTo(@22);
            make.trailing.equalTo(self.mpm_trailing).offset(-5);
        }];
        lastAttribute = self.contentAddressLabel.mpm_bottom;
    }
    
    [self.contentTimeBeginTimeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading);
        make.top.equalTo(lastAttribute);
        make.width.equalTo(@87);
        make.height.equalTo(@22);
    }];
    [self.contentTimeBeginTimeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentTimeBeginTimeLabel.mpm_trailing).offset(5);
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
        make.leading.equalTo(self.contentTimeendTimeLabel.mpm_trailing).offset(5);
        make.top.equalTo(self.contentTimeendTimeLabel.mpm_top);
        make.height.equalTo(@22);
        make.trailing.equalTo(self.mpm_trailing).offset(-5);
    }];
    [self.contentTimeIntervalLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading);
        make.top.equalTo(self.contentTimeendTimeLabel.mpm_bottom);
        make.width.equalTo(@(87));
        make.height.equalTo(@(22));
    }];
    [self.contentTimeIntervalMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentTimeIntervalLabel.mpm_trailing).offset(5);
        make.top.equalTo(self.contentTimeIntervalLabel.mpm_top);
        make.height.equalTo(@22);
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
    }
    return _contentTimeLeftBar;
}

- (UILabel *)contentTimeLeaveTypeLabel {
    if (!_contentTimeLeaveTypeLabel) {
        _contentTimeLeaveTypeLabel = [[UILabel alloc] init];
        _contentTimeLeaveTypeLabel.text = @"处理类型:";
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
        _contentAddressLabel.text = @"出差地址:";
        _contentAddressLabel.textAlignment = NSTextAlignmentRight;
        _contentAddressLabel.textColor = kMainLightGray;
        _contentAddressLabel.font = SystemFont(15);
    }
    return _contentAddressLabel;
}
- (UILabel *)contentAddressMessageLabel {
    if (!_contentAddressMessageLabel) {
        _contentAddressMessageLabel = [[UILabel alloc] init];
        _contentAddressMessageLabel.textAlignment = NSTextAlignmentLeft;
        _contentAddressMessageLabel.text = @"具体地址";
        _contentAddressMessageLabel.font = SystemFont(15);
    }
    return _contentAddressMessageLabel;
}
- (UILabel *)contentTimeBeginTimeLabel {
    if (!_contentTimeBeginTimeLabel) {
        _contentTimeBeginTimeLabel = [[UILabel alloc] init];
        _contentTimeBeginTimeLabel.text = @"开始时间:";
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
        _contentTimeendTimeLabel.text = @"结束时间:";
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
        _contentTimeIntervalLabel.text = @"时长:";
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

@end
