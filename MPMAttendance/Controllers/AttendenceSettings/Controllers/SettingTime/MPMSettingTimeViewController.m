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
#import "MPMSessionManager.h"
#import "MPMSettingTimeModel.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMCustomDatePickerView.h"
#import "NSString+MPMAttention.h"
#import "MPMBaseTableViewCell.h"

@interface MPMSettingTimeViewController () <UITableViewDataSource, UITableViewDelegate, MPMSettingSwitchTableViewCellSwitchDelegate>
// header
@property (nonatomic, strong) UIView *headerButtonView;
@property (nonatomic, strong) UIButton *headerOneButton;
@property (nonatomic, strong) UIButton *headerTwoButton;
@property (nonatomic, strong) UIButton *headerTreButton;
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
@property (nonatomic, copy) NSArray<MPMSettingTimeModel *> *timesArray;    /** 时间数组 */
@property (nonatomic, copy) NSString *schedulingId;
@property (nonatomic, assign) DulingType dulingType;
@property (nonatomic, assign) BOOL switchOn;
@property (nonatomic, strong) UIButton *preSelectedButton;/** 记录上一个点击的按钮 */
@property (nonatomic, copy) NSString *resetTime;
@property (nonatomic, strong) NSDate *preSelectDate;      /** 记录上一次选中的时间，作为再次弹出pickerView的默认时间 */

@end

@implementation MPMSettingTimeViewController

- (instancetype)initWithSchedulingId:(NSString *)schedulingId dulingType:(DulingType)dulingType resetTime:(NSString *)resetTime {
    self = [super init];
    if (self) {
        self.schedulingId = schedulingId;
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
    [self getData];
}
- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"时间段设置";
    self.switchOn = NO;
    self.titlesArray = [self getTitlesArrayWithCount:0];
    [self.headerOneButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerTwoButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerTreButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.bottomSaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    // header
    [self.view addSubview:self.headerButtonView];
    [self.headerButtonView addSubview:self.headerOneButton];
    [self.headerButtonView addSubview:self.headerTwoButton];
    [self.headerButtonView addSubview:self.headerTreButton];
    // table
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomSaveButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    // header
    [self.headerButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@55);
    }];
    
    [self.headerOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerButtonView.mas_leading).offset(10);
        make.trailing.equalTo(self.headerTwoButton.mas_leading).offset(-10);
        make.top.equalTo(self.headerButtonView.mas_top).offset(7.5);
        make.bottom.equalTo(self.headerButtonView.mas_bottom).offset(-7.5);
    }];
    [self.headerTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.headerTreButton.mas_leading).offset(-10);
        make.width.equalTo(self.headerOneButton.mas_width);
        make.top.equalTo(self.headerButtonView.mas_top).offset(7.5);
        make.bottom.equalTo(self.headerButtonView.mas_bottom).offset(-7.5);
    }];
    [self.headerTreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.headerButtonView.mas_trailing).offset(-10);
        make.width.equalTo(self.headerOneButton.mas_width);
        make.top.equalTo(self.headerButtonView.mas_top).offset(7.5);
        make.bottom.equalTo(self.headerButtonView.mas_bottom).offset(-7.5);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerButtonView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@1);
    }];
    [self.bottomSaveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mas_leading).offset(12);
        make.trailing.equalTo(self.bottomView.mas_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
    }];
}

