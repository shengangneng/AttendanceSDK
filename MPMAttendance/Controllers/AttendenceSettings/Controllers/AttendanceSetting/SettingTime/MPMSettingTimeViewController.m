//
//  MPMSettingTimeViewController.m
//  MPMAtendence
//  设置时间段
//  Created by shengangneng on 2018/5/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSettingTimeViewController.h"
#import "MPMButton.h"
#import "MPMTableHeaderView.h"
#import "MPMSettingSwitchTableViewCell.h"
#import "MPMShareUser.h"
#import "MPMHTTPSessionManager.h"
#import "MPMSettingTimeModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMCustomDatePickerView.h"
#import "NSString+MPMAttention.h"
#import "MPMBaseTableViewCell.h"
#import "MPMSettingClassListModel.h"
#import "MPMOauthUser.h"
#import "MPMSessionManager.h"

@interface MPMSettingTimeViewController () <UITableViewDataSource, UITableViewDelegate, MPMSettingSwitchTableViewCellSwitchDelegate, UITextFieldDelegate>
// header
@property (nonatomic, strong) UIView *headerNameView;
@property (nonatomic, strong) UILabel *headerNameLabel;
@property (nonatomic, strong) UITextField *headerNameTextField;
@property (nonatomic, strong) UIView *headerButtonView;
@property (nonatomic, strong) UIButton *headerOneButton;
@property (nonatomic, strong) UIButton *headerTwoButton;
@property (nonatomic, strong) UIButton *headerTreButton;
@property (nonatomic, strong) UIView *seperateLine;
@property (nonatomic, strong) UIView *seperateLine2;
// table
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MPMTableHeaderView *footer;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSaveButton;
// picker
@property (nonatomic, strong) MPMCustomDatePickerView *customDatePickerView;
// data
@property (nonatomic, copy) NSArray *titlesArray;   /** 标题数组 */
@property (nonatomic, copy) NSArray<MPMSettingTimeModel *> *signTimeSections;   /** 签到签退时间数组 */
@property (nonatomic, strong) MPMSettingTimeModel *freeTimeSection;             /** 间休 */

@property (nonatomic, assign) DulingType dulingType;
@property (nonatomic, assign) BOOL switchOn;
@property (nonatomic, strong) UIButton *preSelectedButton;/** 记录上一个点击的按钮 */
@property (nonatomic, copy) NSString *resetTime;
@property (nonatomic, strong) NSDate *preSelectDate;      /** 记录上一次选中的时间，作为再次弹出pickerView的默认时间 */
@property (nonatomic, strong) MPMSettingClassListModel *model;

@end

@implementation MPMSettingTimeViewController

