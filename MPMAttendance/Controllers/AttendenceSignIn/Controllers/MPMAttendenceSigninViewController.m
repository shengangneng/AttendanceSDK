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
// model
#import "MPMShareUser.h"
#import "MPMAttendenceModel.h"
#import "MPMAttendenceOneMonthModel.h"
#import "MPMSettingCardAddressWifiModel.h"


#define kViewBounds             (kScreenWidth / 7)
#define kMPMCalendarButtonTag   999
#define kAddressKeyPath         @"address"

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
@property (nonatomic, strong) UIButton *bottomLocationButton;
@property (nonatomic, strong) MPMCalendarButton *lastCalendarSelectedButton;
// pickerView
@property (nonatomic, strong) MPMAttendencePickerView *pickView;
// location
@property (nonatomic, strong) CLLocationManager *locationManager;
// timer
@property (nonatomic, strong) CADisplayLink *timer; /** 定时器：用于获取当前系统时间 */
// data
@property (nonatomic, copy) NSArray *attendenceArray;
@property (nonatomic, copy) NSArray *attendenceAddressArray;
@property (nonatomic, copy) NSArray *attendenceOneMonthArray;
@property (nonatomic, copy) NSArray *attendenceThreeMonthArray;
@property (nonatomic, assign) NSInteger brushDateCount;
@property (nonatomic, strong) NSDate *currentMiddleDate;
@property (nonatomic, assign) MKCoordinateRegion region;

@end

@implementation MPMAttendenceSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 签到按钮的layer动画
    [self.bottomView.layer insertSublayer:self.bottomAnimateLayer atIndex:0];
    [self setupLocation];
    [self.headerScrollView changeToCurrentWeekDate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 签到按钮的layer动画
    [self.bottomAnimateLayer removeFromSuperlayer];
    self.bottomAnimateLayer = nil;
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc {
    [[MPMShareUser shareUser] removeObserver:self forKeyPath:kAddressKeyPath];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self setupHeaderView];
    [self setupMiddleView];
    [self setupBottomView];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"考勤打卡";
    self.view.backgroundColor = kWhiteColor;
    [[MPMShareUser shareUser] addObserver:self forKeyPath:kAddressKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.headerDateView setDetailDate:[NSDateFormatter formatterDate:[NSDate date] withDefineFormatterType:forDateFormatTypeMonthYearDayWeek]];
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange:)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    // 刷新
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 sizeToFit];// 这句不能少，少了按钮就会消失了
    [rightButton1 setImage:ImageName(@"attendence_refresh") forState:UIControlStateNormal];
    [rightButton1 setImage:ImageName(@"attendence_refresh") forState:UIControlStateHighlighted];
    [rightButton1 addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    // 进去漏卡页面
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 sizeToFit];
    [rightButton2 setImage:ImageName(@"attendence_retroactive") forState:UIControlStateNormal];
    [rightButton2 setImage:ImageName(@"attendence_retroactive") forState:UIControlStateHighlighted];
    [rightButton2 addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightButton1],[[UIBarButtonItem alloc] initWithCustomView:rightButton2]];
    
    [self.bottomRoundButton addTarget:self action:@selector(signin:) forControlEvents:UIControlEventTouchUpInside];
    // TODO：地理位置，可以点击：用来矫正自己的位置
    //    [self.bottomLocationButton addTarget:self action:@selector(toMapView:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setupHeaderView {
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerDateView];
    [self.headerView addSubview:self.headerWeekView];
    
    // headerScrollView
    NSArray *week = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (NSInteger i = 0; i < week.count; i++) {
        UILabel *wl = [[UILabel alloc] initWithFrame:CGRectMake(i * kViewBounds, 0, kViewBounds, PX_H(50))];
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
    [self.bottomView addSubview:self.bottomLocationButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    // header
    [self.headerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.equalTo(@(PX_H(278)));
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
        make.leading.equalTo(self.middleTableView.mpm_leading).offset(29);
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
    [self.bottomLocationButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.view.mpm_bottom).offset(-15);
        make.centerX.equalTo(self.view.mpm_centerX);
        make.height.equalTo(@(17));
        make.leading.greaterThanOrEqualTo(self.view.mpm_leading).offset(30);
        make.trailing.greaterThanOrEqualTo(self.view.mpm_trailing).offset(-30);
    }];
}

