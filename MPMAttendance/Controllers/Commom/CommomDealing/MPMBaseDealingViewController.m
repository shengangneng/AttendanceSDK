//
//  MPMBaseDealingViewController.m
//  MPMAtendence
//  通用的处理页面
//  Created by gangneng shen on 2018/5/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseDealingViewController.h"
#import "MPMCommomDealingTableViewCell.h"
#import "MPMAttendencePickerView.h"
#import "MPMButton.h"
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMCustomDatePickerView.h"
#import "MPMCommomDealingReasonTableViewCell.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMAttendencePickerTypeModel.h"
#import "MPMCommomGetPeopleViewController.h"
#import "MPMTableHeaderView.h"
#import "MPMGetPeopleModel.h"
#import "MPMCommomDealingGetPeopleTableViewCell.h"
#import "MPMCommomDealingAddCellTableViewCell.h"
#import "MPMCausationDetailModel.h"
#import "NSMutableArray+MPMExtention.h"

@interface MPMBaseDealingViewController () <UITableViewDelegate, UITableViewDataSource, MPMAttendencePickerViewDelegate, UIScrollViewDelegate>

// tableview
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSaveButton;
@property (nonatomic, strong) UIButton *bottomSubmitButton;

// pickerView
@property (nonatomic, strong) MPMAttendencePickerView *pickerView;          /** 数据选择器 */
@property (nonatomic, strong) MPMCustomDatePickerView *customDatePickerView;/** 时间选择器 */
// type
@property (nonatomic, assign) CausationType causationType;
@property (nonatomic, copy) NSString *typeStatus;
// data
@property (nonatomic, copy) NSArray *tableViewTitleArray;
@property (nonatomic, copy) NSArray *pickerFirstData;
@property (nonatomic, strong) MPMDealingModel *dealingModel;
@property (nonatomic, assign) DealingFromType dealingFromType;
@property (nonatomic, assign) NSInteger addCount;       /** 记录增加明细的数量 */

@property (nonatomic, assign) BOOL mpm_copyNameNeedFold;/** 是否需要折叠起来 */
@property (nonatomic, copy) NSString *monthDealingCount;/** 记录当月处理次数 */
@property (nonatomic, assign) BOOL needTwoRequest;      /** 有些页面需要请求两个接口，有些页面只需要请求一个接口 */

@end

@implementation MPMBaseDealingViewController