- (instancetype)initWithModel:(MPMSettingClassListModel *)model dulingType:(DulingType)dulingType resetTime:(NSString *)resetTime {
    self = [super init];
    if (self) {
        self.model = model;
        if (self.model) {
            self.headerNameTextField.text = self.model.schedule.name;
            NSArray *arr = self.model.schedule.signTimeSections;
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
            if (arr.count == 0) {
                [self button:self.headerOneButton];
            } else if (arr.count == 1) {
                if (self.model.schedule.freeTimeSection && [self.model.schedule.freeTimeSection isKindOfClass:[NSDictionary class]]) {
                    // 如果为一段式，且有间休时间段，才赋值
                    self.switchOn = YES;
                }
                [self button:self.headerOneButton];
            } else if (arr.count == 2) {
                [self button:self.headerTwoButton];
            } else if (arr.count == 3) {
                [self button:self.headerTreButton];
            }
            for (int i = 0; i < 3; i++) {
                MPMSettingTimeModel *mo;
                if (arr.count > i) {
                    NSDictionary *dic = arr[i];
                    mo = [[MPMSettingTimeModel alloc] initWithDictionary:dic];
                    DLog(@"%.f===%.f",[NSDateFormatter getZeroWithTimeInterverl:mo.signTime.integerValue/1000],[NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970]);
                    DLog(@"%.f===%.f",[NSDateFormatter getZeroWithTimeInterverl:mo.returnTime.integerValue/1000],[NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970]);
                    NSTimeInterval signTimeZero = [NSDateFormatter getZeroWithTimeInterverl:mo.signTime.doubleValue/1000];
                    NSTimeInterval returnTimeZero = [NSDateFormatter getZeroWithTimeInterverl:mo.returnTime.doubleValue/1000];
                    NSTimeInterval currentTimeZero = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                    
                    mo.signTime = [NSString stringWithFormat:@"%.f",(mo.signTime.doubleValue/1000 - signTimeZero + currentTimeZero)*1000];
                    mo.returnTime = [NSString stringWithFormat:@"%.f",(mo.returnTime.doubleValue/1000 - returnTimeZero + currentTimeZero)*1000];
                    mo.signTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:((NSString *)mo.signTime).doubleValue/1000+28800] withDefineFormatterType:forDateFormatTypeSpecial];
                    mo.returnTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:((NSString *)mo.returnTime).doubleValue/1000+28800] withDefineFormatterType:forDateFormatTypeSpecial];
                } else {
                    mo = [[MPMSettingTimeModel alloc] init];
                }
                [temp addObject:mo];
            }
            self.signTimeSections = temp.copy;
        } else {
            // 如果没有model，需要新建一个model，在保存的时候
            self.signTimeSections = @[[[MPMSettingTimeModel alloc] init],[[MPMSettingTimeModel alloc] init],[[MPMSettingTimeModel alloc] init]];
            [self button:self.headerOneButton];
        }
        
        if (self.model.schedule.freeTimeSection && [self.model.schedule.freeTimeSection isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = self.model.schedule.freeTimeSection;
            NSString *start = [dic[@"start"] isKindOfClass:[NSNull class]] ? @"" : kNumberSafeString(dic[@"start"]);
            NSString *end = [dic[@"end"] isKindOfClass:[NSNull class]] ? @"" : kNumberSafeString(dic[@"end"]);
            NSTimeInterval startTimeZero = [NSDateFormatter getZeroWithTimeInterverl:start.doubleValue/1000];
            NSTimeInterval endTimeZero = [NSDateFormatter getZeroWithTimeInterverl:end.doubleValue/1000];
            NSTimeInterval currentTimeZero = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
            self.freeTimeSection = [[MPMSettingTimeModel alloc] initWithDictionary:dic];
            if (!kIsNilString(start)) {
                self.freeTimeSection.signTime = [NSString stringWithFormat:@"%.f",(start.doubleValue/1000 - startTimeZero + currentTimeZero)*1000];
                self.freeTimeSection.noonBreakStartTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:(start).doubleValue/1000+28800] withDefineFormatterType:forDateFormatTypeSpecial];
            }
            if (!kIsNilString(end)) {
                self.freeTimeSection.returnTime = [NSString stringWithFormat:@"%.f",(end.doubleValue/1000 - endTimeZero + currentTimeZero)*1000];
                self.freeTimeSection.noonBreakEndTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:(end).doubleValue/1000+28800] withDefineFormatterType:forDateFormatTypeSpecial];
            }
        } else {
            self.freeTimeSection = [[MPMSettingTimeModel alloc] init];
        }
        self.dulingType = dulingType;
        self.resetTime = resetTime;
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"时间段设置";
    [self.headerOneButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerTwoButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerTreButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.bottomSaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    // header
    [self.view addSubview:self.headerNameView];
    [self.headerNameView addSubview:self.headerNameLabel];
    [self.headerNameView addSubview:self.headerNameTextField];
    [self.view addSubview:self.seperateLine];
    [self.view addSubview:self.headerButtonView];
    [self.headerButtonView addSubview:self.headerOneButton];
    [self.headerButtonView addSubview:self.headerTwoButton];
    [self.headerButtonView addSubview:self.headerTreButton];
    // table
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.seperateLine2];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomSaveButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    // header
    [self.headerNameView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.equalTo(@(kTableViewHeight));
    }];
    [self.headerNameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerNameView.mpm_leading).offset(15);
        make.width.equalTo(@80);
        make.top.bottom.equalTo(self.headerNameView);
    }];
    [self.headerNameTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self.headerNameView);
        make.trailing.equalTo(self.headerNameView.mpm_trailing).offset(-10);
        make.leading.equalTo(self.headerNameLabel.mpm_trailing).offset(10);
    }];
    [self.seperateLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerNameView.mpm_bottom);
        make.bottom.equalTo(self.headerButtonView.mpm_top);
    }];
    [self.seperateLine2 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerButtonView.mpm_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [self.headerButtonView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerNameView.mpm_bottom).offset(10);
        make.height.equalTo(@55);
    }];
    [self.headerOneButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerButtonView.mpm_leading).offset(8);
        make.trailing.equalTo(self.headerTwoButton.mpm_leading).offset(-8);
        make.top.equalTo(self.headerButtonView.mpm_top).offset(7.5);
        make.bottom.equalTo(self.headerButtonView.mpm_bottom).offset(-7.5);
    }];
    [self.headerTwoButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.headerTreButton.mpm_leading).offset(-8);
        make.width.equalTo(self.headerOneButton.mpm_width);
        make.top.equalTo(self.headerButtonView.mpm_top).offset(7.5);
        make.bottom.equalTo(self.headerButtonView.mpm_bottom).offset(-7.5);
    }];
    [self.headerTreButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.headerButtonView.mpm_trailing).offset(-8);
        make.width.equalTo(self.headerOneButton.mpm_width);
        make.top.equalTo(self.headerButtonView.mpm_top).offset(7.5);
        make.bottom.equalTo(self.headerButtonView.mpm_bottom).offset(-7.5);
    }];
    
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.headerButtonView.mpm_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@1);
    }];
    [self.bottomSaveButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(12);
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
}

#pragma mark - Private Method
// 通过点击头部的按钮来获取中间TableView的title
- (NSArray *)getTitlesArrayWithCount:(NSInteger)count {
    switch (count) {
        case 0: {
            if (self.switchOn) {
                return @[@[@"签到",@"签退"],@[@"启动时间",@"间休开始",@"间休结束"]];
            } else {
                return @[@[@"签到",@"签退"],@[@"启动时间"]];
            }
        }break;
        case 1: {
            return @[@[@"签到",@"签退"],@[@"签到",@"签退"]];
        }break;
        case 2: {
            return @[@[@"签到",@"签退"],@[@"签到",@"签退"],@[@"签到",@"签退"]];
        }break;
        default:
            return @[@[@"签到",@"签退"],@[@"启动时间"]];
            break;
    }
}

