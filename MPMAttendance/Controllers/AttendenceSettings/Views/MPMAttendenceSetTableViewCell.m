//
//  MPMAttendenceSetTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceSetTableViewCell.h"
#import "MPMButton.h"
#import "UIImage+MPMExtention.h"
#import "MPMSignTimeSections.h"
#import "NSDateFormatter+MPMExtention.h"

@implementation MPMAttendenceSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setModel:(MPMAttendanceSettingModel *)model {
    _model = model;
    // 考勤地址
    NSString *locationName = @"";
    NSArray *locations = model.type.integerValue == 0 ? model.fixedTimeWorkSchedule[@"locatioinSettings"] : model.flexibleTimeWorkSchedule[@"locatioinSettings"];
    if (locations.count > 1) {
        [self.foldLocationsButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.bottomImageView);
            make.bottom.equalTo(self.bottomImageView.mpm_bottom);
            make.height.equalTo(@30);
            make.top.equalTo(self.workLocationMessage.mpm_bottom).offset(10);
        }];
        if (!model.unfold) {
            self.foldLocationsButton.selected = NO;
            locationName = [NSString stringWithFormat:@"1、%@",locations.firstObject[@"locationName"]];
        } else {
            self.foldLocationsButton.selected = YES;
            for (int i = 0; i < locations.count; i++) {
                if (0 == i) {
                    locationName = [NSString stringWithFormat:@"%d、%@",i+1,locations[i][@"locationName"]];
                } else {
                    locationName = [locationName stringByAppendingString:[NSString stringWithFormat:@"\n%d、%@",i+1,locations[i][@"locationName"]]];
                }
            }
        }
    } else if (locations.count == 1) {
        [self.foldLocationsButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.bottomImageView);
            make.bottom.equalTo(self.bottomImageView.mpm_bottom);
            make.height.equalTo(@0);
            make.top.equalTo(self.workLocationMessage.mpm_bottom).offset(10);
        }];
        locationName = locations.firstObject[@"locationName"];
    } else {
        [self.foldLocationsButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.bottomImageView);
            make.bottom.equalTo(self.bottomImageView.mpm_bottom);
            make.height.equalTo(@0);
            make.top.equalTo(self.workLocationMessage.mpm_bottom).offset(10);
        }];
    }
    // 考勤地址
    self.workLocationMessage.attributedText = [self setAttributeText:locationName withSpacing:5];
    
    self.headerTitleLabel.text = model.name;
    // 范围：部门数量、员工数量
    NSMutableArray *departCount = [NSMutableArray array];
    NSMutableArray *peopleCount = [NSMutableArray array];
    for (MPMObjListModel *obj in model.objList) {
        if (obj.type.integerValue == 1) {
            [departCount addObject:obj];
        } else {
            [peopleCount addObject:obj];
        }
    }
    if (departCount.count > 0 && peopleCount.count > 0) {
        self.workScopeMessage.text = [NSString stringWithFormat:@"参与人员:%ld人  参与部门:%ld个",peopleCount.count,departCount.count];
    } else if (peopleCount.count > 0) {
        self.workScopeMessage.text = [NSString stringWithFormat:@"参与人员:%ld人",peopleCount.count];
    } else if (departCount.count > 0) {
        self.workScopeMessage.text = [NSString stringWithFormat:@"参与部门:%ld个",departCount.count];
    } else {
        self.workScopeMessage.text = nil;
    }
    
    // 班次
    NSArray *fixed = model.fixedTimeWorkSchedule[@"signTimeSections"];
    NSString *classMessage;
    if (fixed.count == 1) {
        MPMSignTimeSections *slt = [[MPMSignTimeSections alloc] initWithDictionary:fixed[0]];
        id free = model.fixedTimeWorkSchedule[@"freeTimeSection"];
        if (free && [free isKindOfClass:[NSDictionary class]] && free[@"start"] && ![free[@"start"] isKindOfClass:[NSNull class]] && free[@"end"] && ![free[@"end"] isKindOfClass:[NSNull class]]) {
            NSString *start = kNumberSafeString(free[@"start"]);
            NSString *end = kNumberSafeString(free[@"end"]);
            classMessage = [NSString stringWithFormat:@"A %@ - %@ 间休:%@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.startReturnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:start.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:end.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        } else {
            classMessage = [NSString stringWithFormat:@"A %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.startReturnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
        }
    } else if (fixed.count == 2) {
        MPMSignTimeSections *slt0 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[0]];
        MPMSignTimeSections *slt1 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[1]];
        classMessage = [NSString stringWithFormat:@"A %@ - %@ \nB %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
    } else if (fixed.count == 3) {
        MPMSignTimeSections *slt0 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[0]];
        MPMSignTimeSections *slt1 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[1]];
        MPMSignTimeSections *slt2 = [[MPMSignTimeSections alloc] initWithDictionary:fixed[2]];
        
        classMessage = [NSString stringWithFormat:@"A %@ - %@\nB %@ - %@\nC %@ - %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt0.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt1.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt2.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute],[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:slt2.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
    }
    if (kIsNilString(classMessage)) {
        self.classLabel.text = self.classMessage.text = nil;
    } else {
        self.classMessage.attributedText = [self setAttributeText:classMessage withSpacing:5];
    }
    
    // 考勤日期
    self.workDateMessage.text = kIsNilString(model.cycle) ? @"" : [NSString stringWithFormat:@"周%@",model.cycle];
    
}