- (void)getDataWithDate:(NSDate *)date {
    [self getAttendanceSigninDataWithDate:date];
    //    [self getOneMonthAttendanceDataWithDate:date];
    [self getThreeWeekDateWithDate:date];
}
/** 获取当前日期的签到信息 */
- (void)getAttendanceSigninDataWithDate:(NSDate *)date {
    NSString *dateString = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    NSString *url = [NSString stringWithFormat:@"%@schedulingSetting/getPunchTheClockTime?employeeId=%@&date=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,dateString,[MPMShareUser shareUser].token];
    NSDictionary *params = @{@"employeeId":[MPMShareUser shareUser].employeeId,@"date":dateString,@"token":[MPMShareUser shareUser].token};
    [[MPMSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
        if ([response[@"dataObj"] isKindOfClass:[NSDictionary class]]) {
            // 清空之前的数据
            self.attendenceAddressArray = nil;
            self.attendenceArray = nil;
            NSDictionary *dataObj = response[@"dataObj"];
            if ([dataObj[@"cardSettings"] isKindOfClass:[NSArray class]]) {
                NSArray *cardSettigns = dataObj[@"cardSettings"];
                NSMutableArray *tempAddress = [NSMutableArray arrayWithCapacity:cardSettigns.count];
                for (int i = 0; i < cardSettigns.count; i++) {
                    MPMSettingCardAddressWifiModel *address = [[MPMSettingCardAddressWifiModel alloc] initWithDictionary:cardSettigns[i]];
                    [tempAddress addObject:address];
                }
                self.attendenceAddressArray = tempAddress.copy;
            }
            
            if ([dataObj[@"employeeAttendances"] isKindOfClass:[NSArray class]]) {
                NSArray *attens = dataObj[@"employeeAttendances"];
                NSMutableArray *tempattens = [NSMutableArray arrayWithCapacity:attens.count];
                for (int i = 0; i < attens.count; i++) {
                    MPMAttendenceModel *model = [[MPMAttendenceModel alloc] initWithDictionary:attens[i]];
                    [tempattens addObject:model];
                }
                if (![NSDateFormatter isDate1:[NSDate date] beforeDate2:self.currentMiddleDate]) {
                    for (int i = 0; i < tempattens.count; i++) {
                        MPMAttendenceModel *model = tempattens[i];
                        // 如果没有attendanceId，那么就是等待刷卡状态
                        if (kIsNilString(model.attendanceId)) {
                            model.isNeedFirstBrush = YES;
                            break;
                        }
                    }
                }
                for (int i = 0; i < tempattens.count; i++) {
                    MPMAttendenceModel *model = tempattens[i];
                    if (i % 2 == 0) {
                        model.classType = @"上班";
                    } else {
                        model.classType = @"下班";
                    }
                    if (i == tempattens.count - 1) {
                        // 判断最后一个数据是否已有数据，如果已有数据，说明已经打完，不再允许打卡，按钮置灰(有数据，但是不是当前日期，也置灰）
                        if (!kIsNilString(model.attendanceId) || [NSDateFormatter isDate1:[NSDate date] beforeDate2:self.currentMiddleDate]) {
                            [self.bottomRoundButton setBackgroundImage:[UIImage getImageFromColor:kRGBA(184, 184, 184, 1)] forState:UIControlStateNormal];
                            [self.bottomRoundButton setBackgroundImage:[UIImage getImageFromColor:kRGBA(184, 184, 184, 1)] forState:UIControlStateHighlighted];
                            if (_bottomAnimateLayer) {
                                [_bottomAnimateLayer removeFromSuperlayer];
                                _bottomAnimateLayer = nil;
                            }
                        } else {
                            // 如果最后一个数据还没打，则按钮恢复
                            [self.bottomRoundButton setBackgroundImage:ImageName(@"attendence_roundbtn") forState:UIControlStateNormal];
                            [self.bottomRoundButton setBackgroundImage:ImageName(@"attendence_roundbtn") forState:UIControlStateHighlighted];
                            if (!_bottomAnimateLayer) {
                                [self.bottomView.layer insertSublayer:self.bottomAnimateLayer atIndex:0];
                            }
                        }
                    }
                }
                self.attendenceArray = tempattens;
            }
        } else if ([response[@"dataObj"] isKindOfClass:[NSArray class]]) {
            // 适配1.0版本的接口
            self.attendenceArray = nil;
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *tempattens = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                MPMAttendenceModel *model = [[MPMAttendenceModel alloc] initWithDictionary:dataObj[i]];
                [tempattens addObject:model];
            }
            self.attendenceArray = tempattens;
        }
        
        if (self.attendenceArray.count == 0) {
            [self.bottomRoundButton setBackgroundImage:[UIImage getImageFromColor:kRGBA(184, 184, 184, 1)] forState:UIControlStateNormal];
            [self.bottomRoundButton setBackgroundImage:[UIImage getImageFromColor:kRGBA(184, 184, 184, 1)] forState:UIControlStateHighlighted];
            if (_bottomAnimateLayer) {
                [_bottomAnimateLayer removeFromSuperlayer];
                _bottomAnimateLayer = nil;
            }
        }
        [self.middleTableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

// 获取前后共三周的数据
- (void)getThreeWeekDateWithDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSString *dateCurrentMonth = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    [comp setMonth:comp.day-7];
    NSDate *lastMonthDate = [cal dateFromComponents:comp];
    NSString *dateLastMonth = [NSDateFormatter formatterDate:lastMonthDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    [comp setMonth:comp.day+14];
    NSDate *nextMonthDate = [cal dateFromComponents:comp];
    NSString *dateNextMonth = [NSDateFormatter formatterDate:nextMonthDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    
    __block NSArray *lastMonthArray;
    __block NSArray *currentMonthArray;
    __block NSArray *nextMonthArray;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@attendanceStatus/getAttendanceStatusListYearWeek?queryDate=%@&token=%@",MPMHost,dateCurrentMonth,[MPMShareUser shareUser].token];
        [[MPMSessionManager shareManager] postRequestWithURL:url params:nil success:^(id response) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                [tempArr addObject:model];
            }
            currentMonthArray = tempArr.copy;
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@attendanceStatus/getAttendanceStatusListYearWeek?queryDate=%@&token=%@",MPMHost,dateLastMonth,[MPMShareUser shareUser].token];
        [[MPMSessionManager shareManager] postRequestWithURL:url params:nil success:^(id response) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                [tempArr addObject:model];
            }
            lastMonthArray = tempArr.copy;
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@attendanceStatus/getAttendanceStatusListYearWeek?queryDate=%@&token=%@",MPMHost,dateNextMonth,[MPMShareUser shareUser].token];
        [[MPMSessionManager shareManager] postRequestWithURL:url params:nil success:^(id response) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                [tempArr addObject:model];
            }
            nextMonthArray = tempArr.copy;
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, kMainQueue, ^{
        if (lastMonthArray.count > 0 && currentMonthArray.count > 0 && nextMonthArray.count > 0) {
            [self.headerScrollView reloadLast:lastMonthArray current:currentMonthArray next:nextMonthArray];
        }
    });
}

/** 获取当前月份+前一个月份+后一个月份数据 */
- (void)getThreeMonthDateWithDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSString *dateCurrentMonth = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    [comp setMonth:comp.month-1];
    NSDate *lastMonthDate = [cal dateFromComponents:comp];
    NSString *dateLastMonth = [NSDateFormatter formatterDate:lastMonthDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    [comp setMonth:comp.month+2];
    NSDate *nextMonthDate = [cal dateFromComponents:comp];
    NSString *dateNextMonth = [NSDateFormatter formatterDate:nextMonthDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
    
    __block NSArray *lastMonthArray;
    __block NSArray *currentMonthArray;
    __block NSArray *nextMonthArray;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@attendanceStatus/getExchangeWorkByApprover?employeeId=%@&date=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,dateCurrentMonth,[MPMShareUser shareUser].token];
        NSDictionary *params = @{@"employeeId":[MPMShareUser shareUser].employeeId,@"date":dateCurrentMonth,@"token":[MPMShareUser shareUser].token};
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                [tempArr addObject:model];
            }
            currentMonthArray = tempArr.copy;
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@attendanceStatus/getExchangeWorkByApprover?employeeId=%@&date=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,dateLastMonth,[MPMShareUser shareUser].token];
        NSDictionary *params = @{@"employeeId":[MPMShareUser shareUser].employeeId,@"date":dateLastMonth,@"token":[MPMShareUser shareUser].token};
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                [tempArr addObject:model];
            }
            lastMonthArray = tempArr.copy;
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
        NSString *url = [NSString stringWithFormat:@"%@attendanceStatus/getExchangeWorkByApprover?employeeId=%@&date=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,dateNextMonth,[MPMShareUser shareUser].token];
        NSDictionary *params = @{@"employeeId":[MPMShareUser shareUser].employeeId,@"date":dateNextMonth,@"token":[MPMShareUser shareUser].token};
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
            NSArray *dataObj = response[@"dataObj"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:dataObj.count];
            for (int i = 0; i < dataObj.count; i++) {
                NSDictionary *dic = dataObj[i];
                MPMAttendenceOneMonthModel *model = [[MPMAttendenceOneMonthModel alloc] initWithDictionary:dic];
                [tempArr addObject:model];
            }
            nextMonthArray = tempArr.copy;
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            DLog(@"%@",error);
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, kMainQueue, ^{
        NSMutableArray *temp = [NSMutableArray arrayWithArray:lastMonthArray];
        [temp addObjectsFromArray:currentMonthArray];
        [temp addObjectsFromArray:nextMonthArray];
        if (temp.count > 0) {
            self.attendenceThreeMonthArray = temp.copy;
            [self.headerScrollView reloadData:self.attendenceThreeMonthArray];
        }
    });
}

#pragma mark - Private Method
/** 计算两个位置的距离 */
- (double)getDistanceWithLocation:(CLLocation *)loc1 location:(CLLocation *)loc2 {
    return [loc1 distanceFromLocation:loc2];
}

- (void)setupLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Target Action

- (void)right:(UIButton *)sender {
    MPMRepairSigninViewController *rs = [[MPMRepairSigninViewController alloc] init];
    [self.navigationController pushViewController:rs animated:YES];
}

- (void)refresh:(UIButton *)sender {
    [self.headerScrollView changeToCurrentWeekDate];
    [self setupLocation];
}

- (void)backToCurrentDate:(UIButton *)sender {
    DLog(@"回到当前日期");
    [self.headerScrollView changeToCurrentWeekDate];
}

- (void)signin:(UIButton *)sender {
    DLog(@"签到");
    
    // 有考勤地址，需要判断考勤距离是否在范围内。没有考勤地址，则让它进行请求
    BOOL canSign = NO;
    NSString *alertMessage = @"当前无法签到";
    // TODO：签到之前需要判断用户是否已经定位。如果用户没有完成定位或者没有
    if (![MPMShareUser shareUser].location) {
        alertMessage = @"请先完成定位再进行打卡，如果当前没有开启定位，请在手机“设置”中开启";
    } else {
        if (self.attendenceAddressArray.count > 0) {
            for (MPMSettingCardAddressWifiModel *model in self.attendenceAddressArray) {
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:model.latitude.doubleValue longitude:model.longitude.doubleValue];
                CLLocation *myLoc = [MPMShareUser shareUser].location;
                double distance = [loc distanceFromLocation:myLoc];
                DLog(@"===当前位置与考勤地点的距离是：%.f===",distance);
                if (distance <= fabs(model.deviation.doubleValue)) {
                    // 如果发现我的地址在考勤地址库中的其中一个并且在考勤范围内，那么就允许签到
                    canSign = YES;
                }
            }
            if (!canSign) {
                alertMessage = @"当前位置不在考勤范围内，不允许考勤";
            }
        } else {
            canSign = YES;
        }
    }
    if (canSign) {
        [self signForEarly:NO];
    } else {
        [self showAlertControllerToLogoutWithMessage:alertMessage sureAction:nil needCancleButton:NO];
    }
}

