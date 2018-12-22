//
//  MPMAtendenceSigninViewController.m
//  MPMAtendence
//  考勤打卡签到
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceSigninViewController.h"
#import "MPMRepairSigninViewController.h"
#import "MPMLoginViewController.h"
#import "MPMAttendenceMapViewController.h"
#import "MPMBaseDealingViewController.h"
#import "MPMButton.h"
#import "UIButton+MPMExtention.h"
#import "UIImage+MPMExtention.h"
#import "NSDate+MPMExtention.h"
#import "MPMCalendarButton.h"
#import "MPMAttendenceTableViewCell.h"
#import "MPMCalendarWeekView.h"
#import "MPMCalendarScrollView.h"
#import "MPMSessionManager.h"
#import "MPMAttendencePickerView.h"
#import "NSDateFormatter+MPMExtention.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MPMSigninDateView.h"
#import "JZLocationConverter.h"
#import "MPMAttendenceExceptionTableViewCell.h"
#import "MPMAttendenceModel.h"
#import "MPMAttendenceOneMonthModel.h"
#import "MPMSettingCardAddressWifiModel.h"
#import "MPMOauthUser.h"
#import "MPMAttendenceManageModel.h"
#import "MPMAttendenceExceptionModel.h"
#import "MPMCausationDetailModel.h"
#import "MPMApprovalProcessDetailViewController.h"
#import "MPMProcessMyMetterModel.h"
#import <AVFoundation/AVFoundation.h>
#import "MPMSigninTimerTask.h"

#define kAddressKeyPath         @"address"
const double NeedRefreshLocationInterval = 600; /** 在打卡页面停留10分钟未操作，需要刷新地址 */
const double ContinueSigninInterval      = 15;  /** 15s内不允许重复点击打卡 */

@interface MPMAttendenceSigninViewController () <UIScrollViewDelegate, CAAnimationDelegate, UITableViewDelegate, UITableViewDataSource, MPMCalendarScrollViewDelegate, CLLocationManagerDelegate>

// Header
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) MPMSigninDateView *headerDateView;
@property (nonatomic, strong) UIView *headerWeekView;
@property (nonatomic, strong) MPMCalendarScrollView *headerScrollView;
@property (nonatomic, strong) NSMutableArray *headerCalendarView;
// Middle
@property (nonatomic, strong) UITableView *middleTableView;
@property (nonatomic, strong) UIView *tableViewLine;
@property (nonatomic, strong) UIImageView *noMessageView;
// Bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomRoundButton;
@property (nonatomic, strong) CAShapeLayer *bottomAnimateLayer;
@property (nonatomic, strong) UIImageView *bottomLocationIcon;      /** 地理位置图标 */
@property (nonatomic, strong) UILabel *bottomLocationLabel;         /** 显示地理位置 */
@property (nonatomic, strong) UIButton *bottomRefreshLocationButton;/** 刷新地址 */
// pickerView
@property (nonatomic, strong) MPMAttendencePickerView *pickView;
// location
@property (nonatomic, strong) CLLocationManager *locationManager;
// timer
@property (nonatomic, strong) MPMSigninTimerTask *timerTask;/** 定时器代理：用于获取当前系统时间，避免循环引用 */
// data
@property (nonatomic, strong) MPMAttendenceManageModel *attendenceManageModel;  /** 打卡信息model */
@property (nonatomic, strong) NSDate *lastSigninDate;                           /** 记录上一次打卡时间（15秒钟不允许操作） */
@property (nonatomic, strong) NSDate *lastRefreshLocationDate;                  /** 记录上一次刷新定位的时间 */

@end

@implementation MPMAttendenceSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    __weak typeof(self) weakself = self;
    [self addNetworkMonitoringWithGoodNetworkBlock:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself setupSubViews];
        [strongself setupConstraints];
        if (strongself.goodNetworkToLoadBlock) {
            strongself.goodNetworkToLoadBlock();
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 签到按钮的layer动画
    [self canSignIn:YES];
    [self setupLocation];
    __weak typeof(self) weakself = self;
    self.goodNetworkToLoadBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        [strongself.headerScrollView changeToCurrentWeekDate];
    };
    [self.headerScrollView changeToCurrentWeekDate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 签到按钮的layer动画
    [self canSignIn:NO];
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc {
    [[MPMOauthUser shareOauthUser] removeObserver:self forKeyPath:kAddressKeyPath];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timerTask shutdownTimer];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self setupHeaderView];
    [self setupMiddleView];
    [self setupBottomView];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"考勤签到";
    self.view.backgroundColor = kWhiteColor;
    [[MPMOauthUser shareOauthUser] addObserver:self forKeyPath:kAddressKeyPath options:NSKeyValueObservingOptionNew context:nil];
    self.attendenceManageModel = [[MPMAttendenceManageModel alloc] init];
    [self.headerDateView setDetailDate:[NSDateFormatter formatterDate:[NSDate date] withDefineFormatterType:forDateFormatTypeMonthYearDayWeek]];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    self.timerTask = [[MPMSigninTimerTask alloc] initWithTarget:self selector:@selector(timeChange:)];
    [self.timerTask resumeTimer];
    
    // 刷新
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 sizeToFit];// 这句不能少，少了按钮就会消失了
    [rightButton1 setImage:ImageName(@"attendence_backtotoday") forState:UIControlStateNormal];
    [rightButton1 setImage:ImageName(@"attendence_backtotoday") forState:UIControlStateHighlighted];
    [rightButton1 addTarget:self action:@selector(backToToday:) forControlEvents:UIControlEventTouchUpInside];
    // 进去漏卡页面
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 sizeToFit];
    [rightButton2 setImage:ImageName(@"attendence_retroactive") forState:UIControlStateNormal];
    [rightButton2 setImage:ImageName(@"attendence_retroactive") forState:UIControlStateHighlighted];
    [rightButton2 addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightButton1],[[UIBarButtonItem alloc] initWithCustomView:rightButton2]];
    
    [self.bottomRoundButton addTarget:self action:@selector(signin:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomRefreshLocationButton addTarget:self action:@selector(refreshLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setupHeaderView {
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerDateView];
    [self.headerView addSubview:self.headerWeekView];
    
    // headerScrollView
    NSArray *week = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    double width = kScreenWidth / week.count;
    for (NSInteger i = 0; i < week.count; i++) {
        UILabel *wl = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0, width, PX_H(50))];
        wl.textAlignment = NSTextAlignmentCenter;
        wl.font = SystemFont(14);
        wl.text = week[i];
        wl.textColor = kWhiteColor;
        [self.headerWeekView addSubview:wl];
    }
    [self.headerView addSubview:self.headerScrollView];
}