/** isUsed为空、isUsed为“0”则isUpdate为@"0"，isUsed不为空，且选择了“修改”，则isUpdate为@"1" isEffective：0生效 1生效*/
- (void)saveTimeSectionsWithisUpdate:(NSString *)isUpdate isElective:(NSString *)isElective {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = kSafeString(self.model.mpm_id);
    params[@"isUpdate"] = isUpdate;
    if ([isElective isEqualToString:@"1"]) {
        params[@"isElective"] = isElective;
    }
    NSMutableDictionary *schedule = [NSMutableDictionary dictionary];
    
    schedule[@"name"] = self.headerNameTextField.text;
    
    if (self.switchOn && self.headerOneButton.isSelected) {
        NSDictionary *freeTimeSection = @{@"start":kSafeString(self.freeTimeSection.signTime),
                                          @"end":kSafeString(self.freeTimeSection.returnTime)};
        schedule[@"freeTimeSection"] = freeTimeSection;
    }
    NSInteger count = self.headerOneButton.isSelected ? 1 : (self.headerTwoButton.isSelected ? 2 : 3);
    NSMutableArray *signTimeSections = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MPMSettingTimeModel *model = self.signTimeSections[i];
        NSDictionary *dic = @{@"corssReturnDay":kSafeString(model.corssReturnDay),
                              @"corssStartDay":kSafeString(model.corssStartDay),
                              @"returnTime":kSafeString(model.returnTime),
                              @"signTime":kSafeString(model.signTime)
                              };
        [signTimeSections addObject:dic];
    }
    schedule[@"signTimeSections"] = signTimeSections;
    NSString *hour = [NSString stringWithFormat:@"%.1f",[self getDuration].doubleValue / 60];
    schedule[@"hour"] = hour;
    params[@"schedule"] = schedule;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SETTING_TIME_SAVE];
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在保存" success:^(id response) {
        DLog(@"%@",response);
        if (response && ((NSString *)response[kResponseDataKey][@"code"]).integerValue == 200) {
            NSString *message = kDulingTypeCreate == self.dulingType ? @"新增成功" : @"修改成功";
            __weak typeof(self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:message sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself.navigationController popViewControllerAnimated:YES];
            } needCancleButton:NO];
            [self.navigationController popViewControllerAnimated:YES];
        } else if (response && ((NSString *)response[kResponseDataKey][@"code"]).integerValue == 204) {
            NSString *message = response[kResponseDataKey][@"message"];
            __weak typeof(self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:message sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself saveTimeSectionsWithisUpdate:@"1" isElective:@"1"];
            } sureActionTitle:@"立即生效" needCancleButton:YES];
        } else {
            [MPMProgressHUD showErrorWithStatus:@"操作失败"];
        }
        // 无论是设置还是创建，成功后，都跳回上一页
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (NSString *)getDetailTextWithIndexPath:(NSIndexPath *)indexPath {
    if (self.headerOneButton.selected) {
        if (self.switchOn) {
            if (self.signTimeSections.count == 0) {
                return @"请选择";
            } else {
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        if (indexPath.row == 1) {
                            if (kIsNilString(self.freeTimeSection.signTime)) {
                                return @"请选择";
                            } else {
                                NSString *time = self.freeTimeSection.signTime;
                                return time;
                            }
                        } else if (indexPath.row == 2) {
                            if (kIsNilString(self.freeTimeSection.returnTime)) {
                                return @"请选择";
                            } else {
                                NSString *time = self.freeTimeSection.returnTime;
                                return time;
                            }
                        }
                    }break;
                    default:
                        break;
                }
            }
        }
        switch (self.signTimeSections.count) {
            case 0:{
                return @"请选择";
            }break;
            case 1:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        return @"请选择";
                    }break;
                    default:
                        break;
                }
            }break;
            case 2:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        return @"请选择";
                    }break;
                    default:
                        break;
                }
            }break;
            case 3:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        return @"请选择";
                    }break;
                    default:
                        break;
                }
            }break;
            default:
                break;
        }
    } else if (self.headerTwoButton.selected) {
        switch (self.signTimeSections.count) {
            case 0:{
                return @"请选择";
            }break;
            case 1:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        return @"请选择";
                    }break;
                    default:
                        break;
                }
            }break;
            case 2:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    default:
                        break;
                }
            }break;
            case 3:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    default:
                        break;
                }
            }break;
            default:
                break;
        }
    } else {
        switch (self.signTimeSections.count) {
            case 0:{
                return @"请选择";
            }break;
            case 1:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        return @"请选择";
                    }break;
                    case 2:{
                        return @"请选择";
                    }break;
                    default:
                        break;
                }
            }break;
            case 2:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 2:{
                        return @"请选择";
                    }break;
                    default:
                        break;
                }
            }break;
            case 3:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    case 2:{
                        MPMSettingTimeModel *model = self.signTimeSections[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return time;
                    }break;
                    default:
                        break;
                }
            }break;
            default:
                break;
        }
    }
    return @"请选择";
}

