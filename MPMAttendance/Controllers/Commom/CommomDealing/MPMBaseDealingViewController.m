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
//#import "MPMCommomGetPeopleViewController.h"
#import "MPMTableHeaderView.h"
#import "MPMGetPeopleModel.h"
#import "MPMCommomDealingGetPeopleTableViewCell.h"
#import "MPMCommomDealingAddCellTableViewCell.h"
#import "MPMCausationDetailModel.h"
#import "NSMutableArray+MPMExtention.h"
#import "MPMOauthUser.h"
#import "MPMBaseDealingHeader.h"
#import "MPMDealingSeeTimeDetailViewController.h"
#import "MPMCommomDealingMultiSelectTableViewCell.h"
#import "MPMRepairSigninViewController.h"
#import "MPMDealingBorderButton.h"
#import "MPMDepartEmployeeHelper.h"

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
@property (nonatomic, strong) MPMDealingModel *dealingModel;
@property (nonatomic, assign) DealingFromType dealingFromType;  /** 跳入的情况：从例外申请跳入、从打卡页面跳入、从编辑页面跳入 */
// data
@property (nonatomic, copy) NSArray *tableViewTitleArray;
@property (nonatomic, copy) NSArray *leaveAllTypesArray;        /** 所有请假类型 */
@property (nonatomic, copy) NSString *monthDealingCount;        /** 记录当月处理次数 */
@property (nonatomic, copy) NSString *bizorderId;               /** 当前处理单id，用于查询本单的明细信息 */
@property (nonatomic, copy) NSString *taskInstId;               /** 任务id */

@end

@implementation MPMBaseDealingViewController

- (instancetype)initWithDealType:(CausationType)type dealingModel:(MPMDealingModel *)dealingModel dealingFromType:(DealingFromType)fromType bizorderId:(NSString *)bizorderId taskInstId:(NSString *)taskInstId {
    self = [super init];
    if (self) {
        // 初始化Model
        if (dealingModel) {
            self.dealingModel = dealingModel;
        } else {
            NSInteger addCount;
            if (kCausationTypeRepairSign == type) {
                // 补签，初始化为0
                addCount = 0;
            } else {
                addCount = 1;
            }
            self.dealingModel = [[MPMDealingModel alloc] initWithCausationType:type addCount:addCount];
        }
        self.bizorderId = bizorderId;
        self.taskInstId = taskInstId;
        self.dealingFromType = fromType;
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTableViewBGColor;
    if (kCausationTypeAskLeave == self.dealingModel.causationType) {
        // 请假
        self.navigationItem.title = @"请假";
    } else if (kCausationTypeevecation == self.dealingModel.causationType) {
        // 出差
        self.navigationItem.title = @"出差";
    } else if (kCausationTypeOverTime == self.dealingModel.causationType) {
        // 加班
        self.navigationItem.title = @"加班";
    } else if (kCausationTypeOut == self.dealingModel.causationType) {
        // 外出
        self.navigationItem.title = @"外出";
    } else if (kCausationTypeRepairSign == self.dealingModel.causationType) {
        // 补签
        self.navigationItem.title = @"补签";
    }
    if (kDealingFromTypeApply == self.dealingFromType) {
        [self getApplyerData];
        if (kCausationTypeAskLeave == self.dealingModel.causationType) {
            // 如果是请假，需要获取所有请假类型
            [self getLeaveType];return;
        }
        self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.dealingModel.causationType addCount:self.dealingModel.addCount];
        [self.tableView reloadData];
    } else if (self.dealingFromType == kDealingFromTypeChangeRepair) {
        
    } else if (self.dealingFromType == kDealingFromTypeEditing) {
        [self getDetailDealingMessage];
    } else {
        // kDealingFromTypePreview：预览模板
        self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.dealingModel.causationType addCount:self.dealingModel.addCount];
        self.dealingModel.status = @"1";// 预览模板改签给个默认‘迟到’
        [self.tableView reloadData];
    }
}

/** 获取例外申请的审批节点：如果管理员有设置了节点，则不可以更改，否则，则才可以增加 */
- (void)getApplyerData {
    NSString *processDefCode = kProcessDefCode_GetCodeFromType[[NSString stringWithFormat:@"%ld",self.dealingModel.causationType]];
    NSString *url = [NSString stringWithFormat:@"%@%@?processDefCode=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_SETTING_TASKDEFSWA,processDefCode];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            id config = object.firstObject[@"config"];
            if ([config isKindOfClass:[NSDictionary class]]) {
                if ([config[@"decision"] isKindOfClass:[NSString class]]) {
                    self.dealingModel.decision = config[@"decision"];
                } else if ([config[@"decision"] isKindOfClass:[NSNumber class]]) {
                    self.dealingModel.decision = ((NSNumber *)config[@"decision"]).stringValue;
                }
                NSArray *participants = config[@"participants"];
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:participants.count];
                for (int i = 0; i < participants.count; i++) {
                    NSDictionary *dic = participants[i];
                    MPMDepartment *po = [[MPMDepartment alloc] init];
                    po.name = dic[@"userName"];
                    po.mpm_id = dic[@"userId"];
                    [temp addObject:po];
                }
                self.dealingModel.participants = temp.copy;
            }
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

/** 获取所有请假类型 */
- (void)getLeaveType {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_GETLEAVETYPE];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:object.count];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                MPMAttendencePickerTypeModel *model = [[MPMAttendencePickerTypeModel alloc] initWithDictionary:dic];
                [temp addObject:model.typeName];
            }
            if (temp.count > 0) {
                self.leaveAllTypesArray = temp.copy;
            }
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.dealingModel.causationType addCount:self.dealingModel.addCount];
            [self.tableView reloadData];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