- (void)setupMiddleView {
    [self.view addSubview:self.tableViewLine];
    [self.view addSubview:self.middleTableView];
    [self.view addSubview:self.noMessageView];
}

- (void)setupBottomView {
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomRoundButton];
    [self.bottomView addSubview:self.bottomLocationIcon];
    [self.bottomView addSubview:self.bottomLocationLabel];
    [self.bottomView addSubview:self.bottomRefreshLocationButton];
    [self.bottomView.layer insertSublayer:self.bottomAnimateLayer atIndex:0];
}

- (void)setupConstraints {
    [super setupConstraints];
    // header
    [self.headerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.equalTo(@(PX_H(260)));
    }];
    [self.headerDateView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.leading.equalTo(self.headerView.mpm_leading);
        make.height.equalTo(@(PX_H(80)));
        make.width.equalTo(@(kScreenWidth / 2));
    }];
    [self.headerWeekView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.top.equalTo(self.headerDateView.mpm_bottom);
        make.height.equalTo(@(PX_H(50)));
    }];
    [self.headerScrollView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerWeekView.mpm_bottom);
        make.height.equalTo(@(PX_H(100)));
    }];
    // middle
    [self.middleTableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerView.mpm_bottom);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    [self.tableViewLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.headerView.mpm_bottom);
        make.bottom.equalTo(self.bottomView.mpm_top);
        make.width.equalTo(@1);
        make.leading.equalTo(self.middleTableView.mpm_leading).offset(27);
    }];
    [self.noMessageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@150);
        make.centerX.equalTo(self.middleTableView.mpm_centerX);
        make.centerY.equalTo(self.middleTableView.mpm_centerY);
    }];
    // bottom
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.view.mpm_leading);
        make.trailing.equalTo(self.view.mpm_trailing);
        make.bottom.equalTo(self.view.mpm_bottom);
        make.height.equalTo(@(175));
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.height.equalTo(@6);
    }];
    [self.bottomRoundButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mpm_top).offset(29);
        make.centerX.equalTo(self.view.mpm_centerX);
        make.width.height.equalTo(@94);
    }];
    [self.bottomLocationIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@9);
        make.height.equalTo(@11);
        make.centerY.equalTo(self.bottomLocationLabel.mpm_centerY);
        make.trailing.equalTo(self.bottomLocationLabel.mpm_leading).offset(-1);
    }];
    [self.bottomLocationLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.view.mpm_bottom).offset(-15);
        make.centerX.equalTo(self.view.mpm_centerX);
        make.height.equalTo(@(17));
        make.width.lessThanOrEqualTo(@(kScreenWidth-50));
    }];
    [self.bottomRefreshLocationButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@16);
        make.centerY.equalTo(self.bottomLocationLabel.mpm_centerY);
        make.leading.equalTo(self.bottomLocationLabel.mpm_trailing).offset(8);
    }];
}

- (void)setupSigninButton {
    // 设置打卡按钮
    if (![NSDateFormatter isDate1:[NSDate date] equalToDate2:self.attendenceManageModel.currentMiddleDate]) {
        [self canSignIn:NO];
    } else {
        if (self.attendenceManageModel.attendenceArray.count == 0) {
            if (3 != self.attendenceManageModel.schedulingEmployeeType.integerValue) {
                // 如果不是自由打卡，不继续打
                [self canSignIn:NO];
            } else {
                // 如果是自由打卡，可以继续打
                [self canSignIn:YES];
            }
        } else {
            if (3 != self.attendenceManageModel.schedulingEmployeeType.integerValue) {
                for (int i = 0; i < self.attendenceManageModel.attendenceArray.count; i++) {
                    MPMAttendenceModel *model = self.attendenceManageModel.attendenceArray[i];
                    if (i == self.attendenceManageModel.attendenceArray.count - 1) {
                        // 判断最后一个数据是否已有数据，如果已有数据，说明已经打完，不再允许打卡，按钮置灰(有数据，但是不是当前日期，也置灰）
                        if (!kIsNilString(model.brushTime)) {
                            [self canSignIn:NO];
                        } else {
                            // 如果最后一个数据还没打，则按钮恢复
                            [self canSignIn:YES];
                        }
                    }
                }
            } else {
                // 如果是自由打卡，可以继续打
                if (kFreeSignMaxCount == self.attendenceManageModel.attendenceArray.count) {
                    [self canSignIn:NO];
                } else {
                    [self canSignIn:YES];
                }
            }
        }
    }
}

- (void)getDataWithDate:(NSDate *)date {
    [self getAttendanceSigninDataWithDate:date];
    [self getThreeWeekDataWithDate:date];
}