- (NSMutableAttributedString *)setAttributeText:(NSString *)text withSpacing:(CGFloat)spacing {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}

#pragma mark - Target Action
- (void)edit:(UIButton *)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)leftswipe:(UISwipeGestureRecognizer *)gesture {
    if (self.swipeShowBlock) {
        self.swipeShowBlock();
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.headerImageView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(-90);
            make.trailing.equalTo(self.mpm_trailing).offset(-100);
            make.top.equalTo(self.mpm_top).offset(5);
            make.height.equalTo(@44.5);
        }];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)rightswipe:(UISwipeGestureRecognizer *)gesture {
    [self dismissSwipeView];
}

- (void)cellTap:(UITapGestureRecognizer *)gesture {
    [self dismissSwipeView];
}

- (void)dismissSwipeView {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.headerImageView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(10);
            make.trailing.equalTo(self.mpm_trailing).offset(-10);
            make.top.equalTo(self.mpm_top).offset(5);
            make.height.equalTo(@44.5);
        }];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)delete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(attendenceSetTableCellDidDeleteWithModel:)]) {
        [self.delegate attendenceSetTableCellDidDeleteWithModel:self.model];
    }
}

- (void)fold:(UIButton *)sender {
    if (self.foldBlock) {
        self.foldBlock();
    }
}

- (void)setupAttributes {
    self.backgroundColor = kTableViewBGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftswipe:)];
    UISwipeGestureRecognizer *rightswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightswipe:)];
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)];
    leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:leftswipe];
    [self addGestureRecognizer:rightswipe];
    [self addGestureRecognizer:cellTap];
    [self.headerEditButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerDeleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.swipeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delete:)]];
    [self.foldLocationsButton addTarget:self action:@selector(fold:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.bottomImageView];
    [self addSubview:self.headerImageView];
    [self addSubview:self.swipeView];
    [self.headerImageView addSubview:self.headerIconView];
    [self.headerImageView addSubview:self.headerTitleLabel];
    [self.headerImageView addSubview:self.headerEditButton];
    [self.headerImageView addSubview:self.headerDeleteButton];
    [self.headerImageView addSubview:self.headerSeperateLine];
    
    // 范围
    [self.bottomImageView addSubview:self.workScopeLabel];
    [self.bottomImageView addSubview:self.workScopeMessage];
    
    // 班次
    [self.bottomImageView addSubview:self.classLabel];
    [self.bottomImageView addSubview:self.classMessage];
    
    // 考勤日期
    [self.bottomImageView addSubview:self.workDateLabel];
    [self.bottomImageView addSubview:self.workDateMessage];
    
    // 地点
    [self.bottomImageView addSubview:self.workLocationLabel];
    [self.bottomImageView addSubview:self.workLocationMessage];
    
    // 折叠
    [self.bottomImageView addSubview:self.foldLocationsButton];
    
    // 左滑才出现的视图
    [self.swipeView addSubview:self.swipeTitleLabel];
}