- (void)signForEarly:(BOOL)early {
    
    BOOL hasSignAll = NO;
    MPMAttendenceModel *signModel;
    for (int i = 0; i < self.attendenceArray.count; i++) {
        MPMAttendenceModel *model = self.attendenceArray[i];
        // 筛选出需要打卡的model
        if (model.isNeedFirstBrush) {
            signModel = model;
            break;
        }
        if (i == self.attendenceArray.count - 1 && !kIsNilString(model.attendanceId)) {
            hasSignAll = YES;
        }
    }
    
    if (hasSignAll) {
        [self showAlertControllerToLogoutWithMessage:@"考勤已打满，无需打卡" sureAction:nil needCancleButton:NO];return;
    }
    
    NSDate *bursh = self.currentMiddleDate ? [NSDate changeToFitJavaDate:self.currentMiddleDate] : [NSDate changeToFitJavaDate:[NSDate date]];
    DLog(@"打卡时间 == %@",bursh);
    NSString *url = [NSString stringWithFormat:@"%@attend/insert?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSString *address = kSafeString([MPMShareUser shareUser].address);
    NSString *brushDate = [NSDateFormatter formatterDate:bursh withDefineFormatterType:forDateFormatTypeSpecial];
    NSString *brushDateCount = [NSString stringWithFormat:@"%ld",self.attendenceArray.count + 1];
    NSString *employeeId = [MPMShareUser shareUser].employeeId;
    NSString *status = @"0";
    NSString *type = kSafeString(signModel.type);
    NSString *schedulingEmployeeId = kSafeString(signModel.schedulingEmployeeId);
    NSString *schedulingEmployeeType = kSafeString(signModel.schedulingEmployeeType);
    NSString *signType = kSafeString(signModel.type);// 0代表上班 1代表下班 使用接口传给我们的就好了（感觉传空也可以）
    NSDictionary *params;
    if (early) {
        params = @{@"address":address,@"brushDate":brushDate,@"brushDateCount":brushDateCount,@"employeeId":employeeId,@"status":status,@"type":type,@"early":@1,@"schedulingEmployeeId":schedulingEmployeeId,@"schedulingEmployeeType":schedulingEmployeeType,@"signType":signType};
    } else {
        params = @{@"address":address,@"brushDate":brushDate,@"brushDateCount":brushDateCount,@"employeeId":employeeId,@"status":status,@"type":type,@"schedulingEmployeeId":schedulingEmployeeId,@"schedulingEmployeeType":schedulingEmployeeType,@"signType":signType};
    }
    [MPMProgressHUD showWithStatus:@"正在打卡"];
    
    [[MPMSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
        [MPMProgressHUD dismiss];
        DLog(@"%@",response);
        id dataObj = response[@"dataObj"];
        if ([dataObj isKindOfClass:[NSNull class]] || ([dataObj isKindOfClass:[NSArray class]] && ((NSArray *)dataObj).count == 0)) {
            [MPMProgressHUD showErrorWithStatus:response[@"message"]];
        } else {
            [self getDataWithDate:[NSDate date]];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        if ([error containsString:@"早退"]) {
            [MPMProgressHUD dismiss];
            __weak typeof (self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:error sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                [strongself signForEarly:YES];
            } needCancleButton:YES];
        } else {
            [MPMProgressHUD showErrorWithStatus:error];
        }
    }];
}

/** 定时器 */
- (void)timeChange:(id)sender {
    NSString *str = [NSDateFormatter formatterDate:[NSDate date] withDefineFormatterType:forDateFormatTypeHourMinute];
    [self.bottomRoundButton setTitle:str forState:UIControlStateNormal];
    [self.bottomRoundButton setTitle:str forState:UIControlStateHighlighted];
}

- (void)toMapView:(UIButton *)sender {
    MPMAttendenceMapViewController *map = [[MPMAttendenceMapViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:map animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Notification
- (void)appResignActive:(NSNotification *)noti {
    [self.bottomAnimateLayer removeFromSuperlayer];
    self.bottomAnimateLayer = nil;
    [self.timer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)appBecomeActive:(NSNotification *)noti {
    [self.bottomView.layer insertSublayer:self.bottomAnimateLayer atIndex:0];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    // 如果最后一个打卡数据不为空，或者当前时间不是今天，置灰打卡按钮
    if (self.attendenceArray.count > 0) {
        MPMAttendenceModel *model = self.attendenceArray.lastObject;
        if (!kIsNilString(model.attendanceId) || [NSDateFormatter isDate1:[NSDate date] beforeDate2:self.currentMiddleDate]) {
            [self.bottomAnimateLayer removeFromSuperlayer];
            self.bottomAnimateLayer = nil;
        }
    } else if (self.attendenceArray.count == 0) {
        [self.bottomAnimateLayer removeFromSuperlayer];
        self.bottomAnimateLayer = nil;
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"address"]) {
        NSString *detailText;
        if ([MPMShareUser shareUser].address) {
            detailText = [NSString stringWithFormat:@"地理位置:%@",[MPMShareUser shareUser].address];
            self.bottomLocationButton.selected = YES;
            [self.bottomLocationButton setTitle:detailText forState:UIControlStateNormal];
            [self.bottomLocationButton setTitle:detailText forState:UIControlStateSelected];
        } else {
            detailText = @"地理位置:";
            self.bottomLocationButton.selected = NO;
            [self.bottomLocationButton setTitle:detailText forState:UIControlStateNormal];
            [self.bottomLocationButton setTitle:detailText forState:UIControlStateSelected];
        }
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
    
    MKCoordinateSpan span;
    // 设置经度的缩放级别
    span.longitudeDelta = 0.05;
    // 设置纬度的缩放级别
    span.latitudeDelta = 0.05;
    // 反向编码部分
    self.region = MKCoordinateRegionMake(newLocation.coordinate, span);
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark * placeMark = placemarks[0];
            [MPMShareUser shareUser].address = [NSString stringWithFormat:@"%@%@%@",placeMark.locality,placeMark.subLocality,placeMark.thoroughfare];
            CLLocationCoordinate2D convert = [JZLocationConverter wgs84ToGcj02:newLocation.coordinate];
            [MPMShareUser shareUser].location = [[CLLocation alloc] initWithLatitude:convert.latitude longitude:convert.longitude];
        } else if (error == nil && placemarks.count == 0) {
            [MPMShareUser shareUser].address = nil;
            [MPMShareUser shareUser].location = nil;
            DLog(@"没有找到地址");
        } else if (error) {
            [MPMShareUser shareUser].address = nil;
            [MPMShareUser shareUser].location = nil;
            DLog(@"定位错误==%@",error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [MPMShareUser shareUser].address = nil;
    [MPMShareUser shareUser].location = nil;
    DLog(@"定位失败==%@",error);
}

#pragma mark - MPMScrollViewDelegate
- (void)mpmCalendarScrollViewDidChangeYearMonth:(NSString *)yearMonth currentMiddleDate:(NSDate *)date {
    [self.headerDateView setDetailDate:yearMonth];
    self.currentMiddleDate = date;
    [self getDataWithDate:date];
}

#pragma mark - UITableViewDelegate && UITableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.attendenceArray.count > 0) {
        self.noMessageView.hidden = YES;
        self.tableViewLine.hidden = NO;
    } else {
        self.noMessageView.hidden = NO;
        self.tableViewLine.hidden = YES;
    }
    return self.attendenceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CalendarCell";
    MPMAttendenceModel *model = self.attendenceArray[indexPath.row];
    MPMAttendenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MPMAttendenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDate *tt = [NSDate dateWithTimeIntervalSince1970:model.fillCardTime.integerValue/1000];
    NSString *time = [NSDateFormatter formatterDate:tt withDefineFormatterType:forDateFormatTypeHourMinute];
    cell.timeLabel.text = time;
    cell.classTypeLabel.text = model.classType;
    if (model.isNeedFirstBrush) {
        cell.accessaryIcon.hidden = YES;
        cell.contentImageView.hidden = YES;
        cell.statusImageView.image = nil;
        cell.messageLabel.text = @"";
        cell.messageTimeLabel.text = @"";
        [cell.scoreButton setTitle:@"" forState:UIControlStateNormal];
        [cell.scoreButton setBackgroundImage:nil forState:UIControlStateNormal];
        cell.waitBrushLabel.hidden = NO;
        cell.classTypeLabel.textColor = kMainBlueColor;
        cell.timeLabel.textColor = kMainBlueColor;
        return cell;
    } else if (model.status.length == 0) {
        cell.accessaryIcon.hidden = YES;
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
        return cell;
    } else {
        cell.waitBrushLabel.hidden = YES;
        cell.accessaryIcon.hidden = NO;
        cell.contentImageView.hidden = NO;
        cell.textLabel.text = @"";
        cell.classTypeLabel.textColor = kMainLightGray;
        cell.timeLabel.textColor = kMainLightGray;
    }
    // 状态及图片
    if (model.status.integerValue == 0) {
        cell.statusImageView.image = ImageName(@"attendence_finish");
        cell.messageLabel.text = @"正常";
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
        cell.messageLabel.text = @"正常";
    } else if (model.status.integerValue == 6) {
        cell.statusImageView.image = ImageName(@"attendence_vacate");
        cell.messageLabel.text = @"加班";
    }
    // 加减分
    if (kIsNilString(model.integral)) {
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
    // 弹出选中处理页面：例外申请、改签
    MPMAttendenceModel *model = self.attendenceArray[indexPath.row];
    if (model.status.length == 0) {
    } else {
        NSArray *pickerData;
        if (model.status.integerValue == 3) {
            // 漏卡
            pickerData = @[@"例外申请",@"补签"];
        } else {
            pickerData = @[@"例外申请",@"改签"];
        }
        [self.pickView showInView:kAppDelegate.window withPickerData:pickerData selectRow:0];
        __weak typeof(self) weakself = self;
        self.pickView.completeSelectBlock = ^(NSString *data) {
            __strong typeof(weakself) strongself = weakself;
            CausationType type;
            NSString *typeStatus;
            MPMDealingModel *dealingModel = [[MPMDealingModel alloc] init];
            if ([data isEqualToString:@"例外申请"]) {
                // 例外申请
                type = forCausationTypeExcetionApply;
                typeStatus = @"2";
            } else if ([data isEqualToString:@"补签"]) {
                // 补签
                type = forCausationTypeRepairSign;
                typeStatus = @"1";
                dealingModel.attendenceId = model.attendanceId;
            } else {
                // 改签
                type = forCausationTypeChangeSign;
                typeStatus = @"0";
                dealingModel.attendenceId = model.attendanceId;
            }
            
            dealingModel.oriAttendenceDate = [NSString stringWithFormat:@"%.f",(model.fillCardDate.doubleValue + model.fillCardTime.doubleValue)/1000+28800];
            dealingModel.attendenceDate = [NSString stringWithFormat:@"%.f",(model.brushDate.doubleValue + model.brushTime.doubleValue)/1000+28800];
            dealingModel.status = model.status;
            dealingModel.brushDate = model.brushDate;
            dealingModel.brushTime = model.brushTime;
            dealingModel.type = model.type;
            MPMBaseDealingViewController *dealing = [[MPMBaseDealingViewController alloc] initWithDealType:type typeStatus:typeStatus dealingModel:dealingModel dealingFromType:kDealingFromTypeChangeRepair];
            strongself.hidesBottomBarWhenPushed = YES;
            [strongself.navigationController pushViewController:dealing animated:YES];
            strongself.hidesBottomBarWhenPushed = NO;
        };
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

- (UIScrollView *)headerScrollView {
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
        _middleTableView.rowHeight = 60;
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

- (UIButton *)bottomLocationButton {
    if (!_bottomLocationButton) {
        _bottomLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomLocationButton setImage:ImageName(@"attendence_location_small") forState:UIControlStateNormal];
        [_bottomLocationButton setImage:ImageName(@"attendence_location_small") forState:UIControlStateSelected];
        [_bottomLocationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
        [_bottomLocationButton setTitle:@"地理位置:" forState:UIControlStateNormal];
        [_bottomLocationButton setTitle:@"地理位置:" forState:UIControlStateSelected];
        _bottomLocationButton.titleLabel.font = SystemFont(13);
        [_bottomLocationButton sizeToFit];
        [_bottomLocationButton setTitleColor:kMainLightGray forState:UIControlStateNormal];
        [_bottomLocationButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
    }
    return _bottomLocationButton;
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
        CAKeyframeAnimation *alpha = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        alpha.delegate = self;
        alpha.values = @[@0.0000001,@0.5,@0.0000001];
        alpha.duration = 1.5;
        alpha.repeatCount = HUGE;
        alpha.autoreverses = NO;
        [_bottomAnimateLayer addAnimation:alpha forKey:@"animate"];
    }
    return _bottomAnimateLayer;
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