/** 获取当前日期的签到信息 */
- (void)getAttendanceSigninDataWithDate:(NSDate *)date {
    NSString *dateString = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970 * 1000];
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_CLOCKTIME];
    NSDictionary *params = @{@"day":dateString};
    [MPMSessionManager shareManager].managerV2.requestSerializer = [MPMJSONRequestSerializer serializer];
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在加载" success:^(id response) {
        DLog(@"%@",response);
        if (response && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            // 清空之前的数据
            self.attendenceManageModel.attendenceAddressArray = nil;
            self.attendenceManageModel.attendenceArray = nil;
            self.attendenceManageModel.attendenceExceptionArray = nil;
            self.attendenceManageModel.schedulingEmployeeType = nil;
            
            NSDictionary *object = response[kResponseObjectKey];
            // 打卡定位信息
            if (object[@"cardSettings"] && [object[@"cardSettings"] isKindOfClass:[NSArray class]]) {
                NSArray *cardSettigns = object[@"cardSettings"];
                NSMutableArray *tempAddress = [NSMutableArray arrayWithCapacity:cardSettigns.count];
                for (int i = 0; i < cardSettigns.count; i++) {
                    MPMSettingCardAddressWifiModel *address = [[MPMSettingCardAddressWifiModel alloc] initWithDictionary:cardSettigns[i]];
                    [tempAddress addObject:address];
                }
                self.attendenceManageModel.attendenceAddressArray = tempAddress.copy;
            }
            
            // 打卡类型
            if (object[@"schedulingEmployeeType"] && [object[@"schedulingEmployeeType"] isKindOfClass:[NSNumber class]]) {
                NSNumber *schedulingEmployeeType = object[@"schedulingEmployeeType"];
                self.attendenceManageModel.schedulingEmployeeType = schedulingEmployeeType.stringValue;
            }
            
            // 打卡数据
            if (object[@"employeeAttendances"] && [object[@"employeeAttendances"] isKindOfClass:[NSArray class]]) {
                NSArray *attens = object[@"employeeAttendances"];
                NSMutableArray *tempattens = [NSMutableArray arrayWithCapacity:attens.count];
                for (int i = 0; i < attens.count; i++) {
                    MPMAttendenceModel *model = [[MPMAttendenceModel alloc] initWithDictionary:attens[i]];
                    [tempattens addObject:model];
                }
                // 筛选等待打卡状态：当天+最新一个未打卡的节点
                if ([NSDateFormatter isDate1:[NSDate date] equalToDate2:self.attendenceManageModel.currentMiddleDate]) {
                    for (int i = 0; i < tempattens.count; i++) {
                        MPMAttendenceModel *model = tempattens[i];
                        // 如果没有brushTime（并且不是漏卡），那么就是等待刷卡状态
                        if (kIsNilString(model.brushTime) && model.status.integerValue != 3) {
                            model.isNeedFirstBrush = YES;
                            break;
                        }
                    }
                }
                self.attendenceManageModel.attendenceArray = tempattens;
            }
            // 例外申请信息
            if (object[@"kqBizOrderVo"] && [object[@"kqBizOrderVo"] isKindOfClass:[NSArray class]]) {
                NSArray *kqBizOrderVo = object[@"kqBizOrderVo"];
                // 根据id筛选出相同的
                NSMutableArray *allArray = [NSMutableArray array];
                for (int i = 0; i < kqBizOrderVo.count; i++) {
                    NSDictionary *dic = kqBizOrderVo[i];
                    MPMAttendenceExceptionModel *excep = [[MPMAttendenceExceptionModel alloc] initWithDictionary:dic];
                    [allArray addObject:excep];
                }
                NSMutableArray *newSeperateArray = [NSMutableArray array];
                for (int i = 0; i < allArray.count; i++) {
                    NSMutableArray *temparray = [NSMutableArray array];
                    MPMAttendenceExceptionModel *excep = allArray[i];
                    [temparray addObject:excep];
                    if (excep.hasJoin) {
                        continue;
                    } else {
                        excep.hasJoin = YES;
                    }
                    for (int j = i + 1; j < allArray.count; j++) {
                        MPMAttendenceExceptionModel *sub = allArray[j];
                        if (!sub.hasJoin && [sub.mpm_id isEqualToString:excep.mpm_id]) {
                            sub.hasJoin = YES;
                            [temparray addObject:sub];
                        }
                        continue;
                    }
                    [newSeperateArray addObject:temparray.copy];
                }
                self.attendenceManageModel.attendenceExceptionArray = newSeperateArray.copy;
            }
            
            [self setupSigninButton];
            
            [self.middleTableView reloadData];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (void)canSignIn:(BOOL)canSign {
    dispatch_async(kMainQueue, ^{
        if (canSign) {
            [self.bottomRoundButton setBackgroundImage:ImageName(@"attendence_roundbtn") forState:UIControlStateNormal];
            [self.bottomRoundButton setBackgroundImage:ImageName(@"attendence_roundbtn") forState:UIControlStateHighlighted];
            [self.bottomAnimateLayer removeAllAnimations];
            [self.bottomAnimateLayer addAnimation:[self alpha] forKey:@"animate"];
        } else {
            [self.bottomRoundButton setBackgroundImage:[UIImage getImageFromColor:kRGBA(184, 184, 184, 1)] forState:UIControlStateNormal];
            [self.bottomRoundButton setBackgroundImage:[UIImage getImageFromColor:kRGBA(184, 184, 184, 1)] forState:UIControlStateHighlighted];
            [self.bottomAnimateLayer removeAllAnimations];
        }
    });
}

/** 当前接口可以获取当前月份和前后共三个星期的班次信息 */
- (void)getThreeWeekDataWithDate:(NSDate *)date {
    
    NSDate *dateOfLastWeek;             /** 当前日期减7天 */
    NSDate *dateOfCurrentWeek = date;   /** 当前日期 */
    NSDate *dateOfNextWeek;             /** 当前日期加7天 */
    
    __block NSArray *lastWeekArray;             /** 保存上个星期的7天 */
    __block NSArray *currentWeekArray;          /** 保存当前星期的7天 */
    __block NSArray *nextWeekArray;             /** 保存下个星期的7天 */
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:dateOfCurrentWeek];
    [comp setDay:comp.day - 7];
    dateOfLastWeek = [cal dateFromComponents:comp];
    [comp setDay:comp.day + 7 + 7];
    dateOfNextWeek = [cal dateFromComponents:comp];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_GETSTATUS];
        NSDictionary *params = @{@"day":[NSString stringWithFormat:@"%.f",dateOfCurrentWeek.timeIntervalSince1970*1000]};
        [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:nil success:^(id response) {
            if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                NSArray *object = response[kResponseObjectKey];
                NSMutableArray *temp = @[].mutableCopy;
                for (int i = 0; i < object.count; i++) {
                    NSDictionary *dic = object[i];
                    MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                    [temp addObject:model];
                }
                currentWeekArray = temp.copy;
            }
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_GETSTATUS];
        NSDictionary *params = @{@"day":[NSString stringWithFormat:@"%.f",dateOfLastWeek.timeIntervalSince1970*1000]};
        [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:nil success:^(id response) {
            if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                NSArray *object = response[kResponseObjectKey];
                NSMutableArray *temp = @[].mutableCopy;
                for (int i = 0; i < object.count; i++) {
                    NSDictionary *dic = object[i];
                    MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                    [temp addObject:model];
                }
                lastWeekArray = temp.copy;
            }
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    
    
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_GETSTATUS];
        NSDictionary *params = @{@"day":[NSString stringWithFormat:@"%.f",dateOfNextWeek.timeIntervalSince1970*1000]};
        [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:nil success:^(id response) {
            if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
                NSArray *object = response[kResponseObjectKey];
                NSMutableArray *temp = @[].mutableCopy;
                for (int i = 0; i < object.count; i++) {
                    NSDictionary *dic = object[i];
                    MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                    [temp addObject:model];
                }
                nextWeekArray = temp.copy;
            }
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, kMainQueue, ^{
        NSMutableArray *temp = [NSMutableArray arrayWithArray:lastWeekArray];
        [temp addObjectsFromArray:currentWeekArray];
        [temp addObjectsFromArray:nextWeekArray];
        self.attendenceManageModel.attendenceThreeWeekArray = temp.copy;
        if (temp.count > 0) {
            [self.headerScrollView reloadData:self.attendenceManageModel.attendenceThreeWeekArray];
        }
    });
}