/** 计算时长 */
- (NSString *)getDuration {
    if (self.headerOneButton.selected) {        // 一天一次班次
        if (self.switchOn) {
            NSString *sectionOneDuration;
            NSString *sectionTwoDuration;
            if (!kIsNilString(self.signTimeSections.firstObject.signTime) && !kIsNilString(self.signTimeSections.firstObject.returnTime)) {
                if (self.signTimeSections.firstObject.signTime.timeValue <= self.signTimeSections.firstObject.returnTime.timeValue) {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue)];
                } else {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
                }
            }
            if (!kIsNilString(self.freeTimeSection.signTime) && !kIsNilString(self.freeTimeSection.returnTime)) {
                if (self.freeTimeSection.signTime.timeValue <= self.freeTimeSection.returnTime.timeValue) {
                    sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.freeTimeSection.returnTime.hourMinuteToString.timeValue - self.freeTimeSection.signTime.hourMinuteToString.timeValue)];
                } else {
                    sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.freeTimeSection.returnTime.hourMinuteToString.timeValue - self.freeTimeSection.signTime.hourMinuteToString.timeValue + 1440)];
                }
            }
            if (!kIsNilString(sectionOneDuration) && !kIsNilString(sectionTwoDuration)) {
                return [NSString stringWithFormat:@"%.f",(sectionOneDuration.doubleValue - sectionTwoDuration.doubleValue)];
            } else if (!kIsNilString(sectionOneDuration)) {
                return [NSString stringWithFormat:@"%.f",sectionOneDuration.doubleValue];
            } else if (!kIsNilString(sectionTwoDuration)) {
                return [NSString stringWithFormat:@"%.f",sectionTwoDuration.doubleValue];
            } else {
                return @"0";
            }
            
        } else {
            NSString *sectionOneDuration;
            if (!kIsNilString(self.signTimeSections.firstObject.signTime) && !kIsNilString(self.signTimeSections.firstObject.returnTime)) {
                if (self.signTimeSections.firstObject.signTime.timeValue <= self.signTimeSections.firstObject.returnTime.timeValue) {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue)];
                } else {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
                }
            }
            if (!kIsNilString(sectionOneDuration)) {
                return sectionOneDuration;
            } else {
                return @"0";
            }
        }
        
        
    } else if (self.headerTwoButton.selected) {
        
        NSString *sectionOneDuration;
        NSString *sectionTwoDuration;
        if (!kIsNilString(self.signTimeSections.firstObject.signTime) && !kIsNilString(self.signTimeSections.firstObject.returnTime)) {
            if (self.signTimeSections.firstObject.signTime.timeValue <= self.signTimeSections.firstObject.returnTime.timeValue) {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue)];
            } else {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        
        if (!kIsNilString(self.signTimeSections[1].signTime) && !kIsNilString(self.signTimeSections[1].returnTime)) {
            if (self.signTimeSections[1].signTime.timeValue <= self.signTimeSections[1].returnTime.timeValue) {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections[1].returnTime.hourMinuteToString.timeValue - self.signTimeSections[1].signTime.hourMinuteToString.timeValue)];
            } else {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections[1].returnTime.hourMinuteToString.timeValue - self.signTimeSections[1].signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        
        if (kIsNilString(sectionOneDuration) && kIsNilString(sectionTwoDuration)) {
            return @"0";
        } else {
            return [NSString stringWithFormat:@"%.f",((kIsNilString(sectionOneDuration) ? 0 : sectionOneDuration.doubleValue) + (kIsNilString(sectionTwoDuration) ? 0 : sectionTwoDuration.doubleValue))];
        }
        
    } else {
        NSString *sectionOneDuration;
        NSString *sectionTwoDuration;
        NSString *sectionTreDuration;
        if (!kIsNilString(self.signTimeSections.firstObject.signTime) && !kIsNilString(self.signTimeSections.firstObject.returnTime)) {
            if (self.signTimeSections.firstObject.signTime.timeValue <= self.signTimeSections.firstObject.returnTime.timeValue) {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue)];
            } else {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections.firstObject.returnTime.hourMinuteToString.timeValue - self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        
        if (!kIsNilString(self.signTimeSections[1].signTime) && !kIsNilString(self.signTimeSections[1].returnTime)) {
            if (self.signTimeSections[1].signTime.timeValue <= self.signTimeSections[1].returnTime.timeValue) {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections[1].returnTime.hourMinuteToString.timeValue - self.signTimeSections[1].signTime.hourMinuteToString.timeValue)];
            } else {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections[1].returnTime.hourMinuteToString.timeValue - self.signTimeSections[1].signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        if (!kIsNilString(self.signTimeSections[2].signTime) && !kIsNilString(self.signTimeSections[2].returnTime)) {
            if (self.signTimeSections[2].signTime.timeValue <= self.signTimeSections[2].returnTime.timeValue) {
                sectionTreDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections[2].returnTime.hourMinuteToString.timeValue - self.signTimeSections[2].signTime.hourMinuteToString.timeValue)];
            } else {
                sectionTreDuration = [NSString stringWithFormat:@"%.f",(self.signTimeSections[2].returnTime.hourMinuteToString.timeValue - self.signTimeSections[2].signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        
        if (kIsNilString(sectionOneDuration) && kIsNilString(sectionTwoDuration) && kIsNilString(sectionTreDuration)) {
            return @"0";
        } else {
            return [NSString stringWithFormat:@"%.f",((kIsNilString(sectionOneDuration) ? 0 : sectionOneDuration.doubleValue) + (kIsNilString(sectionTwoDuration) ? 0 : sectionTwoDuration.doubleValue) + (kIsNilString(sectionTreDuration) ? 0 : sectionTreDuration.doubleValue))];
        }
    }
}

#pragma mark - Target Action
// 顶部三个按钮：tag分别为1、2、3
- (void)button:(UIButton *)sender {
    if (self.preSelectedButton && self.preSelectedButton == sender) {
        return;
    }
    self.preSelectedButton.selected = NO;
    sender.selected = YES;
    self.preSelectedButton = sender;
    self.titlesArray = [self getTitlesArrayWithCount:sender.tag - 1];
    [self.tableView reloadData];
}
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(UIButton *)sender {
    //    NSMutableArray *params = [NSMutableArray array];
    // 检查输入内容
    if (kIsNilString(self.headerNameTextField.text)) {
        [self showAlertControllerToLogoutWithMessage:@"请输入班次名称" sureAction:nil needCancleButton:NO];return;
    } else if (self.headerNameTextField.text.length > 10) {
        [self showAlertControllerToLogoutWithMessage:@"班次名称不能超过10个字" sureAction:nil needCancleButton:NO];return;
    }
    
    if (self.preSelectedButton == self.headerOneButton) {
        if (self.signTimeSections.count < 1 || kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[0]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[0]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.switchOn && kIsNilString(self.freeTimeSection.signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择间休开始时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.switchOn && kIsNilString(self.freeTimeSection.returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择间休结束时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.switchOn) {
            // noonBreakEndTime、noonBreakStartTime、returnTime、signTime、schedulingId
            double noonBreakEndTime = self.freeTimeSection.returnTime.hourMinuteToString.timeValue;
            double noonBreakStartTime = self.freeTimeSection.signTime.hourMinuteToString.timeValue;
            double returnTime = self.signTimeSections[0].returnTime.hourMinuteToString.timeValue;
            double signTime = self.signTimeSections[0].signTime.hourMinuteToString.timeValue;
            if (noonBreakEndTime == noonBreakStartTime ||
                noonBreakEndTime == returnTime ||
                noonBreakEndTime == signTime ||
                
                noonBreakStartTime == returnTime ||
                noonBreakStartTime == signTime ||
                
                returnTime == signTime) {
                [self showAlertControllerToLogoutWithMessage:@"所选时间不能交错" sureAction:nil needCancleButton:NO];return;
            }
            if (returnTime > signTime) {
                // 非跨天
                if (noonBreakStartTime > noonBreakEndTime) {
                    [self showAlertControllerToLogoutWithMessage:@"间休时间不正确" sureAction:nil needCancleButton:NO];return;
                }
                if (noonBreakStartTime < signTime) {
                    [self showAlertControllerToLogoutWithMessage:@"间休开始时间必须大于签到时间" sureAction:nil needCancleButton:NO];return;
                }
                if (noonBreakEndTime > returnTime) {
                    [self showAlertControllerToLogoutWithMessage:@"间休结束时间必须小于签退时间" sureAction:nil needCancleButton:NO];return;
                }
            } else {
                // 跨天:
                if (noonBreakStartTime < signTime && noonBreakStartTime > returnTime) {
                    [self showAlertControllerToLogoutWithMessage:@"间休开始时间在签到时间之间" sureAction:nil needCancleButton:NO];return;
                }
                if (noonBreakEndTime < signTime && noonBreakEndTime > returnTime) {
                    [self showAlertControllerToLogoutWithMessage:@"间休结束时间在签到时间之间" sureAction:nil needCancleButton:NO];return;
                }
                if (noonBreakStartTime > signTime && noonBreakEndTime > signTime && noonBreakStartTime > noonBreakEndTime) {
                    [self showAlertControllerToLogoutWithMessage:@"间休开始时间在不能大于间休结束时间" sureAction:nil needCancleButton:NO];return;
                }
                if (noonBreakStartTime < returnTime && noonBreakEndTime < returnTime && noonBreakStartTime > noonBreakEndTime) {
                    [self showAlertControllerToLogoutWithMessage:@"间休开始时间在不能大于间休结束时间" sureAction:nil needCancleButton:NO];return;
                }
            }
            // 赋值跨天
            self.signTimeSections[0].corssStartDay = @"0";
            if (signTime > returnTime) {
                [self showAlertControllerToLogoutWithMessage:@"目前时间段设置暂不支持跨天" sureAction:nil needCancleButton:NO];return;
                self.signTimeSections[0].corssReturnDay = @"1";
            } else {
                self.signTimeSections[0].corssReturnDay = @"0";
            }
        } else {
            double returnTime =  self.signTimeSections[0].returnTime.hourMinuteToString.timeValue;
            double signTime = self.signTimeSections[0].signTime.hourMinuteToString.timeValue;
            if (returnTime == signTime) {
                [self showAlertControllerToLogoutWithMessage:@"开始时间不能等于结束时间" sureAction:nil needCancleButton:NO];return;
            }
            // 赋值跨天
            self.signTimeSections[0].corssStartDay = @"0";
            if (signTime > returnTime) {
                [self showAlertControllerToLogoutWithMessage:@"目前时间段设置暂不支持跨天" sureAction:nil needCancleButton:NO];return;
                self.signTimeSections[0].corssReturnDay = @"1";
            } else {
                self.signTimeSections[0].corssReturnDay = @"0";
            }
            //            [params addObject:@{@"returnTime":self.signTimeSections[0].returnTime,@"signTime":self.signTimeSections[0].signTime,@"noonBreak":@"0",@"crossDay":crossDay}];
        }
    } else if (self.preSelectedButton == self.headerTwoButton) {
        if (self.signTimeSections.count < 1 || kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[0]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[0]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.signTimeSections.count < 2 || kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[1]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[1]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签退时间" sureAction:nil needCancleButton:NO];return;
        }
        
        if ([self getDuration].doubleValue > 1440) {
            [self showAlertControllerToLogoutWithMessage:@"工作时间不能超过一天" sureAction:nil needCancleButton:NO];return;
        }
        
        double signTime0 = self.signTimeSections[0].signTime.hourMinuteToString.timeValue;
        double returnTime0 = self.signTimeSections[0].returnTime.hourMinuteToString.timeValue;
        double signTime1 = self.signTimeSections[1].signTime.hourMinuteToString.timeValue;
        double returnTime1 = self.signTimeSections[1].returnTime.hourMinuteToString.timeValue;
        
        if (signTime0 == returnTime0 ||
            signTime0 == signTime1 ||
            signTime0 == returnTime1 ||
            
            returnTime0 == signTime1 ||
            returnTime0 == returnTime1 ||
            
            signTime1 == returnTime1) {
            [self showAlertControllerToLogoutWithMessage:@"所选时间不能交错" sureAction:nil needCancleButton:NO];return;
        }
        
        
        if (signTime0 < returnTime0) {
            // 第一段是正序没跨天：第二第三段不能在第一段之间
            if ((signTime1 >= signTime0 && signTime1 <= returnTime0) ||
                (returnTime1 >= signTime0 && returnTime1 <= returnTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
            double duration1;
            if (signTime1 > returnTime0) {
                duration1 = signTime1 - returnTime0;
            } else {
                duration1 = signTime1 - returnTime0 + @"24:00".timeValue;
            }
            
            if ((duration1) + [self getDuration].doubleValue > 1440) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
        } else {
            // 第一段已经跨天了（第二第三段不能再跨天）
            if (!(signTime1 > returnTime0 && signTime1 < signTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"第二段开始时间有误" sureAction:nil needCancleButton:NO];return;
            }
            if (!(returnTime1 > returnTime0 && returnTime1 < signTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"第二段结束时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
            // 第二段第三段的签到和签退时间都必须在大于第一段的签退和小于第一段的签到
            if (!((signTime1 > returnTime0) && (signTime1 < signTime0)) || !((returnTime1 > returnTime0) && (returnTime1 < signTime0))) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
            if (!(signTime1 > returnTime0) || !(returnTime1 > returnTime0) || !(returnTime1 > signTime1)) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
        }
        
        for (int i = 0; i < 2; i++) {
            NSString *returnTime =  self.signTimeSections[i].returnTime;
            NSString *signTime = self.signTimeSections[i].signTime;
            if (signTime.hourMinuteToString.timeValue < signTime0) {
                self.signTimeSections[i].corssStartDay = @"1";
            } else {
                self.signTimeSections[i].corssStartDay = @"0";
            }
            if (returnTime.hourMinuteToString.timeValue < returnTime0) {
                [self showAlertControllerToLogoutWithMessage:@"目前时间段设置暂不支持跨天" sureAction:nil needCancleButton:NO];return;
                self.signTimeSections[i].corssReturnDay = @"1";
            } else {
                self.signTimeSections[i].corssReturnDay = @"0";
            }
        }
    } else if (self.preSelectedButton == self.headerTreButton) {
        if (self.signTimeSections.count < 1 || kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[0]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[0]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.signTimeSections.count < 2 || kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[1]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[1]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.signTimeSections.count < 3 || kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[2]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.signTimeSections[2]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if ([self getDuration].doubleValue > 1440) {
            [self showAlertControllerToLogoutWithMessage:@"工作时间不能超过一天" sureAction:nil needCancleButton:NO];return;
        }
        double signTime0 = self.signTimeSections[0].signTime.hourMinuteToString.timeValue;
        double returnTime0 = self.signTimeSections[0].returnTime.hourMinuteToString.timeValue;
        double signTime1 = self.signTimeSections[1].signTime.hourMinuteToString.timeValue;
        double returnTime1 = self.signTimeSections[1].returnTime.hourMinuteToString.timeValue;
        double signTime2 = self.signTimeSections[2].signTime.hourMinuteToString.timeValue;
        double returnTime2 = self.signTimeSections[2].returnTime.hourMinuteToString.timeValue;
        
        if (signTime0 == returnTime0 ||
            signTime0 == signTime1 ||
            signTime0 == returnTime1 ||
            signTime0 == signTime2 ||
            signTime0 == returnTime2 ||
            
            returnTime0 == signTime1 ||
            returnTime0 == returnTime1 ||
            returnTime0 == signTime2 ||
            returnTime0 == returnTime2 ||
            
            signTime1 == returnTime1 ||
            signTime1 == signTime2 ||
            signTime1 == returnTime2 ||
            
            returnTime1 == signTime2 ||
            returnTime1 == returnTime2 ||
            
            signTime2 == returnTime2) {
            [self showAlertControllerToLogoutWithMessage:@"所选时间不能交错" sureAction:nil needCancleButton:NO];return;
        }
        
        
        if (signTime0 < returnTime0) {
            // 第一段是正序没跨天：第二第三段不能在第一段之间
            if ((signTime1 >= signTime0 && signTime1 <= returnTime0) ||
                (returnTime1 >= signTime0 && returnTime1 <= returnTime0) ||
                (signTime2 >= signTime0 && signTime2 <= returnTime0) ||
                (returnTime2 >= signTime0 && returnTime2 <= returnTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
            double duration1;
            double duration2;
            if (signTime1 > returnTime0) {
                duration1 = signTime1 - returnTime0;
            } else {
                duration1 = signTime1 - returnTime0 + @"24:00".timeValue;
            }
            if (signTime2 > returnTime1) {
                duration2 = signTime2 - returnTime1;
            } else {
                duration2 = signTime2 - returnTime1 + @"24:00".timeValue;
            }
            
            if ((duration1 + duration2) + [self getDuration].doubleValue > 1440) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
        } else {
            // 第一段已经跨天了（第二第三段不能再跨天）
            if (!(signTime1 > returnTime0 && signTime1 < signTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"第二段开始时间有误" sureAction:nil needCancleButton:NO];return;
            }
            if (!(returnTime1 > returnTime0 && returnTime1 < signTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"第二段结束时间有误" sureAction:nil needCancleButton:NO];return;
            }
            if (!(signTime2 > returnTime0 && signTime2 < signTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"第三段开始时间有误" sureAction:nil needCancleButton:NO];return;
            }
            if (!(returnTime2 > returnTime0 && returnTime2 < signTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"第三段结束时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
            // 第二段第三段的签到和签退时间都必须在大于第一段的签退和小于第一段的签到
            if (!((signTime1 > returnTime0) && (signTime1 < signTime0)) || !((signTime2 > returnTime0) && (signTime2 < signTime0)) || !((returnTime1 > returnTime0) && (returnTime1 < signTime0)) || !((returnTime2 > returnTime0) && (returnTime2 < signTime0))) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
            
            if (!(signTime1 > returnTime0) || !(returnTime1 > returnTime0) || !(returnTime1 > signTime1) || !(signTime2 > returnTime0) || !(signTime2 > signTime1) || !(signTime2 > returnTime1) || !(returnTime2 > returnTime0) || !(returnTime2 > signTime1) || !(returnTime2 > returnTime1) || !(returnTime2 > signTime2) || !(returnTime2 < signTime0)) {
                [self showAlertControllerToLogoutWithMessage:@"选择时间有误" sureAction:nil needCancleButton:NO];return;
            }
        }
        
        for (int i = 0; i < 3; i++) {
            NSString *returnTime =  self.signTimeSections[i].returnTime;
            NSString *signTime = self.signTimeSections[i].signTime;
            if (signTime.hourMinuteToString.timeValue < signTime0) {
                self.signTimeSections[i].corssStartDay = @"1";
            } else {
                self.signTimeSections[i].corssStartDay = @"0";
            }
            if (returnTime.hourMinuteToString.timeValue < returnTime0) {
                [self showAlertControllerToLogoutWithMessage:@"目前时间段设置暂不支持跨天" sureAction:nil needCancleButton:NO];return;
                self.signTimeSections[i].corssReturnDay = @"1";
            } else {
                self.signTimeSections[i].corssReturnDay = @"0";
            }
        }
    }
    
    [self saveTimeSectionsWithisUpdate:@"1" isElective:@"0"];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.headerNameTextField resignFirstResponder];
    return YES;
}

#pragma mark - MPMSettingThreeTimeTableViewCellButtonDelegate
- (void)settingSwithChange:(UISwitch *)sw {
    // 点击了“启动间休”switch
    self.switchOn = sw.isOn;
    self.titlesArray = [self getTitlesArrayWithCount:self.preSelectedButton.tag - 1];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.titlesArray[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.titlesArray.count - 1) {
        return 30;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.titlesArray.count - 1) {
        return self.footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.headerOneButton.selected && indexPath.section == 1 && indexPath.row == 0) {
        static NSString *cellIdentifier = @"switchCell";
        MPMSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMSettingSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.switchDelegate = self;
        }
        cell.textLabel.text = @"启动间休";
        [cell.startNonSwitch setOn:self.switchOn];
        return cell;
    } else {
        static NSString *cellIdentifier = @"commomCell";
        MPMBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSInteger section = (self.headerOneButton.selected && self.switchOn && indexPath.section > 0) ? 0 : indexPath.section;
        MPMSettingTimeModel *model = self.signTimeSections[section];
        if (!cell) {
            cell = [[MPMBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
        NSString *detail;
        
        if (self.headerOneButton.selected) {        // 一天一次上下班
            switch (indexPath.section) {
                case 0:{
                    switch (indexPath.row) {
                        case 0:{
                            detail = kIsNilString(model.signTime) ? @"请选择" : [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                        }break;
                        case 1:{
                            if (kIsNilString(model.returnTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(model.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (model.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        default:
                            break;
                    }
                }break;
                case 1:{
                    switch (indexPath.row) {
                        case 1:{
                            if (kIsNilString(self.freeTimeSection.signTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(model.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.freeTimeSection.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (model.signTime.hourMinuteToString.timeValue > self.freeTimeSection.signTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.freeTimeSection.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.freeTimeSection.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        case 2:{
                            if (kIsNilString(self.freeTimeSection.returnTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(model.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.freeTimeSection.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (model.signTime.hourMinuteToString.timeValue > self.freeTimeSection.returnTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.freeTimeSection.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:self.freeTimeSection.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        default:
                            break;
                    }
                }break;
                default:
                    break;
            }
            
            
        } else if (self.headerTwoButton.selected) {         // 一天两次上下班
            switch (indexPath.section) {
                case 0:{
                    switch (indexPath.row) {
                        case 0:{
                            detail = kIsNilString(model.signTime) ? @"请选择" : [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                        }break;
                        case 1:{
                            if (kIsNilString(model.returnTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(model.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (model.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                            
                        default:
                            break;
                    }
                }break;
                case 1:{
                    switch (indexPath.row) {
                        case 0:{
                            if (kIsNilString(model.signTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(self.signTimeSections.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue > model.signTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        case 1:{
                            if (kIsNilString(model.returnTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(self.signTimeSections.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        default:
                            break;
                    }
                }break;
                default:
                    break;
            }
            
        } else {            // 一天三次班次
            switch (indexPath.section) {
                case 0:{
                    switch (indexPath.row) {
                        case 0:{
                            detail = kIsNilString(model.signTime) ? @"请选择" : [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                        }break;
                        case 1:{
                            if (kIsNilString(model.returnTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(model.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (model.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                            
                        default:
                            break;
                    }
                }break;
                case 1:{
                    switch (indexPath.row) {
                        case 0:{
                            if (kIsNilString(model.signTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(self.signTimeSections.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue > model.signTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        case 1:{
                            if (kIsNilString(model.returnTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(self.signTimeSections.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        default:
                            break;
                    }
                }break;
                case 2:{
                    switch (indexPath.row) {
                        case 0:{
                            if (kIsNilString(model.signTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(self.signTimeSections.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue > model.signTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        case 1:{
                            if (kIsNilString(model.returnTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(self.signTimeSections.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.signTimeSections.firstObject.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        default:
                            break;
                    }
                }break;
                default:
                    break;
            }
        }
        cell.detailTextLabel.text = detail;
        NSString *duration = [self getDuration];
        NSInteger hour = duration.intValue / 60;
        NSInteger minute = duration.intValue % 60;
        self.footer.headerTextLabel.text = [NSString stringWithFormat:@"合计工作时长:%ld小时%ld分钟",hour,minute];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.headerOneButton.selected && indexPath.section == 1 && indexPath.row == 0) {
        // 如果点击了启动间休这一行
        return;
    }
    __weak typeof(self) weakself = self;
    // 筛选时间选择器的默认打开时间
    NSDate *defaultDate;
    NSString *detailText = [self getDetailTextWithIndexPath:indexPath];
    if ([detailText isEqualToString:@"请选择"]) {
        defaultDate = self.preSelectDate ? self.preSelectDate : nil;
    } else {
        defaultDate = [NSDate dateWithTimeIntervalSince1970:detailText.doubleValue/1000];
    }
    
    [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeHourMinute defaultDate:defaultDate];
    self.customDatePickerView.completeBlock = ^(NSDate *date) {
        __strong typeof(weakself) strongself = weakself;
        strongself.preSelectDate = date;
        // cell点击之后
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                MPMSettingTimeModel *model = strongself.signTimeSections[0];
                NSTimeInterval start = date.timeIntervalSince1970;
                NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                model.signTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                model.signTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
            } else if (indexPath.row == 1) {
                MPMSettingTimeModel *model = strongself.signTimeSections[0];
                NSTimeInterval start = date.timeIntervalSince1970;
                NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                model.returnTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                model.returnTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
            }
        } else if (indexPath.section == 1) {
            if (strongself.headerOneButton.selected) {
                if (indexPath.row == 1) {
                    NSTimeInterval start = date.timeIntervalSince1970;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                    strongself.freeTimeSection.signTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                    strongself.freeTimeSection.noonBreakStartTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
                } else if (indexPath.row == 2) {
                    NSTimeInterval start = date.timeIntervalSince1970;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                    strongself.freeTimeSection.returnTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                    strongself.freeTimeSection.noonBreakEndTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
                }
            } else {
                if (indexPath.row == 0) {
                    NSTimeInterval start = date.timeIntervalSince1970;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                    ((MPMSettingTimeModel *)strongself.signTimeSections[1]).signTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                    ((MPMSettingTimeModel *)strongself.signTimeSections[1]).signTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
                } else if (indexPath.row == 1) {
                    NSTimeInterval start = date.timeIntervalSince1970;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                    ((MPMSettingTimeModel *)strongself.signTimeSections[1]).returnTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                    ((MPMSettingTimeModel *)strongself.signTimeSections[1]).returnTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
                }
            }
        } else {
            if (indexPath.row == 0) {
                NSTimeInterval start = date.timeIntervalSince1970;
                NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                ((MPMSettingTimeModel *)strongself.signTimeSections[2]).signTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                ((MPMSettingTimeModel *)strongself.signTimeSections[2]).signTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
            } else if (indexPath.row == 1) {
                NSTimeInterval start = date.timeIntervalSince1970;
                NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                NSTimeInterval now = [NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970];
                ((MPMSettingTimeModel *)strongself.signTimeSections[2]).returnTime = [NSString stringWithFormat:@"%.0f",(now + start - inte)*1000];
                ((MPMSettingTimeModel *)strongself.signTimeSections[2]).returnTimeString = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970-28800] withDefineFormatterType:forDateFormatTypeSpecial];
            }
        }
        [strongself.tableView reloadData];
    };
}

#pragma mark - Lazy Init

// header

- (UIView *)headerNameView {
    if (!_headerNameView) {
        _headerNameView = [[UIView alloc] init];
        _headerNameView.backgroundColor = kWhiteColor;
    }
    return _headerNameView;
}
- (UILabel *)headerNameLabel {
    if (!_headerNameLabel) {
        _headerNameLabel = [[UILabel alloc] init];
        _headerNameLabel.text = @"班次名称";
        [_headerNameLabel sizeToFit];
        _headerNameLabel.font = SystemFont(17);
        _headerNameLabel.textColor = kBlackColor;
        _headerNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _headerNameLabel;
}
- (UITextField *)headerNameTextField {
    if (!_headerNameTextField) {
        _headerNameTextField = [[UITextField alloc] init];
        _headerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _headerNameTextField.delegate = self;
        _headerNameTextField.font = SystemFont(17);
        _headerNameTextField.textColor = kBlackColor;
        _headerNameTextField.returnKeyType = UIReturnKeyDone;
        _headerNameTextField.placeholder = @"请输入班次名称";
        _headerNameTextField.textAlignment = NSTextAlignmentRight;
    }
    return _headerNameTextField;
}

- (UIView *)headerButtonView {
    if (!_headerButtonView) {
        _headerButtonView = [[UIView alloc] init];
        _headerButtonView.backgroundColor = kWhiteColor;
    }
    return _headerButtonView;
}

- (UIButton *)headerOneButton {
    if (!_headerOneButton) {
        _headerOneButton = [MPMButton titleButtonWithTitle:@"1天1次上下班" nTitleColor:kBlackColor hTitleColor:kMainLightGray nBGImage:ImageName(@"setting_unselected") hImage:ImageName(@"setting_selected")];
        [_headerOneButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _headerOneButton.tag = 1;
        _headerOneButton.titleLabel.font = SystemFont(15);
        [_headerOneButton setBackgroundImage:ImageName(@"setting_selected") forState:UIControlStateSelected];
    }
    return _headerOneButton;
}
- (UIButton *)headerTwoButton {
    if (!_headerTwoButton) {
        _headerTwoButton = [MPMButton titleButtonWithTitle:@"1天2次上下班" nTitleColor:kBlackColor hTitleColor:kMainLightGray nBGImage:ImageName(@"setting_unselected") hImage:ImageName(@"setting_selected")];
        [_headerTwoButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _headerTwoButton.tag = 2;
        _headerTwoButton.titleLabel.font = SystemFont(15);
        [_headerTwoButton setBackgroundImage:ImageName(@"setting_selected") forState:UIControlStateSelected];
    }
    return _headerTwoButton;
}
- (UIButton *)headerTreButton {
    if (!_headerTreButton) {
        _headerTreButton = [MPMButton titleButtonWithTitle:@"1天3次上下班" nTitleColor:kBlackColor hTitleColor:kMainLightGray nBGImage:ImageName(@"setting_unselected") hImage:ImageName(@"setting_selected")];
        [_headerTreButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _headerTreButton.tag = 3;
        _headerTreButton.titleLabel.font = SystemFont(15);
        [_headerTreButton setBackgroundImage:ImageName(@"setting_selected") forState:UIControlStateSelected];
    }
    return _headerTreButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorColor:kSeperateColor];
        _tableView.backgroundColor = kTableViewBGColor;
    }
    return _tableView;
}

- (MPMTableHeaderView *)footer {
    if (!_footer) {
        _footer = [[MPMTableHeaderView alloc] init];
        _footer.headerTextLabel.text = @"合计工作时长:0小时";
    }
    return _footer;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kWhiteColor;
    }
    return _bottomView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kSeperateColor;
    }
    return _bottomLine;
}

- (UIButton *)bottomSaveButton {
    if (!_bottomSaveButton) {
        _bottomSaveButton = [MPMButton titleButtonWithTitle:@"保存" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomSaveButton;
}

- (MPMCustomDatePickerView *)customDatePickerView {
    if (!_customDatePickerView) {
        _customDatePickerView = [[MPMCustomDatePickerView alloc] init];
    }
    return _customDatePickerView;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = kTableViewBGColor;
    }
    return _seperateLine;
}
- (UIView *)seperateLine2 {
    if (!_seperateLine2) {
        _seperateLine2 = [[UIView alloc] init];
        _seperateLine2.backgroundColor = kTableViewBGColor;
    }
    return _seperateLine2;
}


@end