- (void)setupConstraints {
    [self.headerImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(10);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.top.equalTo(self.mpm_top).offset(5);
        make.height.equalTo(@44.5);
    }];
    [self.headerIconView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@22);
        make.height.equalTo(@20.5);
        make.leading.equalTo(self.headerImageView.mpm_leading).offset(10);
        make.centerY.equalTo(self.headerImageView.mpm_centerY);
    }];
    [self.headerTitleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@20.5);
        make.leading.equalTo(self.headerIconView.mpm_trailing).offset(10);
        make.trailing.equalTo(self.headerEditButton.mpm_leading).offset(-10);
        make.centerY.equalTo(self.headerImageView.mpm_centerY);
    }];
    [self.headerDeleteButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@19.5);
        make.height.equalTo(@20.5);
        make.trailing.equalTo(self.headerImageView.mpm_trailing).offset(-15);
        make.centerY.equalTo(self.headerImageView.mpm_centerY);
    }];
    [self.headerSeperateLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@28.5);
        make.width.equalTo(@0.5);
        make.centerY.equalTo(self.headerImageView.mpm_centerY);
        make.trailing.equalTo(self.headerDeleteButton.mpm_leading).offset(-15);
    }];
    [self.headerEditButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@20.5);
        make.height.equalTo(@20.5);
        make.trailing.equalTo(self.headerSeperateLine.mpm_leading).offset(-15);
        make.centerY.equalTo(self.headerImageView.mpm_centerY);
    }];
    
    [self.bottomImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mpm_leading);
        make.trailing.equalTo(self.headerImageView);
        make.top.equalTo(self.headerImageView.mpm_bottom).offset(-5);
        make.bottom.equalTo(self.mpm_bottom).offset(-5);
    }];
    
    // 范围
    [self.workScopeLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mpm_leading).offset(10);
        make.top.equalTo(self.headerImageView.mpm_bottom).offset(8);
        make.width.equalTo(@55);
    }];
    [self.workScopeMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.workScopeLabel.mpm_trailing).offset(8);
        make.trailing.equalTo(self.bottomImageView.mpm_trailing).offset(-10);
        make.top.equalTo(self.workScopeLabel.mpm_top);
    }];
    
    // 班次
    [self.classLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mpm_leading).offset(10);
        make.top.equalTo(self.workScopeLabel.mpm_bottom).offset(8);
        make.width.equalTo(@55);
    }];
    [self.classMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.classLabel.mpm_trailing).offset(8);
        make.top.equalTo(self.classLabel.mpm_top);
        make.trailing.equalTo(self.bottomImageView.mpm_trailing).offset(-10);
    }];
    
    // 考勤日期
    [self.workDateLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mpm_leading).offset(10);
        make.width.equalTo(@55);
        make.top.equalTo(self.classMessage.mpm_bottom).offset(8);
    }];
    [self.workDateMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.workDateLabel.mpm_trailing).offset(8);
        make.trailing.equalTo(self.bottomImageView.mpm_trailing).offset(-10);
        make.top.equalTo(self.workDateLabel.mpm_top);
    }];
    
    // 地点
    [self.workLocationLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mpm_leading).offset(10);
        make.top.equalTo(self.workDateMessage.mpm_bottom).offset(8);
        make.width.equalTo(@55);
    }];
    [self.workLocationMessage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.workLocationLabel.mpm_trailing).offset(8);
        make.trailing.equalTo(self.bottomImageView.mpm_trailing).offset(-10);
        make.top.equalTo(self.workLocationLabel.mpm_top);
    }];
    
    // 折叠
    [self.foldLocationsButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.bottomImageView);
        make.bottom.equalTo(self.bottomImageView.mpm_bottom);
        make.height.equalTo(@30);
        make.top.equalTo(self.workLocationMessage.mpm_bottom).offset(10);
    }];
    
    // 左滑视图
    [self.swipeView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mpm_trailing).offset(10);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.mpm_bottom).offset(-5);
        make.top.equalTo(self.mpm_top).offset(5);
    }];
    [self.swipeTitleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerX.equalTo(self.swipeView.mpm_centerX);
        make.centerY.equalTo(self.swipeView.mpm_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
}

#pragma mark - Lazy Init
// 头部视图
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithImage:ImageName(@"setting_header")];
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.layer.masksToBounds = NO;
        _headerImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _headerImageView.layer.shadowRadius = 3;
        _headerImageView.layer.shadowColor = kMainLightGray.CGColor;
        _headerImageView.layer.shadowOpacity = 0.5;
    }
    return _headerImageView;
}
- (UIImageView *)headerIconView {
    if (!_headerIconView) {
        _headerIconView = [[UIImageView alloc] initWithImage:ImageName(@"setting_scheduling")];
    }
    return _headerIconView;
}
- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.textColor = kWhiteColor;
        _headerTitleLabel.font = SystemFont(17);
        [_headerTitleLabel sizeToFit];
    }
    return _headerTitleLabel;
}
- (UIButton *)headerEditButton {
    if (!_headerEditButton) {
        _headerEditButton = [MPMButton imageButtonWithImage:ImageName(@"setting_scheduleditor") hImage:ImageName(@"setting_scheduleditor")];
    }
    return _headerEditButton;
}
- (UIButton *)headerDeleteButton {
    if (!_headerDeleteButton) {
        _headerDeleteButton = [MPMButton imageButtonWithImage:ImageName(@"setting_scheduldelete") hImage:ImageName(@"setting_scheduleditor")];
    }
    return _headerDeleteButton;
}
- (UIView *)headerSeperateLine {
    if (!_headerSeperateLine) {
        _headerSeperateLine = [[UIView alloc] init];
        _headerSeperateLine.backgroundColor = kTableViewBGColor;
    }
    return _headerSeperateLine;
}