#pragma mark - Private Method
/** 计算两个位置的距离 */
- (double)getDistanceWithLocation:(CLLocation *)loc1 location:(CLLocation *)loc2 {
    return [loc1 distanceFromLocation:loc2];
}

/** 设置、重新获取地理位置 */
- (void)setupLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

/** 打卡成功 */
- (void)signinSuccess {
    self.lastSigninDate = [NSDate date];// 打卡成功，记录下此次打卡时间，再次打卡校验不能在15秒内立即打卡
    [MPMProgressHUD showSuccessWithStatus:@"打卡成功"];
    /*
     AVSpeechSynthesizer *speech = [[AVSpeechSynthesizer alloc] init];
     AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:@"打卡成功"];
     [speech speakUtterance:utt];
     */
    [self getDataWithDate:[NSDate date]];
}

#pragma mark - Target Action

- (void)right:(UIButton *)sender {
    MPMRepairSigninViewController *rs = [[MPMRepairSigninViewController alloc] initWithRepairFromType:kRepairFromTypeSigning passingLeadArray:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rs animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)backToToday:(UIButton *)sender {
    [self.headerScrollView changeToCurrentWeekDate];
}

- (void)refreshLocation:(UIButton *)sender {
    self.bottomLocationLabel.text = @"地理位置:重新定位中...";
    [self setupLocation];
}

- (void)backToCurrentDate:(UIButton *)sender {
    DLog(@"回到当前日期");
    [self.headerScrollView changeToCurrentWeekDate];
}

/** 打卡验证 */
- (BOOL)validateSignin {
    // 如果不是当天，不允许打卡
    if (![NSDateFormatter isDate1:[NSDate date] equalToDate2:self.attendenceManageModel.currentMiddleDate]) {
        [self showAlertControllerToLogoutWithMessage:@"当前日期不允许打卡" sureAction:nil needCancleButton:NO];return NO;
    }
    // 判断是否已打满卡
    BOOL hasSignAll = NO;
    if (3 == self.attendenceManageModel.schedulingEmployeeType.integerValue) {
        // 自由打卡，只能打20个
        if (kFreeSignMaxCount == self.attendenceManageModel.attendenceArray.count) {
            hasSignAll = YES;
        }
    } else {
        // 其他打卡类型
        for (int i = 0; i < self.attendenceManageModel.attendenceArray.count; i++) {
            MPMAttendenceModel *model = self.attendenceManageModel.attendenceArray[i];
            if (i == self.attendenceManageModel.attendenceArray.count - 1 && !kIsNilString(model.brushTime)) {
                hasSignAll = YES;
            }
        }
    }
    if (hasSignAll) {
        [self showAlertControllerToLogoutWithMessage:@"考勤已打满，无需打卡" sureAction:nil needCancleButton:NO];return NO;
    }
    
    if (3 == self.attendenceManageModel.schedulingEmployeeType.integerValue) {
        // 自由打卡，不校验打卡位置
    } else {
        if (![MPMOauthUser shareOauthUser].location) {
            [self showAlertControllerToLogoutWithMessage:@"请先完成定位再进行打卡，如果当前没有开启定位，请在手机“设置”中开启" sureAction:nil needCancleButton:NO];return NO;
        } else {
            // 10分钟
            if ([NSDate date].timeIntervalSince1970 - self.lastRefreshLocationDate.timeIntervalSince1970 >= NeedRefreshLocationInterval) {
                __weak typeof(self) weakself = self;
                [self showAlertControllerToLogoutWithMessage:@"需要刷新至最新定位哦~" sureAction:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakself) strongself = weakself;
                    [strongself setupLocation];
                } sureActionTitle:@"刷新"needCancleButton:NO];return NO;
            }
            BOOL canSign = NO;
            if (self.attendenceManageModel.attendenceAddressArray.count > 0) {
                for (MPMSettingCardAddressWifiModel *model in self.attendenceManageModel.attendenceAddressArray) {
                    CLLocation *loc = [[CLLocation alloc] initWithLatitude:model.latitude.doubleValue longitude:model.longitude.doubleValue];
                    CLLocation *myLoc = [MPMOauthUser shareOauthUser].location;
                    double distance = [loc distanceFromLocation:myLoc];
                    DLog(@"===当前位置与考勤地点的距离是：%.f===",distance);
                    if (distance <= fabs(model.deviation.doubleValue) || model.deviation.doubleValue == 0) {
                        // 如果发现我的地址在考勤地址库中的其中一个并且在考勤范围内，那么就允许签到
                        canSign = YES;
                    }
                }
                if (!canSign) {
                    [self showAlertControllerToLogoutWithMessage:@"当前位置不在考勤范围内，不允许考勤" sureAction:nil needCancleButton:NO];return NO;
                }
            }
        }
    }
    
    if ([NSDate date].timeIntervalSince1970 - self.lastSigninDate.timeIntervalSince1970 <= ContinueSigninInterval) {
        [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%.f秒内不允许打卡",ContinueSigninInterval] sureAction:nil needCancleButton:NO];return NO;
    }
    
    return YES;
}