- (void)getData {
    NSString *url = [NSString stringWithFormat:@"%@timeSlotController/getTimeSlotBySchedulingId?schedulingId=%@&token=%@",MPMHost,self.schedulingId,[MPMShareUser shareUser].token];
    [[MPMSessionManager shareManager] getRequestWithURL:url params:nil loadingMessage:@"正在加载" success:^(id response) {
        NSArray *arr = response[@"dataObj"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] initWithDictionary:dic];
            [temp addObject:model];
        }
        for (NSInteger i = temp.count; i < 3; i++) {
            MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] init];
            [temp addObject:model];
        }
        self.timesArray = temp.copy;
        self.titlesArray = [self getTitlesArrayWithCount:self.timesArray.count];
        switch (arr.count) {
            case 0:{
                [self button:self.headerOneButton];
            }break;
            case 1:{
                if (!kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).noonBreakStartTime)) {
                    self.switchOn = YES;
                }
                [self button:self.headerOneButton];
            }break;
            case 2:{
                [self button:self.headerTwoButton];
            }break;
            case 3:{
                [self button:self.headerTreButton];
            }break;
            default:
                break;
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
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

- (NSString *)getDetailTextWithIndexPath:(NSIndexPath *)indexPath {
    if (self.headerOneButton.selected) {
        if (self.switchOn) {
            if (self.timesArray.count == 0) {
                return @"请选择";
            } else {
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                    }break;
                    case 1:{
                        if (indexPath.row == 1) {
                            if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).noonBreakStartTime)) {
                                return @"请选择";
                            } else {
                                NSString *time = ((MPMSettingTimeModel *)self.timesArray[0]).noonBreakStartTime;
                                return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                            }
                        } else if (indexPath.row == 2) {
                            if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).noonBreakEndTime)) {
                                return @"请选择";
                            } else {
                                NSString *time = ((MPMSettingTimeModel *)self.timesArray[0]).noonBreakEndTime;
                                return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                            }
                        }
                    }break;
                    default:
                        break;
                }
            }
        }
        switch (self.timesArray.count) {
            case 0:{
                return @"请选择";
            }break;
            case 1:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
        switch (self.timesArray.count) {
            case 0:{
                return @"请选择";
            }break;
            case 1:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                    }break;
                    default:
                        break;
                }
            }break;
            case 3:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                    }break;
                    default:
                        break;
                }
            }break;
            default:
                break;
        }
    } else {
        switch (self.timesArray.count) {
            case 0:{
                return @"请选择";
            }break;
            case 1:{
                switch (indexPath.section) {
                    case 0:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];;
                    }break;
                    case 1:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                    }break;
                    case 2:{
                        MPMSettingTimeModel *model = self.timesArray[indexPath.section];
                        NSString *time;
                        if (indexPath.row == 0) {
                            time = model.signTime;
                        } else {
                            time = model.returnTime;
                        }
                        if (kIsNilString(time)) {
                            return @"请选择";
                        }
                        return [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:time.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
            if (!kIsNilString(self.timesArray.firstObject.signTime) && !kIsNilString(self.timesArray.firstObject.returnTime)) {
                if (self.timesArray.firstObject.signTime.timeValue <= self.timesArray.firstObject.returnTime.timeValue) {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue)];
                } else {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
                }
            }
            if (!kIsNilString(self.timesArray.firstObject.noonBreakStartTime) && !kIsNilString(self.timesArray.firstObject.noonBreakEndTime)) {
                if (self.timesArray.firstObject.noonBreakStartTime.timeValue <= self.timesArray.firstObject.noonBreakEndTime.timeValue) {
                    sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.noonBreakEndTime.hourMinuteToString.timeValue - self.timesArray.firstObject.noonBreakStartTime.hourMinuteToString.timeValue)];
                } else {
                    sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.noonBreakEndTime.hourMinuteToString.timeValue - self.timesArray.firstObject.noonBreakStartTime.hourMinuteToString.timeValue + 1440)];
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
            if (!kIsNilString(self.timesArray.firstObject.signTime) && !kIsNilString(self.timesArray.firstObject.returnTime)) {
                if (self.timesArray.firstObject.signTime.timeValue <= self.timesArray.firstObject.returnTime.timeValue) {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue)];
                } else {
                    sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
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
        if (!kIsNilString(self.timesArray.firstObject.signTime) && !kIsNilString(self.timesArray.firstObject.returnTime)) {
            if (self.timesArray.firstObject.signTime.timeValue <= self.timesArray.firstObject.returnTime.timeValue) {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue)];
            } else {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        
        if (!kIsNilString(self.timesArray[1].signTime) && !kIsNilString(self.timesArray[1].returnTime)) {
            if (self.timesArray[1].signTime.timeValue <= self.timesArray[1].returnTime.timeValue) {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.timesArray[1].returnTime.hourMinuteToString.timeValue - self.timesArray[1].signTime.hourMinuteToString.timeValue)];
            } else {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.timesArray[1].returnTime.hourMinuteToString.timeValue - self.timesArray[1].signTime.hourMinuteToString.timeValue + 1440)];
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
        if (!kIsNilString(self.timesArray.firstObject.signTime) && !kIsNilString(self.timesArray.firstObject.returnTime)) {
            if (self.timesArray.firstObject.signTime.timeValue <= self.timesArray.firstObject.returnTime.timeValue) {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue)];
            } else {
                sectionOneDuration = [NSString stringWithFormat:@"%.f",(self.timesArray.firstObject.returnTime.hourMinuteToString.timeValue - self.timesArray.firstObject.signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        
        if (!kIsNilString(self.timesArray[1].signTime) && !kIsNilString(self.timesArray[1].returnTime)) {
            if (self.timesArray[1].signTime.timeValue <= self.timesArray[1].returnTime.timeValue) {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.timesArray[1].returnTime.hourMinuteToString.timeValue - self.timesArray[1].signTime.hourMinuteToString.timeValue)];
            } else {
                sectionTwoDuration = [NSString stringWithFormat:@"%.f",(self.timesArray[1].returnTime.hourMinuteToString.timeValue - self.timesArray[1].signTime.hourMinuteToString.timeValue + 1440)];
            }
        }
        if (!kIsNilString(self.timesArray[2].signTime) && !kIsNilString(self.timesArray[2].returnTime)) {
            if (self.timesArray[2].signTime.timeValue <= self.timesArray[2].returnTime.timeValue) {
                sectionTreDuration = [NSString stringWithFormat:@"%.f",(self.timesArray[2].returnTime.hourMinuteToString.timeValue - self.timesArray[2].signTime.hourMinuteToString.timeValue)];
            } else {
                sectionTreDuration = [NSString stringWithFormat:@"%.f",(self.timesArray[2].returnTime.hourMinuteToString.timeValue - self.timesArray[2].signTime.hourMinuteToString.timeValue + 1440)];
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
    NSString *url = [NSString stringWithFormat:@"%@timeSlotController/saveScheduling?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSMutableArray *params = [NSMutableArray array];
    // 检查输入内容
    if (self.preSelectedButton == self.headerOneButton) {
        if (self.timesArray.count < 1 || kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.switchOn && kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).noonBreakStartTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入间休开始时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.switchOn && kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).noonBreakEndTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入间休结束时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.switchOn) {
            // noonBreakEndTime、noonBreakStartTime、returnTime、signTime、schedulingId
            double noonBreakEndTime = self.timesArray[0].noonBreakEndTime.hourMinuteToString.timeValue;
            double noonBreakStartTime = self.timesArray[0].noonBreakStartTime.hourMinuteToString.timeValue;
            double returnTime = self.timesArray[0].returnTime.hourMinuteToString.timeValue;
            double signTime = self.timesArray[0].signTime.hourMinuteToString.timeValue;
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
            NSString *crossDay;
            if (signTime > returnTime) {
                crossDay = @"1";
            } else {
                crossDay = @"0";
            }
            [params addObject:@{@"noonBreakEndTime":self.timesArray[0].noonBreakEndTime,@"noonBreakStartTime":self.timesArray[0].noonBreakStartTime,@"returnTime":self.timesArray[0].returnTime,@"signTime":self.timesArray[0].signTime,@"schedulingId":self.schedulingId,@"noonBreak":@"1",@"crossDay":crossDay}];
        } else {
            double returnTime =  self.timesArray[0].returnTime.hourMinuteToString.timeValue;
            double signTime = self.timesArray[0].signTime.hourMinuteToString.timeValue;
            // 赋值跨天
            NSString *crossDay;
            if (signTime > returnTime) {
                crossDay = @"1";
            } else {
                crossDay = @"0";
            }
            [params addObject:@{@"returnTime":self.timesArray[0].returnTime,@"signTime":self.timesArray[0].signTime,@"noonBreak":@"0",@"schedulingId":self.schedulingId,@"crossDay":crossDay}];
        }
    } else if (self.preSelectedButton == self.headerTwoButton) {
        if (self.timesArray.count < 1 || kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.timesArray.count < 2 || kIsNilString(((MPMSettingTimeModel *)self.timesArray[1]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[1]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签退时间" sureAction:nil needCancleButton:NO];return;
        }
        
        if ([self getDuration].doubleValue > 1440) {
            [self showAlertControllerToLogoutWithMessage:@"工作时间不能超过一天" sureAction:nil needCancleButton:NO];return;
        }
        
        double signTime0 = self.timesArray[0].signTime.hourMinuteToString.timeValue;
        double returnTime0 = self.timesArray[0].returnTime.hourMinuteToString.timeValue;
        double signTime1 = self.timesArray[1].signTime.hourMinuteToString.timeValue;
        double returnTime1 = self.timesArray[1].returnTime.hourMinuteToString.timeValue;
        
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
            NSString *returnTime =  self.timesArray[i].returnTime;
            NSString *signTime = self.timesArray[i].signTime;
            NSString *crossDay = @"0";
            if (signTime.hourMinuteToString.timeValue < signTime0 || returnTime.hourMinuteToString.timeValue < signTime0) {
                crossDay = @"1";
            }
            [params addObject:@{@"returnTime":returnTime,@"signTime":signTime,@"schedulingId":self.schedulingId,@"crossDay":crossDay}];
        }
    } else if (self.preSelectedButton == self.headerTreButton) {
        if (self.timesArray.count < 1 || kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[0]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.timesArray.count < 2 || kIsNilString(((MPMSettingTimeModel *)self.timesArray[1]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[1]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if (self.timesArray.count < 3 || kIsNilString(((MPMSettingTimeModel *)self.timesArray[2]).signTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签到时间" sureAction:nil needCancleButton:NO];return;
        }
        if (kIsNilString(((MPMSettingTimeModel *)self.timesArray[2]).returnTime)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入签退时间" sureAction:nil needCancleButton:NO];return;
        }
        if ([self getDuration].doubleValue > 1440) {
            [self showAlertControllerToLogoutWithMessage:@"工作时间不能超过一天" sureAction:nil needCancleButton:NO];return;
        }
        double signTime0 = self.timesArray[0].signTime.hourMinuteToString.timeValue;
        double returnTime0 = self.timesArray[0].returnTime.hourMinuteToString.timeValue;
        double signTime1 = self.timesArray[1].signTime.hourMinuteToString.timeValue;
        double returnTime1 = self.timesArray[1].returnTime.hourMinuteToString.timeValue;
        double signTime2 = self.timesArray[2].signTime.hourMinuteToString.timeValue;
        double returnTime2 = self.timesArray[2].returnTime.hourMinuteToString.timeValue;
        
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
            NSString *returnTime =  self.timesArray[i].returnTime;
            NSString *signTime = self.timesArray[i].signTime;
            NSString *crossDay = @"0";
            if (signTime.hourMinuteToString.timeValue < signTime0 || returnTime.hourMinuteToString.timeValue < signTime0) {
                crossDay = @"1";
            }
            [params addObject:@{@"returnTime":returnTime,@"signTime":signTime,@"schedulingId":self.schedulingId,@"crossDay":crossDay}];
        }
    }
    [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
        DLog(@"%@",response);
        // 无论是设置还是创建，成功后，都跳回上一页
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
    
}

#pragma mark - MPMSettingThreeTimeTableViewCellButtonDelegate
- (void)settingSwithChange:(UISwitch *)sw {
    // 点击了“启动间休”switch
    self.switchOn = sw.isOn;
    self.titlesArray = [self getTitlesArrayWithCount:self.preSelectedButton.tag - 1];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
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
        MPMSettingTimeModel *model = self.timesArray[section];
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
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.noonBreakEndTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
                            if (kIsNilString(model.noonBreakStartTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(model.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.noonBreakStartTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (model.signTime.hourMinuteToString.timeValue > model.noonBreakStartTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.noonBreakStartTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.noonBreakStartTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                    }
                                }
                            }
                        }break;
                        case 2:{
                            if (kIsNilString(model.noonBreakEndTime)) {
                                detail = @"请选择";
                            } else {
                                if (kIsNilString(model.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.noonBreakEndTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (model.signTime.hourMinuteToString.timeValue > model.noonBreakEndTime.hourMinuteToString.timeValue) {
                                        detail = [NSString stringWithFormat:@"次日 %@",[NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.noonBreakEndTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute]];
                                    } else {
                                        detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.noonBreakEndTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
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
                                if (kIsNilString(self.timesArray.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.timesArray.firstObject.signTime.hourMinuteToString.timeValue > model.signTime.hourMinuteToString.timeValue) {
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
                                if (kIsNilString(self.timesArray.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.timesArray.firstObject.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
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
                                if (kIsNilString(self.timesArray.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.timesArray.firstObject.signTime.hourMinuteToString.timeValue > model.signTime.hourMinuteToString.timeValue) {
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
                                if (kIsNilString(self.timesArray.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.timesArray.firstObject.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
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
                                if (kIsNilString(self.timesArray.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.signTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.timesArray.firstObject.signTime.hourMinuteToString.timeValue > model.signTime.hourMinuteToString.timeValue) {
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
                                if (kIsNilString(self.timesArray.firstObject.signTime)) {
                                    detail = [NSDateFormatter formatterDate:[NSDateFormatter getDateFromJaveTime:model.returnTime.doubleValue] withDefineFormatterType:forDateFormatTypeHourMinute];
                                } else {
                                    // 如果签到不为空：需要判断次日
                                    if (self.timesArray.firstObject.signTime.hourMinuteToString.timeValue > model.returnTime.hourMinuteToString.timeValue) {
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
        defaultDate = [NSDate dateWithTimeIntervalSince1970:[NSDateFormatter getZeroWithTimeInterverl:[NSDate date].timeIntervalSince1970] + detailText.timeValue*60];
    }
    
    [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeHourMinute defaultDate:defaultDate];
    self.customDatePickerView.completeBlock = ^(NSDate *date) {
        __strong typeof(weakself) strongself = weakself;
        strongself.preSelectDate = date;
        // cell点击之后
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if (self.timesArray.count == 0) {
                    MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model.signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    strongself.timesArray = @[model];
                } else {
                    MPMSettingTimeModel *model = strongself.timesArray[0];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model.signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                }
            } else if (indexPath.row == 1) {
                if (self.timesArray.count == 0) {
                    MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model.returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                } else {
                    MPMSettingTimeModel *model = strongself.timesArray[0];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model.returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                }
            }
        } else if (indexPath.section == 1) {
            if (strongself.headerOneButton.selected) {
                if (indexPath.row == 1) {
                    if (self.timesArray.count == 0) {
                        MPMSettingTimeModel *model0 = [[MPMSettingTimeModel alloc] init];
                        MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        model0.noonBreakStartTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                        strongself.timesArray = @[model0,model1];
                    } else {
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        ((MPMSettingTimeModel *)strongself.timesArray[0]).noonBreakStartTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    }
                } else if (indexPath.row == 2) {
                    if (self.timesArray.count == 0) {
                        MPMSettingTimeModel *model0 = [[MPMSettingTimeModel alloc] init];
                        MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        model0.noonBreakEndTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                        strongself.timesArray = @[model0,model1];
                    }  else {
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        ((MPMSettingTimeModel *)strongself.timesArray[0]).noonBreakEndTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    }
                }
            } else {
                if (indexPath.row == 0) {
                    if (self.timesArray.count == 0) {
                        MPMSettingTimeModel *model0 = [[MPMSettingTimeModel alloc] init];
                        MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        model1.signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                        strongself.timesArray = @[model0,model1];
                    } else if (strongself.timesArray.count == 1) {
                        MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] init];
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        model.signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                        strongself.timesArray = @[strongself.timesArray[0], model];
                    } else {
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        ((MPMSettingTimeModel *)strongself.timesArray[1]).signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    }
                } else if (indexPath.row == 1) {
                    if (self.timesArray.count == 0) {
                        MPMSettingTimeModel *model0 = [[MPMSettingTimeModel alloc] init];
                        MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        model1.returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                        strongself.timesArray = @[model0,model1];
                    } else if (strongself.timesArray.count == 1) {
                        MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] init];
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        model.returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                        strongself.timesArray = @[strongself.timesArray[0], model];
                    } else {
                        NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                        NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                        ((MPMSettingTimeModel *)strongself.timesArray[1]).returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    }
                }
            }
        } else {
            if (indexPath.row == 0) {
                if (self.timesArray.count == 0) {
                    MPMSettingTimeModel *model0 = [[MPMSettingTimeModel alloc] init];
                    MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                    MPMSettingTimeModel *model2 = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model2.signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    strongself.timesArray = @[model0,model1,model2];
                } else if (strongself.timesArray.count == 1) {
                    MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                    MPMSettingTimeModel *model2 = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model2.signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    strongself.timesArray = @[strongself.timesArray[0], model1, model2];
                } else if (strongself.timesArray.count == 2) {
                    MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model.signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    strongself.timesArray = @[strongself.timesArray[0], strongself.timesArray[1], model];
                } else {
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    ((MPMSettingTimeModel *)strongself.timesArray[2]).signTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                }
            } else if (indexPath.row == 1) {
                if (self.timesArray.count == 0) {
                    MPMSettingTimeModel *model0 = [[MPMSettingTimeModel alloc] init];
                    MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                    MPMSettingTimeModel *model2 = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model2.returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    strongself.timesArray = @[model0,model1,model2];
                } else if (strongself.timesArray.count == 1) {
                    MPMSettingTimeModel *model1 = [[MPMSettingTimeModel alloc] init];
                    MPMSettingTimeModel *model2 = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model2.returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    strongself.timesArray = @[strongself.timesArray[0], model1, model2];
                } else if (strongself.timesArray.count == 2) {
                    MPMSettingTimeModel *model = [[MPMSettingTimeModel alloc] init];
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    model.returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                    strongself.timesArray = @[strongself.timesArray[0], strongself.timesArray[1], model];
                } else {
                    NSTimeInterval start = date.timeIntervalSince1970 - 28800000;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    ((MPMSettingTimeModel *)strongself.timesArray[2]).returnTime = [NSString stringWithFormat:@"%.0f",(start - inte)*1000];
                }
            }
        }
        [strongself.tableView reloadData];
    };
}

#pragma mark - Lazy Init

// header
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
        _bottomSaveButton = [MPMButton titleButtonWithTitle:@"下一步" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomSaveButton;
}

- (MPMCustomDatePickerView *)customDatePickerView {
    if (!_customDatePickerView) {
        _customDatePickerView = [[MPMCustomDatePickerView alloc] init];
    }
    return _customDatePickerView;
}

@end