// 底部视图
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] initWithImage:ImageName(@"setting_bottom")];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.layer.masksToBounds = NO;
        _bottomImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _bottomImageView.layer.shadowRadius = 3;
        _bottomImageView.layer.shadowColor = kMainLightGray.CGColor;
        _bottomImageView.layer.shadowOpacity = 0.5;
    }
    return _bottomImageView;
}

// 参与人员
- (UILabel *)workScopeLabel {
    if (!_workScopeLabel) {
        _workScopeLabel = [[UILabel alloc] init];
        _workScopeLabel.text = @"人员";
        _workScopeLabel.textAlignment = NSTextAlignmentRight;
        [_workScopeLabel sizeToFit];
        _workScopeLabel.textColor = kRGBA(28, 28, 28, 1);
        _workScopeLabel.font = SystemFont(13);
    }
    return _workScopeLabel;
}
- (UILabel *)workScopeMessage {
    if (!_workScopeMessage) {
        _workScopeMessage = [[UILabel alloc] init];
        _workScopeMessage.textAlignment = NSTextAlignmentLeft;
        [_workScopeMessage sizeToFit];
        _workScopeMessage.textColor = kMainLightGray;
        _workScopeMessage.font = SystemFont(13);
    }
    return _workScopeMessage;
}

// 班次
- (UILabel *)classLabel {
    if (!_classLabel) {
        _classLabel = [[UILabel alloc] init];
        _classLabel.textAlignment = NSTextAlignmentRight;
        [_classLabel sizeToFit];
        _classLabel.text = @"班次";
        _classLabel.textColor = kRGBA(28, 28, 28, 1);
        _classLabel.font = SystemFont(13);
    }
    return _classLabel;
}
- (UILabel *)classMessage {
    if (!_classMessage) {
        _classMessage = [[UILabel alloc] init];
        _classMessage.textAlignment = NSTextAlignmentLeft;
        _classMessage.textColor = kMainLightGray;
        _classMessage.numberOfLines = 0;
        [_classMessage sizeToFit];
        _classMessage.font = SystemFont(13);
    }
    return _classMessage;
}