- (void)signin:(UIButton *)sender {
    DLog(@"签到");
    if ([self validateSignin]) {
        [self signForEarly:NO];
    }
}

- (void)signForEarly:(BOOL)early {
    
    // 筛选出需要打卡的model
    MPMAttendenceModel *signModel;
    NSString *address;
    NSString *signType;
    if (3 == self.attendenceManageModel.schedulingEmployeeType.integerValue) {
        signModel = self.attendenceManageModel.attendenceArray.firstObject;
        address = kIsNilString([MPMOauthUser shareOauthUser].address) ? @"自由打卡无地址" : [MPMOauthUser shareOauthUser].address;
        signType = [NSString stringWithFormat:@"%ld",self.attendenceManageModel.attendenceArray.count % 2];
    } else {
        for (int i = 0; i < self.attendenceManageModel.attendenceArray.count; i++) {
            MPMAttendenceModel *model = self.attendenceManageModel.attendenceArray[i];
            if (model.isNeedFirstBrush) {
                signModel = model;
                break;
            }
        }
        address = kSafeString([MPMOauthUser shareOauthUser].address);
        signType = kSafeString(signModel.signType);// 0代表上班 1代表下班 使用接口传给我们的就好了（感觉传空也可以）
    }
    
    NSDate *bursh = self.attendenceManageModel.currentMiddleDate ? [NSDate changeToFitJavaDate:self.attendenceManageModel.currentMiddleDate] : [NSDate changeToFitJavaDate:[NSDate date]];
    DLog(@"打卡时间 == %@",bursh);
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_PUNCHCARD];
    NSString *brushDate = [NSDateFormatter formatterDate:bursh withDefineFormatterType:forDateFormatTypeSpecial];
    NSString *schedulingEmployeeId = kSafeString(signModel.schedulingEmployeeId);
    NSString *schedulingEmployeeType = kSafeString(self.attendenceManageModel.schedulingEmployeeType);
    NSDictionary *params;
    if (early) {
        params = @{@"address":address,@"brushDate":brushDate,@"early":@1,@"schedulingEmployeeId":schedulingEmployeeId,@"schedulingEmployeeType":schedulingEmployeeType,@"signType":signType};
    } else {
        params = @{@"address":address,@"brushDate":brushDate,@"early":@0,@"schedulingEmployeeId":schedulingEmployeeId,@"schedulingEmployeeType":schedulingEmployeeType,@"signType":signType};
    }
    [MPMProgressHUD showWithStatus:@"正在打卡"];
    
    [MPMSessionManager shareManager].managerV2.requestSerializer = [MPMJSONRequestSerializer serializer];
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:nil success:^(id response) {
        [MPMProgressHUD dismiss];
        DLog(@"%@",response);
        if (response[kResponseDataKey] &&
            [response[kResponseDataKey] isKindOfClass:[NSDictionary class]] &&
            ((NSString *)response[kResponseDataKey][@"code"]).integerValue == 202) {
            // 早退
            __weak typeof (self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:(NSString *)response[@"responseData"][@"message"] sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself signForEarly:YES];
            } needCancleButton:YES];
        } else if (response[kResponseDataKey] &&
                   [response[kResponseDataKey] isKindOfClass:[NSDictionary class]] &&
                   ((NSString *)response[kResponseDataKey][@"code"]).integerValue != 200) {
            NSString *message = (NSString *)response[kResponseDataKey][@"message"];
            [self showAlertControllerToLogoutWithMessage:kSafeString(message) sureAction:nil needCancleButton:NO];
        } else if (response[kResponseDataKey] &&
                   [response[kResponseDataKey] isKindOfClass:[NSDictionary class]] &&
                   ((NSString *)response[kResponseDataKey][@"code"]).integerValue == 200) {
            [self signinSuccess];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

/** 定时器 */
- (void)timeChange:(id)sender {
    NSString *str = [NSDateFormatter formatterDate:[NSDate date] withDefineFormatterType:forDateFormatTypeHourMinute];
    [self.bottomRoundButton setTitle:str forState:UIControlStateNormal];
    [self.bottomRoundButton setTitle:str forState:UIControlStateHighlighted];
}

- (void)back:(UIButton *)sender {
    [[MPMSessionManager shareManager] backWithExpire:NO alertMessage:nil];
}

#pragma mark - Notification
- (void)appResignActive:(NSNotification *)noti {
    [self.timerTask pauseTimer];
}

- (void)appBecomeActive:(NSNotification *)noti {
    [self setupSigninButton];
    [self.timerTask resumeTimer];
    /*
     // 如果最后一个打卡数据不为空，或者当前时间不是今天，置灰打卡按钮
     if (self.attendenceManageModel.attendenceArray.count > 0) {
     MPMAttendenceModel *model = self.attendenceManageModel.attendenceArray.lastObject;
     if (!kIsNilString(model.brushTime) || ![NSDateFormatter isDate1:[NSDate date] equalToDate2:self.attendenceManageModel.currentMiddleDate]) {
     [self.bottomAnimateLayer removeFromSuperlayer];
     self.bottomAnimateLayer = nil;
     }
     } else if (self.attendenceManageModel.attendenceArray.count == 0) {
     [self.bottomAnimateLayer removeFromSuperlayer];
     self.bottomAnimateLayer = nil;
     }
     */
    // 从后台切换回前台，刷新定位
    [self setupLocation];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"address"]) {
        self.bottomLocationLabel.text = [NSString stringWithFormat:@"地理位置:%@",kSafeString([MPMOauthUser shareOauthUser].address)];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * newLocation = [locations lastObject];
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 1.0) {
        return;
    }
    // 处理相关定位信息
    [manager stopUpdatingLocation];
    // 每次获取到新的定位的时候，更新获取到定位时间（打卡的时候会与当前时间对比，如果超过10分钟，则需要重新刷新定位）
    self.lastRefreshLocationDate = [NSDate date];
    
    MKCoordinateSpan span;
    // 设置经度的缩放级别
    span.longitudeDelta = 0.05;
    // 设置纬度的缩放级别
    span.latitudeDelta = 0.05;
    // 反向编码部分
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark * placeMark = placemarks[0];
            [MPMOauthUser shareOauthUser].address = [NSString stringWithFormat:@"%@%@%@",kSafeString(placeMark.locality),kSafeString(placeMark.subLocality),kSafeString(placeMark.thoroughfare)];
            CLLocationCoordinate2D convert = [JZLocationConverter wgs84ToGcj02:newLocation.coordinate];
            [MPMOauthUser shareOauthUser].location = [[CLLocation alloc] initWithLatitude:convert.latitude longitude:convert.longitude];
        } else if (error == nil && placemarks.count == 0) {
            [MPMOauthUser shareOauthUser].address = nil;
            [MPMOauthUser shareOauthUser].location = nil;
            DLog(@"没有找到地址");
        } else if (error) {
            [MPMOauthUser shareOauthUser].address = nil;
            [MPMOauthUser shareOauthUser].location = nil;
            DLog(@"定位错误==%@",error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [MPMOauthUser shareOauthUser].address = nil;
    [MPMOauthUser shareOauthUser].location = nil;
    DLog(@"定位失败==%@",error);
}

#pragma mark - MPMScrollViewDelegate
- (void)mpmCalendarScrollViewDidChangeYearMonth:(NSString *)yearMonth currentMiddleDate:(NSDate *)date {
    [self.headerDateView setDetailDate:yearMonth];
    self.attendenceManageModel.currentMiddleDate = date;
    [self getDataWithDate:date];
}

#pragma mark - UITableViewDelegate && UITableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section) {
        return 60;
    } else {
        NSInteger count = self.attendenceManageModel.attendenceExceptionArray[indexPath.row].count;
        return 60 + (count - 1)*15;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.noMessageView.hidden = (self.attendenceManageModel.attendenceArray.count > 0 || self.attendenceManageModel.attendenceExceptionArray.count > 0);
    self.tableViewLine.hidden = (self.attendenceManageModel.attendenceArray.count == 0 && self.attendenceManageModel.attendenceExceptionArray.count == 0);
    if (0 == section) {
        return self.attendenceManageModel.attendenceExceptionArray.count;
    } else {
        return self.attendenceManageModel.attendenceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        static NSString *identifier = @"ExceptionCell";
        MPMAttendenceExceptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MPMAttendenceExceptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSArray *array = self.attendenceManageModel.attendenceExceptionArray[indexPath.row];
        
        NSString *formatter;
        for (int i = 0; i < array.count; i++) {
            MPMAttendenceExceptionModel *excep = self.attendenceManageModel.attendenceExceptionArray[indexPath.row][i];
            if (0 == i) {
                formatter = [NSString stringWithFormat:@"%@  %@",[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:excep.startTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds],[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:excep.endTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds]];
            } else {
                formatter = [formatter stringByAppendingString:[NSString stringWithFormat:@"\n%@  %@",[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:excep.startTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds],[NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:excep.endTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds]]];
            }
        }
        
        cell.typeLabel.text = kException_GetNameFromNum[((MPMAttendenceExceptionModel *)self.attendenceManageModel.attendenceExceptionArray[indexPath.row].firstObject).type];
        cell.detailTimeLabel.text = formatter;
        return cell;
    }
    
    static NSString *cellIdentifier = @"CalendarCell";
    MPMAttendenceModel *model = self.attendenceManageModel.attendenceArray[indexPath.row];
    MPMAttendenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MPMAttendenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDate *tt = [NSDate dateWithTimeIntervalSince1970:model.fillCardTime.integerValue/1000];
    NSString *time = [NSDateFormatter formatterDate:tt withDefineFormatterType:forDateFormatTypeHourMinute];
    if (1 == self.attendenceManageModel.schedulingEmployeeType.integerValue) {
        cell.timeLabel.text = nil;
        [cell.classTypeLabel mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.centerY.equalTo(cell.mpm_centerY);
        }];
        cell.timeLabel.hidden = YES;
    } else {
        [cell.classTypeLabel mpm_updateConstraints:^(MPMConstraintMaker *make) {
            make.centerY.equalTo(cell.mpm_centerY).offset(-8.5);
        }];
        cell.timeLabel.text = time;
        cell.timeLabel.hidden = NO;
    }
    cell.classTypeLabel.text = model.signType.integerValue == 0 ? @"上班" : @"下班";
    
    if (3 == self.attendenceManageModel.schedulingEmployeeType.integerValue) {
        // 自由打卡
        cell.timeLabel.hidden = YES;
        cell.classTypeLabel.hidden = YES;
        cell.waitBrushLabel.hidden = YES;
        cell.accessaryIcon.hidden = NO;
        cell.contentImageView.hidden = NO;
        cell.textLabel.text = @"";
        cell.classTypeLabel.textColor = kMainLightGray;
        cell.timeLabel.textColor = kMainLightGray;
        cell.exceptionBtn.hidden = YES;
    } else if (model.isNeedFirstBrush) {
        // 等待打卡中~~
        cell.accessaryIcon.hidden = YES;
        cell.classTypeLabel.hidden = NO;
        cell.contentImageView.hidden = YES;
        cell.statusImageView.image = nil;
        cell.messageLabel.text = @"";
        cell.messageTimeLabel.text = @"";
        [cell.scoreButton setTitle:@"" forState:UIControlStateNormal];
        [cell.scoreButton setBackgroundImage:nil forState:UIControlStateNormal];
        cell.waitBrushLabel.hidden = NO;
        cell.classTypeLabel.textColor = kMainBlueColor;
        cell.timeLabel.textColor = kMainBlueColor;
        cell.exceptionBtn.hidden = YES;
        return cell;
    } else if (!model.brushTime || model.brushTime.length == 0) {
        // 只有时间点的打卡节点
        cell.accessaryIcon.hidden = YES;
        cell.classTypeLabel.hidden = NO;
        cell.contentImageView.hidden = YES;
        cell.statusImageView.image = nil;
        cell.messageLabel.text = @"";
        cell.messageTimeLabel.text = @"";
        [cell.scoreButton setTitle:@"" forState:UIControlStateNormal];
        [cell.scoreButton setBackgroundImage:nil forState:UIControlStateNormal];
        cell.textLabel.text = @"";
        cell.waitBrushLabel.hidden = YES;
        cell.classTypeLabel.textColor = kMainLightGray;
        cell.timeLabel.textColor = kMainLightGray;
        cell.exceptionBtn.hidden = YES;
        return cell;
    } else {
        // 常用形态
        cell.waitBrushLabel.hidden = YES;
        cell.classTypeLabel.hidden = NO;
        cell.accessaryIcon.hidden = NO;
        cell.contentImageView.hidden = NO;
        cell.textLabel.text = @"";
        cell.classTypeLabel.textColor = kMainLightGray;
        cell.timeLabel.textColor = kMainLightGray;
        if (kIsNilString(model.statusException)) {
            cell.exceptionBtn.hidden = YES;
        } else {
            cell.exceptionBtn.hidden = NO;
            [cell.exceptionBtn setTitle:kException_GetNameFromNum[model.statusException] forState:UIControlStateNormal];
            [cell.exceptionBtn setTitle:kException_GetNameFromNum[model.statusException] forState:UIControlStateHighlighted];
        }
    }
    // 状态及图片
    if (3 == self.attendenceManageModel.schedulingEmployeeType.integerValue) {
        // 自由打卡
        cell.statusImageView.image = ImageName(@"attendence_finish");
        cell.messageLabel.text = nil;
    } else if (model.status.integerValue == 0) {
        cell.statusImageView.image = ImageName(@"attendence_finish");
        cell.messageLabel.text = @"准时";
    } else if (model.status.integerValue == 1) {
        cell.statusImageView.image = ImageName(@"attendence_vacate");
        cell.messageLabel.text = @"迟到";
    } else if (model.status.integerValue == 2) {
        cell.statusImageView.image = ImageName(@"attendence_vacate");
        cell.messageLabel.text = @"早退";
    } else if (model.status.integerValue == 3) {
        cell.statusImageView.image = ImageName(@"attendence_unfinished");
        cell.messageLabel.text = @"漏卡";
    } else if (model.status.integerValue == 4) {
        cell.statusImageView.image = ImageName(@"attendence_finish");
        cell.messageLabel.text = @"早到";
    } else if (model.status.integerValue == 5) {
        cell.statusImageView.image = ImageName(@"attendence_finish");
        cell.messageLabel.text = @"准时";
    } else if (model.status.integerValue == 6) {
        cell.statusImageView.image = ImageName(@"attendence_vacate");
        cell.messageLabel.text = @"加班";
    }
    // 加减分
    if (kIsNilString(model.integral) || model.integral.integerValue == 0) {
        cell.scoreButton.hidden = YES;
    } else if (model.integral.integerValue >= 0) {
        cell.scoreButton.hidden = NO;
        [cell.scoreButton setTitle:model.integral forState:UIControlStateNormal];
        [cell.scoreButton setBackgroundImage:ImageName(@"attendence_aceb") forState:UIControlStateNormal];
    } else {
        cell.scoreButton.hidden = NO;
        [cell.scoreButton setTitle:[NSString stringWithFormat:@"%ld",labs(model.integral.integerValue)] forState:UIControlStateNormal];
        [cell.scoreButton setBackgroundImage:ImageName(@"attendence_deb") forState:UIControlStateNormal];
    }
    
    if (!kIsNilString(model.brushTime)) {
        NSDate *brushTime = [NSDate dateWithTimeIntervalSince1970:model.brushTime.integerValue/1000];
        cell.messageTimeLabel.text = [NSDateFormatter formatterDate:brushTime withDefineFormatterType:forDateFormatTypeHourMinute];
    } else {
        cell.messageTimeLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        MPMAttendenceExceptionModel *excep = (MPMAttendenceExceptionModel *)((NSArray *)self.attendenceManageModel.attendenceExceptionArray[indexPath.row]).firstObject;
        MPMProcessMyMetterModel *md = [[MPMProcessMyMetterModel alloc] init];
        md.mpm_id = excep.mpm_id;
        MPMApprovalProcessDetailViewController *detail = [[MPMApprovalProcessDetailViewController alloc] initWithModel:md selectedIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    // 补签、改签。如果已经处理过，则跳到详情页面。
    MPMAttendenceModel *model = self.attendenceManageModel.attendenceArray[indexPath.row];
    if (!model.brushTime || model.brushTime.length == 0) {
    } else {
        
        NSString *url = [NSString stringWithFormat:@"%@%@?detailId=%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_ISEXISTDETAIL,model.schedulingEmployeeId];
        [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在操作" success:^(id response) {
            if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]] && response[kResponseDataKey] && [response[kResponseDataKey] isKindOfClass:[NSDictionary class]] && kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
                // 已经申请过，则直接跳到详情
                MPMProcessMyMetterModel *md = [[MPMProcessMyMetterModel alloc] init];
                md.mpm_id = model.schedulingEmployeeId;
                MPMApprovalProcessDetailViewController *detail = [[MPMApprovalProcessDetailViewController alloc] initWithModel:md selectedIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            } else {
                // 没有申请过，则重新申请
                CausationType type;
                NSInteger addCount;
                NSString *typeStatus;
                if (model.status.integerValue == 3) {
                    // 漏卡-补签
                    type = kCausationTypeRepairSign;
                    addCount = 1;
                    typeStatus = @"1";
                } else {
                    // 其他状态-改签
                    type = kCausationTypeChangeSign;
                    addCount = 0;
                    typeStatus = @"0";
                }
                MPMDealingModel *dealingModel = [[MPMDealingModel alloc] initWithCausationType:type addCount:1];
                // 补签
                dealingModel.causationDetail[0].detailId = model.schedulingEmployeeId;
                dealingModel.causationDetail[0].fillupTime = model.brushTime;
                // 改签
                dealingModel.status = model.status;
                dealingModel.causationDetail[0].type = model.signType;
                dealingModel.causationDetail[0].attendanceTime = model.fillCardTime;/** 打卡节点时间 */
                dealingModel.causationDetail[0].signTime = model.brushTime;         /** 实际打卡时间 */
                dealingModel.causationDetail[0].reviseSignTime = model.brushTime;   /** 实际打卡时间 */
                MPMBaseDealingViewController *dealing = [[MPMBaseDealingViewController alloc] initWithDealType:type dealingModel:dealingModel dealingFromType:kDealingFromTypeApply bizorderId:nil taskInstId:nil];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:dealing animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        } failure:^(NSString *error) {
            DLog(@"获取节点补签改签失败");
            [MPMProgressHUD showErrorWithStatus:error];
        }];
    }
}