/** “编辑”根据单据id获取详细信息 */
- (void)getDetailDealingMessage {
    NSString *url;
    if (kCausationTypeAskLeave == self.dealingModel.causationType) {
        // 请假
        url = [NSString stringWithFormat:@"%@%@/%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_QUERY_LEAVE,self.bizorderId];
    } else if (kCausationTypeevecation == self.dealingModel.causationType) {
        // 出差
        url = [NSString stringWithFormat:@"%@%@/%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_QUERY_TRAVEL,self.bizorderId];
    } else if (kCausationTypeOverTime == self.dealingModel.causationType) {
        // 加班
        url = [NSString stringWithFormat:@"%@%@/%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_QUERY_OVERTIME,self.bizorderId];
    } else if (kCausationTypeOut == self.dealingModel.causationType) {
        // 外出
        url = [NSString stringWithFormat:@"%@%@/%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_QUERY_GOOUT,self.bizorderId];
    } else if (kCausationTypeRepairSign == self.dealingModel.causationType || kCausationTypeChangeSign == self.dealingModel.causationType) {
        // 补签、改签
        url = [NSString stringWithFormat:@"%@%@/%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_QUERY_SIGN,self.bizorderId];
    }
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = response[kResponseObjectKey];
            
            if (object[@"workFlow"] && [object[@"workFlow"] isKindOfClass:[NSDictionary class]]) {
                // 审批节点（提交至）
                if (object[@"workFlow"][@"participantConfig"] && [object[@"workFlow"][@"participantConfig"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *config = object[@"workFlow"][@"participantConfig"];
                    if ([config[@"decision"] isKindOfClass:[NSString class]]) {
                        self.dealingModel.decision = config[@"decision"];
                    } else if ([config[@"decision"] isKindOfClass:[NSNumber class]]) {
                        self.dealingModel.decision = ((NSNumber *)config[@"decision"]).stringValue;
                    }
                    NSArray *participants = config[@"participants"];
                    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:participants.count];
                    for (int i = 0; i < participants.count; i++) {
                        NSDictionary *dic = participants[i];
                        MPMDepartment *po = [[MPMDepartment alloc] init];
                        po.mpm_id = dic[@"userId"];
                        po.name = dic[@"userName"];
                        [temp addObject:po];
                    }
                    self.dealingModel.participants = temp.copy;
                }
                // 抄送人
                if (object[@"workFlow"][@"delivers"] && [object[@"workFlow"][@"delivers"] isKindOfClass:[NSArray class]]) {
                    NSArray *delivers = object[@"workFlow"][@"delivers"];
                    NSMutableArray *tempDe = [NSMutableArray arrayWithCapacity:delivers.count];
                    for (int i = 0; i < delivers.count; i++) {
                        NSDictionary *pp = delivers[i];
                        MPMDepartment *depart = [[MPMDepartment alloc] init];
                        depart.mpm_id = pp[@"userId"];
                        depart.name = pp[@"userName"];
                        [tempDe addObject:depart];
                    }
                    self.dealingModel.delivers = tempDe;
                }
            }
            // 处理原因
            if (object[@"reason"] && [object[@"reason"] isKindOfClass:[NSString class]]) {
                self.dealingModel.remark = object[@"reason"];
            }
            // TODO 多段详情 - 很多不同的Dto...
            NSArray *detailArray;
            if (object[@"kqBizLeaveDtoList"] && [object[@"kqBizLeaveDtoList"] isKindOfClass:[NSArray class]]) {
                // 请假
                detailArray = object[@"kqBizLeaveDtoList"];
            } else if (object[@"kqBizBusinessTravelDtoList"] && [object[@"kqBizBusinessTravelDtoList"] isKindOfClass:[NSArray class]]) {
                // 出差
                detailArray = object[@"kqBizBusinessTravelDtoList"];
            } else if (object[@"otDetails"] && [object[@"otDetails"] isKindOfClass:[NSArray class]]) {
                // 加班
                detailArray = object[@"otDetails"];
            } else if (object[@"gooutDetails"] && [object[@"gooutDetails"] isKindOfClass:[NSArray class]]) {
                // 外出
                detailArray = object[@"gooutDetails"];
            } else if (object[@"kqBizFillupSignList"] && [object[@"kqBizFillupSignList"] isKindOfClass:[NSArray class]]) {
                // 补签
                detailArray = object[@"kqBizFillupSignList"];
            } else if (object[@"kqBizReviseSignList"] && [object[@"kqBizReviseSignList"] isKindOfClass:[NSArray class]]) {
                // 改签
                detailArray = object[@"kqBizReviseSignList"];
            }
            self.dealingModel.addCount = detailArray.count;
            for (int i = 0; i < detailArray.count; i++) {
                NSDictionary *dDic = detailArray[i];
                // 通用属性
                self.dealingModel.causationDetail[i].startTime = kNumberSafeString(dDic[@"startTime"]);
                self.dealingModel.causationDetail[i].endTime = kNumberSafeString(dDic[@"endTime"]);
                self.dealingModel.causationDetail[i].dayAccount = kNumberSafeString(dDic[@"dayAccount"]);
                self.dealingModel.causationDetail[i].hourAccount = kNumberSafeString(dDic[@"hourAccount"]);
                // 请假类型
                self.dealingModel.causationDetail[i].causationType = kNumberSafeString(dDic[@"type"]);
                // 出差
                self.dealingModel.causationDetail[i].expectCost = kNumberSafeString(dDic[@"expectCost"]);
                self.dealingModel.causationDetail[i].address = dDic[@"address"];
                self.dealingModel.causationDetail[i].isShareRoom = dDic[@"isShareRoom"];
                self.dealingModel.causationDetail[i].traffic = dDic[@"traffic"];
                if (!kIsNilString(self.dealingModel.causationDetail[i].traffic) && ![kTraffic containsObject:self.dealingModel.causationDetail[i].traffic]) {
                    // 如果之前有填有交通工具，并且交通工具数组里面不包含该交通工具，则需要展开控件
                    self.dealingModel.causationDetail[i].trafficNeedFold = NO;
                }
                // 加班
                self.dealingModel.redress = dDic[@"redress"];
                // 补签、改签
                self.dealingModel.causationDetail[i].detailId = dDic[@"detailId"];
                self.dealingModel.causationDetail[i].fillupTime = kNumberSafeString(dDic[@"fillupTime"]);
                self.dealingModel.causationDetail[i].signTime = kNumberSafeString(dDic[@"signTime"]);
                self.dealingModel.causationDetail[i].mpm_id = dDic[@"id"];
                // 改签
                self.dealingModel.causationDetail[i].attendanceTime = kNumberSafeString(dDic[@"attendanceTime"]);
                self.dealingModel.causationDetail[i].reviseSignTime = kNumberSafeString(dDic[@"reviseSignTime"]);
                self.dealingModel.causationDetail[i].status = kNumberSafeString(dDic[@"status"]);
                self.dealingModel.status = kNumberSafeString(dDic[@"status"]);
            }
            if (kCausationTypeAskLeave == self.dealingModel.causationType) {
                [self getLeaveType];return;
            }
            self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.dealingModel.causationType addCount:self.dealingModel.addCount];
            [self.tableView reloadData];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

/** 调用接口计算时长 */
- (void)calculateDayAndHourWithStart:(NSString *)start end:(NSString *)end complete:(void(^)(NSString *day, NSString *hour))com {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_CALCULATETIME];
    NSString *type = self.dealingModel.causationType == kCausationTypeOverTime ? @"1" : @"0";
    NSDictionary *params = @{@"startTime":kSafeString(start),@"endTime":kSafeString(end),@"type":type};
    DLog(@"%@",params);
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:nil success:^(id response) {
        DLog(@"计算时长 === %@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = response[kResponseObjectKey];
            id day;
            id hour;
            if ([object[@"day"] isKindOfClass:[NSNumber class]]) {
                day = ((NSNumber *)object[@"day"]).stringValue;
            } else if ([object[@"day"] isKindOfClass:[NSString class]]) {
                day = object[@"day"];
            }
            if ([object[@"hour"] isKindOfClass:[NSNumber class]]) {
                hour = ((NSNumber *)object[@"hour"]).stringValue;
            } else if ([object[@"hour"] isKindOfClass:[NSString class]]) {
                hour = object[@"hour"];
            }
            if (com) {
                com(day,hour);
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"计算时长失败，请重新选择"];
            if (com) {
                com(nil,nil);
            }
        }
    } failure:^(NSString *error) {
        DLog(@"计算时长失败 === %@",error);
        [SVProgressHUD showErrorWithStatus:@"计算时长失败，请重新选择"];
        if (com) {
            com(nil,nil);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupAttributes {
    [super setupAttributes];
    if (kDealingFromTypePreview == self.dealingFromType) {
        // 如果是预览模式下，按钮不能点击
        self.bottomSaveButton.userInteractionEnabled =
        self.bottomSubmitButton.userInteractionEnabled = NO;
    }
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
    [self.tableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
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
    /*  不再有保存功能
     if (self.dealingFromType == kDealingFromTypeApply) {
     [self.bottomSaveButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
     make.leading.equalTo(self.bottomView.mpm_leading).offset(PX_H(23));
     make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
     make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
     make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
     }];
     [self.bottomSubmitButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
     make.leading.equalTo(self.bottomSaveButton.mpm_trailing).offset(PX_H(23));
     make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-PX_H(23));
     make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
     make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
     }];
     } else {
     */
    [self.bottomSubmitButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(PX_H(23));
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-PX_H(23));
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
}

#pragma mark - Target Action
- (void)left:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 保存 */
- (void)save:(UIButton *)sender {
    [self saveOrSubmit:YES];
}

/** 提交 */
- (void)submit:(UIButton *)sender {
    [self saveOrSubmit:NO];
}

#pragma mark - Private Method
/** 检验提交数据 */
- (BOOL)validateData {
    BOOL canPass = YES;
    NSInteger count = (0 == self.dealingModel.addCount) ? 1 : self.dealingModel.addCount;/** 明细数量 */
    
    if (kCausationTypeRepairSign == self.dealingModel.causationType) {
        // 补签
        if (self.dealingModel.addCount == 0) {
            [self showAlertControllerToLogoutWithMessage:@"请先增加漏签明细" sureAction:nil needCancleButton:NO];return canPass = NO;
        }
        for (int i = 0; i < count; i++) {
            MPMCausationDetailModel *detail = self.dealingModel.causationDetail[i];
            if (kIsNilString(detail.fillupTime)) {
                [self showAlertControllerToLogoutWithMessage:@"请选择漏签时间" sureAction:nil needCancleButton:NO];return canPass = NO;
            } else if (kIsNilString(detail.signTime)) {
                [self showAlertControllerToLogoutWithMessage:@"请选择补签时间" sureAction:nil needCancleButton:NO];return canPass = NO;
            }
        }
    } else if (kCausationTypeChangeSign == self.dealingModel.causationType) {
        // 改签
        for (int i = 0; i < count; i++) {
            MPMCausationDetailModel *detail = self.dealingModel.causationDetail[i];
            if (kIsNilString(detail.reviseSignTime)) {
                [self showAlertControllerToLogoutWithMessage:@"请选择改签时间" sureAction:nil needCancleButton:NO];return canPass = NO;
            }
        }
    } else {
        // 校验开始、结束时间是否为空
        for (int i = 0; i < count; i++) {
            MPMCausationDetailModel *detail = self.dealingModel.causationDetail[i];
            if (kIsNilString(detail.startTime)) {
                [self showAlertControllerToLogoutWithMessage:@"请选择开始时间" sureAction:nil needCancleButton:NO];return canPass = NO;
            } else if (kIsNilString(detail.endTime)) {
                [self showAlertControllerToLogoutWithMessage:@"请选择结束时间" sureAction:nil needCancleButton:NO];return canPass = NO;
            } else if (kIsNilString(detail.hourAccount) || kIsNilString(detail.dayAccount)) {
                [self showAlertControllerToLogoutWithMessage:@"时长计算有误，请重新选择" sureAction:nil needCancleButton:NO];return canPass = NO;
            } else if (detail.endTime.doubleValue <= detail.startTime.doubleValue) {
                [self showAlertControllerToLogoutWithMessage:@"开始时间必须小于结束时间" sureAction:nil needCancleButton:NO];return canPass = NO;
            }
        }
        if (kCausationTypeAskLeave == self.dealingModel.causationType) {
            // 请假
            for (int i = 0; i < count; i++) {
                MPMCausationDetailModel *detail = self.dealingModel.causationDetail[i];
                if (kCausationTypeAskLeave == detail.causationType.integerValue) {
                    [self showAlertControllerToLogoutWithMessage:@"请选择请假类型" sureAction:nil needCancleButton:NO];return canPass = NO;
                }
            }
        } else if (kCausationTypeevecation == self.dealingModel.causationType) {
            // 出差
            for (int i = 0; i < count; i++) {
                MPMCausationDetailModel *detail = self.dealingModel.causationDetail[i];
                if (kIsNilString(detail.address)) {
                    [self showAlertControllerToLogoutWithMessage:@"请输入出差地点" sureAction:nil needCancleButton:NO];return canPass = NO;
                }
                /*
                 if (kIsNilString(detail.expectCost)) {
                 [self showAlertControllerToLogoutWithMessage:@"请输入预计费用" sureAction:nil needCancleButton:NO];return canPass = NO;
                 }
                 */
            }
        } else if (kCausationTypeOverTime == self.dealingModel.causationType) {
            // 加班
        } else if (kCausationTypeOut == self.dealingModel.causationType) {
            // 外出
        }
    }
    
    if (kIsNilString(self.dealingModel.remark)) {
        [self showAlertControllerToLogoutWithMessage:@"请输入理由" sureAction:nil needCancleButton:NO];return canPass = NO;
    }
    if (self.dealingModel.participants.count == 0) {
        [self showAlertControllerToLogoutWithMessage:@"请选择审批人" sureAction:nil needCancleButton:NO];return canPass = NO;
    }
    
    return canPass;
}

/** YES为保存，NO为提交 */
- (void)saveOrSubmit:(BOOL)save {
    if (![self validateData]) return;
    NSString *state = save ? @"0" : @"1";// 0草稿箱 1提交
    NSString *message = save ? @"保存" : @"提交";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    
    if (kCausationTypeAskLeave == self.dealingModel.causationType) {
        // 请假
        if (self.dealingFromType == kDealingFromTypeEditing) {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_UPDATE_LEAVE];
        } else {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_SUBMIT_LEAVE];
        }
        NSMutableArray *kqBizLeaveDtoList = [NSMutableArray array];
        for (int i = 0; i < self.dealingModel.addMaxCount; i++) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:5];
            MPMCausationDetailModel *model = self.dealingModel.causationDetail[i];
            NSString *startTime = model.startTime;
            NSString *endTime = model.endTime;
            NSString *dayAccount = model.dayAccount;
            NSString *hourAccount = model.hourAccount;
            NSString *type = model.causationType;
            if (!kIsNilString(endTime) && !kIsNilString(startTime)) {
                temp[@"startTime"] = kSafeString(startTime);
                temp[@"endTime"] = kSafeString(endTime);
                temp[@"dayAccount"] = kSafeString(dayAccount);
                temp[@"hourAccount"] = kSafeString(hourAccount);
                temp[@"type"] = kSafeString(type);
                [kqBizLeaveDtoList addObject:temp];
            }
        }
        params[@"kqBizLeaveDtoList"] = kqBizLeaveDtoList;
    } else if (kCausationTypeevecation == self.dealingModel.causationType) {
        // 出差
        if (self.dealingFromType == kDealingFromTypeEditing) {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_UPDATE_TRAVEL];
        } else {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_SUBMIT_TRAVEL];
        }
        NSMutableArray *kqBizBusinessTravelDtoList = [NSMutableArray array];
        for (int i = 0; i < self.dealingModel.addMaxCount; i++) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:8];
            MPMCausationDetailModel *model = self.dealingModel.causationDetail[i];
            NSString *address = model.address;
            NSString *startTime = model.startTime;
            NSString *endTime = model.endTime;
            NSString *dayAccount = model.dayAccount;
            NSString *hourAccount = model.hourAccount;
            NSString *expectCost = model.expectCost;
            NSNumber *isShareRoom = @1;
            NSString *traffic = model.traffic;
            if (!kIsNilString(endTime) && !kIsNilString(startTime)) {
                temp[@"address"] = kSafeString(address);
                temp[@"startTime"] = kSafeString(startTime);
                temp[@"endTime"] = kSafeString(endTime);
                temp[@"dayAccount"] = kSafeString(dayAccount);
                temp[@"hourAccount"] = kSafeString(hourAccount);
                temp[@"expectCost"] = kSafeString(expectCost);
                temp[@"isShareRoom"] = isShareRoom;
                temp[@"traffic"] = kSafeString(traffic);
                [kqBizBusinessTravelDtoList addObject:temp];
            }
        }
        params[@"kqBizBusinessTravelDtoList"] = kqBizBusinessTravelDtoList;
    } else if (kCausationTypeOverTime == self.dealingModel.causationType) {
        // 加班
        if (self.dealingFromType == kDealingFromTypeEditing) {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_UPDATE_OT];
        } else {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_SUBMIT_OT];
        }
        NSMutableArray *details = [NSMutableArray array];
        for (int i = 0; i < self.dealingModel.addMaxCount; i++) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:5];
            MPMCausationDetailModel *model = self.dealingModel.causationDetail[i];
            NSString *redress = self.dealingModel.redress;
            NSString *startTime = model.startTime;
            NSString *endTime = model.endTime;
            NSString *dayAccount = model.dayAccount;
            NSString *hourAccount = model.hourAccount;
            if (!kIsNilString(endTime) && !kIsNilString(startTime)) {
                temp[@"redress"] = kSafeString(redress);
                temp[@"startTime"] = kSafeString(startTime);
                temp[@"endTime"] = kSafeString(endTime);
                temp[@"dayAccount"] = kSafeString(dayAccount);
                temp[@"hourAccount"] = kSafeString(hourAccount);
                [details addObject:temp];
            }
        }
        params[@"details"] = details;
    } else if (kCausationTypeOut == self.dealingModel.causationType) {
        // 外出
        if (self.dealingFromType == kDealingFromTypeEditing) {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_UPDATE_GOOUT];
        } else {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_SUBMIT_GOOUT];
        }
        NSMutableArray *gooutParamList = [NSMutableArray array];
        for (int i = 0; i < self.dealingModel.addMaxCount; i++) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:4];
            MPMCausationDetailModel *model = self.dealingModel.causationDetail[i];
            NSString *startTime = model.startTime;
            NSString *endTime = model.endTime;
            NSString *dayAccount = model.dayAccount;
            NSString *hourAccount = model.hourAccount;
            if (!kIsNilString(endTime) && !kIsNilString(startTime)) {
                temp[@"startTime"] = kSafeString(startTime);
                temp[@"endTime"] = kSafeString(endTime);
                temp[@"dayAccount"] = kSafeString(dayAccount);
                temp[@"hourAccount"] = kSafeString(hourAccount);
                [gooutParamList addObject:temp];
            }
        }
        params[@"gooutParamList"] = gooutParamList;
    } else if (kCausationTypeRepairSign == self.dealingModel.causationType) {
        // 补签
        if (self.dealingFromType == kDealingFromTypeEditing) {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_UPDATE_FSIGN];
        } else {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_SUBMIT_FSIGN];
        }
        NSMutableArray *kqBizFillupSignList = [NSMutableArray array];
        for (int i = 0; i < self.dealingModel.addMaxCount; i++) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:3];
            MPMCausationDetailModel *model = self.dealingModel.causationDetail[i];
            NSString *mpm_id = model.mpm_id;
            NSString *detailId = model.detailId;
            NSString *fillupTime = model.fillupTime;
            NSString *signTime = model.signTime;
            if (!kIsNilString(fillupTime) && !kIsNilString(signTime)) {
                temp[@"id"] = kSafeString(mpm_id);
                temp[@"detailId"] = kSafeString(detailId);
                temp[@"fillupTime"] = kSafeString(fillupTime);
                temp[@"signTime"] = kSafeString(signTime);
                [kqBizFillupSignList addObject:temp];
            }
        }
        params[@"kqBizFillupSignList"] = kqBizFillupSignList;
    } else if (kCausationTypeChangeSign == self.dealingModel.causationType) {
        // 改签
        if (self.dealingFromType == kDealingFromTypeEditing) {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_UPDATE_CSIGN];
        } else {
            url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_APPLY_SUBMIT_CSIGN];
        }
        
        NSMutableArray *kqBizReviseSignList = [NSMutableArray array];
        for (int i = 0; i < self.dealingModel.addMaxCount; i++) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:3];
            MPMCausationDetailModel *model = self.dealingModel.causationDetail[i];
            NSString *attendanceTime = model.attendanceTime;
            NSString *mpm_id = model.mpm_id;
            NSString *detailId = model.detailId;
            NSString *reviseSignTime = model.reviseSignTime;
            NSString *signTime = model.signTime;
            if (!kIsNilString(attendanceTime) && !kIsNilString(signTime) && !kIsNilString(reviseSignTime)) {
                temp[@"attendanceTime"] = kSafeString(attendanceTime);
                temp[@"id"] = kSafeString(mpm_id);
                temp[@"detailId"] = kSafeString(detailId);
                temp[@"reviseSignTime"] = kSafeString(reviseSignTime);
                temp[@"signTime"] = kSafeString(signTime);
                [kqBizReviseSignList addObject:temp];
            }
        }
        params[@"kqBizReviseSignList"] = kqBizReviseSignList;
    }
    
    // id有则为修改，无则为新增
    NSDictionary *kqBizOrderDto = @{@"id":kSafeString(self.bizorderId),@"reason":kSafeString(self.dealingModel.remark),@"state":state};
    params[@"kqBizOrderDto"] = kqBizOrderDto;
    
    NSMutableDictionary *workFlow = [NSMutableDictionary dictionary];
    /** 抄送人 */
    NSMutableArray *delivers = [NSMutableArray arrayWithCapacity:self.dealingModel.delivers.count];
    for (int i = 0; i < self.dealingModel.delivers.count; i++) {
        MPMDepartment *deliver = self.dealingModel.delivers[i];
        [delivers addObject:@{@"userId":deliver.mpm_id,@"userName":deliver.name}];
    }
    /** 审批人/提交至 */
    NSMutableDictionary *participantConfig = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString *decision = kIsNilString(self.dealingModel.decision) ? @"1" : self.dealingModel.decision;
    participantConfig[@"decision"] = decision;
    NSMutableArray *participants = [NSMutableArray arrayWithCapacity:self.dealingModel.participants.count];
    for (int i = 0; i < self.dealingModel.participants.count; i++) {
        MPMDepartment *participant = self.dealingModel.participants[i];
        [participants addObject:@{@"userId":participant.mpm_id,@"userName":participant.name}];
    }
    participantConfig[@"participants"] = participants;
    workFlow[@"delivers"] = delivers;
    workFlow[@"participantConfig"] = participantConfig;
    // 编辑需要传递taskInstId标识当前业务单id
    if (!kIsNilString(self.taskInstId)) {
        workFlow[@"taskInstId"] = kSafeString(self.taskInstId);
    }
    params[@"workFlow"] = workFlow;
    
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:[NSString stringWithFormat:@"正在%@",message] success:^(id response) {
        if (response[@"responseData"] && [response[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            __weak typeof(self) weakself = self;
            if (kRequestSuccess == ((NSString *)response[@"responseData"][kCode]).integerValue) {
                [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%@成功",message] sureAction:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakself) strongself = weakself;
                    if (kDealingFromTypeEditing == strongself.dealingFromType) {
                        // 如果是编辑，则往回跳两个控制器，跳回到流程审批首页
                        [strongself.navigationController popToViewController:strongself.navigationController.viewControllers[strongself.navigationController.viewControllers.count-3] animated:YES];
                    } else {
                        [strongself.navigationController popViewControllerAnimated:YES];
                    }
                } needCancleButton:NO];
            } else if (!kIsNilString(((NSString *)response[@"responseData"][@"message"]))) {
                NSString *message = response[@"responseData"][@"message"];
                [self showAlertControllerToLogoutWithMessage:message sureAction:nil needCancleButton:NO];
            } else {
                [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%@失败",message] sureAction:nil needCancleButton:NO];
            }
        } else {
            [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%@失败",message] sureAction:nil needCancleButton:NO];
        }
    } failure:^(NSString *error) {
        [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%@失败",message] sureAction:nil needCancleButton:NO];
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
    return ((NSArray *)self.tableViewTitleArray[section][kCellTitleDetailKey]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.tableViewTitleArray.count - 3) {
        if (indexPath.row == 0) {
            return kTableViewHeight + 45;
        } else {
            return kTableViewHeight;
        }
    } else if (indexPath.section == self.tableViewTitleArray.count - 2) {
        if (self.dealingModel.participants.count > 0) {
            if (!self.dealingModel.mpm_applyNameNeedFold) {
                return kTabbarHeight + 70 + (((self.dealingModel.participants.count-1)/5) * 56.5);
            } else {
                if (self.dealingModel.participants.count > 5) {
                    return kTabbarHeight + 70;
                } else {
                    return kTabbarHeight + 56.5;
                }
            }
        }
    } else if (indexPath.section == self.tableViewTitleArray.count - 1) {
        if (self.dealingModel.delivers.count > 0) {
            if (!self.dealingModel.mpm_copyNameNeedFold) {
                return kTabbarHeight + 70 + (((self.dealingModel.delivers.count-1)/5) * 56.5);
            } else {
                if (self.dealingModel.delivers.count > 5) {
                    return kTabbarHeight + 70;
                } else {
                    return kTabbarHeight + 56.5;
                }
            }
        }
    }
    NSDictionary *dic = self.tableViewTitleArray[indexPath.section];
    NSArray *cellType = dic[kCellDetailTypeKey];
    NSString *detailType = cellType[indexPath.row];
    if ([detailType isEqualToString:kCellDetailTypeSelectTool]) {
        if (self.dealingModel.causationDetail[indexPath.section].trafficNeedFold) {
            return kTableViewHeight;
        } else {
            return kTableViewHeight * 2;
        }
    }
    
    return kTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = self.tableViewTitleArray[section][kCellHeaderTitleKey];
    NSString *detailTitle = self.tableViewTitleArray[section][kCellHeaderDetailKey];
    if (kIsNilString(title) && kIsNilString(detailTitle)) {
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
    NSString *title = self.tableViewTitleArray[section][kCellHeaderTitleKey];
    NSString *detailTitle = self.tableViewTitleArray[section][kCellHeaderDetailKey];
    if (kIsNilString(title) && kIsNilString(detailTitle)) {
        return nil;
    } else {
        // 改签、补签、例外申请
        MPMBaseDealingHeader *header = [[MPMBaseDealingHeader alloc] init];
        if (section == 0 && (kCausationTypeChangeSign == self.dealingModel.causationType || kCausationTypeRepairSign == self.dealingModel.causationType || self.dealingFromType == kDealingFromTypeChangeRepair)) {
            title = [NSString stringWithFormat:@"%@：%@ %@",kAttendenceStatus[self.dealingModel.status],([NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[0].attendanceTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds]),@[@"上班",@"下班"][self.dealingModel.causationDetail.firstObject.type.integerValue]];
            header.deleteButton.hidden = YES;
        }
        header.deleteButton.hidden = kIsNilString(detailTitle);
        
        header.headerTitleLabel.text = title;
        __weak typeof(self) weakself = self;
        header.seeDetailBlock = ^{
            // 查看明细
            __strong typeof(weakself) strongself = weakself;
            if (kIsNilString(strongself.dealingModel.causationDetail[section].startTime) ||
                kIsNilString(strongself.dealingModel.causationDetail[section].endTime)) {
                [strongself showAlertControllerToLogoutWithMessage:@"请选择完整的时间" sureAction:nil needCancleButton:NO];return;
            }
            MPMDealingSeeTimeDetailViewController *seeTime = [[MPMDealingSeeTimeDetailViewController alloc] initWithCausationDetail:strongself.dealingModel.causationDetail[section]];
            strongself.hidesBottomBarWhenPushed = YES;
            [strongself.navigationController pushViewController:seeTime animated:YES];
        };
        header.deleteBlock = ^{
            // 删除
            __strong typeof(weakself) strongself = weakself;
            // 如果是补签，则index是section-1
            NSInteger index = (kCausationTypeRepairSign == strongself.dealingModel.causationType) ? section - 1 : section;
            BOOL canDelete = YES;
            for (int i = 0; i < strongself.dealingModel.causationDetail.count; i++) {
                if (strongself.dealingModel.causationDetail[i].calculatingTime) {
                    canDelete = NO;
                    break;
                }
            }
            if (canDelete) {
                [strongself.dealingModel.causationDetail removeModelAtIndex:index];
                strongself.dealingModel.addCount--;
                if (strongself.dealingModel.addCount < 1 && kCausationTypeRepairSign != strongself.dealingModel.causationType) {
                    strongself.dealingModel.addCount = 1;
                }
                
                strongself.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:strongself.dealingModel.causationDetail[section].causationType.integerValue addCount:strongself.dealingModel.addCount];
                [strongself.tableView reloadData];
            }
        };
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kDealingFromTypePreview == self.dealingFromType) {
        cell.userInteractionEnabled = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.tableViewTitleArray[indexPath.section];
    NSArray *cellType = dic[kCellDetailTypeKey];
    NSString *detailType = cellType[indexPath.row];
    
    if ([detailType isEqualToString:kCellDetailTypeSelectTool]) {
        // 交通工具、加班补偿
        static NSString *identifier = @"cellIdentifierSelectTool";
        MPMCommomDealingMultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            if (kCausationTypeOverTime == self.dealingModel.causationType) {
                // 加班补偿
                cell = [[MPMCommomDealingMultiSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier multiSelectionType:kMultiSelectionTypeOverTimeMoney];
            } else {
                // 交通工具
                cell = [[MPMCommomDealingMultiSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier multiSelectionType:kMultiSelectionTypeTraffic];
            }
        }
        if (kCausationTypeOverTime == self.dealingModel.causationType) {
            // 加班补偿
            cell.lastSelectedBtn.selected = NO;
            if (!kIsNilString(self.dealingModel.redress)) {
                UIView *sub = [cell viewWithTag:kMoneyBtnTag + 3 - self.dealingModel.redress.integerValue];
                if (sub && [sub isKindOfClass:[MPMDealingBorderButton class]]) {
                    cell.lastSelectedBtn = (MPMDealingBorderButton *)sub;
                    cell.lastSelectedBtn.selected = YES;
                }
            }
        } else {
            // 交通工具
            if (!kIsNilString(self.dealingModel.causationDetail[indexPath.section].traffic)) {
                UIView *sub;
                if ([kTraffic indexOfObject:self.dealingModel.causationDetail[indexPath.section].traffic] == NSNotFound) {
                    sub = [cell viewWithTag:kTafficBtnTag];
                    cell.trafficDetailTextField.text = self.dealingModel.causationDetail[indexPath.section].traffic;
                } else {
                    sub = [cell viewWithTag:kTafficBtnTag + [kTraffic indexOfObject:self.dealingModel.causationDetail[indexPath.section].traffic]];
                    cell.lastSelectedBtn.selected = NO;
                }
                if (sub && [sub isKindOfClass:[MPMDealingBorderButton class]]) {
                    cell.lastSelectedBtn = (MPMDealingBorderButton *)sub;
                    cell.lastSelectedBtn.selected = YES;
                }
            } else {
                // 如果交通工具为空：1、需要折叠的时候，则把之前的选中按钮取消。2、不需要折叠的时候，不需要取消选中‘其他’按钮
                if (self.dealingModel.causationDetail[indexPath.section].trafficNeedFold) {
                    cell.lastSelectedBtn.selected = NO;
                }
            }
        }
        __weak typeof(self) weakself = self;
        cell.cellNeedFoldBlock = ^(BOOL fold) {
            __strong typeof(weakself) strongself = weakself;
            strongself.dealingModel.causationDetail[indexPath.section].trafficNeedFold = fold;
            [strongself.tableView reloadData];
        };
        cell.selectedBtnBlock = ^(NSInteger index) {
            __strong typeof(weakself) strongself = weakself;
            if (kCausationTypeOverTime == strongself.dealingModel.causationType) {
                // 加班补偿
                NSInteger redress = kMoney.count - index;
                strongself.dealingModel.redress = [NSString stringWithFormat:@"%ld",redress];
            } else {
                // 交通工具
                if (0 == index) {
                    strongself.dealingModel.causationDetail[indexPath.section].traffic = nil;
                } else {
                    strongself.dealingModel.causationDetail[indexPath.section].traffic = kTraffic[index];
                }
            }
        };
        cell.cellTextFieldChangeBlock = ^(NSString *text) {
            // 输入交通工具
            __strong typeof(weakself) strongself = weakself;
            strongself.dealingModel.causationDetail[indexPath.section].traffic = text;
        };
        return cell;
    } else if ([detailType isEqualToString:kCellDetailTypeUITextView]) {
        // TextView
        static NSString *cellIdentifier = @"cellIdentifierTextView";
        MPMCommomDealingReasonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMCommomDealingReasonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        NSArray *cellArr = self.tableViewTitleArray[indexPath.section][kCellTitleDetailKey];
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
    } else if ([detailType isEqualToString:kCellDetailTypePeople]) {
        // 审批人、抄送人
        static NSString *cellIdentifier = @"cellIdentifierPeople";
        MPMCommomDealingGetPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MPMCommomDealingGetPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        if (indexPath.section == self.tableViewTitleArray.count - 1) {
            // 抄送人：可以删除
            cell.startIcon.hidden = YES;
            cell.accessoryButton.hidden = NO;
            cell.peopleCanDelete = YES;
            [cell setPeopleViewArray:self.dealingModel.delivers fold:self.dealingModel.mpm_copyNameNeedFold];
            __weak typeof(self) weakself = self;
            cell.addpBlock = ^(UIButton *sender) {
                __strong typeof (weakself) strongself = weakself;
                
                // 跳入多选人员页面（只能选择人员）
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:strongself.dealingModel.delivers.count];
                for (int i = 0; i < strongself.dealingModel.delivers.count; i++) {
                    MPMDepartment *people = strongself.dealingModel.delivers[i];
                    people.isHuman = YES;
                    people.type = @"user";
                    [temp addObject:people];
                }
                [MPMDepartEmployeeHelper shareInstance].employees = temp;
                MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:@"部门"] selectionType:kSelectionTypeOnlyEmployee comfirmBlock:nil];
                
                __weak typeof(strongself) wweakself = strongself;
                depart.sureSelectBlock = ^(NSArray<MPMDepartment *> *departments, NSArray<MPMDepartment *> *employees) {
                    // 这里只回传人员数据
                    __strong typeof(wweakself) sstrongself = wweakself;
                    sstrongself.dealingModel.delivers = employees;
                    [sstrongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                };
                strongself.hidesBottomBarWhenPushed = YES;
                [strongself.navigationController pushViewController:depart animated:YES];
                
            };
            cell.foldBlock = ^(UIButton *sender) {
                // 展开收缩
                sender.selected = !sender.selected;
                __strong typeof (weakself) strongself = weakself;
                strongself.dealingModel.mpm_copyNameNeedFold = !sender.selected;
                [strongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            cell.deleteBlock = ^(UIButton *sender) {
                __strong typeof (weakself) strongself = weakself;
                NSMutableArray *temp = [NSMutableArray arrayWithArray:strongself.dealingModel.delivers];
                [temp removeObjectAtIndex:sender.tag - kButtonTag];
                strongself.dealingModel.delivers = temp.copy;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
        } else if (self.tableViewTitleArray.count - 2 == indexPath.section) {
            // 提交至：如果流程有节点，则不可以删除，如果流程没有节点，是自己增加的，则可以删除
            cell.startIcon.hidden = NO;
            if (!kIsNilString(self.dealingModel.decision) && self.dealingModel.participants.count != 0) {
                // 如果已经有决策数据，说明管理员设置过审批人，则隐藏按钮，不给更改
                cell.accessoryButton.hidden = YES;
                cell.peopleCanDelete = NO;
            } else {
                cell.accessoryButton.hidden = NO;
                cell.peopleCanDelete = YES;
            }
            [cell setPeopleViewArray:self.dealingModel.participants fold:self.dealingModel.mpm_applyNameNeedFold];
            __weak typeof (self) weakself = self;
            cell.addpBlock = ^(UIButton *sender) {
                __strong typeof (weakself) strongself = weakself;
                
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:strongself.dealingModel.participants.count];
                for (int i = 0; i < strongself.dealingModel.participants.count; i++) {
                    MPMDepartment *people = strongself.dealingModel.participants[i];
                    people.isHuman = YES;
                    people.type = kUserType;
                    [temp addObject:people];
                }
                [MPMDepartEmployeeHelper shareInstance].employees = temp;
                // 跳入多选人员页面（只能选择人员）
                MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:@"部门"] selectionType:kSelectionTypeOnlyEmployee comfirmBlock:nil];
                
                __weak typeof(strongself) wweakself = strongself;
                depart.sureSelectBlock = ^(NSArray<MPMDepartment *> *departments, NSArray<MPMDepartment *> *employees) {
                    // 这里只回传人员数据
                    __strong typeof(wweakself) sstrongself = wweakself;
                    sstrongself.dealingModel.participants = employees;
                    [sstrongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                };
                strongself.hidesBottomBarWhenPushed = YES;
                [strongself.navigationController pushViewController:depart animated:YES];
            };
            cell.foldBlock = ^(UIButton *sender) {
                // 展开收缩
                sender.selected = !sender.selected;
                __strong typeof (weakself) strongself = weakself;
                strongself.dealingModel.mpm_applyNameNeedFold = !sender.selected;
                [strongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            cell.deleteBlock = ^(UIButton *sender) {
                __strong typeof (weakself) strongself = weakself;
                NSMutableArray *temp = [NSMutableArray arrayWithArray:strongself.dealingModel.participants];
                [temp removeObjectAtIndex:sender.tag - kButtonTag];
                strongself.dealingModel.participants = temp.copy;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
        } else {
            cell.startIcon.hidden = NO;
            cell.accessoryButton.hidden = NO;
            __weak typeof (self) weakself = self;
            cell.addpBlock = ^(UIButton *sender) {
                __strong typeof (weakself) strongself = weakself;
                // 跳入多选人员页面（只能选择人员）
                MPMRepairSigninViewController *repair = [[MPMRepairSigninViewController alloc] initWithRepairFromType:kRepairFromTypeDealing];
                __weak typeof(strongself) wweakself = strongself;
                repair.toDealingBlock = ^(MPMDealingModel *model) {
                    __strong typeof(wweakself) sstrongself = wweakself;
                    sstrongself.dealingModel.addCount = model.addCount;
                    for (int i = 0; i < sstrongself.dealingModel.addMaxCount; i++) {
                        [sstrongself.dealingModel.causationDetail[i] copyWithOtherModel:model.causationDetail[i]];
                    }
                    sstrongself.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:sstrongself.dealingModel.causationType addCount:sstrongself.dealingModel.addCount];
                    [sstrongself.tableView reloadData];
                };
                strongself.hidesBottomBarWhenPushed = YES;
                [strongself.navigationController pushViewController:repair animated:YES];
            };
        }
        NSArray *cellArr = self.tableViewTitleArray[indexPath.section][kCellTitleDetailKey];
        cell.txLabel.text = [cellArr[indexPath.row] componentsSeparatedByString:@","].firstObject;
        return cell;
    } else if ([detailType isEqualToString:kCellDetailTypeUIButton]) {
        // 按钮类型
        NSString *cellTitle = ((NSArray *)dic[kCellTitleDetailKey]).firstObject;
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
        NSArray *cellArr = self.tableViewTitleArray[indexPath.section][kCellTitleDetailKey];
        cell.startIcon.hidden = NO;
        cell.txLabel.text = [cellArr[indexPath.row] componentsSeparatedByString:@","].firstObject;
        __weak typeof(self) weakself = self;
        if ([detailType isEqualToString:kCellDetailTypeUITextField]) {
            // detail类型为输入框
            [cell setupDetailToBeUITextField];
            cell.detailView.userInteractionEnabled = YES;
            NSString *cellTitle = cell.txLabel.text;
            ((UITextField *)cell.detailView).placeholder = [cellArr[indexPath.row] componentsSeparatedByString:@","].lastObject;
            if ([cellTitle isEqualToString:@"出差地点"]) {
                [cell needCheckNumber:NO limitLength:0];
                NSString *currentString = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section]).address;
                ((UITextField *)cell.detailView).text = kIsNilString(currentString)?@"":currentString;
            } else if ([cellTitle isEqualToString:@"预计费用"]) {
                cell.startIcon.hidden = YES;// 预计费用非必填项
                [cell needCheckNumber:YES limitLength:6];
                NSString *currentString = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section]).expectCost;
                ((UITextField *)cell.detailView).text = kIsNilString(currentString)?@"":currentString;
            } else if ([cellTitle containsString:@"时长"]) {
                [cell needCheckNumber:YES limitLength:4];
                cell.detailView.userInteractionEnabled = YES;
                if (kCausationTypeYearLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeMonthLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeSeeRelativeLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeMarryLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeBabyLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeCompanyBabyLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeFuneralLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeInjuryLeave == self.dealingModel.causationDetail[indexPath.section].causationType.integerValue ||
                    kCausationTypeevecation == self.dealingModel.causationType) {
                    cell.txLabel.text = [[cellArr[indexPath.row] componentsSeparatedByString:@","].firstObject stringByAppendingString:@"(天)"];
                    NSString *currentString = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section]).dayAccount;
                    ((UITextField *)cell.detailView).text = kIsNilString(currentString)?@"":currentString;
                } else {
                    cell.txLabel.text = [[cellArr[indexPath.row] componentsSeparatedByString:@","].firstObject stringByAppendingString:@"(小时)"];
                    NSString *currentString = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section]).hourAccount;
                    ((UITextField *)cell.detailView).text = kIsNilString(currentString)?@"":currentString;
                }
            } else {
                [cell needCheckNumber:NO limitLength:0];
                NSString *currentString = ((MPMCausationDetailModel *)self.dealingModel.causationDetail[indexPath.section]).hourAccount;
                ((UITextField *)cell.detailView).text = kIsNilString(currentString)?@"":currentString;
            }
            cell.textFieldChangeBlock = ^(NSString *currentText) {
                __strong typeof(weakself) strongself = weakself;
                NSInteger index = indexPath.section;
                if ([cellTitle isEqualToString:@"出差地点"]) {
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).address = currentText;
                } else if ([cellTitle isEqualToString:@"预计费用"]) {
                    ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).expectCost = currentText;
                } else {
                    // 时长(小时、天）
                    if (kCausationTypeevecation == strongself.dealingModel.causationType ||
                        kCausationTypeYearLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue ||
                        kCausationTypeMonthLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue ||
                        kCausationTypeSeeRelativeLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue ||
                        kCausationTypeMarryLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue ||
                        kCausationTypeBabyLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue ||
                        kCausationTypeCompanyBabyLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue ||
                        kCausationTypeFuneralLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue ||
                        kCausationTypeInjuryLeave == strongself.dealingModel.causationDetail[index].causationType.integerValue) {
                        ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).dayAccount = currentText;
                    } else {
                        ((MPMCausationDetailModel *)strongself.dealingModel.causationDetail[index]).hourAccount = currentText;
                    }
                }
            };
        } else {
            // detail类型为UILabel
            [cell setupDetailToBeLabel];
            NSString *title = cell.txLabel.text;
            NSString *originalText = [cellArr[indexPath.row] componentsSeparatedByString:@","].lastObject;
            if ([title isEqualToString:@"请假类型"]) {
                NSString *typeNum = self.dealingModel.causationDetail[indexPath.section].causationType;
                NSString *typeName = kLeaveType_GetTypeNameFromNum[typeNum];
                cell.detailTextLabel.text = kIsNilString(typeName) ? originalText : typeName;
            } else if ([title isEqualToString:@"开始时间"]) {
                cell.detailTextLabel.text = self.dealingModel.causationDetail[indexPath.section].startTime ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[indexPath.section].startTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds] : originalText;
            } else if ([title isEqualToString:@"结束时间"]) {
                cell.detailTextLabel.text = self.dealingModel.causationDetail[indexPath.section].endTime ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[indexPath.section].endTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds] : originalText;
            } else if ([title isEqualToString:@"改签时间"]) {
                cell.detailTextLabel.text = self.dealingModel.causationDetail[indexPath.section].reviseSignTime ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[indexPath.section].reviseSignTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds] : originalText;
            } else if ([title isEqualToString:@"漏签时间"]) {
                NSInteger index = indexPath.section - 1;
                cell.detailTextLabel.text = !kIsNilString(self.dealingModel.causationDetail[index].fillupTime) ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].fillupTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds] : originalText;
            } else if ([title isEqualToString:@"补签时间"]) {
                NSInteger index = indexPath.section - 1;
                cell.detailTextLabel.text = !kIsNilString(self.dealingModel.causationDetail[index].signTime) ? [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].signTime.doubleValue/1000] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds] : originalText;
            } else {
                cell.detailTextLabel.text = originalText;
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == self.tableViewTitleArray.count - 1) {
        // 抄送人
    } else if (indexPath.section == self.tableViewTitleArray.count - 2) {
        // 审批人
    } else if (self.tableViewTitleArray.count > 3 && indexPath.section == self.tableViewTitleArray.count - 3) {
        // 处理理由（加班则包含加班补偿）
    } else {
        NSArray *action = self.tableViewTitleArray[indexPath.section][kCellActionTypeKey];
        NSString *actionTitle = action[indexPath.row];
        MPMCommomDealingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([actionTitle isEqualToString:kAction_PickerTypeDealingType]) {
            // 请假类型
            NSInteger index = indexPath.section;
            MPMCausationDetailModel *detail = self.dealingModel.causationDetail[index];
            NSInteger defaultRow = 0;
            if (!kIsNilString(detail.causationType)) {
                defaultRow = [self.leaveAllTypesArray indexOfObject:kLeaveType_GetTypeNameFromNum[detail.causationType]];
            }
            [self.pickerView showInView:kAppDelegate.window withPickerData:self.leaveAllTypesArray selectRow:defaultRow];
            __weak typeof(self) weakself = self;
            self.pickerView.completeSelectBlock = ^(id data) {
                __strong typeof(weakself) strongself = weakself;
                NSString *causationNum = (NSString *)kLeaveType_GetTypeNumFromName[data];
                strongself.dealingModel.causationDetail[indexPath.section].causationType = causationNum;
                [strongself.tableView reloadData];
            };
            
        } else if ([actionTitle isEqualToString:kAction_PickerTypeTimeOfOne]) {
            // 时分秒picker
            NSInteger index = indexPath.section;
            NSDate *defaultDate;
            CustomPickerViewType pickerType = kCustomPickerViewTypeYearMonthDayHourMinute;//  时间选择器类型
            if ([cell.txLabel.text isEqualToString:@"开始时间"]) {
                if (!kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).startTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].startTime.doubleValue/1000];
                } else if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).startTime) && !kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).endTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].endTime.doubleValue/1000];
                } else {
                    defaultDate = [NSDate date];
                }
            } else if ([cell.txLabel.text isEqualToString:@"结束时间"]) {
                
                if (!kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).endTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].endTime.doubleValue/1000];
                } else if (kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).endTime) && !kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).startTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].startTime.doubleValue/1000];
                } else {
                    defaultDate = [NSDate date];
                }
            } else if ([cell.txLabel.text isEqualToString:@"漏签时间"] &&
                       !kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index - 1]).fillupTime)) {
                defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index - 1].fillupTime.doubleValue/1000];
            } else if ([cell.txLabel.text isEqualToString:@"补签时间"]) {
                if (!kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index - 1]).signTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index - 1].signTime.doubleValue/1000];
                } else if (!kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index - 1]).fillupTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index - 1].fillupTime.doubleValue/1000];
                }
            } else if ([cell.txLabel.text isEqualToString:@"改签时间"]) {
                pickerType = kCustomPickerViewTypeHourMinute;
                if (!kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).reviseSignTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].reviseSignTime.doubleValue/1000];
                } else if (!kIsNilString(((MPMCausationDetailModel *)self.dealingModel.causationDetail[index]).signTime)) {
                    defaultDate = [NSDate dateWithTimeIntervalSince1970:self.dealingModel.causationDetail[index].signTime.doubleValue/1000];
                }
            } else {
                defaultDate = [NSDate date];
            }
            [self.customDatePickerView showPicerViewWithType:pickerType defaultDate:defaultDate];
            __weak typeof (self) weakself = self;
            self.customDatePickerView.completeBlock = ^(NSDate *date) {
                __strong typeof (weakself) strongself = weakself;
                if ([cell.txLabel.text isEqualToString:@"开始时间"]) {
                    if (!kIsNilString(strongself.dealingModel.causationDetail[index].endTime) && strongself.dealingModel.causationDetail[index].endTime.doubleValue <= [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970*1000].doubleValue) {
                        [strongself showAlertControllerToLogoutWithMessage:@"结束时间必须大于开始时间" sureAction:nil needCancleButton:NO];return;
                    }
                    strongself.dealingModel.causationDetail[index].startTime = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970*1000];
                } else if ([cell.txLabel.text isEqualToString:@"结束时间"]) {
                    if (!kIsNilString(strongself.dealingModel.causationDetail[index].startTime) && strongself.dealingModel.causationDetail[index].startTime.doubleValue >= [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970*1000].doubleValue) {
                        [strongself showAlertControllerToLogoutWithMessage:@"结束时间必须大于开始时间" sureAction:nil needCancleButton:NO];return;
                    }
                    strongself.dealingModel.causationDetail[index].endTime = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970*1000];
                } else if ([cell.txLabel.text isEqualToString:@"漏签时间"]) {
                    strongself.dealingModel.causationDetail[index-1].fillupTime = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970*1000];
                } else if ([cell.txLabel.text isEqualToString:@"补签时间"]) {
                    strongself.dealingModel.causationDetail[index-1].signTime = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970*1000];
                } else if ([cell.txLabel.text isEqualToString:@"改签时间"]) {
                    strongself.dealingModel.causationDetail[index].reviseSignTime = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970*1000];
                }
                cell.detailTextLabel.text = [NSDateFormatter formatterDate:date withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
                // 开始时间、结束时间 自动计算时长
                if (!kIsNilString(strongself.dealingModel.causationDetail[index].startTime) && !kIsNilString(strongself.dealingModel.causationDetail[index].endTime)) {
                    strongself.dealingModel.causationDetail[index].calculatingTime = YES;
                    __weak typeof(strongself) wweakself = strongself;
                    [strongself calculateDayAndHourWithStart:strongself.dealingModel.causationDetail[index].startTime end:strongself.dealingModel.causationDetail[index].endTime complete:^(NSString *day, NSString *hour) {
                        __strong typeof(wweakself) wstrongself = wweakself;
                        wstrongself.dealingModel.causationDetail[index].calculatingTime = NO;
                        wstrongself.dealingModel.causationDetail[index].dayAccount = day;
                        wstrongself.dealingModel.causationDetail[index].hourAccount = hour;
                        [wstrongself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }];
                }
            };
        } else if ([actionTitle isEqualToString:kAction_PickerTypeTimeOfTwo]) {
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
        } else if ([actionTitle isEqualToString:kAction_PickerTypeTwoClass]) {
            NSInteger defaultRow = kIsNilString(self.dealingModel.shiftName) ? 0 : ((NSString *)kShiftNameRever[self.dealingModel.shiftName]).integerValue;
            [self.pickerView showInView:kAppDelegate.window withPickerData:@[@"上班",@"下班"] selectRow:defaultRow];
            __weak typeof (self) weakself = self;
            self.pickerView.completeSelectBlock = ^(id data) {
                __strong typeof (weakself) strongself = weakself;
                cell.detailTextLabel.text = data;
                strongself.dealingModel.shiftName = kShiftName[data];
            };
        } else if ([actionTitle isEqualToString:kAction_PickerTypeThreeClass]) {
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
        } else if ([actionTitle isEqualToString:kAction_AddCell]) {
            BOOL canAdd = YES;
            for (int i = 0; i < self.dealingModel.causationDetail.count; i++) {
                if (self.dealingModel.causationDetail[i].calculatingTime) {
                    canAdd = NO;
                    break;
                }
            }
            if (canAdd) {
                self.dealingModel.addCount++;
                if (self.dealingModel.addCount > 3) {
                    self.dealingModel.addCount = 1;
                }
                // 增加一行数据
                self.tableViewTitleArray = [MPMCausationTypeData getTableViewDataWithCausationType:self.dealingModel.causationType addCount:self.dealingModel.addCount];
                [self.tableView reloadData];
            }
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
        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self addChildViewController:tvc];
        _tableView = tvc.tableView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = kTableViewHeight;
        _tableView.rowHeight = UITableViewAutomaticDimension;
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