// 考勤日期
- (UILabel *)workDateLabel {
    if (!_workDateLabel) {
        _workDateLabel = [[UILabel alloc] init];
        _workDateLabel.textAlignment = NSTextAlignmentRight;
        _workDateLabel.text = @"考勤日期";
        [_workDateLabel sizeToFit];
        _workDateLabel.textColor = kRGBA(28, 28, 28, 1);
        _workDateLabel.font = SystemFont(13);
    }
    return _workDateLabel;
}
- (UILabel *)workDateMessage {
    if (!_workDateMessage) {
        _workDateMessage = [[UILabel alloc] init];
        _workDateMessage.textAlignment = NSTextAlignmentLeft;
        [_workDateMessage sizeToFit];
        _workDateMessage.textColor = kMainLightGray;
        _workDateMessage.font = SystemFont(13);
    }
    return _workDateMessage;
}

// 考勤地址
- (UILabel *)workLocationLabel {
    if (!_workLocationLabel) {
        _workLocationLabel = [[UILabel alloc] init];
        _workLocationLabel.textAlignment = NSTextAlignmentRight;
        [_workLocationLabel sizeToFit];
        _workLocationLabel.text = @"考勤地址";
        _workLocationLabel.textColor = kRGBA(28, 28, 28, 1);
        _workLocationLabel.font = SystemFont(13);
    }
    return _workLocationLabel;
}
- (UILabel *)workLocationMessage {
    if (!_workLocationMessage) {
        _workLocationMessage = [[UILabel alloc] init];
        _workLocationMessage.textAlignment = NSTextAlignmentLeft;
        [_workLocationMessage sizeToFit];
        _workLocationMessage.numberOfLines = 0;
        _workLocationMessage.textColor = kMainLightGray;
        _workLocationMessage.font = SystemFont(13);
    }
    return _workLocationMessage;
}

// 左滑视图
- (UIView *)swipeView {
    if (!_swipeView) {
        _swipeView = [[UIView alloc] init];
        _swipeView.backgroundColor = kWhiteColor;
        _swipeView.layer.cornerRadius = 5;
        _swipeView.layer.masksToBounds = NO;
        _swipeView.layer.shadowOffset = CGSizeMake(0, 0);
        _swipeView.layer.shadowRadius = 3;
        _swipeView.layer.shadowColor = kMainLightGray.CGColor;
        _swipeView.layer.shadowOpacity = 0.5;
    }
    return _swipeView;
}

- (UILabel *)swipeTitleLabel {
    if (!_swipeTitleLabel) {
        _swipeTitleLabel = [[UILabel alloc] init];
        _swipeTitleLabel.textAlignment = NSTextAlignmentCenter;
        _swipeTitleLabel.textColor = kRGBA(28, 28, 28, 1);
        _swipeTitleLabel.font = SystemFont(16);
        _swipeTitleLabel.text = @"删除";
    }
    return _swipeTitleLabel;
}

- (UIButton *)foldLocationsButton {
    if (!_foldLocationsButton) {
        _foldLocationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _foldLocationsButton.backgroundColor = kWhiteColor;
        _foldLocationsButton.layer.cornerRadius = 5;
        [_foldLocationsButton setImage:ImageName(@"apply_dropdown") forState:UIControlStateNormal];
        [_foldLocationsButton setImage:ImageName(@"apply_dropdown") forState:UIControlStateHighlighted];
        [_foldLocationsButton setImage:ImageName(@"apply_toppull") forState:UIControlStateSelected];
        _foldLocationsButton.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _foldLocationsButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