#pragma mark - Lazy Init
// header
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = ImageName(@"attendence_headerbg");
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (MPMSigninDateView *)headerDateView {
    if (!_headerDateView) {
        _headerDateView = [[MPMSigninDateView alloc] init];
        _headerDateView.backgroundColor = kClearColor;
    }
    return _headerDateView;
}

- (UIView *)headerWeekView {
    if (!_headerWeekView) {
        _headerWeekView = [[UIView alloc] init];
    }
    return _headerWeekView;
}

- (MPMCalendarScrollView *)headerScrollView {
    if (!_headerScrollView) {
        _headerScrollView = [[MPMCalendarScrollView alloc] init];
        _headerScrollView.delegate = self;
        _headerScrollView.mpmDelegate = self;
        _headerScrollView.pagingEnabled = YES;
        _headerScrollView.showsVerticalScrollIndicator = NO;
        _headerScrollView.showsHorizontalScrollIndicator = NO;
        _headerScrollView.contentSize = CGSizeMake(kScreenWidth * 3, PX_H(100));
        _headerScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    }
    return _headerScrollView;
}
// middle
- (UITableView *)middleTableView {
    if (!_middleTableView) {
        _middleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _middleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _middleTableView.delegate = self;
        _middleTableView.dataSource = self;
        _middleTableView.backgroundColor = kClearColor;
    }
    return _middleTableView;
}