- (instancetype)initWithDealType:(CausationType)type typeStatus:(NSString *)typeStatus dealingModel:(MPMDealingModel *)dealingModel dealingFromType:(DealingFromType)fromType {
    self = [super init];
    if (self) {
        self.needTwoRequest = NO;
        self.causationType = type;
        self.typeStatus = typeStatus;
        self.dealingFromType = fromType;
        if (dealingModel) {
            self.dealingModel = dealingModel;
        } else {
            self.dealingModel = [[MPMDealingModel alloc] init];
        }
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *twoUrl;
    NSDictionary *twoParams;
    NSString *number = (self.dealingFromType == kDealingFromTypeApply) ? @"1" : @"-1";
    NSString *status = @"6";// 不明白这个什么意思
    if (self.dealingFromType == kDealingFromTypeEditing) {
        // 编辑，已经有数据了
        self.addCount = self.dealingModel.causationDetail.count;
        for (int i = 0; i < 3-self.addCount; i++) {
            // 如果causationDetail数组不足3个，需要凑够3个。
            [self.dealingModel.causationDetail addObject:[[MPMCausationDetailModel alloc] init]];
        }
        self.pickerFirstData = @[kSausactionType[[NSString stringWithFormat:@"%ld",self.causationType]]];
        self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
        [self.tableView reloadData];
        return;
    } else if (self.dealingFromType == kDealingFromTypeApply) {
        // 例外申请
        self.addCount = 1;
        if (self.causationType == forCausationTypeevecation) {
            self.pickerFirstData = @[@"出差"];
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
        } else if (self.causationType == forCausationTypeOverTime) {
            self.pickerFirstData = @[@"加班"];
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
        } else if (self.causationType == forCausationTypeOut) {
            self.pickerFirstData = @[@"外出"];
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
        } else {
            self.needTwoRequest = YES;
            twoUrl = [NSString stringWithFormat:@"%@causationtype/getList?token=%@",MPMHost,[MPMShareUser shareUser].token];
            twoParams = @{@"token":[MPMShareUser shareUser].token};
        }
    } else if (self.dealingFromType == kDealingFromTypeChangeRepair) {
        // 打卡页面例外申请、改签、补签
        self.addCount = 0;
        if (self.causationType == forCausationTypeChangeSign) {
            self.pickerFirstData = @[@"改签"];
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
        } else if (self.causationType == forCausationTypeRepairSign) {
            self.pickerFirstData = @[@"补签"];
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
        } else {
            self.needTwoRequest = YES;
            twoUrl = [NSString stringWithFormat:@"%@attendanceType/getInfo?typeStatus=%@&token=%@",MPMHost,self.typeStatus,[MPMShareUser shareUser].token];
            twoParams = @{@"typeStatus":self.typeStatus,@"token":[MPMShareUser shareUser].token};
        }
    }
    
    if (self.needTwoRequest) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
            [[MPMSessionManager shareManager] postRequestWithURL:twoUrl params:twoParams loadingMessage:@"正在加载" success:^(id response) {
                NSArray *arr = response[@"dataObj"];
                DLog(@"%@",arr);
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arr.count];
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    MPMAttendencePickerTypeModel *model = [[MPMAttendencePickerTypeModel alloc] initWithDictionary:dic];
                    if (model.attendanceNo.integerValue == 13 || model.causationtypeNo.integerValue == 2) {
                        // TODO 先手动筛除调班‘13’、请假‘2’
                        continue;
                    }
                    [temp addObject:model.type];
                }
                self.pickerFirstData = temp.copy;
                self.causationType = ((NSString *)kSausactionNo[self.pickerFirstData.firstObject]).integerValue;
                self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
                dispatch_group_leave(group);
            } failure:^(NSString *error) {
                DLog(@"%@",error);
                dispatch_group_leave(group);
            }];
        });
        dispatch_group_enter(group);
        dispatch_group_async(group, kGlobalQueueDEFAULT, ^{
            // 获取当月处理次数
            NSString *month = self.dealingModel.brushTime ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.brushDate.integerValue/1000 + 28800] withDefineFormatterType:forDateFormatTypeYearMonthBar] : [NSDateFormatter formatterDate:[NSDate date] withDefineFormatterType:forDateFormatTypeYearMonthBar];
            NSString *url = [NSString stringWithFormat:@"%@causation/getApproveNumber?employeeId=%@&month=%@&status=%@&number=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,month,status,number,[MPMShareUser shareUser].token];
            [[MPMSessionManager shareManager] getRequestWithURL:url params:nil success:^(id response) {
                if (response[@"dataObj"] && [response[@"dataObj"] isKindOfClass:[NSNumber class]]) {
                    self.monthDealingCount = [NSString stringWithFormat:@"%@",response[@"dataObj"]];
                }
                dispatch_group_leave(group);
            } failure:^(NSString *error) {
                DLog(@"%@",error);
                dispatch_group_leave(group);
            }];
        });
        dispatch_group_notify(group, kMainQueue, ^{
            [self.tableView reloadData];
        });
    } else {
        NSString *month = self.dealingModel.brushTime ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.brushDate.integerValue/1000 + 28800] withDefineFormatterType:forDateFormatTypeYearMonthBar] : [NSDateFormatter formatterDate:[NSDate date] withDefineFormatterType:forDateFormatTypeYearMonthBar];
        NSString *url = [NSString stringWithFormat:@"%@causation/getApproveNumber?employeeId=%@&month=%@&status=%@&number=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,month,status,number,[MPMShareUser shareUser].token];
        [[MPMSessionManager shareManager] getRequestWithURL:url params:nil success:^(id response) {
            if (response[@"dataObj"] && [response[@"dataObj"] isKindOfClass:[NSNumber class]]) {
                self.monthDealingCount = [NSString stringWithFormat:@"%@",response[@"dataObj"]];
            }
            [self.tableView reloadData];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = kSausactionType[[NSString stringWithFormat:@"%ld",self.causationType]];
    self.mpm_copyNameNeedFold = YES;
    [self.bottomSaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomSubmitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(left:)];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomSaveButton];
    [self.bottomView addSubview:self.bottomSubmitButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
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
    if (self.dealingFromType == kDealingFromTypeApply) {
        [self.bottomSaveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomView.mas_leading).offset(PX_H(23));
            make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomSubmitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomSaveButton.mas_trailing).offset(PX_H(23));
            make.trailing.equalTo(self.bottomView.mas_trailing).offset(-PX_H(23));
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
    } else {
        [self.bottomSubmitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomView.mas_leading).offset(PX_H(23));
            make.trailing.equalTo(self.bottomView.mas_trailing).offset(-PX_H(23));
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
    }
}

#pragma mark - Target Action
- (void)left:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 保存 */
- (void)save:(UIButton *)sender {
    [self requestWithSubmitNumber:@"0"];
}

/** 提交 */
- (void)submit:(UIButton *)sender {
    [self requestWithSubmitNumber:@"1"];
}

#pragma mark - Private Method
/**
 * submitNumber:保存0、提交1
 */
- (void)requestWithSubmitNumber:(NSString *)submitNumber {
    NSString *url;
    NSDictionary *params;
    if (self.causationType == forCausationTypeChangeSign || self.causationType == forCausationTypeRepairSign) {
        if (kIsNilString(self.dealingModel.attendenceDate)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择签到时间" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.remark)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入处理理由" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.nowApproval) || kIsNilString(self.dealingModel.nowApprovalId)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择审批人" sureAction:nil needCancleButton:NO];
            return;
        }
        // 改签、补签
        url = [NSString stringWithFormat:@"%@RetroactiveOrResign/updataOrSave?token=%@",MPMHost,[MPMShareUser shareUser].token];
        NSString *approveId = [MPMShareUser shareUser].employeeId;
        NSString *approveName = [MPMShareUser shareUser].employeeName;
        // 抄送人-可以不选
        NSString *copyName = self.dealingModel.mpm_copyName;
        NSString *copyNameId = self.dealingModel.mpm_copyNameId;
        // 审批人-不能为空
        NSString *nowApprove = self.dealingModel.nowApproval;
        NSString *nowApproveId = self.dealingModel.nowApprovalId;
        
        NSString *status = @"1";
        // 0上班 1下班
        NSString *dealingType = [NSString stringWithFormat:@"%@",@(self.causationType)];
        // 处理理由-不能为空
        NSString *remark = self.dealingModel.remark;
        // 修改后的时间
        NSString *attendanceDate = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.attendenceDate.doubleValue - 28800] withDefineFormatterType:forDateFormatTypeSpecial];
        
        // 实际打卡时间（时间戳）(改签才需要）
        NSString *attendanceTime = [NSString stringWithFormat:@"%.f",self.dealingModel.brushDate.doubleValue + self.dealingModel.brushTime.doubleValue + 28800000];
        // 考勤节点时间（时间戳）(改签才需要）
        NSString *schedulingDate = [NSString stringWithFormat:@"%.f",self.dealingModel.oriAttendenceDate.doubleValue*1000];
        NSDictionary *attendance;
        {
            NSString *address = [MPMShareUser shareUser].address;
            NSString *attendanceId = self.dealingModel.attendenceId;// 考勤ID：选中的补签处理类型id
            NSString *brushDate = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.attendenceDate.integerValue - 28800] withDefineFormatterType:forDateFormatTypeSpecial];// 处理签到日期
            NSString *brushTime = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.attendenceDate.integerValue - 28800] withDefineFormatterType:forDateFormatTypeSpecial];// 处理签到时间
            NSString *attenDate = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.attendenceDate.integerValue - 28800] withDefineFormatterType:forDateFormatTypeSpecial];// 考勤节点时间
            NSString *shiftName = self.dealingModel.type;
            NSString *employeeId = [MPMShareUser shareUser].employeeId;
            NSString *signType = dealingType;   // 签到类型：改签、补签
            NSString *source = @"1";    // 来源0安卓、1iOS、2pc、3考勤机
            NSString *status = @"0";    // 该次打卡的状态：0正常、1异常
            NSString *type = self.dealingModel.type;       // 考勤类型：0上班，1下班
            NSNumber *early = @1;
            attendance = @{@"address":kSafeString(address),
                           @"attendanceId":kSafeString(attendanceId),
                           @"brushDate":kSafeString(brushDate),
                           @"brushTime":kSafeString(brushTime),
                           @"attendanceDate":kSafeString(attenDate),
                           @"checkCode":@"",
                           @"createTime":@"",
                           @"employeeId":kSafeString(employeeId),
                           @"remark":@"",
                           @"shiftName":shiftName,
                           @"signType":kSafeString(signType),
                           @"source":source,
                           @"status":status,
                           @"type":kSafeString(type),
                           @"early":early
                           };
        }
        params = @{@"approveId":kSafeString(approveId),
                   @"approveName":kSafeString(approveName),
                   @"copyName":kSafeString(copyName),
                   @"copyNameId":kSafeString(copyNameId),
                   @"nowApprove":kSafeString(nowApprove),
                   @"nowApproveId":kSafeString(nowApproveId),
                   @"status":kSafeString(status),
                   @"type":kSafeString(dealingType),
                   @"remark":kSafeString(remark),
                   @"attendanceDate":kSafeString(attendanceDate),
                   @"attendanceTime":kSafeString(attendanceTime),
                   @"schedulingDate":kSafeString(schedulingDate),
                   @"attendance":attendance,
                   };
    } else if (self.causationType == forCausationTypeChangeClass) {
        // 调班
        if (kIsNilString(self.dealingModel.originalDate)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择调班日期" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.originalClassName)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择原班次" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.mpm_newDate)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择新调班日期" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.mpm_newClassName)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择新班次" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.remark)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入处理理由" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.nowApproval) || kIsNilString(self.dealingModel.nowApprovalId)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择审批人" sureAction:nil needCancleButton:NO];
            return;
        }
        url = [NSString stringWithFormat:@"%@exchangeWorkOpreation/launch?token=%@",MPMHost,[MPMShareUser shareUser].token];
        NSString *approveId = @"1";
        NSString *copyName = self.dealingModel.mpm_copyName;
        NSString *copyNameId = self.dealingModel.mpm_copyNameId;
        NSString *nowApprove = self.dealingModel.nowApproval;
        NSString *nowApproveId = self.dealingModel.nowApprovalId;
        NSString *reason = self.dealingModel.remark;
        NSMutableArray *details = [NSMutableArray array];
        {
            // TODO:applicant不知道是什么意思
            NSString *applicant = @"";
            NSString *newClass = self.dealingModel.mpm_newClassName;
            NSString *originalClass = self.dealingModel.originalClassName;
            NSString *newDate = self.dealingModel.mpm_newDate;
            NSString *originalDate = self.dealingModel.originalDate;
            [details addObject: @{
                                  @"applicant":applicant,
                                  @"newClass":kSafeString(newClass),
                                  @"originalClass":kSafeString(originalClass),
                                  @"newDate":kSafeString(newDate),
                                  @"originalDate":kSafeString(originalDate),
                                  }];
        }
        params = @{
                   @"approveId":kSafeString(approveId),
                   @"copyName":kSafeString(copyName),
                   @"copyNameId":kSafeString(copyNameId),
                   @"nowApprove":kSafeString(nowApprove),
                   @"nowApproveId":kSafeString(nowApproveId),
                   @"reason":kSafeString(reason),
                   @"details":details,
                   };
    } else {
        url = [NSString stringWithFormat:@"%@causation/getListByEmpId?token=%@",MPMHost,[MPMShareUser shareUser].token];
        // 其他
        NSInteger index = (self.addCount == 0 ? 1 : self.addCount) - 1;
        BOOL needAlert = NO;
        // 验证出差地点
        if (self.causationType == forCausationTypeevecation) {
            if (index == 0) {
                if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).address)) {
                    needAlert = YES;
                }
            } else if (index == 1) {
                if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).address)
                    || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).address)) {
                    needAlert = YES;
                }
            } else if (index == 2) {
                if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).address)
                    || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).address)
                    || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[2]).address)) {
                    needAlert = YES;
                }
            }
            if (needAlert) {
                [self showAlertControllerToLogoutWithMessage:@"请输入出差地点" sureAction:nil needCancleButton:NO];
                return;
            }
        }
        // 验证开始时间
        if (index == 0) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).startDate)) {
                needAlert = YES;
            }
        } else if (index == 1) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).startDate)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).startDate)) {
                needAlert = YES;
            }
        } else if (index == 2) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).startDate)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).startDate)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[2]).startDate)) {
                needAlert = YES;
            }
        }
        if (needAlert) {
            [self showAlertControllerToLogoutWithMessage:@"请选择开始时间" sureAction:nil needCancleButton:NO];
            return;
        }
        
        // 验证结束时间
        if (index == 0) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).endDate)) {
                needAlert = YES;
            }
        } else if (index == 1) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).endDate)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).endDate)) {
                needAlert = YES;
            }
        } else if (index == 2) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).endDate)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).endDate)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[2]).endDate)) {
                needAlert = YES;
            }
        }
        if (needAlert) {
            [self showAlertControllerToLogoutWithMessage:@"请选择结束时间" sureAction:nil needCancleButton:NO];
            return;
        }
        
        // 验证输入时长
        if (index == 0) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).days)) {
                needAlert = YES;
            }
        } else if (index == 1) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).days)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).days)) {
                needAlert = YES;
            }
        } else if (index == 2) {
            if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[0]).days)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[1]).days)
                || kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[2]).days)) {
                needAlert = YES;
            }
        }
        if (needAlert) {
            [self showAlertControllerToLogoutWithMessage:@"请输入时长" sureAction:nil needCancleButton:NO];
            return;
        }
        
        if (kIsNilString(self.dealingModel.remark)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入处理原因" sureAction:nil needCancleButton:NO];
            return;
        }
        if (kIsNilString(self.dealingModel.nowApproval) || kIsNilString(self.dealingModel.nowApprovalId)) {
            [self showAlertControllerToLogoutWithMessage:@"请选择审批人" sureAction:nil needCancleButton:NO];
            return;
        }
        NSString *copyName = self.dealingModel.mpm_copyName;
        NSString *copyNameId = self.dealingModel.mpm_copyNameId;
        NSString *nowApprove = self.dealingModel.nowApproval;
        NSString *nowApproveId = self.dealingModel.nowApprovalId;
        NSMutableArray *causationDetail = [NSMutableArray array];
        {
            for (MPMCausationDetailModel *mo in self.dealingModel.causationDetail) {
                // 如果时间为空，则说明这个是空数据
                if (kIsNilString(mo.days)) continue;
                NSString *causationId = kIsNilString(mo.attendenceId) ? @"-1" : mo.attendenceId;
                // 后台需要前端计算最初的时间start和最后的时间end给他计算加减分
                double startValue = mo.startDate.doubleValue + mo.startTime.doubleValue + 28800000;
                NSString *start = [NSString stringWithFormat:@"%.0f",startValue];
                double endValue = mo.endDate.doubleValue + mo.endTime.doubleValue + 28800000;
                NSString *end = [NSString stringWithFormat:@"%.0f",endValue];
                [causationDetail addObject:@{
                                             @"address":kSafeString(mo.address),
                                             @"causationId":causationId,
                                             @"days":kSafeString(mo.days),
                                             @"endDate":kSafeString(mo.endDate),
                                             @"endTime":kSafeString(mo.endTime),
                                             @"startDate":kSafeString(mo.startDate),
                                             @"startTime":kSafeString(mo.startTime),
                                             @"start":kSafeString(start),
                                             @"end":kSafeString(end),
                                             }];
            }
        }
        NSDictionary *causation;
        {
            NSString *address = self.dealingModel.address;
            NSString *causationCommont = self.dealingModel.remark;
            NSString *causationId = kIsNilString(self.dealingModel.attendenceId) ? @"-1" : self.dealingModel.attendenceId;
            NSString *causationtypeNo = [NSString stringWithFormat:@"%@",@(self.causationType)];
            NSString *employeeId = [MPMShareUser shareUser].employeeId;
            NSString *employeename = [MPMShareUser shareUser].employeeName;
            NSString *whitename = @"";
            causation = @{@"address":kSafeString(address),
                          @"causationCommont":kSafeString(causationCommont),
                          @"causationId":causationId,
                          @"causationtypeNo":kSafeString(causationtypeNo),
                          @"employeeId":kSafeString(employeeId),
                          @"employeename":kSafeString(employeename),
                          @"whitename":whitename,
                          };
        }
        params = @{
                   @"copyName":kSafeString(copyName),
                   @"copyNameId":kSafeString(copyNameId),
                   @"nowApprove":kSafeString(nowApprove),
                   @"nowApproveId":kSafeString(nowApproveId),
                   @"submitNumber":kSafeString(submitNumber),
                   @"causationDetail":causationDetail,
                   @"causation":causation
                   };
    }
    
    [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在提交" success:^(id response) {
        DLog(@"%@",response);
        NSString *message = submitNumber.integerValue == 1 ? @"提交成功" : @"保存成功";
        __weak typeof(self) weakself = self;
        [self showAlertControllerToLogoutWithMessage:message sureAction:^(UIAlertAction *action) {
            __strong typeof(weakself) strongself = weakself;
            if (strongself.dealingFromType == kDealingFromTypeEditing) {
                // 编辑状态，跳回流程审批
                [strongself.navigationController popToViewController:strongself.navigationController.viewControllers[strongself.navigationController.viewControllers.count-3] animated:YES];
            } else {
                [strongself.navigationController popViewControllerAnimated:YES];
            }
        } needCancleButton:NO];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - MPMAttendencePickerViewDelegate
- (void)mpmAttendencePickerView:(MPMAttendencePickerView *)pickerView didSelectedData:(id)data {
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.tableViewTitleArray[section][@"cell"]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.tableViewTitleArray.count - 3) {
        return kTableViewHeight + 45;
    } else if (indexPath.section == self.tableViewTitleArray.count - 2) {
        if (!kIsNilString(self.dealingModel.nowApproval)) {
            return kTableViewHeight + 56.5;
        }
    } else if (indexPath.section == self.tableViewTitleArray.count - 1) {
        if (!kIsNilString(self.dealingModel.mpm_copyName)) {
            if (!self.mpm_copyNameNeedFold) {
                return kTabbarHeight + 70 + ((((int)[self.dealingModel.mpm_copyName componentsSeparatedByString:@","].count-1)/5) * 56.5);
            } else {
                if ((int)[self.dealingModel.mpm_copyName componentsSeparatedByString:@","].count > 5) {
                    return kTabbarHeight + 70;
                } else {
                    return kTabbarHeight + 56.5;
                }
            }
        }
    }
    return kTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = self.tableViewTitleArray[section][@"title"];
    if (kIsNilString(title)) {
        return 10;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.tableViewTitleArray.count - 1) {
        return 30;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = self.tableViewTitleArray[section][@"title"];
    if (kIsNilString(title)) {
        return nil;
    } else {
        // 改签、补签、例外申请
        if (section == 0 && (self.causationType == forCausationTypeChangeSign || self.causationType == forCausationTypeRepairSign || self.dealingFromType == kDealingFromTypeChangeRepair)) {
            title = [NSString stringWithFormat:@"%@：%@ %@",kAttendenceStatus[self.dealingModel.status],([NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:(kIsNilString(self.dealingModel.oriAttendenceDate) ? self.dealingModel.attendenceDate.doubleValue : self.dealingModel.oriAttendenceDate.doubleValue)] withDefineFormatterType:forDateFormatTypeYearMonthDayHourMinite]),@[@"上班",@"下班"][self.dealingModel.type.integerValue]];
        } else if (section == 1 && !(self.causationType == forCausationTypeevecation || self.causationType == forCausationTypeOverTime || self.causationType == forCausationTypeOut)) {
            title = [NSString stringWithFormat:@"这是本月第%ld次%@",self.monthDealingCount.integerValue+1,title];
        }
        MPMTableHeaderView *header = [[MPMTableHeaderView alloc] init];
        header.headerTextLabel.text = title;
        [header resetTextLabelLeadingOffser:20];
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.tableViewTitleArray.count - 1) {
        MPMTableHeaderView *footer = [[MPMTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        footer.headerTextLabel.text = @"审批通过后，通知抄送人";
        [footer resetTextLabelLeadingOffser:20];
        return footer;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.tableViewTitleArray[indexPath.section];
    NSArray *cellType = dic[@"cellType"];
    NSString *detailType = cellType[indexPath.row];
    
    if ([detailType isEqualToString:@"UITextView"]) {
        static NSString *cellIdentifier = @"cellIdentifierTextView";
        MPMCommomDealingReasonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMCommomDealingReasonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        NSArray *cellArr = self.tableViewTitleArray[indexPath.section][@"cell"];
        cell.txLabel.text = [cellArr[indexPath.row] componentsSeparatedByString:@","].firstObject;
        NSString *detailString = kIsNilString(self.dealingModel.remark)?[cellArr[indexPath.row] componentsSeparatedByString:@","].lastObject:self.dealingModel.remark;
        cell.detailTextView.text = detailString;
        if (![detailString isEqualToString:UITextViewPlaceHolder1] && ![detailString isEqualToString:UITextViewPlaceHolder2]) {
            NSString *attrStr = [NSString stringWithFormat:@"%ld/30",cell.detailTextView.text.length];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:attrStr];
            NSInteger loca = attrStr.length - 2;
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:kMainLightGray
                                  range:NSMakeRange(loca, 2)];
            cell.textViewTotalLength.attributedText = AttributedStr;
        }
        [cell.detailTextView resignFirstResponder];
        __weak typeof(self) weakself = self;
        cell.changeTextBlock = ^(NSString *currentText) {
            __strong typeof(weakself) strongself = weakself;
            strongself.dealingModel.remark = currentText;
        };
        return cell;
    } else if ([detailType isEqualToString:@"People"]) {
        // 审批人、抄送人
        static NSString *cellIdentifier = @"cellIdentifierPeople";
        MPMCommomDealingGetPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMCommomDealingGetPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        if (indexPath.section == self.tableViewTitleArray.count - 1) {
            // 抄送人
            cell.startIcon.hidden = YES;
            [cell setPeopleViewData:self.dealingModel.mpm_copyName fold:self.mpm_copyNameNeedFold];
            __weak typeof(self) weakself = self;
            cell.addpBlock = ^(UIButton *sender) {
                __strong typeof (weakself) strongself = weakself;
                MPMCommomGetPeopleViewController *people = [[MPMCommomGetPeopleViewController alloc] initWithCode:@"0" idString:strongself.dealingModel.mpm_copyNameId sureSelect:^(NSArray<MPMGetPeopleModel *> *arr) {
                    __strong typeof (strongself) sstrongself = strongself;
                    NSString *name;
                    NSString *mpm_id;
                    for (int i = 0; i < arr.count; i++) {
                        MPMGetPeopleModel *mo = arr[i];
                        if (i == 0) {
                            name = mo.name;
                            mpm_id = mo.mpm_id;
                        } else {
                            name = [[name stringByAppendingString:@","]stringByAppendingString:mo.name];
                            mpm_id = [[mpm_id stringByAppendingString:@","]stringByAppendingString:mo.mpm_id];
                        }
                    }
                    sstrongself.dealingModel.mpm_copyName = name;
                    sstrongself.dealingModel.mpm_copyNameId = mpm_id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                strongself.hidesBottomBarWhenPushed = YES;
                [strongself.navigationController pushViewController:people animated:YES];
            };
            cell.foldBlock = ^(UIButton *sender) {
                // 展开收缩
                sender.selected = !sender.selected;
                __strong typeof (weakself) strongself = weakself;
                strongself.mpm_copyNameNeedFold = !sender.selected;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
        } else {
            // 审批人
            cell.startIcon.hidden = NO;
            [cell setPeopleViewData:self.dealingModel.nowApproval fold:YES];
            __weak typeof (self) weakself = self;
            cell.addpBlock = ^(UIButton *sender) {
                __strong typeof (weakself) strongself = weakself;
                MPMCommomGetPeopleViewController *people = [[MPMCommomGetPeopleViewController alloc] initWithCode:@"1" idString:strongself.dealingModel.nowApprovalId sureSelect:^(NSArray<MPMGetPeopleModel *> *arr) {
                    __strong typeof (strongself) sstrongself = strongself;
                    MPMGetPeopleModel *model = arr.firstObject;
                    sstrongself.dealingModel.nowApproval = model.name;
                    sstrongself.dealingModel.nowApprovalId = model.mpm_id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                strongself.hidesBottomBarWhenPushed = YES;
                [strongself.navigationController pushViewController:people animated:YES];
            };
        }
        NSArray *cellArr = self.tableViewTitleArray[indexPath.section][@"cell"];
        cell.txLabel.text = [cellArr[indexPath.row] componentsSeparatedByString:@","].firstObject;
        
        return cell;
    } else if ([detailType isEqualToString:@"UIButton"]) {
        NSString *cellTitle = ((NSArray *)dic[@"cell"]).firstObject;
        static NSString *cellIdentifier = @"btnCellIdentifier";
        MPMCommomDealingAddCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMCommomDealingAddCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier btnTitle:cellTitle];
        }
        return cell;
    } else {
        static NSString *cellIdentifier = @"cellIdentifier";
        MPMCommomDealingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMCommomDealingTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        NSArray *cellArr = self.tableViewTitleArray[indexPath.section][@"cell"];
        cell.txLabel.text = [cellArr[indexPath.row] componentsSeparatedByString:@","].firstObject;
        if (indexPath.row == 0 && self.addCount > 1 && indexPath.section != 0) {
            cell.deleteCellButton.hidden = NO;
        } else {
            cell.deleteCellButton.hidden = YES;
        }
        __weak typeof(self) weakself = self;
        cell.sectionDeleteBlock = ^(UIButton *sender) {
            __strong typeof(weakself) strongself = weakself;
            // 移除model里面的数据
            [strongself.dealingModel.causationDetail removeModelAtIndex:indexPath.section - 1];
            strongself.addCount--;
            if (strongself.addCount < 1) {
                strongself.addCount = 1;
            }
            strongself.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:strongself.causationType addCount:strongself.addCount];
            [strongself.tableView reloadData];
        };
        if ([detailType isEqualToString:@"UITextField"]) {
            NSString *cellTitle = cell.txLabel.text;
            if ([cellTitle isEqualToString:@"出差地点"]) {
                [cell setupTextFieldCheck:NO];
            } else {
                [cell setupTextFieldCheck:YES];
            }
            ((UITextField *)cell.detailView).placeholder = [cellArr[indexPath.row] componentsSeparatedByString:@","].lastObject;
            if ([cellTitle isEqualToString:@"出差地点"]) {
                NSString *currentString = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section - 1]).address;
                ((UITextField *)cell.detailView).text = kIsNilString(currentString)?@"":currentString;
            } else {
                // 时长
                NSString *currentString = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section - 1]).days;
                ((UITextField *)cell.detailView).text = kIsNilString(currentString)?@"":currentString;
            }
            cell.textFieldChangeBlock = ^(NSString *currentText) {
                __strong typeof(weakself) strongself = weakself;
                NSInteger index = indexPath.section - 1;
                if ([cellTitle isEqualToString:@"出差地点"]) {
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).address = currentText;
                } else {
                    // 时长
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).days = currentText;
                }
            };
        } else {
            [cell setupUILabel];
            if (self.pickerFirstData.count <= 1 && indexPath.row == 0 && indexPath.section == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            NSString *title = cell.txLabel.text;
            NSString *originalText = [cellArr[indexPath.row] componentsSeparatedByString:@","].lastObject;
            if ([title isEqualToString:@"开始时间"]) {
                NSString *st = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section - 1]).startLongDate;
                cell.detailTextLabel.text = st ? st : originalText;
            } else if ([title isEqualToString:@"结束时间"]) {
                NSString *et = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section - 1]).endLongDate;
                cell.detailTextLabel.text = et ? et : originalText;
            } else if ([title isEqualToString:@"处理签到时间"] || [title isEqualToString:@"实际时间"]) {
                cell.detailTextLabel.text = self.dealingModel.attendenceDate ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.attendenceDate.doubleValue] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds] : originalText;
            } else if ([title isEqualToString:@"选择班次"]) {
                cell.detailTextLabel.text = self.dealingModel.shiftName ? kShiftNameRever[self.dealingModel.shiftName] : originalText;
            } else if ([title isEqualToString:@"审批人"]) {
                cell.detailTextLabel.text = self.dealingModel.nowApproval ? self.dealingModel.nowApproval : originalText;
            } else if ([title isEqualToString:@"抄送人"]) {
                cell.detailTextLabel.text = self.dealingModel.mpm_copyName ? self.dealingModel.mpm_copyName : originalText;
            } else if ([title isEqualToString:@"请选择调班日期"]) {
                cell.detailTextLabel.text = self.dealingModel.originalDate ? [self.dealingModel.originalDate substringToIndex:10] : originalText;
            } else if ([title isEqualToString:@"原班次"]) {
                cell.detailTextLabel.text = self.dealingModel.originalClassName ? kClassNameRever[self.dealingModel.originalClassName] : originalText;
            } else if ([title isEqualToString:@"请选择新调班日期"]) {
                cell.detailTextLabel.text = self.dealingModel.mpm_newDate ? [self.dealingModel.mpm_newDate substringToIndex:10] : originalText;
            } else if ([title isEqualToString:@"新班次"]) {
                cell.detailTextLabel.text = self.dealingModel.mpm_newClassName ? kClassNameRever[self.dealingModel.mpm_newClassName] : originalText;
            } else {
                cell.detailTextLabel.text = originalText;
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSInteger defaultRow = [self.pickerFirstData indexOfObject:kSausactionType[[NSString stringWithFormat:@"%ld",self.causationType]]];
        [self.pickerView showInView:kAppDelegate.window withPickerData:self.pickerFirstData selectRow:defaultRow];
        __weak typeof(self) weakself = self;
        self.pickerView.completeSelectBlock = ^(id data) {
            __strong typeof(weakself) strongself = weakself;
            strongself.causationType = ((NSString *)kSausactionNo[data]).integerValue;
            strongself.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:strongself.causationType addCount:strongself.addCount];
            [strongself.tableView reloadData];
        };
    } else if (indexPath.section == self.tableViewTitleArray.count - 1) {
        // 抄送人
    } else if (indexPath.section == self.tableViewTitleArray.count - 2) {
        // 审批人
    } else if (self.tableViewTitleArray.count > 3 && indexPath.section == self.tableViewTitleArray.count - 3) {
        // 选择处理理由--不处理
    } else {
        NSArray *action = self.tableViewTitleArray[indexPath.section][@"action"];
        NSString *actionTitle = action[indexPath.row];
        MPMCommomDealingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([actionTitle isEqualToString:@"picker2"]) {
            NSInteger index = indexPath.section - 1;
            NSDate *defaultDate;
            if ([cell.txLabel.text isEqualToString:@"开始时间"] &&
                !kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).startDate) &&
                !kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).startTime)) {
                NSTimeInterval interval = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).startDate.doubleValue/1000 + ((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).startTime.doubleValue/1000 + 28800;
                defaultDate = [NSDate dateWithTimeIntervalSince1970:interval];
            } else if ([cell.txLabel.text isEqualToString:@"结束时间"] &&
                       !kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).endDate) &&
                       !kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).endTime)) {
                NSTimeInterval interval = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).endDate.doubleValue/1000 + ((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).endTime.doubleValue/1000 + 28800;
                defaultDate = [NSDate dateWithTimeIntervalSince1970:interval];
            } else if (self.dealingModel.attendenceDate) {
                defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.attendenceDate.doubleValue];
            } else {
                defaultDate = [NSDate date];
            }
            [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeYearMonthDayHourMinute defaultDate:defaultDate];
            __weak typeof (self) weakself = self;
            self.customDatePickerView.completeBlock = ^(NSDate *date) {
                __strong typeof (weakself) strongself = weakself;
                cell.detailTextLabel.text = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
                strongself.dealingModel.attendenceDate = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970];
                if ([cell.txLabel.text isEqualToString:@"开始时间"]) {
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).startLongDate = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
                    NSTimeInterval start = date.timeIntervalSince1970;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).startDate = [NSString stringWithFormat:@"%.0f",inte*1000];
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).startTime = [NSString stringWithFormat:@"%.0f",(start - inte - 28800)*1000];
                    
                } else if ([cell.txLabel.text isEqualToString:@"结束时间"]) {
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).endLongDate = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
                    NSTimeInterval start = date.timeIntervalSince1970;
                    NSTimeInterval inte = [NSDateFormatter getZeroWithTimeInterverl:start];
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).endDate = [NSString stringWithFormat:@"%.0f",inte*1000];
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).endTime = [NSString stringWithFormat:@"%.0f",(start - inte - 28800)*1000];
                }
            };
        } else if ([actionTitle isEqualToString:@"picker3"]) {
            [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeYearMonthDay defaultDate:nil];
            __weak typeof (self) weakself = self;
            self.customDatePickerView.completeBlock = ^(NSDate *date) {
                __strong typeof (weakself) strongself = weakself;
                cell.detailTextLabel.text = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeYearMonthDayBar];
                if ([cell.textLabel.text containsString:@"新"]) {
                    strongself.dealingModel.mpm_newDate = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeSpecial];
                } else {
                    strongself.dealingModel.originalDate = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeSpecial];
                }
            };
        } else if ([actionTitle isEqualToString:@"picker4"]) {
            NSInteger defaultRow = kIsNilString(self.dealingModel.shiftName) ? 0 : ((NSString *)kShiftNameRever[self.dealingModel.shiftName]).integerValue;
            [self.pickerView showInView:kAppDelegate.window withPickerData:@[@"上班",@"下班"] selectRow:defaultRow];
            __weak typeof (self) weakself = self;
            self.pickerView.completeSelectBlock = ^(id data) {
                __strong typeof (weakself) strongself = weakself;
                cell.detailTextLabel.text = data;
                strongself.dealingModel.shiftName = kShiftName[data];
            };
        } else if ([actionTitle isEqualToString:@"picker5"]) {
            NSInteger defaultRow;
            if ([cell.textLabel.text hasPrefix:@"新"]) {
                defaultRow = kIsNilString(self.dealingModel.mpm_newClassName) ? 0 : ((NSString *)kClassNameRever[self.dealingModel.mpm_newClassName]).integerValue;
            } else {
                defaultRow = kIsNilString(self.dealingModel.originalClassName) ? 0 : ((NSString *)kShiftNameRever[self.dealingModel.originalClassName]).integerValue;
            }
            [self.pickerView showInView:kAppDelegate.window withPickerData:@[@"早班",@"中班",@"晚班"] selectRow:defaultRow];
            NSString *cellTitle = cell.textLabel.text;
            __weak typeof (self) weakself = self;
            self.pickerView.completeSelectBlock = ^(id data) {
                __strong typeof (weakself) strongself = weakself;
                cell.detailTextLabel.text = data;
                if ([cellTitle hasPrefix:@"新"]) {
                    strongself.dealingModel.mpm_newClassName = kClassName[data];
                } else {
                    strongself.dealingModel.originalClassName = kClassName[data];
                }
            };
        } else if ([actionTitle isEqualToString:@"addCell"]) {
            self.addCount++;
            if (self.addCount > 3) {
                self.addCount = 1;
            }
            // 增加一行数据
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.causationType addCount:self.addCount];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Lazy Init
// tableVeiw
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewBGColor;
        [_tableView setSeparatorColor:kSeperateColor];
    }
    return _tableView;
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
        _bottomSaveButton = [MPMButton titleButtonWithTitle:@"保存" nTitleColor:kMainBlueColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
    }
    return _bottomSaveButton;
}

- (UIButton *)bottomSubmitButton {
    if (!_bottomSubmitButton) {
        _bottomSubmitButton = [MPMButton titleButtonWithTitle:@"提交" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomSubmitButton;
}

- (MPMAttendencePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MPMAttendencePickerView alloc] init];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (MPMCustomDatePickerView *)customDatePickerView {
    if (!_customDatePickerView) {
        _customDatePickerView = [[MPMCustomDatePickerView alloc] init];
    }
    return _customDatePickerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