- (UIView *)tableViewLine {
    if (!_tableViewLine) {
        _tableViewLine = [[UIView alloc] init];
        _tableViewLine.backgroundColor = kRGBA(226, 226, 226, 1);
    }
    return _tableViewLine;
}

- (UIImageView *)noMessageView {
    if (!_noMessageView) {
        _noMessageView = [[UIImageView alloc] initWithImage:ImageName(@"global_notSignDay")];
        _noMessageView.hidden = YES;
    }
    return _noMessageView;
}

// bottom
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kTableViewBGColor;
    }
    return _bottomLine;
}
- (UIButton *)bottomRoundButton {
    if (!_bottomRoundButton) {
        _bottomRoundButton = [MPMButton titleButtonWithTitle:@"15:46" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"attendence_roundbtn") hImage:ImageName(@"attendence_roundbtn")];
        _bottomRoundButton.layer.cornerRadius = 47;
        _bottomRoundButton.layer.masksToBounds = YES;
        _bottomRoundButton.titleLabel.font = SystemFont(28);
    }
    return _bottomRoundButton;
}

- (UIImageView *)bottomLocationIcon {
    if (!_bottomLocationIcon) {
        _bottomLocationIcon = [[UIImageView alloc] initWithImage:ImageName(@"attendence_location_gray")];
    }
    return _bottomLocationIcon;
}
- (UILabel *)bottomLocationLabel {
    if (!_bottomLocationLabel) {
        _bottomLocationLabel = [[UILabel alloc] init];
        _bottomLocationLabel.font = SystemFont(13);
        _bottomLocationLabel.textColor = kMainLightGray;
        _bottomLocationLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLocationLabel.text = @"地理位置:";
        [_bottomLocationLabel sizeToFit];
    }
    return _bottomLocationLabel;
}

- (UIButton *)bottomRefreshLocationButton {
    if (!_bottomRefreshLocationButton) {
        _bottomRefreshLocationButton = [MPMButton imageButtonWithImage:ImageName(@"attendence_refresh") hImage:ImageName(@"attendence_refresh")];
    }
    return _bottomRefreshLocationButton;
}

// pickerView
- (MPMAttendencePickerView *)pickView {
    if (!_pickView) {
        _pickView = [[MPMAttendencePickerView alloc] init];
        _pickView.backgroundColor = kRedColor;
    }
    return _pickView;
}

- (CALayer *)bottomAnimateLayer {
    if (!_bottomAnimateLayer) {
        _bottomAnimateLayer = [CAShapeLayer layer];
        _bottomAnimateLayer.frame = CGRectMake(0, 0, 108, 108);
        _bottomAnimateLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 108, 108)].CGPath;
        _bottomAnimateLayer.fillColor = kMainBlueColor.CGColor;
        _bottomAnimateLayer.opacity = 0;
        _bottomAnimateLayer.position = CGPointMake(kScreenWidth / 2, 76);
        [_bottomAnimateLayer addAnimation:[self alpha] forKey:@"animate"];
    }
    return _bottomAnimateLayer;
}

- (CAKeyframeAnimation *)alpha {
    CAKeyframeAnimation *alpha = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alpha.delegate = self;
    alpha.values = @[@0.0000001,@0.5,@0.0000001];
    alpha.duration = 1.5;
    alpha.repeatCount = HUGE;
    alpha.autoreverses = NO;
    return alpha;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0f;
    }
    return _locationManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
